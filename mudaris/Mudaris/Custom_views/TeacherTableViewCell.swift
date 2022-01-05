//
//  ShopTableViewCell.swift
//  Salon
//
//  Created by Marzouq Almukhlif on 17/04/1443 AH.
//

import UIKit

class TeacherTableViewCell: UITableViewCell {

  @IBOutlet weak var shopImageView: UIImageView!
  @IBOutlet weak var shopName: UILabel!
  @IBOutlet weak var shopDescription: UILabel!
  
  
  
}

extension UIColor {
    static var random: UIColor {
      
      let color1 = UIColor(
        red: 153/255,
        green: 180/255,
        blue: 225/255,
        alpha: 0.20
    )
      
      let color2 = UIColor(
        red: 60/255,
        green: 109/255,
        blue: 219/255,
        alpha: 0.21
    )
      
      let color3 = UIColor(
        red: 0/255,
        green: 45/255,
        blue: 23/255,
        alpha: 0.12
    )
    
      let color4 = UIColor(
        red: 68/255,
        green: 197/255,
        blue: 253/255,
        alpha: 0.16
    )
      
      let color5 = UIColor(
        red: 0/255,
        green: 127/255,
        blue: 255/255,
        alpha: 0.13
    )
      
      let array : [UIColor] = [color1,color2,color4,color5]
      

        return array[.random(in: 0...3)]
    }
}
