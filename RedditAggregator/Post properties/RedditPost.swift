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
            if newValue {
                let _ = PostRepository.repository.save(post: post)
                //print("post is saved")
            } else if saved && !newValue {
                let _ = PostRepository.repository.remove(post: post)
                //print("post is removed")
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
        let hours = Calendar.current.component(.hour, from: Date(timeIntervalSince1970: post.createdUTC))
        let days = Calendar.current.component(.day, from: Date(timeIntervalSince1970: post.createdUTC))
        return days > 0 ? (days * 24 + hours) : hours
    }
    
    var permalink: String {
        post.permalink
    }
    
    var id: String {
        post.id
    }
    
}
