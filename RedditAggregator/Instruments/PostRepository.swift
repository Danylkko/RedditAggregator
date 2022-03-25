//
//  PostRepository.swift
//  RedditAggregator
//
//  Created by Danylo Litvinchuk on 12.03.2022.
//

import Foundation

struct PostRepository {
    let path: URL
    var savedPosts: [PostLayer4]
    
    init(to: String) {
        self.path = PostRepository.getDocumentsDirectory().appendingPathComponent(to)
        if let data = try? Data(contentsOf: path), let cache = try? JSONDecoder().decode([PostLayer4].self, from: data) {
            self.savedPosts = cache
            print("cache is \(cache) and data is \(data)")
        } else {
            self.savedPosts = []
        }
    }
    
    func containsId(id: String) -> Bool{
        return savedPosts.first{ $0.id == id } != nil
    }
    
    func backup() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        let data = try! encoder.encode(self.savedPosts)
        do {
            try String(data: data, encoding: .utf8)!.write(to: self.path, atomically: true, encoding: .utf8)
        } catch {
            print("backup error \(error.localizedDescription)")
        }
    }
    
    mutating func save(post: PostLayer4) -> Bool {
        if savedPosts.first(where: { $0.id == post.id }) == nil {
            savedPosts.append(post)
            return true
        }
        return false
    }
    
    mutating func remove(post: PostLayer4) -> Bool {
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
