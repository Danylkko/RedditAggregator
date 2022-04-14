//
//  PostRepository.swift
//  RedditAggregator
//
//  Created by Danylo Litvinchuk on 12.03.2022.
//

import Foundation

class PostRepository {
    public static let repository = PostRepository(to: "saved_posts.json")
    
    private let path: URL
    private var savedPosts: [PostLayer4]
    
    init(to: String) {
        self.path = PostRepository.getDocumentsDirectory().appendingPathComponent(to)
        if let data = try? Data(contentsOf: path), let cache = try? JSONDecoder().decode([PostLayer4].self, from: data) {
            self.savedPosts = cache
            //print("cache is \(cache) and data is \(data)")
        } else {
            self.savedPosts = []
        }
    }
    
    public func getRawPosts() -> [PostLayer4] {
        self.savedPosts
    }
    
    public func getRedditPosts() -> [RedditPost] {
        self.savedPosts.map { post in
            let redditPost = RedditPost(from: post, after: nil)
            redditPost.saved = true
            return redditPost
        }.reversed()
    }
    
    public func containsId(id: String) -> Bool{
        savedPosts.first{ $0.id == id } != nil
    }
    
    public func backup() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        let data = try! encoder.encode(self.savedPosts)
        print(self.savedPosts)
        do {
            try String(data: data, encoding: .utf8)!.write(to: self.path, atomically: true, encoding: .utf8)
        } catch {
            print("backup error \(error.localizedDescription)")
        }
    }
    
    public func save(post: PostLayer4) -> Bool {
        if savedPosts.first(where: { $0.id == post.id }) == nil {
            savedPosts.append(post)
            return true
        }
        return false
    }
    
    public func remove(post: PostLayer4) -> Bool {
        let preRemoveCount = savedPosts.count
        savedPosts.removeAll { $0.id == post.id }
        return preRemoveCount == savedPosts.count + 1
    }
    
    static func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
}
