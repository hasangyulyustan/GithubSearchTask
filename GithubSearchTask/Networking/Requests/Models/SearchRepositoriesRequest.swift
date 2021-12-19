//
//  SearchRepositoriesRequest.swift
//  GithubSearchTask
//
//  Created by Hasan Gyulyustan on 19.12.21.
//

import Foundation

struct SearchRepositoriesRequest {
    let searchString: String
    let page: Int
    let perPage: Int
}
