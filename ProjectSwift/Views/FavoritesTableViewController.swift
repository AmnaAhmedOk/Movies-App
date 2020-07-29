//
//  FavoritesTableViewController.swift
//  ProjectSwift
//
//  Created by Amna Ahmed on 3/16/20.
//  Copyright © 2020 Amna Ahmed. All rights reserved.
//

import UIKit
import  SDWebImage

class FavoritesTableViewController: UITableViewController {
    var  favArr = [Favorites]()


    
    override func viewDidLoad() {
        super.viewDidLoad()

        favArr = MovieDatabase.sharedMovieDatabase.getFavorites()


    }
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
      /*  favArr = MovieDatabase.sharedMovieDatabase.getFavorites()*/

        self.tableView.reloadData()
    }
    
    
        override func viewWillAppear(_ animated: Bool) {
        /*print("view will appear")
            favArr.removeAll();
            MovieDatabase.sharedMovieDatabase.dropFav()

            
            self.tableView.reloadData()
        print(favArr.count)*/
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return favArr.count;
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      

        let label=cell.viewWithTag(2)as?UILabel
        label!.text=favArr[indexPath.row].title!
        let imgV=cell.viewWithTag(1)as?UIImageView
        let url = URL(string: favArr[indexPath.row].img!)
        imgV?.sd_setImage(with:  url , completed: nil);

        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150;
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
             MovieDatabase.sharedMovieDatabase.delete(id: favArr[indexPath.row].id!)
            self.favArr.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)

        }
    }

}
