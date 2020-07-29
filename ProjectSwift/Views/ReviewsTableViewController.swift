//
//  ReviewsTableViewController.swift
//  ProjectSwift
//
//  Created by Amna Ahmed on 3/13/20.
//  Copyright © 2020 Amna Ahmed. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ReviewsTableViewController: UITableViewController {
    //https://api.themoviedb.org/3/movie/300671/reviews?api_key=380d8c64ab31c6718e3cdd8f8914347b
    var authorsArr = [String]()
    var contentArr = [String]()
    var id : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
       fetchReviews()
    }
    
    
    func fetchReviews(){
        DispatchQueue.main.async {
            
            
            
            Alamofire.request("https://api.themoviedb.org/3/movie/\(self.id!)/reviews?api_key=380d8c64ab31c6718e3cdd8f8914347b").responseJSON(completionHandler: { (response) in
                switch response.result{
                case .success(let v):
                    let json = JSON(v)
                    self.authorsArr =  json["results"].arrayValue.map {$0["author"].stringValue}
                    self.contentArr =  json["results"].arrayValue.map {$0["content"].stringValue}
                    
                    
                    print(self.authorsArr.count)
                    
                    
                    
                case .failure(let error):
                    print(error)
                    
                }
                self.tableView.reloadData()
                
                
            })
            
            
            
        }
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return authorsArr.count;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text=authorsArr[indexPath.row]
     cell.detailTextLabel?.text=contentArr[indexPath.row]

        return cell
    }
    



  

}
