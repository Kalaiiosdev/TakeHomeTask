import Foundation
import UIKit
import CoreData

// Protocol to handle avatar downloading
protocol AvatarDownloadable {
    func getAvatar(url: String, completion: @escaping (UIImage?) -> Void)
}

// Protocol to handle notes update
protocol NotesTableViewCellDelegate: AnyObject {
    func didUpdateNotes(_ cell: NotesTableViewCell, notes: String)
}

// Extension to provide default implementation for downloading avatars
extension AvatarDownloadable {
    func getAvatar(url: String, completion: @escaping (UIImage?) -> Void) {
        guard let avatarURL = URL(string: url) else {
            completion(nil)
            return
        }
        
        ImageDownloader.shared.downloadImage(from: avatarURL) { image in
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}

// ViewModel for user profile
class UserProfileViewModel: AvatarDownloadable {
    var profile: ProfileEntity?
    var onProfileUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    var profileData: [(String, String)] = []
    
    // Fetch profile from API or Core Data
    func fetchProfile(username: String) {
        if Reachability.shared.isConnected() {
            fetchProfileFromAPI(username: username)
        } else {
            fetchProfileFromCoreData(username: username)
        }
    }
    
    // Fetch profile from API and merge with Core Data
    private func fetchProfileFromAPI(username: String) {
        NetworkManager.shared.getProfileDetail(for: username) { [weak self] result in
            switch result {
            case .success(let apiProfile):
                self?.mergeProfile(apiProfile)
                self?.fetchProfileFromCoreData(username: username)
            case .failure(let error):
                self?.onError?(error)
                self?.fetchProfileFromCoreData(username: username)
            }
        }
    }
    
    // Fetch profile from Core Data
    private func fetchProfileFromCoreData(username: String) {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<ProfileEntity> = ProfileEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "login == %@", username)
        
        do {
            let profiles = try context.fetch(fetchRequest)
            if let profile = profiles.first {
                self.profile = profile
                setBioData()
                onProfileUpdated?()
            } else {
                onError?(NSError(domain: "Profile not found in Core Data", code: -1, userInfo: nil))
            }
        } catch {
            onError?(error)
        }
    }
    
    // Merge API profile with Core Data
    private func mergeProfile(_ apiProfile: Profile) {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<ProfileEntity> = ProfileEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", apiProfile.id)
        
        do {
            let profiles = try context.fetch(fetchRequest)
            let profile: ProfileEntity
            
            if let existingProfile = profiles.first {
                profile = existingProfile
            } else {
                profile = ProfileEntity(context: context)
            }
            
            profile.login = apiProfile.login
            profile.id = Int64(apiProfile.id)
            profile.node_id = apiProfile.node_id
            profile.avatar_url = apiProfile.avatar_url
            profile.gravatar_id = apiProfile.gravatar_id
            profile.url = apiProfile.url
            profile.html_url = apiProfile.html_url
            profile.followers_url = apiProfile.followers_url
            profile.following_url = apiProfile.following_url
            profile.gists_url = apiProfile.gists_url
            profile.starred_url = apiProfile.starred_url
            profile.subscriptions_url = apiProfile.subscriptions_url
            profile.organizations_url = apiProfile.organizations_url
            profile.repos_url = apiProfile.repos_url
            profile.events_url = apiProfile.events_url
            profile.received_events_url = apiProfile.received_events_url
            profile.type = apiProfile.type
            profile.site_admin = apiProfile.site_admin
            profile.name = apiProfile.name
            profile.company = apiProfile.company
            profile.blog = apiProfile.blog
            profile.location = apiProfile.location
            profile.email = apiProfile.email
            profile.hireable = apiProfile.hireable ?? false
            profile.bio = apiProfile.bio
            profile.twitter_username = apiProfile.twitter_username
            profile.public_repos = Int64(apiProfile.public_repos)
            profile.public_gists = Int64(apiProfile.public_gists)
            profile.followers = Int64(apiProfile.followers)
            profile.following = Int64(apiProfile.following)
            profile.created_at = apiProfile.created_at
            profile.updated_at = apiProfile.updated_at
            
            try context.save()
        } catch {
            print("Failed to merge profile: \(error)")
        }
    }
    
    // Get the current profile
    func getProfile() -> ProfileEntity? {
        return profile
    }
    
    // Create profile data array from the UserProfile struct
    func setBioData() {
        var data: [(String, String)] = []
        let profile = getProfile()
        if let name = profile?.name {
            data.append(("Name", name))
        }
        if let company = profile?.company {
            data.append(("Company", company))
        }
        if let blog = profile?.blog {
            data.append(("Blog", blog))
        }
        if let bio = profile?.bio {
            data.append(("Bio", bio))
        }
        if let location = profile?.location {
            data.append(("Location", location))
        }
        if let email = profile?.email {
            data.append(("Email", email))
        }
        if let twitter = profile?.twitter_username {
            data.append(("Twitter", twitter))
        }
        self.profileData = data
    }
    
    // Save notes for the user and update availability
    func saveNotes(username: String, note: String) {
        let fetchRequest: NSFetchRequest<ProfileEntity> = ProfileEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "login == %@", username)
        
        do {
            let results = try CoreDataManager.shared.context.fetch(fetchRequest)
            if let profile = results.first {
                profile.userNote = note
            } else {
                let newProfile = ProfileEntity(context: CoreDataManager.shared.context)
                newProfile.login = username
                newProfile.userNote = note
            }
            CoreDataManager.shared.saveContext()
            // Update isNoteAvailable
            updateNotesAvailablility(userName: username)
        } catch {
            onError?(error)
        }
    }
    
    // Update the note availability for a user
    func updateNotesAvailablility(userName: String) {
        let context = CoreDataManager.shared.context
        
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "login == %@", userName)
        do {
            let users = try context.fetch(fetchRequest)
            users.first?.isNoteAvailable = true
            try context.save()
        } catch {
            print("Failed to merge users: \(error)")
        }
    }
}

