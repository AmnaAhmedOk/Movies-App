//
//  MoviePOJO.swift
//  ProjectSwift
//
//  Created by Amna Ahmed on 3/8/20.
//  Copyright © 2020 Amna Ahmed. All rights reserved.
//

import Foundation
struct Movie {
   
    
    var title:String;
    var rating:Double;
    var overview:String;
    var imagePath:String;
    var video:String;
    var arrReviewAuthor = Array<String>();
    var arrReviewContent = Array<String>();
    var popularity:Double;
    var releaseDate:String;
    var id:Int;
    
    init( id : Int , title : String , rating : Double , overview : String , img : String , popularity : Double , releaseDate : String , vid : String ) {
        self.id = id ;
        self.title = title;
        self.rating = rating
        self.overview = overview;
        self.imagePath = img;
        self.popularity = popularity;
        self.releaseDate = releaseDate;
        self.video = vid
    }
    
    init() {
        self.id = 0 ;
        self.title = "";
        self.rating = 0.0
        self.overview = "";
        self.imagePath = "";
        self.popularity = 0.0
        self.releaseDate = "";
        self.video = " "

    }
}
