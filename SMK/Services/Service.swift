//
//  Service.swift
//  SMK
//
//  Created by Вячеслав Рожнов on .10.2018.
//

import Foundation
import SwiftyJSON

class Service {
  
  let nc = NotificationCenter.default
  
  enum queryType {
    case search
    case full
  }
  
  func getUrl(_ strSearch: String, queryType: queryType) -> URL? {
    var urlComponents = URLComponents()
    urlComponents.scheme = "http"
    urlComponents.host = "www.omdbapi.com"
    urlComponents.queryItems = []
    
    switch queryType {
    case .search:
      urlComponents.queryItems?.append(URLQueryItem(name: "s", value: strSearch))
    default:
      urlComponents.queryItems?.append(URLQueryItem(name: "i", value: strSearch))
    }
    urlComponents.queryItems?.append(URLQueryItem(name: "apikey", value: "1b744d1c"))
    
    guard let url = urlComponents.url else {return nil}
    return url
  }
  
  func getData(_ strSearch: String, queryType: queryType, completion: (([Film]?, Error?) -> Void)? = nil){
    guard let urlStr = getUrl(strSearch, queryType: queryType) else {return}
    guard let url = URL(string:urlStr.absoluteString) else {return}
    let session = URLSession.shared
    let task = session.dataTask(with: url) { (data, response, error) in
      if let error = error {
        completion?(nil, error)
        return
      }
      
      if let data = data, let json = try? JSON(data: data) {
        guard json["Response"].boolValue == true else {
          QuestionsManager.sharedInstance.reset()
          self.nc.post(name: NSNotification.Name(rawValue: "reloadData"), object: data)
          return
        }
        var film = [Film]()
        switch queryType {
        case .search:
          film = json["Search"].arrayValue.map { Film(json: $0) }
          QuestionsManager.sharedInstance.listFilm = film
          completion?(film, nil)
        default:
          film = [Film(json: json)]
          QuestionsManager.sharedInstance.listFilm.remove(at: 0)
          QuestionsManager.sharedInstance.listFilm.append(film[0])
          self.nc.post(name: NSNotification.Name(rawValue: "reloadData"), object: data)
        }
      }
      return
    }
    task.resume()
  }
}

