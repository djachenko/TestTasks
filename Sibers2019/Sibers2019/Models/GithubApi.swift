//
// Created by Igor Djachenko on 2019-05-18.
// Copyright (c) 2019 Igor Djachenko. All rights reserved.
//

import Foundation

class GithubApi {
    private static let baseUrl = "https://api.github.com/"
    private static let pageSize = 30

    private var currentSearch: URLSessionTask?



    @discardableResult
    func request(url: String,
                 parameters: [String:String] = [:],
                 success: @escaping (Data) -> Void,
                 failure: @escaping (String) -> Void) -> URLSessionTask? {

        guard var urlComponents = URLComponents(string: url) else {
            failure("Base URL was built incorrectly")

            return nil
        }

        urlComponents.queryItems = parameters.map { name, value in URLQueryItem(name: name, value: value)}

        guard let url = urlComponents.url else {
            failure("URL was built incorrectly")

            return nil
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                failure("Request finished unsuccessfully: \(error.localizedDescription)")
            }

            guard let data = data else {
                failure("Request finished unsuccessfully")

                return
            }

            success(data)
        }

        task.resume()

        return task
    }



    func searchUsers(query: String,
                     startingFrom start:Int = 0,
                     success: @escaping ([UserPreview], Int) -> Void,
                     failure: @escaping (String) -> Void) {

        let url = GithubApi.baseUrl + "search/users"

        let pageNumber = start / GithubApi.pageSize + 1

        let parameters = [
            "q": query,
            "page": String(pageNumber),
            "per_page": String(GithubApi.pageSize)
        ]


        let optionalTask = request(url: url,
                parameters: parameters,
                success: { data in
                    guard let searchResult = try? JSONDecoder().decode(UserSearchResult.self, from: data) else {
                        failure("Received corrupted data")

                        return
                    }

                    success(searchResult.items, searchResult.totalCount)
                },
                failure: failure
        )

        guard let task = optionalTask else {
            return
        }

        currentSearch?.cancel()
        currentSearch = task
    }



    func get(user username: String,
             success: @escaping (User) -> Void,
             failure: @escaping (String) -> Void) {

        let url = GithubApi.baseUrl + "users/" + username

        request(url: url,
                success: { data in
                    guard let user = try? JSONDecoder().decode(User.self, from: data) else {
                        failure("Received corrupted data")

                        return
                    }

                    success(user)
                },
                failure: failure
        )
    }



    func repos(user username: String,
               startingFrom start:Int = 0,
               success: @escaping ([Repository]) -> Void,
               failure: @escaping (String) -> Void) {

        let url = "\(GithubApi.baseUrl)users/\(username)/repos"

        let pageNumber = start / GithubApi.pageSize + 1

        let parameters = [
            "page": String(pageNumber),
            "per_page": String(GithubApi.pageSize)
        ]


        request(url: url,
                parameters: parameters,
                success: { data in
                    guard let repositories = try? JSONDecoder().decode([Repository].self, from: data) else {
                        failure("Received corrupted data")

                        return
                    }

                    success(repositories)
                },
                failure: failure
        )
    }
}
