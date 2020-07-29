//
//  MovieDatabase.swift
//  ProjectSwift
//
//  Created by Amna Ahmed on 3/8/20.
//  Copyright © 2020 Amna Ahmed. All rights reserved.
//

import Foundation


class MovieDatabase {
    static let sharedMovieDatabase = MovieDatabase()
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    var db: OpaquePointer? = nil
    private init() {
         //Create database file
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("contacts3.sqlite")
        
        // Open database
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
    }
    
    func createDatabases() {
       
        
        
        // Create Table
        if sqlite3_exec(db, "create table if not exists Movie (id integer primary key,title text, image text,video text,rating text,date text,popularity text,overview text)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error creating table: \(errmsg)")
        }
        if sqlite3_exec(db, "create table if not exists reviews (id integer, author text, review text ,PRIMARY KEY (id, author) ,FOREIGN KEY (id) REFERENCES Movie (id))", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error creating table: \(errmsg)")
        }
        // favorite
        if sqlite3_exec(db, "create table if not exists favorites (id integer, title text, image text)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error creating table: \(errmsg)")
        }
        else{
            print("creating table Favoto")

        }
    }
    
   
    func saveMovie(movie:Movie)  {
         var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, "insert into Movie (id,title,image,video,rating,date,popularity,overview) values (?,?,?,?,?,?,?,?)", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error preparing insert: \(errmsg)")
            
        }
        if sqlite3_bind_int(statement, 1, Int32(movie.id)) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("failure binding name: \(errmsg)")
        }
        if sqlite3_bind_text(statement, 2,movie.title , -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("failure binding name: \(errmsg)")
        }
        if sqlite3_bind_text(statement, 3, movie.imagePath , -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("failure binding name: \(errmsg)")
        }
        if sqlite3_bind_text(statement, 4, movie.video , -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("failure binding name: \(errmsg)")
        }
        if sqlite3_bind_text(statement, 5, String(movie.rating) , -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("failure binding name: \(errmsg)")
        }
        if sqlite3_bind_text(statement, 6, movie.releaseDate , -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("failure binding name: \(errmsg)")
        }
        if sqlite3_bind_text(statement, 7, String(movie.popularity) , -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("failure binding name: \(errmsg)")
        }
        if sqlite3_bind_text(statement, 8, movie.overview , -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("failure binding name: \(errmsg)")
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("failure inserting into contact: \(errmsg)")
        }
        
        
    }
    
    func saveMovieReview(movie:Movie){
        var  i:Int = 0;
        var arrAuthor = movie.arrReviewAuthor
        var arrContent = movie.arrReviewContent
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, "insert into reviews (id,author,review) values (?,?,?)", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error preparing insert: \(errmsg)")
            
        }
        while arrAuthor.count > i {
            if sqlite3_bind_int(statement, 1, Int32(movie.id)) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("failure binding name: \(errmsg)")
            }
            if sqlite3_bind_text(statement, 2,arrAuthor[i] , -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("failure binding name: \(errmsg)")
            }
            if sqlite3_bind_text(statement, 3,arrContent[i] , -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("failure binding name: \(errmsg)")
            }
            i += 1;
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("failure inserting into contact: \(errmsg)")
        }
    }
    
    func saveFavorites(id : Int , title : String , img : String)  {
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, "insert into favorites (id,title,image) values (?,?,?)", -1, &statement, nil)
            != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error preparing insert: \(errmsg)")
            
        }
        else{
            sqlite3_bind_int(statement, 1, Int32(id))
            sqlite3_bind_text(statement, 2, title, -1, nil)
            sqlite3_bind_text(statement, 3, img, -1, nil)


        }
        
        if sqlite3_step(statement) == SQLITE_DONE {

        print("fav insert Done \(id)  \(title) \(img)")
        }
        sqlite3_finalize(statement)

        
    }
    
    func dropMovie(){
        if sqlite3_exec(db, "drop table if exists Movie", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error creating table: \(errmsg)")
        }
        if sqlite3_exec(db, "drop table if exists reviews", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error creating table: \(errmsg)")
        }
    }

    func dropFav(){
        // favorite
        if sqlite3_exec(db, "drop table if not exists favorites", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error creating table: \(errmsg)")
        }
    }
    
    func getMovies ()-> (Array<Movie>){
        var  movieArr : Array<Movie> = [Movie]()

        var statment: OpaquePointer? = nil
        if   sqlite3_prepare_v2(db, "select * from Movie", -1 , &statment , nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error preparing fav insert: \(errmsg)")
        }
        
        print("preparing fav select fav done \(statment!)")
        while (sqlite3_step(statment) == SQLITE_ROW)
        {
            var movie : Movie = Movie.init();
            movie.id = Int(sqlite3_column_int(statment, 0))
            let colTitle = sqlite3_column_text(statment, 1);
            let colImg = sqlite3_column_text(statment, 2);
            let coVideo = sqlite3_column_text(statment, 3);
            let colDateelease = sqlite3_column_text(statment, 5);
            let colOverview = sqlite3_column_text(statment, 7);

            movie.title = String(cString: colTitle!);
            movie.imagePath = String(cString: colImg!);
            movie.video = String(cString: coVideo!);
            movie.rating = sqlite3_column_double(statment, 4);
            movie.releaseDate = String(cString: colDateelease!);
            movie.popularity = sqlite3_column_double(statment, 61);
            movie.releaseDate = String(cString: colDateelease!);
            movie.overview = String(cString: colOverview!);

            movieArr.append(movie)
            
        }
        

        return movieArr;
    }
    
    
    
    var  favArr : Array<Favorites> = [Favorites]()

    func getFavorites ()-> (Array<Favorites>){
        var statment: OpaquePointer? = nil
        if   sqlite3_prepare_v2(db, "select * from favorites", -1 , &statment , nil) != SQLITE_OK{
        let errmsg = String(cString: sqlite3_errmsg(db))
        print("error preparing fav insert: \(errmsg)")
        }
        
            print("preparing fav select fav done \(statment!)")
        while (sqlite3_step(statment) == SQLITE_ROW)
        {
            
                 var  fav : Favorites = Favorites.init();
                fav.id = Int(sqlite3_column_int(statment, 0))
                let colTitle = sqlite3_column_text(statment, 1);
                let colImg = sqlite3_column_text(statment, 2);
                
                fav.title = String(cString: colTitle!);
                fav.img = String(cString: colImg!);

                favArr.append(fav)
                
            }
        
        
        
        return favArr;
    }
    
    
    func getFavoritesIDs ()-> (Array<Int>){
        var  favArr = Array<Int>()
        var statment: OpaquePointer? = nil
        if   sqlite3_prepare_v2(db, "select id from favorites", -1 , &statment , nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error preparing fav insert: \(errmsg)")
        }
        
        print("preparing fav select fav done \(statment!)")
        while (sqlite3_step(statment) == SQLITE_ROW)
        {
            let FavId = Int(sqlite3_column_int(statment, 0))
              favArr.append(FavId)
            
        }
        
        return favArr;
    }
    
   
    func delete(id : Int ) {
        let deleteStatementString = "DELETE FROM favorites WHERE id = ?;"
        var deleteStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        
        
        
        sqlite3_finalize(deleteStatement)
        
        
        print("delete")
        

    }

    
  
    
}


