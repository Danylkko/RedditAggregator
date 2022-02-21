//
//  PostViewController.swift
//  RedditAggregator
//
//  Created by Danylo Litvinchuk on 13.02.2022.
//

import UIKit
import SDWebImage

class PostViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var postView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var ratingButton: UIButton!
    @IBOutlet private weak var commentsButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var usenameLabel: UILabel!
    @IBOutlet private weak var timePassedLabel: UILabel!
    @IBOutlet private weak var domainLabel: UILabel!
    @IBOutlet private weak var bookmarkButton: UIButton!
    
    // MARK: - Behavior
    override func viewDidLoad() {
        super.viewDidLoad()
        postView.setShadow()

        let post = PostFetcher(limit: 10)
        post.fetchPost(setPosts: setTitles(posts:))
    }
    
    private func setTitles(posts: [RedditPost]) {
        let post = posts[0]
        if let url = post.media {
            self.imageView.sd_setImage(with: URL(string: url), completed: nil)
        }
        self.ratingButton.setTitle("\(post.rating)", for: .normal)
        self.commentsButton.setTitle("\(post.numberOfComments)", for: .normal)
        self.shareButton.setTitle("Share", for: .normal)
        self.headerLabel.text = post.title
        self.usenameLabel.text = post.author
        self.timePassedLabel.text = "\(post.timePassed)h"
        self.domainLabel.text = post.domain
        self.bookmarkButton.setImage(post.saved ?
                                        UIImage(systemName: "bookmark.fill") :
                                        UIImage(systemName: "bookmark"), for: .normal)
    }
}

// MARK: - Extensions
extension UIView {
    func setShadow() {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
    }
}
