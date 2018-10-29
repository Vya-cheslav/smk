//
//  GlobalVarManager.swift
//  SMK
//
//  Created by Вячеслав Рожнов on
//

import Foundation

class QuestionsManager {
  
  var listFilm: [Film] = [Film]()
  
  static let sharedInstance = QuestionsManager()
  
  private init() {
    
  }
  
  func reset() {
    listFilm = [Film]()
  }

  func getBookmark(id: String, value: Bool) -> Film {
    let film = Film()
    
    for (index, value) in listFilm.enumerated() {
      if value.imdbID == id {
        listFilm[index].bookmark = (value.bookmark == true ? false : true)
        return value
      }
    }
    
    return film
  }
  
}
