//
//  RedditPost.swift
//  RedditAggregator
//
//  Created by Danylo Litvinchuk on 15.02.2022.
//

import Foundation


struct Post {
    let post: PostLayer4
    
    let saved = Bool.random()
    
    init(from post: PostLayer4) {
        self.post = post
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
        //let tz = TimeZone.current.secondsFromGMT()
        return Calendar.current.component(.hour, from: Date(timeIntervalSince1970: post.createdUTC))
    }
    
}
