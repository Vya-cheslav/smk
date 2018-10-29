//
//  testViewController.swift
//  SMK
//
//  Created by Вячеслав Рожнов on 21.10.2018.
//

import UIKit
import SQLite

class testViewController: UIViewController {
  
  var db: Connection!
  
    override func viewDidLoad() {
        super.viewDidLoad()

      
        // Do any additional setup after loading the view.
    }
  
  @IBAction func tapButton(_ sender: UIButton) {
    
    do {
      let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
      let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
      let db = try Connection(fileUrl.path)
      self.db = db
    } catch  {
      print(error)
    }catch  {
      
    }
    
    let users = Table("users")
    let id = Expression<Int64>("id")
    let name = Expression<String>("name")
    let email = Expression<String>("email")
    
    var userstabel = users.create { table in
      table.column(id, primaryKey: true)
      table.column(name)
      table.column(email, unique: true)
    }
    do {
      try self.db.run(userstabel)
    } catch {
      print(error)
    }
    
//    let arrayColumn = Film().getSqliteColumn()
//
//    for (key, value) in arrayColumn {
//
//      if ((value["expression"] as? Expression<String>) != nil) {
//        let column = (value["expression"] as? Expression<String>)
//        userstabel.column(column, primaryKey: true)
//      }
//
//    }
    
//    var film = Film()
//    film.description = "1"
//
//
    
    var insert = users.insert(name <- "Alice3", email <- "alice3@mac.com")

    
    do {
      try self.db.run(insert)
    } catch {
        print(error)
    }
    
    
    
    
    let user = users.filter(id == 1)
    let update = user.update(name <- "Alice4", email <- "alice4@mac.com")
    
    do {
      try self.db.run(update)
    } catch {
      print(error)
    }
    
    do {
      let users1 = try self.db.prepare(users)
      for user in users1 {
        print("id: \(user[id]); name: \(user[name]); mail: \(user[email]): ")
      }
    } catch {
      print(error)
    }
//
//    for user in db.prepare(users) {
//      print("id: \(user[id]), name: \(user[name]), email: \(user[email])")
//      // id: 1, name: Optional("Alice"), email: alice@mac.com
//    }
    
    
  }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
