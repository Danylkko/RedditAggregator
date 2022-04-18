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
    
    //MARK: - Other properties
    public var post: RedditPost?
    
    // MARK: - Behavior
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postView.setShadow()
        guard let chosenPost = post else { return }
        // MARK:- that's the way to force imageView to respond to gesture recognizer
        self.imageView.isUserInteractionEnabled = true
        self.setTitles(post: chosenPost)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapImageGesture))
        doubleTap.numberOfTapsRequired = 2
        self.imageView.addGestureRecognizer(doubleTap)
        doubleTap.delaysTouchesBegan = true
    }
    
    public func setTitles(post: RedditPost) {
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
    
    //MARK:- IBActions
    
    @IBAction func shareActionButton(_ sender: Any) {
        guard let post = self.post else {
            print("Post is nil...")
            return
        }
        let url = "https://www.reddit.com\(post.permalink)"
        let items = [url]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
    @IBAction func saveActionButton(_ sender: Any) {
        guard let post = self.post else { return }
        post.saved.toggle()
        setTitles(post: post)
    }
    
    @objc func didDoubleTapImageGesture() {
        guard let post = self.post else { return }
        post.saved.toggle()
        setTitles(post: post)
        
        //TODO fix that view doesn't appears in the middle
        let bookmark = Bookmark(frame: self.imageView.frame)
        bookmark.animate(during: 0.5, to: self.postView)
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
