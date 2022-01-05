//
//  payMethodsCell.swift
//  Mudaris
//
//  Created by Marzouq Almukhlif on 19/05/1443 AH.
//

import UIKit
import MFSDK


class payMethodsCell: UICollectionViewCell {
    
  @IBOutlet weak var paymentMethodImageView: UIImageView!
  @IBOutlet weak var paymentMethodNameLabel: UILabel!
  
  //MARK Methods
  func configure(paymentMethod: MFPaymentMethod, selected: Bool) {
      paymentMethodImageView.image = nil
      paymentMethodImageView.layer.cornerRadius = 5
      if selected {
          if #available(iOS 13.0, *) {
              paymentMethodImageView.layer.borderColor = UIColor.label.cgColor
          } else {
              paymentMethodImageView.layer.borderColor = UIColor.black.cgColor
          }
          paymentMethodImageView.layer.borderWidth = 3
      } else {
          paymentMethodImageView.layer.borderWidth = 0
      }
      if let imageURL = paymentMethod.imageUrl {
          paymentMethodImageView.downloaded(from: imageURL)
      }
      paymentMethodNameLabel.text = paymentMethod.paymentMethodEn ?? ""
  }
  
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
