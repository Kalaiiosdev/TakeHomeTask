import Foundation
import CoreData

class UserProfileViewModel {
    private var profile: ProfileEntity?
    var onProfileUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?

    func fetchProfile(username: String) {
        if Reachability.shared.isConnected() {
            fetchProfileFromAPI(username: username)
        } else {
            fetchProfileFromCoreData(username: username)
        }
    }

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

    private func fetchProfileFromCoreData(username: String) {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<ProfileEntity> = ProfileEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "login == %@", username)

        do {
            let profiles = try context.fetch(fetchRequest)
            if let profile = profiles.first {
                self.profile = profile
                onProfileUpdated?()
            } else {
                onError?(NSError(domain: "Profile not found in Core Data", code: -1, userInfo: nil))
            }
        } catch {
            onError?(error)
        }
    }

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

    func getProfile() -> ProfileEntity? {
        return profile
    }
}
