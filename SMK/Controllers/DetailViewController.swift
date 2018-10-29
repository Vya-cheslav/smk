//
//  ViewController.swift
//  SMK
//
//  Created by Вячеслав Рожнов on .10.2018.
//

import UIKit
import MessageUI
import Social

class DetailViewController: UIViewController {
  
  @IBOutlet weak var viewFrame: UIView!
  @IBOutlet weak var titleLable: UILabel!
  @IBOutlet weak var runtimeGenreReleasedCountryLabel: UILabel!
  @IBOutlet weak var ratingLabel: UILabel!
  @IBOutlet weak var directorLabel: UILabel!
  @IBOutlet weak var writerLabel: UILabel!
  @IBOutlet weak var typeLabel: UILabel!
  @IBOutlet weak var plotLabel: UILabel!
  @IBOutlet weak var bookmarkButton: UIButton!
  @IBOutlet weak var posterImageView: UIImageView!
  
  @IBOutlet var shareButton: [UIButton]!
  
  
  
  
  
  var film = Film()
  let instets10: CGFloat = 10
  let instets20: CGFloat = 20
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadData()
    title = film.title
  }
  
  
  @IBAction func tapBookmarkButton(_ sender: UIButton) {
    
    var newImage = UIImage()
    
    if film.bookmark == true {
      newImage = UIImage(named: "noBookmark")!
      DatabaseManager.sharedInstance.delete(film: film)
    }
    else {
      newImage = UIImage(named: "bookmark")!
      DatabaseManager.sharedInstance.insert(film: film)
    }
    
    bookmarkButton.setImage(newImage, for: .normal)
    film = QuestionsManager.sharedInstance.getBookmark(id: film.imdbID, value: film.bookmark)
    
  }
  
  @IBAction func tapShare(_ sender: UIButton) {
    
    UIView.animate(withDuration: 0.7, animations: {
      self.shareButton.forEach{(button) in
        if button.restorationIdentifier == "bookmark" {
          let bookmarkButtonTitle = (self.film.bookmark == true ? "Remove bookmark": "Add bookmark")
          button.titleLabel?.text = bookmarkButtonTitle
          button.reloadInputViews()
        }
        button.isHidden = !button.isHidden
      }
    })
  }
  
  
  func loadData() {
    
    let bookmarkImage = (film.bookmark == true ? UIImage(named: "bookmark")!: UIImage(named: "noBookmark")!)
    bookmarkButton.setImage(bookmarkImage, for: .normal)
    
    titleLable.text = film.title
    resizeLableFrame(label: titleLable, x: 0, y: titleLable.frame.origin.y)
    runtimeGenreReleasedCountryLabel.text = "\(film.runtime) - \(film.genre) - \(film.released) - (\(film.country))"
    resizeLableFrame(label: runtimeGenreReleasedCountryLabel, x: 0, y: titleLable.frame.origin.y+titleLable.frame.size.height+instets20)
    ratingLabel.text = "Rating - \(film.rating)"
    resizeLableFrame(label: ratingLabel, x: 0, y: runtimeGenreReleasedCountryLabel.frame.origin.y+runtimeGenreReleasedCountryLabel.frame.size.height+instets20)
    directorLabel.text = "Director - \(film.director)"
    resizeLableFrame(label: directorLabel, x: 0, y: ratingLabel.frame.origin.y+ratingLabel.frame.size.height + instets10)
    writerLabel.text = "Writers - \(film.writer)"
    resizeLableFrame(label: writerLabel, x: 0, y: directorLabel.frame.origin.y+directorLabel.frame.size.height + instets10)
    typeLabel.text = film.type
    resizeLableFrame(label: typeLabel, x: 0, y: writerLabel.frame.origin.y+writerLabel.frame.size.height + instets10)
    plotLabel.text = film.plot
    resizeLableFrame(label: plotLabel, x: 0, y: typeLabel.frame.origin.y+typeLabel.frame.size.height + 54)
    
    let poster = film.poster
    let getCacheImage = GetCacheImage(url: poster)
    
    getCacheImage.main()
    
    if let outputImage = getCacheImage.outputImage {
      posterImageView.image = outputImage
      let origImageSizeHeight = outputImage.size.height, origImageSizeWidth = outputImage.size.width
      let posterImageSizeWidth = posterImageView.frame.size.width
      
      let percent = posterImageSizeWidth / origImageSizeWidth
      
      posterImageView.frame.size.width = origImageSizeWidth * percent
      posterImageView.frame.size.height = origImageSizeHeight * percent
      
      posterImageView.frame = CGRect(x: plotLabel.frame.minX+instets10, y: plotLabel.frame.origin.y + plotLabel.frame.height + instets10, width: posterImageView.frame.size.width, height: posterImageView.frame.size.height)
      
    }
  }
  func resizeLableFrame(label: UILabel, x: CGFloat, y: CGFloat) {
    let LabelSize = getLabelSize(text: label.text!, font: label.font)
    let LabelOrigin = CGPoint(x: x, y: y)
    label.frame = CGRect(origin: LabelOrigin, size: LabelSize)
  }
  
  func getLabelSize(text: String, font: UIFont) -> CGSize {
    let view: UIView = viewFrame
    let maxWidth = view.bounds.width - instets10 * 2
    let textBlock = CGSize(width: maxWidth, height:
      CGFloat.greatestFiniteMagnitude)
    let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    let width = Double(rect.size.width)
    let height = Double(rect.size.height)
    let size = CGSize(width: ceil(width), height: ceil((text == "" || text.isEmpty) ? 0 : height))
    return size
  }
  
  
}

extension DetailViewController: MFMailComposeViewControllerDelegate {
  @IBAction func sendMail(_ sender: UIButton) {
    let mailComposeViewController = configureMailComposer()
    if MFMailComposeViewController.canSendMail(){
      self.present(mailComposeViewController, animated: true, completion: nil)
    }else{
      print("Can't send email")
    }
  }
  func configureMailComposer() -> MFMailComposeViewController{
    let mailComposeVC = MFMailComposeViewController()
    mailComposeVC.mailComposeDelegate = self
    mailComposeVC.setToRecipients(["god44@mail.ru"])
    mailComposeVC.setSubject("shema")
    mailComposeVC.setMessageBody("body", isHTML: false)
    return mailComposeVC
  }
  
}

extension DetailViewController {
  @IBAction func shareSocial(_ sender: UIButton) {
    var slServiceType = SLServiceTypeTwitter
    if sender.restorationIdentifier == "facebook" {
      slServiceType = SLServiceTypeFacebook
    }
    
    if SLComposeViewController.isAvailable(forServiceType: slServiceType){
      let post = SLComposeViewController(forServiceType: slServiceType)
      post?.setInitialText("new post!")
      self.present(post!, animated: true, completion: nil)
    }
    else {showAlert(service: slServiceType)}
  }
  func showAlert(service: String) {
    let alert = UIAlertController(title: "Error", message: "Not onnected to \(service)", preferredStyle: .alert)
    let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
}

