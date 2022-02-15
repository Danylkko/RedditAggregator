//
//  PostBody.swift
//  RedditAggregator
//
//  Created by Danylo Litvinchuk on 13.02.2022.
//

import Foundation

struct PostLayer1: Codable {
    let kind: String
    let data: PostLayer2
}

struct PostLayer2: Codable {
    let after: String
    let dist: Int
    let modhash: String
    let geoFilter: String
    let children: [PostLayer3]
    
    enum CodingKeys: String, CodingKey {
        case after
        case dist
        case modhash
        case geoFilter = "geo_filter"
        case children
    }
}

struct PostLayer3: Codable {
    let kind: String
    let data: Post
}

struct Post: Codable {
    let username: String
    let domain: String
    let createdUTC: Double
    let title: String
    let media: String?
    let ups: Int
    let downs: Int
    let numComments: Int

    enum CodingKeys: String, CodingKey {
        case username = "author"
        case domain
        case createdUTC = "created_utc"
        case title
        case media
        case ups
        case downs
        case numComments = "num_comments"
    }
}
