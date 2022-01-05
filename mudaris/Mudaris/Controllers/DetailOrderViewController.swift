//
//  DetailOrderViewController.swift
//  Mudaris
//
//  Created by Marzouq Almukhlif on 29/05/1443 AH.
//

import UIKit

class DetailOrderViewController: UIViewController {

  @IBOutlet weak var coresName: UILabel!
  @IBOutlet weak var shopRating: UILabel!
  @IBOutlet weak var teacherImage: UIImageView!
  @IBOutlet var teacherName: UILabel!
  @IBOutlet var lessonDate: UILabel!
  @IBOutlet var lessonTime: UILabel!

  @IBOutlet var studentName: NSLayoutConstraint!
  @IBOutlet var studentPhone: UILabel!
  @IBOutlet var studentLocation: UILabel!
  
  var location:[CGFloat]!
  var array:Order?

    override func viewDidLoad() {
        super.viewDidLoad()

      coresName.text = array?.coresName
      teacherImage.image = array?.image
      teacherName.text = array?.teacherName
      lessonDate.text = array?.lessonDate
      lessonTime.text = array?.lessonTime
      location = array?.location
    }
    
  
  @IBAction func locationButtonTapped(_ sender: UIButton) {
    
    print("~~ \(location)")
  }
  
  

}
