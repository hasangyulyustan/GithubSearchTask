//
//  SearchRepositoriesResponse.swift
//  GithubSearchTask
//
//  Created by Hasan Gyulyustan on 19.12.21.
//

import Foundation

struct SearchRepositoriesResponse: Decodable {
    let total: Int
    let repositories: [Repository]

    enum CodingKeys: String, CodingKey {
        case repositories = "items"
        case total = "total_count"
    }
}

struct Repository: Decodable {
    let name: String
    let htmlURL: String

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case htmlURL = "html_url"
    }
}
