//
//  DataSourceManager.swift
//  RedditAggregator
//
//  Created by Danylo Litvinchuk on 29.03.2022.
//

import Foundation

struct DataSourceManager {
    private var webPosts = [RedditPost]()
    
    mutating func update(with posts: [RedditPost]) {
        self.webPosts = posts
    }
    
    func getLastUpdate() -> [RedditPost] {
        return self.webPosts
    }
}
