//
//  PostFetcher.swift
//  RedditAggregator
//
//  Created by Danylo Litvinchuk on 13.02.2022.
//

import UIKit

struct PostFetcher {
    let subreddit: String
    let limit: Int
    let after: Int
    
    init(subreddit: String = "ios", limit: Int = 1, after: Int = 0) {
        self.subreddit = subreddit
        self.limit = limit
        self.after = after
    }
    
    func fetchPost(setPosts: @escaping ([RedditPost]) -> Void) {
        var urlComponents = URLComponents(string: "https://www.reddit.com/r/\(self.subreddit)/top.json")!
        urlComponents.queryItems = []
        urlComponents.queryItems?.append(URLQueryItem(name: "limit", value: String(limit)))
        urlComponents.queryItems?.append(URLQueryItem(name: "after", value: String(after)))
        
        let urlSesion = URLSession(configuration: .default)
        let _ = urlSesion.dataTask(with: urlComponents.url!) { data, error, responce in
            DispatchQueue.global(qos: .userInitiated).async {
                guard let data = data, let post = try? JSONDecoder().decode(PostLayer1.self, from: data) else { return }
                let fetchedPosts = post.data.children.map { (postItem) -> RedditPost in
                    RedditPost(from: postItem.data)
                }
                DispatchQueue.main.async {
                    setPosts(fetchedPosts)
                }
            }
        }.resume()
    }
}
