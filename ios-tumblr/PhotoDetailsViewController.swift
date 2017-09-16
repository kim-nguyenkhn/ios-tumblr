//
//  PhotoDetailsViewController.swift
//  ios-tumblr
//
//  Created by Nguyen, Kim on 9/15/17.
//  Copyright © 2017 knguyen1. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.image = self.image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
