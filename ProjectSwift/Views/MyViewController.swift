//
//  MyViewController.swift
//  ProjectSwift
//
//  Created by Amna Ahmed on 2/29/20.
//  Copyright © 2020 Amna Ahmed. All rights reserved.
//

import UIKit



import Alamofire
import SwiftyJSON
import SDWebImage






class MyViewController: UIViewController {
//create outltet from collection view
   
    @IBOutlet weak var collectionView: UICollectionView!;
    //cell identifier in itemViewControllercell
    let cellIdentifier = "cell";
    // to set number of rows and columns
    var collectionViewFL:UICollectionViewFlowLayout!;
    // segue idintifier
    let seguIdinifier = "viewDetailsSegueId";
    // titles'
    var titleArr = [String]()
    //releasw date
    var releaseDateArr = [String]()
    //image
    var posterPathArr = [String]()
    //vote_average
    var rateArr = [Double]()
    //overView
    var oveviewArr = [String]()
    //videos
    var videosArr = [String]()
    //ids
    var idArr = [Int]()
    //popularity
    var popularityArr = [Double]()
    //image base url + size
    let imgBaseUrl="https://image.tmdb.org/t/p/w185";
    var db = MovieDatabase.sharedMovieDatabase;
    var  movieObjArr = Array<Movie>()


        override func viewDidLoad() {
                super.viewDidLoad()
              setupCollectionView();
              navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(sortAction))
                checkConnection()
               
            
        }
    @objc func sortAction(){
        // Create An UIAlertController with Action Sheet
        
        let optionMenuController = UIAlertController(title: nil, message: "Choose Sort by Option ", preferredStyle: .actionSheet)
        
        // Create UIAlertAction for UIAlertController
        
        let addAction = UIAlertAction(title: "popularity", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("popularity")
            self.movieObjArr = self.movieObjArr.sorted(by: { $0.popularity < $1.popularity })
            self.collectionView.reloadData()
            
        })
        let saveAction = UIAlertAction(title: "Rating", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.movieObjArr = self.movieObjArr.sorted(by: { $0.releaseDate < $1.releaseDate })
            self.collectionView.reloadData()

        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        // Add UIAlertAction in UIAlertController
        
        optionMenuController.addAction(addAction)
        optionMenuController.addAction(saveAction)
        optionMenuController.addAction(cancelAction)
        
        // Present UIAlertController with Action Sheet
        
        self.present(optionMenuController, animated: true, completion: nil)

    }
  
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
        setupCollectionViewItemSize();
    }
    
 
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        // to get ItemCollectionViewCell
        let nib = UINib(nibName: "ItemCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    //responsive cell width  and hieght
    private func setupCollectionViewItemSize() {
        if collectionViewFL == nil{
            let numOfItemForRow :CGFloat = 2.0;
            let lineSpacing : CGFloat = 3.0;
            let interSpacing : CGFloat = 3.0;
           let width = (self.collectionView.frame.width - (numOfItemForRow - 1) * interSpacing )/numOfItemForRow;
            //let width = (collectionView.frame.size.width - interSpacing)/numOfItemForRow
            let height = width * 1.5;
            collectionViewFL = UICollectionViewFlowLayout();
            collectionViewFL.itemSize=CGSize(width: width, height: height);
            collectionViewFL.sectionInset=UIEdgeInsets.zero;
            collectionViewFL.scrollDirection = .vertical;
            collectionViewFL.minimumLineSpacing = lineSpacing
            collectionViewFL.minimumInteritemSpacing = interSpacing;
            collectionView.setCollectionViewLayout(collectionViewFL, animated: true);
            
            
            

            
        }
        
        
        
    }
 
    
    
    
    func fetchMovies(){
        DispatchQueue.main.async {
         
            
            Alamofire.request("https://api.themoviedb.org/3/discover/movie?page=3&api_key=380d8c64ab31c6718e3cdd8f8914347b").responseJSON(completionHandler: { (response) in
                switch response.result{
                case .success(let v):
                    let json = JSON(v)
                    self.idArr = json["results"].arrayValue.map {$0["id"].intValue}
                    self.popularityArr =  json["results"].arrayValue.map {$0["popularity"].doubleValue}
                    self.titleArr =  json["results"].arrayValue.map {$0["title"].stringValue}
                    self.oveviewArr =  json["results"].arrayValue.map {$0["overview"].stringValue}
                    self.posterPathArr =  json["results"].arrayValue.map {$0["poster_path"].stringValue}
                    self.videosArr =  json["results"].arrayValue.map {$0["video"].stringValue}
                    self.releaseDateArr =  json["results"].arrayValue.map {$0["release_date"].stringValue}
                    self.rateArr =  json["results"].arrayValue.map {$0["vote_average"].doubleValue}
                    for i in stride(from: 0, to: self.idArr.count, by: 1) {
                    let currentMovie : Movie = Movie.init(id: self.idArr[i], title: self.titleArr[i], rating : self.rateArr[i], overview: self.oveviewArr[i], img: self.imgBaseUrl+self.posterPathArr[i], popularity: self.popularityArr[i], releaseDate: self.releaseDateArr[i], vid: self.videosArr[i]);
                    self.movieObjArr.append(currentMovie)
                    print(self.idArr[i])
                        self.db.saveMovie(movie: currentMovie);

                }
                
                case .failure(let error):
                print(error)
               
                }
                
                print(self.movieObjArr.count)

                self.collectionView.reloadData()

                
            })
            


}
    }
    
    func checkConnection()  {
        let reachabilityManager = NetworkReachabilityManager()
        
        reachabilityManager?.startListening()
        reachabilityManager?.listener = { _ in
            if let isNetworkReachable = reachabilityManager?.isReachable,
                isNetworkReachable == true {
                    self.db.dropMovie()
                    self.db.createDatabases()
                self.fetchMovies();
                print("connected")
            } else {
                self.movieObjArr =  self.db.getMovies();
                self.collectionView.reloadData()
                
                print("no internet   \(self.movieObjArr)")
            }
        }
        

    }
    
    
   
    
    
    
    
}


extension MyViewController : UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
     
        return  self.movieObjArr.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ItemCollectionViewCell;
       // cell.title.text=titleArr[indexPath.row]
        let url = URL(string: (movieObjArr[indexPath.row].imagePath));
        cell.imageView?.sd_setImage(with: url , completed: nil);
        


        return cell;
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "Dsec")as!DetailsTableViewController;
        vc.id=idArr[indexPath.row]
        vc.movie = movieObjArr[indexPath.row];
        vc.Dtitle = titleArr[indexPath.row]
        vc.vote = rateArr[indexPath.row]
        vc.date = releaseDateArr[indexPath.row]
        vc.overView = oveviewArr[indexPath.row]
        //vc.video = v;
        vc.Dimg = "https://image.tmdb.org/t/p/w92" + posterPathArr[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        

        
    }
    
    
    
}
