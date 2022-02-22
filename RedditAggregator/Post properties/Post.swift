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
    let after: String?
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
    let data: PostLayer4
}

struct Preview: Codable{
    let images: [Image]
    
    enum CodingKeys: String, CodingKey{
        case images
    }
}

struct Image:Codable{
    let source: Source
    enum CodingKeys:String, CodingKey{
        case source
    }
}

struct Source: Codable{
    let url: String
    
    enum CodingKeys:String, CodingKey{
        case url
    }
}

struct PostLayer4: Codable {
    let author: String
    let domain: String
    let createdUTC: Double
    let title: String
    let preview: Preview?
    let ups: Int
    let downs: Int
    let numComments: Int
    
    enum CodingKeys: String, CodingKey {
        case author
        case domain
        case createdUTC = "created_utc"
        case title
        case preview
        case ups
        case downs
        case numComments = "num_comments"
    }
}

