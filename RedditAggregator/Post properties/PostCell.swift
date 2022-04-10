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
        self.timeLabel.text = "\(post.timePassed)h"
        self.domainLabel.text = post.domain
        self.bookmarkButton.setImage(post.saved ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark"), for: .normal)
        // to show normal bookmark button remove line below
        self.bookmarkButton.isHidden = true
        
        self.bookmarkFigure(in: self.viewMetadata)
    }
    
    //MARK:- Custom Graphics
    
    private func bookmarkFigure(in view: UIView) {
        let start = CGPoint(
            x: view.frame.width - BookmarkConstants.marginFromRightEdge - BookmarkConstants.width,
            y: view.frame.midY - BookmarkConstants.height / 2)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: CGPoint(x: start.x + BookmarkConstants.width,
                                 y: start.y))
        path.addLine(to: CGPoint(x: start.x + BookmarkConstants.width,
                                 y: start.y + BookmarkConstants.height))
        path.addLine(to: CGPoint(x: start.x + BookmarkConstants.width / 2,
                                 y: start.y + BookmarkConstants.height - BookmarkConstants.curveDiff))
        path.addLine(to: CGPoint(x: start.x,
                                 y: start.y + BookmarkConstants.height))
        path.addLine(to: start)
        
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.fillColor = UIColor.yellow.cgColor
        shapeLayer.lineWidth = BookmarkConstants.lineWidth
        
        view.layer.addSublayer(shapeLayer)
    }
    
    struct BookmarkConstants {
        private static let constLength: CGFloat = 10
        
        static let marginFromRightEdge: CGFloat = 20
        
        static var height: CGFloat {
            constLength * 1.8
        }
        
        static var width: CGFloat {
            constLength
        }
        
        static var curveDiff: CGFloat {
            constLength * 0.5
        }
        
        static let lineWidth: CGFloat = 1.5
        
    }
}
