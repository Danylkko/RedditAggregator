//
//  PostFetcher.swift
//  RedditAggregator
//
//  Created by Danylo Litvinchuk on 13.02.2022.
//

import UIKit

class PostFetcher {
    let subreddit: String
    var limit: Int
    var after: String?
    
    init(subreddit: String = "r/ios", limit: Int = 1, after: String?) {
        self.subreddit = subreddit
        self.limit = limit
        self.after = after
    }
    
    var isPaginating = false
    
    func fetchPost(paginating: Bool = false, setPosts: @escaping ([RedditPost]) -> Void) {
        if paginating {
            self.isPaginating = true
        }
        var urlComponents = URLComponents(string: "https://www.reddit.com/\(self.subreddit)/top.json")!
        urlComponents.queryItems = []
        urlComponents.queryItems?.append(URLQueryItem(name: "limit", value: String(limit)))
        if let after = self.after {
            urlComponents.queryItems?.append(URLQueryItem(name: "after", value: String(after)))
        }
        let urlSession = URLSession(configuration: .default)
        let _ = urlSession.dataTask(with: urlComponents.url!) { [weak self] data, error, responce in
            DispatchQueue.global(qos: .userInitiated).async {
                guard let data = data, let post = try? JSONDecoder().decode(PostLayer1.self, from: data) else { return }
                let fetchedPosts = post.data.children.map { (postItem) -> RedditPost in
                    RedditPost(from: postItem.data, after: post.data.after)
                }
                DispatchQueue.main.async {
                    setPosts(fetchedPosts)
                    self?.isPaginating = false
                }
            }
        }.resume()
    }
}
