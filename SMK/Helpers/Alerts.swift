//
//  Alerts.swift
//  SMK
//
//  Created by Вячеслав Рожнов on .10.2018.
//

import Foundation
import UIKit

class Alerts {
  class func show(title: String, message: String, actionTitle: String, form: AnyObject) {
    let alertController = UIAlertController(title: title, message: message
      , preferredStyle: UIAlertController.Style.alert)
    alertController.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default,handler: nil))
    form.present(alertController, animated: true, completion: nil)
  }
}
