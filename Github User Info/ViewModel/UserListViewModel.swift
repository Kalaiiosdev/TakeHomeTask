import CoreData
class UserListViewModel: AvatarDownloadable {
    var users: [UserEntity] = []
    var onUsersUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    private var isFetching: Bool = false
    private var since: Int = 0
    private var pageSize: Int = 0
    
    // Fetch users from API or Core Data based on connectivity
    func fetchUsers(reset: Bool = false) {
        if reset {
            since = 0
            pageSize = 0
            users.removeAll()
        }
        
        if Reachability.shared.isConnected() {
            fetchUsersFromAPI()
        } else {
            fetchUsersFromCoreData()
        }
    }
    // Fetch users from API and merge them with Core Data
    private func fetchUsersFromAPI() {
        guard !isFetching else { return }
        isFetching = true
        
        NetworkManager.shared.getUserList(since: since) { [weak self] result in
            guard let self = self else { return }
            self.isFetching = false
            
            switch result {
            case .success(let apiUsers):
                self.mergeUsers(apiUsers)
                self.fetchUsersFromCoreData()
                
                if self.pageSize == 0 {
                    self.pageSize = apiUsers.count
                }
                
                if let lastUser = apiUsers.last {
                    self.since = lastUser.id
                }
                
            case .failure(let error):
                self.onError?(error)
                self.fetchUsersFromCoreData()
            }
        }
    }
    
    // Fetch users from Core Data
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
    
    // Merge API users with Core Data
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
    
    // Search users based on login
    func searchUsers(searchText: String) {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        let predicate = NSPredicate(format: "login CONTAINS[cd] %@", searchText)
        request.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "login", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
        request.sortDescriptors = [sortDescriptor]
        let context = CoreDataManager.shared.context
        do {
            users = try context.fetch(request)
            onUsersUpdated?()
        } catch {
            onError?(error)
        }
    }
   
    // Return the number of users
    func numberOfUsers() -> Int {
        return users.count
    }

    // Return the user at a specific index
    func user(at index: Int) -> UserEntity {
        return users[index]
    }
    
    // Return the number of filtered users (if any filtering is applied)
    func numberOfUsersFiltered() -> Int {
        return users.count
    }
}

