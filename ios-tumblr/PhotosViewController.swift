//
//  PhotosViewController.swift
//  ios-tumblr
//
//  Created by Nguyen, Kim on 9/14/17.
//  Copyright © 2017 knguyen1. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var posts: [NSDictionary] = []
    var image: UIImage!
    let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        
        // config datasource & delegate
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 240;

        // call the network request
        getTumblrPosts()

    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: network request
    func getTumblrPosts() {
        let request = URLRequest(url: self.url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        print("responseDictionary: \(responseDictionary)")
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        
                        // This is where you will store the returned array of posts in your posts property
                        self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                        
                        self.tableView.reloadData()
                    }
                }
        });
        task.resume()
    }

    // define number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    // configure custom table view cells -- called each time a cell is made or referenced
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoTableViewCell", for: indexPath) as! PhotoTableViewCell
//        cell.textLabel?.text = "\(indexPath.row)"
        
        // pull out the single post
        let post = posts[indexPath.row]
        
        // get the list of photos for this post
        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] {
            // photos is NOT nil, go ahead and access
            let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String
            if let imageUrl = URL(string: imageUrlString!) {
                cell.photoImageView.setImageWith(imageUrl)
            } else {
                // imageUrlString is nil
            }
        } else {
            // photos is nil
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: segueing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination as! PhotoDetailsViewController
        
        
        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
        let cell = self.tableView.cellForRow(at: indexPath) as! PhotoTableViewCell
        destinationViewController.image = cell.photoImageView.image
        
        
        
        
        
    }

    // MARK: refresh control
    // 1. makes a network request to get updated data
    // 2. updates the tableView with the new data
    // 3. hides the refreshControl
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        // create a request
        let request = URLRequest(url: self.url!)
        
        // configure session so that completion handler is executed on main UI thread
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            // use the new data to update the data source
            if let data = data {
                if let responseDictionary = try! JSONSerialization.jsonObject(
                    with: data, options:[]) as? NSDictionary {
                    print("responseDictionary: \(responseDictionary)")
                    
                    // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                    // This is how we get the 'response' field
                    let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                    
                    // This is where you will store the returned array of posts in your posts property
                    self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                    
                    self.tableView.reloadData()
                }
            }
            
            // tell refreshControl to stop spinning
            refreshControl.endRefreshing()
        }
        task.resume()
    }
    
    
}
