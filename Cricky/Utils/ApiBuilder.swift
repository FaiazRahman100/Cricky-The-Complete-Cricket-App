//
//  ApiBuilder.swift
//  Cricky
//
//  Created by Faiaz Rahman on 26/2/23.
//

import Foundation

class APIQueryBuilder {
    private var baseUrl: String
    private var endpoint: String = ""
    private var queryParams: [String: String] = [:]
    private var includeParams: [String] = []

    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }

    func setEndpoint(_ endpoint: String) -> APIQueryBuilder {
        self.endpoint = endpoint
        return self
    }

    func addQueryParam(key: String, value: String) -> APIQueryBuilder {
        queryParams[key] = value
        return self
    }

    func addIncludeParam(_ include: String) -> APIQueryBuilder {
        includeParams.append(include)
        return self
    }

    func build() -> String {
        var urlComponents = URLComponents(string: baseUrl)!
        urlComponents.path += endpoint

        var queryItems: [URLQueryItem] = []
        for (key, value) in queryParams {
            let queryItem = URLQueryItem(name: key, value: value)
            queryItems.append(queryItem)
        }
        urlComponents.queryItems = queryItems

        if !includeParams.isEmpty {
            let includeString = includeParams.joined(separator: ",")
            urlComponents.queryItems?.append(URLQueryItem(name: "include", value: includeString))
        }

        return urlComponents.string!
    }
}

// Define the builder class
class AllMatchesLinkBuilder {
    private var token: String
    private var startsBetween: String?
    private var sort: String?
    private var include: String?

    init(token: String) {
        self.token = token
    }

    func setStartsBetween(startsBetween: String) -> AllMatchesLinkBuilder {
        self.startsBetween = startsBetween
        return self
    }

    func setSort(sort: String) -> AllMatchesLinkBuilder {
        self.sort = sort
        return self
    }

    func setInclude(include: String) -> AllMatchesLinkBuilder {
        self.include = include
        return self
    }

    func build() -> String {
        var link = "https://cricket.sportmonks.com/api/v2.0/fixtures?api_token=\(token)"

        if let startsBetween = startsBetween {
            link += "&filter[starts_between]=\(startsBetween)"
        }

        if let sort = sort {
            link += "&sort=\(sort)"
        }

        if let include = include {
            link += "&include=\(include)"
        }

        return link
    }
}
