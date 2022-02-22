//
//  RedditPost.swift
//  RedditAggregator
//
//  Created by Danylo Litvinchuk on 15.02.2022.
//

import Foundation


struct RedditPost {
    let post: PostLayer4
    
    let saved = Bool.random()
    
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
    
}
