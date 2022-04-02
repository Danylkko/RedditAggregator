//
//  RedditPost.swift
//  RedditAggregator
//
//  Created by Danylo Litvinchuk on 15.02.2022.
//

import Foundation


class RedditPost: Codable {
    
    let post: PostLayer4
    
    var saved = false {
        willSet {
            guard let repository = repository else {
                print("repository doesn't exist error.")
                return
            }
            if newValue {
                let _ = repository.save(post: post)
                print("post is saved")
            } else if saved && !newValue {
                let _ = repository.remove(post: post)
                print("post is removed")
            }
        }
    }
    
    let after: String?
    
    init(from post: PostLayer4, after: String?) {
        self.post = post
        self.after = after
    }
    
    var author: String {
        post.author
    }
    
    var domain: String {
        post.domain
    }
    
    var title: String {
        post.title
    }
    
    var media: String? {
        post.preview?.images[0].source.url.replacingOccurrences(of: "amp;", with: "")
    }
    
    var rating: Int {
        post.ups - post.downs
    }
    
    var numberOfComments: Int {
        post.numComments
    }
    
    var timePassed: Int {
        let time = Calendar.current.component(.hour, from: Date(timeIntervalSince1970: post.createdUTC))
        return time - 2
    }
    
    var permalink: String {
        post.permalink
    }
    
    var id: String {
        post.id
    }
    
}
