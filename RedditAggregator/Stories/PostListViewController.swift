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
    @IBOutlet private weak var subredditTitle: UINavigationItem!
    @IBOutlet private weak var onlySavedModeButton: UIBarButtonItem!
    @IBOutlet private weak var searchField: UITextField!
    
    //MARK: - Other properties
    var postList = [RedditPost]()
    var fetcher = PostFetcher(limit: 10, after: nil)
    var onlySaved = false
    var sourceManager = DataSourceManager()
    
    //MARK: - Behaviour
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.searchField.delegate = self
        self.subredditTitle.title = fetcher.subreddit
        
        if !onlySaved {
            self.searchField.placeholder = "Search saved posts..."
        }
        
        fetcher.fetchPost(setPosts: fillRedditPostList(list:))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    private func fillRedditPostList(list: [RedditPost]) {
        let input = list
        input.forEach { item in
            item.saved = PostRepository.repository.containsId(id: item.id)
        }
        self.postList += input
        self.sourceManager.update(with: self.postList)
        tableView.reloadData()
    }
    
    @IBAction func onlySavedModeAction(_ sender: Any) {
        self.onlySaved.toggle()
        self.onlySavedModeButton.image = UIImage(systemName: self.onlySaved ? "bookmark.fill" : "bookmark")
        
        self.subredditTitle.titleView = self.searchField.inputView
        
        self.postList = self.onlySaved ?
            PostRepository.repository.getRedditPosts() :
            self.sourceManager.getLastUpdate()
        
        self.searchField.placeholder = self.onlySaved ?
            "Search..." :
            "Search saved posts..."
        
        self.tableView.reloadData()
        if self.postList.count != 0 {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: true)
        }
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

 // MARK: - UITableViewDelegate, pagination
extension PostListViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - 250 - scrollView.frame.size.height) && !onlySaved {
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

 // MARK: - PostCellDelegate
extension PostListViewController: PostCellDelegate {
    
    func didDoubleTapImageGesture(with post: inout RedditPost) {
        self.didTapSaveButton(with: &post)
    }
    
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
// MARK: - UITextFieldDelegate
extension PostListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        guard text.isEmpty else { return }
        self.postList = PostRepository.repository.getRedditPosts()
        tableView.reloadData()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let searchText = textField.text?.lowercased(), onlySaved else {
            print("palianytsia")
            return
        }
        
        let searchResults = PostRepository.repository.getRedditPosts()
            .filter { $0.title.lowercased().contains(searchText) }
        
        self.postList = searchResults
        
        self.tableView.reloadData()
    }
    
}
