//
//  GlobalVarManager.swift
//  SMK
//
//  Created by Вячеслав Рожнов on
//

import Foundation
import SQLite

class DatabaseManager {
  
  var database: Connection!
  let tableFilm = Table("films")
  
  static let sharedInstance = DatabaseManager()
  
  private init() {
    
    do {
      let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
      let fileUrl = documentDirectory.appendingPathComponent("db").appendingPathExtension("sqlite")
      let database = try Connection(fileUrl.path)
      self.database = database
    } catch {
      print(error)
    }
    
    let tableCreate = tableFilm.create { table in
      
      let arrayColumn = Film().getColumnsForSqlite()
      
      for (_, value) in arrayColumn {
        if ((value["expression"] as? Expression<String>) != nil) {
          if let column = (value["expression"] as? Expression<String>) {
            table.column(column, primaryKey: value["isPrimaryKey"] as! Bool)
          } else if let column = (value["expression"] as? Expression<Bool>) {
            table.column(column, primaryKey: value["isPrimaryKey"] as! Bool)
          }
        }
      }
      
    }
    do {
      try self.database.run(tableCreate)
    } catch {
      print("error for create - \(error)")
    }
    
      
  }
  
  func insert(film: Film) {
    
    let insert = film.getInsertForSqlite(table: self.tableFilm, film: film)
    do {
      try self.database.run(insert)
      let nc = NotificationCenter.default
      nc.post(name: NSNotification.Name(rawValue: "reloadDataBookmark"), object: nil)
    } catch {
      print(error)
    }
    
  }
  
  func delete(film: Film) {
  
    let delete = self.tableFilm.filter(Expression<String>("imdbID") == film.imdbID).delete()
    do {
      try self.database.run(delete)
      let nc = NotificationCenter.default
      nc.post(name: NSNotification.Name(rawValue: "reloadDataBookmark"), object: nil)
    } catch {
      print(error)
    }
    
  }
  
  func getRow() ->[Film] {
    
    var films = [Film]()
    do {
      let rows = try self.database.prepare(tableFilm)
      for row in rows {
        films.append(Film(row: row))
      }
    } catch {
      print(error)
    }
    
    return films
  }
  
  
}
