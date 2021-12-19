//
//  GithubRepositoriesViewController.swift
//  GithubSearchTask
//
//  Created by Hasan Gyulyustan on 18.12.21.
//

import UIKit
import ProgressHUD

class GithubRepositoriesViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    let requestManager = SearchRepositoriesRequestManager()
    let searchController = UISearchController(searchResultsController: nil)
    
    var validatedText: String {
        return searchController.searchBar.text!.lowercased()
    }
    
    var searchResults = [Repository]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Repositories"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self

        requestManager.delegate = self
        searchResults = requestManager.searchResults
        requestManager.search(searchText: validatedText)
    }
    
    func openUrl(_ urlString: String) {
        if let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                    print("Open url : \(success)")
                })
            }
        }
    }
}

extension GithubRepositoriesViewController: UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath)
        
        cell.textLabel?.text = searchResults[indexPath.row].name
        cell.detailTextLabel?.text = searchResults[indexPath.row].htmlURL
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openUrl(searchResults[indexPath.row].htmlURL)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.first?.row == searchResults.count - 10 {
            requestManager.getNextPage(searchText: validatedText)
            
            ProgressHUD.show("Loading page (\(requestManager.pageNumber))...")
            self.view.isUserInteractionEnabled = false
        }
    }
}

extension GithubRepositoriesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        ProgressHUD.show("Loading page (\(requestManager.pageNumber))...")
        self.view.isUserInteractionEnabled = false
    
        requestManager.resetSearch(tellDelegate: false)
        searchResults = requestManager.searchResults
        requestManager.search(searchText: validatedText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        requestManager.resetSearch()
    }
}

extension GithubRepositoriesViewController: SearchRepositoriesRequestManagerDelegate {
    func searchFinished(success: Bool, repositories: [Repository]) {
        
        ProgressHUD.dismiss()
        self.view.isUserInteractionEnabled = true
        
        searchResults = repositories
                
        if !success {
            showAlertViewControllerWithTitle("Something went wrong. Try again later.")
        }
    }
}
