//
//  PostListViewController.swift
//  RedditAggregator
//
//  Created by Danylo Litvinchuk on 21.02.2022.
//

import UIKit

class PostListViewController: UIViewController {
    
    //MARK:- IBoutlets
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK:- Other properties
    var postList = [RedditPost]()
    var fetcher = PostFetcher(limit: 10)
    
    //MARK:- Behaviour
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self

        fetcher.fetchPost(setPosts: fillRedditPostList(list:))
    }
    
    private func fillRedditPostList(list: [RedditPost]) {
        self.postList = list
        tableView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PostListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell_id", for: indexPath) as! PostCell
        cell.configurePost(post: postList[indexPath.row])
        return cell;
    }
    
    
}
