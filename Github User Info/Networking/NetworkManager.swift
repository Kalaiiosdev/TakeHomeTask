import Foundation
class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    let baseURL = "https://api.github.com"
    
    // Method to get user list
    func getUserList(since: Int = 0, completion: @escaping (Result<[User], Error>) -> Void) {
        let urlString = "\(baseURL)/users?since=\(since)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                completion(.success(users))
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }.resume()
    }
    
    // Method to get profile detail
    func getProfileDetail(for username: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        let urlString = "\(baseURL)/users/\(username)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let profile = try JSONDecoder().decode(Profile.self, from: data)
                completion(.success(profile))
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }.resume()
    }
}

