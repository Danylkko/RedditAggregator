//
//  PostCell.swift
//  RedditAggregator
//
//  Created by Danylo Litvinchuk on 21.02.2022.
//

import UIKit

class PostCell: UITableViewCell  {
    
    //MARK:- IBoutlets
    @IBOutlet private weak var postImage: UIImageView!
    @IBOutlet private weak var postHeaderLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var domainLabel: UILabel!
    @IBOutlet private weak var bookmarkButton: UIButton!
    @IBOutlet private weak var ratingButton: UIButton!
    @IBOutlet private weak var commentsButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    
    //MARK:- Other properties
    public var post: RedditPost?
    
    public func configurePost(post: RedditPost) {
        if let url = post.media {
            self.postImage.sd_setImage(with: URL(string: url), completed: nil)
        } else {
            self.postImage.image = #imageLiteral(resourceName: "Placehorders")
        }
        self.ratingButton.setTitle("\(post.rating)", for: .normal)
        self.commentsButton.setTitle("\(post.numberOfComments)", for: .normal)
        self.shareButton.setTitle("Share", for: .normal)
        self.postHeaderLabel.text = post.title
        self.usernameLabel.text = post.author
        self.timeLabel.text = "\(post.timePassed)h"
        self.domainLabel.text = post.domain
        self.bookmarkButton.setImage(post.saved ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark"), for: .normal)
    }
}
