//
//  PostViewController.swift
//  RedditAggregator
//
//  Created by Danylo Litvinchuk on 13.02.2022.
//

import UIKit

class PostViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var postView: UIView!
    
    // MARK: - Behavior
    override func viewDidLoad() {
        super.viewDidLoad()
        postView.setShadow()
        let post = FetchPost(limit: 2)
        post.fetchPost()
        // Do any additional setup after loading the view.
    }
    
}

extension UIView {
    func setShadow() {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
    }
}
