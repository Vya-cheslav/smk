//
//  Films.swift
//  SMK
//
//  Created by Вячеслав Рожнов on .10.2018.
//

import Foundation
import SwiftyJSON
import SQLite

class Film {
  
  let service = Service()
  
  
  
  var imdbID: String = ""
  var title: String = ""
  var year: String = ""
  var type: String = ""
  var poster: String = ""
  var runtime: String = ""
  var plot: String = ""
  var genre: String = ""
  var released: String = ""
  var country: String = ""
  var rating: String = ""
  var director: String = ""
  var writer: String = ""
  var bookmark: Bool = false
  
  
  
  
  
  convenience init(json: JSON) {
    
    self.init()
    
    self.imdbID = json["imdbID"].stringValue
    self.title = json["Title"].stringValue
    self.year = json["Year"].stringValue
    self.type = json["Type"].stringValue
    self.poster = json["Poster"].stringValue
    switch json["Plot"] {
    case nil:
      service.getData(json["imdbID"].stringValue, queryType: Service.queryType.full) { (data, error) in
        if let data = data?[0]{
          self.runtime = data.runtime
          self.plot = data.plot
          self.genre = data.genre
          self.released = data.released
          self.country = data.country
          self.rating = data.rating
          self.director = data.director
          self.writer = data.writer
        }
      }
    default:
      self.runtime = json["Runtime"].stringValue
      self.plot = json["Plot"].stringValue
      self.genre = json["Genre"].stringValue
      self.released = json["Released"].stringValue
      self.country = json["Country"].stringValue
      self.rating = json["Rating"].stringValue
      self.director = json["Director"].stringValue
      self.writer = json["Writer"].stringValue
    }
    
  }
  
  convenience init(row: Row) {
    
    self.init()
    
    self.imdbID = row[Expression<String>("imdbID")]
    self.title = row[Expression<String>("title")]
    self.year = row[Expression<String>("year")]
    self.type = row[Expression<String>("type")]
    self.poster = row[Expression<String>("poster")]
    self.runtime = row[Expression<String>("runtime")]
    self.plot = row[Expression<String>("plot")]
    self.genre = row[Expression<String>("genre")]
    self.released = row[Expression<String>("released")]
    self.country = row[Expression<String>("country")]
    self.rating = row[Expression<String>("rating")]
    self.director = row[Expression<String>("director")]
    self.writer = row[Expression<String>("writer")]
    self.bookmark = true
    
  }
  
  func getColumnsForSqlite() -> [String: [String: Any]] {
    
    var dictionaryColumn = [String: [String: Any]]()
    
    dictionaryColumn["imdbID"]    = ["expression": Expression<String>("imdbID"), "isPrimaryKey": true]
    dictionaryColumn["title"]     = ["expression": Expression<String>("title"), "isPrimaryKey": false]
    dictionaryColumn["year"]      = ["expression": Expression<String>("year"), "isPrimaryKey": false]
    dictionaryColumn["type"]      = ["expression": Expression<String>("type"), "isPrimaryKey": false]
    dictionaryColumn["poster"]    = ["expression": Expression<String>("poster"), "isPrimaryKey": false]
    dictionaryColumn["runtime"]   = ["expression": Expression<String>("runtime"), "isPrimaryKey": false]
    dictionaryColumn["plot"]      = ["expression": Expression<String>("plot"), "isPrimaryKey": false]
    dictionaryColumn["genre"]     = ["expression": Expression<String>("genre"), "isPrimaryKey": false]
    dictionaryColumn["released"]  = ["expression": Expression<String>("released"), "isPrimaryKey": false]
    dictionaryColumn["country"]   = ["expression": Expression<String>("country"), "isPrimaryKey": false]
    dictionaryColumn["rating"]    = ["expression": Expression<String>("rating"), "isPrimaryKey": false]
    dictionaryColumn["director"]  = ["expression": Expression<String>("director"), "isPrimaryKey": false]
    dictionaryColumn["writer"]    = ["expression": Expression<String>("writer"), "isPrimaryKey": false]

  
    return dictionaryColumn
  }
  
  func getInsertForSqlite(table: Table, film: Film) -> Insert {
    
    let arrayColumn = self.getColumnsForSqlite()
    let insert = table.insert((arrayColumn["imdbID"]!["expression"] as! Expression<String>) <- film.imdbID,
                              (arrayColumn["title"]!["expression"] as! Expression<String>) <- film.title,
                              (arrayColumn["year"]!["expression"] as! Expression<String>) <- film.year,
                              (arrayColumn["type"]!["expression"] as! Expression<String>) <- film.type,
                              (arrayColumn["poster"]!["expression"] as! Expression<String>) <- film.poster,
                              (arrayColumn["runtime"]!["expression"] as! Expression<String>) <- film.runtime,
                              (arrayColumn["plot"]!["expression"] as! Expression<String>) <- film.plot,
                              (arrayColumn["genre"]!["expression"] as! Expression<String>) <- film.genre,
                              (arrayColumn["released"]!["expression"] as! Expression<String>) <- film.released,
                              (arrayColumn["country"]!["expression"] as! Expression<String>) <- film.country,
                              (arrayColumn["rating"]!["expression"] as! Expression<String>) <- film.rating,
                              (arrayColumn["director"]!["expression"] as! Expression<String>) <- film.director,
                              (arrayColumn["writer"]!["expression"] as! Expression<String>) <- film.writer)
    
    return insert
  }
  
}
