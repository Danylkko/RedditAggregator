//
//  PostListViewController.swift
//  RedditAggregator
//
//  Created by Danylo Litvinchuk on 21.02.2022.
//

import UIKit

class PostListViewController: UIViewController {
    
    //MARK: - IBoutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var subredditTitle: UINavigationItem!
    
    //MARK: - Other properties
    var postList = [RedditPost]()
    var fetcher = PostFetcher(limit: 10, after: nil)
    
    //MARK: - Behaviour
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.subredditTitle.title = fetcher.subreddit
        
        fetcher.fetchPost(setPosts: fillRedditPostList(list:))
    }
    
    private func fillRedditPostList(list: [RedditPost]) {
        let input = list
        input.forEach { item in
            item.saved = repository?.containsId(id: item.id) ?? false
        }
        self.postList += input
        tableView.reloadData()
    }
    
    //MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? PostCell, let post = cell.post else { return }
        guard let destination = segue.destination as? PostViewController else { return }
        destination.post = post
    }
    
}

//MARK:- Extensions

extension PostListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell_id", for: indexPath) as! PostCell
        cell.post = postList[indexPath.row]
        cell.configurePost(post: postList[indexPath.row])
        cell.delegate = self
        return cell;
    }
    
}

extension PostListViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - 250 - scrollView.frame.size.height) {
            guard !fetcher.isPaginating else { return }
            fetcher.limit = 10
            fetcher.after = postList.last?.after
            if fetcher.after == nil {
                print("QUERY ITEM 'AFTER' IS NIL")
                return
            }
            fetcher.fetchPost(paginating: true, setPosts: fillRedditPostList(list:))
        }
    }
    
}

extension PostListViewController: PostCellDelegate {
    
    func didTapSaveButton(with post: inout RedditPost) {
        post.saved.toggle()
        tableView.reloadData()
    }
    
    func didTapShareButton(with permalink: String) {
        let url = "https://www.reddit.com\(permalink)"
        let items = [url]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
    
}
