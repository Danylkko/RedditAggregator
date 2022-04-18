//
//  PostCell.swift
//  RedditAggregator
//
//  Created by Danylo Litvinchuk on 21.02.2022.
//

import UIKit

protocol PostCellDelegate: AnyObject {
    func didTapShareButton(with url: String)
    func didTapSaveButton(with post: inout RedditPost)
    func didDoubleTapImageGesture(with post: inout RedditPost)
}

class PostCell: UITableViewCell  {
    
    weak var delegate: PostCellDelegate?
    var animationContainerView: UIView?
    
    //MARK:- IBoutlets
    
    @IBOutlet private weak var viewPostImage: UIView!
    @IBOutlet private weak var viewMetadata: UIView!
    
    @IBOutlet private weak var postImage: UIImageView!
    @IBOutlet private weak var postHeaderLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var domainLabel: UILabel!
    @IBOutlet private weak var bookmarkButton: UIButton!
    @IBOutlet private weak var ratingButton: UIButton!
    @IBOutlet private weak var commentsButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    
    //MARK:- IBactions
    @IBAction func shareActionButton(_ sender: Any) {
        guard let post = self.post else { return }
        self.delegate?.didTapShareButton(with: post.permalink)
    }
    
    @IBAction func saveActionButton(_ sender: Any) {
        guard var post = self.post else { return }
        self.delegate?.didTapSaveButton(with: &post)
    }
    
    @objc func didDoubleTapImageGesture() {
        guard var post = self.post else { return }
        self.delegate?.didDoubleTapImageGesture(with: &post)
        
        let bookmark = Bookmark(frame: self.postImage.frame)
        bookmark.animate(during: 0.5, to: self.postImage)
    }
    
    //MARK:- Other properties
    public var post: RedditPost?
    
    //MARK:- Behavior
    public func configurePost(post: RedditPost) {
        if let url = post.media {
            self.postImage.sd_setImage(with: URL(string: url), completed: nil)
        } else {
            self.postImage.image = #imageLiteral(resourceName: "Placehorders")
        }
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapImageGesture))
        doubleTap.numberOfTapsRequired = 2
        self.viewPostImage.addGestureRecognizer(doubleTap)
        doubleTap.delaysTouchesBegan = true
        
        self.ratingButton.setTitle("\(post.rating)", for: .normal)
        self.commentsButton.setTitle("\(post.numberOfComments)", for: .normal)
        self.shareButton.setTitle("Share", for: .normal)
        self.postHeaderLabel.text = post.title
        self.usernameLabel.text = post.author
        self.timeLabel.text = post.timePassed > 24 ? "\(post.timePassed / 24)d" : "\(post.timePassed)h"
        self.domainLabel.text = post.domain
        self.bookmarkButton.setImage(post.saved ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark"), for: .normal)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.postImage.subviews.forEach { $0.removeFromSuperview() }
    }
}
