//
//  SearchViewController.swift
//  SMK
//
//  Created by Вячеслав Рожнов on .10.2018.
//

import UIKit
import SwiftyJSON

class BookmarkViewController: UIViewController {
  
  @IBOutlet var viewFrame: UIView!
  
  @IBOutlet weak var bookmarkCollectionView: UICollectionView!
  
  
  
  let service = Service()
  let nc = NotificationCenter.default
  
  var listFilm = DatabaseManager.sharedInstance.getRow()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    nc.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(rawValue: "reloadDataBookmark"), object: nil)
    
    bookmarkCollectionView.reloadData()

  }
  
  @objc func reloadData(notification: Notification) {
    
    listFilm = DatabaseManager.sharedInstance.getRow()
    
    DispatchQueue.main.async {
      self.bookmarkCollectionView.reloadData()
    }
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let VC = segue.destination as? DetailViewController {
      let indexPath = bookmarkCollectionView.indexPathsForSelectedItems
      VC.film = listFilm[Array(indexPath!)[0][1]]
    }
  }
}

extension BookmarkViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    navigationController?.tabBarItem.badgeValue = String(listFilm.count)
    return listFilm.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if listFilm.count != 0 {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SearchCollectionViewCell
      
      let listFilmForIndexPath = listFilm[indexPath.row]
      
      cell.layer.borderWidth = 1
      cell.layer.borderColor = UIColor.black.cgColor
      
      cell.titleLable.text = listFilmForIndexPath.title
      cell.countryAndYearLable.text = "\(listFilmForIndexPath.country) - \(listFilmForIndexPath.year)"
      
      cell.plotLable.text = listFilm[indexPath.row].plot
      
      let poster = listFilmForIndexPath.poster
      let getCacheImage = GetCacheImage(url: poster)
      
      getCacheImage.main()
      
      if let outputImage = getCacheImage.outputImage {
        cell.posterImageView.image = outputImage
      }
      
      
      return cell
    }
    else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellNothingFound", for: indexPath)
      return cell
    }
    
  }
  
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    if listFilm.count != 0 {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SearchCollectionViewCell
      let textTitle = listFilm[indexPath.row].title
      let textPlot = listFilm[indexPath.row].plot
      let fontTitle = cell.titleLable.font
      let fontPlot = cell.plotLable.font
      let labelTitle = getLabelSize(text: textTitle, font: fontTitle!)
      let labelPlot = getLabelSize(text: textPlot, font: fontPlot!)
      
      let newHeight = 200 + labelTitle.height + labelPlot.height
      
      return CGSize(width: 356, height: newHeight)
    }
    
    return CGSize(width: 356, height: 249)
  }
  
  func resizeLableFrame(label: UILabel, x: CGFloat, y: CGFloat) {
    let LabelSize = getLabelSize(text: label.text!, font: label.font)
    let LabelOrigin = CGPoint(x: x, y: y)
    label.frame = CGRect(origin: LabelOrigin, size: LabelSize)
  }
  
  func getLabelSize(text: String, font: UIFont) -> CGSize {
    let view: UIView = viewFrame
    let maxWidth = view.bounds.width - 10 * 2
    let textBlock = CGSize(width: maxWidth, height:
      CGFloat.greatestFiniteMagnitude)
    let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    let width = Double(rect.size.width)
    let height = Double(rect.size.height)
    let size = CGSize(width: ceil(width), height: ceil((text == "" || text.isEmpty) ? 0 : height))
    return size
  }
  
}
