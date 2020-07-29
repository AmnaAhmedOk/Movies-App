//
//  DetailsTableViewController.swift
//  ProjectSwift
//
//  Created by Amna Ahmed on 3/12/20.
//  Copyright © 2020 Amna Ahmed. All rights reserved.
//

import UIKit
import YouTubePlayer_Swift
import MKMagneticProgress
import Alamofire
import SwiftyJSON
import MBCircularProgressBar


class DetailsTableViewController: UITableViewController {

    @IBOutlet weak var fav_btn: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mkProgress: MBCircularProgressBarView!
    @IBOutlet weak var videoPlayer: YouTubePlayerView!
    @IBOutlet weak var overViewlabel: UILabel!
    
   
    
    ///                MovieDatabase.sharedMovieDatabase;

    var Dtitle : String?
    var date : String?
    var vote : Double=0
    var id : Int?
    var video : String = "";
    var overView : String?
    var Dimg : String? ;
    var  favArrId = Array<Int>()
    var flag = 0;
    var movie:Movie = Movie();


    @IBAction func addFav_Action(_ sender: Any) {
        
        favArrId = MovieDatabase.sharedMovieDatabase.getFavoritesIDs();
        for item in favArrId {
            if id! == item
            {
                MovieDatabase.sharedMovieDatabase.delete(id: id!);
                
                flag = 1;
                popUp(context: self, msg: "Removed from favorites")

                   fav_btn.setImage( UIImage.init(named: "empty.png"), for: .normal)
                break
            }
        }
        
        
        if flag == 0{

        MovieDatabase.sharedMovieDatabase.saveFavorites(id: id!, title: Dtitle!, img: Dimg!)
        
            popUp(context: self, msg: "Added to favorites")
            flag = 1;
              fav_btn.setImage( UIImage.init(named: "full_heart.png"), for: .normal)

        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            fetchVideo(idm: id!)
        favArrId = MovieDatabase.sharedMovieDatabase.getFavoritesIDs();
        for item in favArrId {
            if id == item
            {
            fav_btn.setImage( UIImage.init(named: "full_heart.png"), for: .normal)
                break
            }

        }
        titleLabel.text = Dtitle;
        dateLabel.text = date;
        overViewlabel.text = overView;
        UIView.animate(withDuration: 2.0){
            self.mkProgress.value = CGFloat(self.vote*10)

        }
}
    

     func popUp(context ctx: UIViewController, msg: String) {
        
        let toast = UILabel(frame:
            CGRect(x: 16, y: ctx.view.frame.size.height / 2,
                   width: ctx.view.frame.size.width - 32, height: 70))
        
        toast.backgroundColor = UIColor.lightGray
        toast.textColor = UIColor.white
        toast.textAlignment = .center;
        toast.numberOfLines = 3
        toast.font = UIFont.systemFont(ofSize: 20)
        toast.layer.cornerRadius = 12;
        toast.clipsToBounds  =  true
        
        toast.text = msg
        
        ctx.view.addSubview(toast)
        
        UIView.animate(withDuration: 5.0, delay: 0.2,
                       options: .curveEaseOut, animations: {
                        toast.alpha = 0.0
        }, completion: {(isCompleted) in
            toast.removeFromSuperview()
        })
    }
    
    func fetchVideo(idm:Int) -> (){
        var vad : String = "";
            
            let url = "https://api.themoviedb.org/3/movie/\(idm)/videos?api_key=380d8c64ab31c6718e3cdd8f8914347b"
            Alamofire.request(url).responseJSON(completionHandler: { (response) in
                switch response.result{
                case .success(let v):
                    let json = JSON(v)
                vad = json["results"][0]["key"].string!
                    
                    self.videoPlayer.loadVideoID(vad);

                case .failure(let error):
                    print(error)
                    
                }
                
                
                
            })
        }
    
        
    
    @IBAction func reviewsDetails(_ sender: Any) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "review")as!ReviewsTableViewController;
        vc.id = id;
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
