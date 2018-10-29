//
//  SearchCollectionViewController.swift
//  SMK
//
//  Created by Вячеслав Рожнов on 12.10.2018.
//

import UIKit
import SwiftyJSON

private let reuseIdentifier = "Cell"

class SearchCollectionViewController: UIViewController {
  
  @IBOutlet weak var titleLable: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!
  
  var listFilm = [Film]()

    override func viewDidLoad() {
        super.viewDidLoad()
      
      collectionView.dataSource = self as? UICollectionViewDataSource
      collectionView.delegate = self as? UICollectionViewDelegate
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
      getData(){ (data, error) in
        if let error = error {
          Alerts.show(title: "warning", message: "warning", actionTitle: "warning", form: self)
          return
        }
        self.listFilm = data!
        DispatchQueue.main.async {
          self.collectionView.reloadData()
        }
      }
      
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of items
//        return listFilm.count
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SearchCollectionViewCell
//
//        // Configure the cell
//      cell.layer.borderWidth = 1
//      cell.layer.borderColor = UIColor.black.cgColor
//
//      cell.titleLable.text = listFilm[indexPath.row].title
//      cell.plotLable.text = "pkSDHFGSHDIOGJSDIOVJJZNJFSD FGHDFJFHDFHGUITHGUHFUGUHSYUDFHHGFUHFGGSCSDVFYXUXDYRCFUAIUFYUCIHCFIYSGCFIYGYFGCYGFSCGFYGF YDGFYRCGCFYUYCFHSUHFIUNSAGFIUSNGFUYISFYFUGFUGNFUHGFCUINSGFUYWGFUSHFUASHFUCGVUYDUCSUFSUFHUSCGHCVUD"
//        return cell
//    }
  
  func getUrl() -> URL? {
    var urlComponents = URLComponents()
    urlComponents.scheme = "http"
    urlComponents.host = "www.omdbapi.com"
    urlComponents.queryItems = [
      URLQueryItem(name: "s", value: "star wars"),
      URLQueryItem(name: "apikey", value: "1b744d1c"),
    ]
    guard let url = urlComponents.url else {return nil}
    return url
    //return URLRequest(url: url)
  }
  
  func getData(completion: (([Film]?, Error?) -> Void)? = nil){
    guard let urlStr = getUrl() else {return}
    guard let url = URL(string:urlStr.absoluteString) else {return}
    let session = URLSession.shared
    let task = session.dataTask(with: url) { (data, response, error) in
      if let error = error {
        completion?(nil, error)
        return
      }

      //            let json1 = try? JSONSerialization.jsonObject(with: data!, options:
      //                JSONSerialization.ReadingOptions.allowFragments)
      //            print(json1)

      if let data = data, let json = try? JSON(data: data) {
        guard json["Response"].boolValue == true else {return}
        let film = json["Search"].arrayValue.map { Film(json: $0) }//
print(json)
        completion?(film, nil)
        DispatchQueue.main.async {
          //Friend().saveData(friend)
          
        }

      }

      return
    }
    task.resume()
  }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SearchCollectionViewCell
    return cell
  }
  
  
}
