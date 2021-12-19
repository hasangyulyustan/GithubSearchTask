//
//  SearchRepositoriesRequestManager.swift
//  GithubSearchTask
//
//  Created by Hasan Gyulyustan on 19.12.21.
//

import Foundation

protocol SearchRepositoriesRequestManagerDelegate {
    func searchFinished(success: Bool, repositories: [Repository])
}

class SearchRepositoriesRequestManager {
    
    var pageNumber = 1
    private var hasMore = false
    
    var searchResults = [Repository]()
    var delegate : SearchRepositoriesRequestManagerDelegate?
    
    func search(searchText: String) {
        
        if searchText.isEmpty {
            resetSearch()
            return
        } else {
            let request = SearchRepositoriesRequest(searchString: searchText, page: pageNumber, perPage: Constants.ConfigurationStrings.searchRepositoriesDefaultPageSize)
            
            SearchRouter.searchRepositories(request: request).send(SearchRepositoriesResponse.self) { [weak self] (result) in

                guard let self = self else { return }

                switch result {
                case .failure:
                    self.delegate?.searchFinished(success: false, repositories: self.searchResults)
                case .success(let response):
                    if let repositories = response?.repositories {
                        self.hasMore = repositories.count == Constants.ConfigurationStrings.searchRepositoriesDefaultPageSize ? true : false
                        self.searchResults += repositories
                        self.delegate?.searchFinished(success: true, repositories: self.searchResults)
                    }
                }
            }
        }
    }
    
    func getNextPage(searchText: String) {
        if hasMore {
            pageNumber += 1
            search(searchText: searchText)
        }
    }
    
    func resetSearch(tellDelegate: Bool = true) {
        pageNumber = 1
        searchResults = []
        
        if tellDelegate {
            delegate?.searchFinished(success: true, repositories: searchResults)
        }
    }
}

