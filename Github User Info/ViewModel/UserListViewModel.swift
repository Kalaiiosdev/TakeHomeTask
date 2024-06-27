import Foundation
import CoreData
import UIKit

class UserListViewModel: AvatarDownloadable {
    var users: [UserEntity] = []
    var onUsersUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?

    func fetchUsers() {
        if Reachability.shared.isConnected() {
            fetchUsersFromAPI()
        } else {
            fetchUsersFromCoreData()
        }
    }

    private func fetchUsersFromAPI() {
        NetworkManager.shared.getUserList { [weak self] result in
            switch result {
            case .success(let apiUsers):
                self?.mergeUsers(apiUsers)
                self?.fetchUsersFromCoreData()
            case .failure(let error):
                self?.onError?(error)
                self?.fetchUsersFromCoreData()
            }
        }
    }

    private func fetchUsersFromCoreData() {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "login", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            users = try context.fetch(fetchRequest)
            onUsersUpdated?()
        } catch {
            onError?(error)
        }
    }

    private func mergeUsers(_ apiUsers: [User]) {
        let context = CoreDataManager.shared.context

        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id IN %@", apiUsers.map { NSNumber(value: $0.id) })

        do {
            let existingUsers = try context.fetch(fetchRequest)
            let existingUsersMap = Dictionary(uniqueKeysWithValues: existingUsers.map { ($0.id, $0) })

            apiUsers.forEach { apiUser in
                if let existingUser = existingUsersMap[Int64(apiUser.id)] {
                    existingUser.login = apiUser.login
                    existingUser.node_id = apiUser.node_id
                    existingUser.avatar_url = apiUser.avatar_url
                    existingUser.gravatar_id = apiUser.gravatar_id
                    existingUser.url = apiUser.url
                    existingUser.html_url = apiUser.html_url
                    existingUser.followers_url = apiUser.followers_url
                    existingUser.following_url = apiUser.following_url
                    existingUser.gists_url = apiUser.gists_url
                    existingUser.starred_url = apiUser.starred_url
                    existingUser.subscriptions_url = apiUser.subscriptions_url
                    existingUser.organizations_url = apiUser.organizations_url
                    existingUser.repos_url = apiUser.repos_url
                    existingUser.events_url = apiUser.events_url
                    existingUser.received_events_url = apiUser.received_events_url
                    existingUser.type = apiUser.type
                    existingUser.site_admin = apiUser.site_admin
                } else {
                    let newUser = UserEntity(context: context)
                    newUser.login = apiUser.login
                    newUser.id = Int64(apiUser.id)
                    newUser.node_id = apiUser.node_id
                    newUser.avatar_url = apiUser.avatar_url
                    newUser.gravatar_id = apiUser.gravatar_id
                    newUser.url = apiUser.url
                    newUser.html_url = apiUser.html_url
                    newUser.followers_url = apiUser.followers_url
                    newUser.following_url = apiUser.following_url
                    newUser.gists_url = apiUser.gists_url
                    newUser.starred_url = apiUser.starred_url
                    newUser.subscriptions_url = apiUser.subscriptions_url
                    newUser.organizations_url = apiUser.organizations_url
                    newUser.repos_url = apiUser.repos_url
                    newUser.events_url = apiUser.events_url
                    newUser.received_events_url = apiUser.received_events_url
                    newUser.type = apiUser.type
                    newUser.site_admin = apiUser.site_admin
                }
            }

            try context.save()
        } catch {
            print("Failed to merge users: \(error)")
        }
    }
    
    func searchUsers(searchText: String) {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        let predicate = NSPredicate(format: "login CONTAINS[cd] %@", searchText)
        request.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "login", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
        request.sortDescriptors = [sortDescriptor]
        let context = CoreDataManager.shared.context
        do {
            users.removeAll()
            users = try context.fetch(request)
            onUsersUpdated?()
        } catch {
            onError?(error)
        }
    }

   
    func numberOfUsers() -> Int {
        return users.count
    }

    func user(at index: Int) -> UserEntity {
        return users[index]
    }
    
    func numberOfUsersFilterd() -> Int {
        return users.count
    }
}

