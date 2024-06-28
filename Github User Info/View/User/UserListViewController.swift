import UIKit
import CoreData

class UserListViewController: UIViewController {
    private let viewModel = UserListViewModel()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    private var spinner: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        tableView.register(UserTableViewCell.nib(), forCellReuseIdentifier: UserTableViewCell.identifier)
        setupSpinner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Fetch users
        viewModel.fetchUsers(reset: true)
       
        // Bind ViewModel
        viewModel.onUsersUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            if !Reachability.shared.isConnected() {
                self?.offlineAlert()
            }
           
        }
        
        viewModel.onError = { error in
            // Handle error
        }
    }
    
    private func setupSpinner() {
        spinner = UIActivityIndicatorView(style: .large)
        spinner?.color = .gray
        spinner?.hidesWhenStopped = true
        spinner?.startAnimating()
        tableView.tableFooterView = spinner
    }
}

extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileDetailViewController
        vc.userName = viewModel.user(at: indexPath.row).login ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfUsers()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        cell.configure(with: viewModel, index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            viewModel.fetchUsers()
        }
    }
}

extension UserListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchUsers(searchText: searchBar.text ?? "")
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.fetchUsers(reset: true)
        } else {
            viewModel.searchUsers(searchText: searchText)
        }
    }
    func offlineAlert(){
        let alertController = UIAlertController(title: "No Network", message: "Please check your network connetivity", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

