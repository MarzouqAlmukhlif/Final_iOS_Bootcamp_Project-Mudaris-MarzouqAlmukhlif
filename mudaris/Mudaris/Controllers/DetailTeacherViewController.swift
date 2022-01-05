//
//  DetailTeacherViewController.swift
//  Salon
//
//  Created by Marzouq Almukhlif on 23/04/1443 AH.
//

import UIKit

class DetailTeacherViewController: UIViewController {
  
  var teacher: Teacher?
  
  
  
  // MARK: - IBOutlets
  
  
  @IBOutlet weak var imageView: UIImageView!
  
  @IBOutlet var checkBoxButton: UIButton!
  
  @IBOutlet weak var courseName: UILabel!
  @IBOutlet weak var courseRating: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var ageLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var experienceLabel: UILabel!
  @IBOutlet weak var stageLabel: UILabel!
  

  
  // MARK: - View controller lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    fillVisualComponentsWithData()
    
    checkBoxButton
      .setBackgroundImage(UIImage(named: K.Images.checkBoxYes),
                          for: .selected)
    
    configureNavigationController()
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    imageView.backgroundColor = .white
  }
  
  
  
  // MARK: - IBActions
  
  @IBAction func checkBoxPressed(_ sender: UIButton) {
    sender.isSelected.toggle()
//    sender.isSelected = !sender.isSelected
  }
  
  
  @IBAction func requestButtonPressed(_ sender: UIButton) {
    if checkBoxButton.isSelected {
      print("~~ YES")
      performSegue(withIdentifier: K.Storyboard.requestShowSegue, sender: nil)
    } else {
      print("~~ NO")
    }
    
  }
  
  
  
  @IBAction func reservationButtonPressed(_ sender: UIButton) {
    if checkBoxButton.isSelected {
      print("~~ YES")
      performSegue(withIdentifier: K.Storyboard.reservationShowSegue, sender: nil)
    } else {
      print("~~ NO")
    }
    
  }
  
  
  
  // MARK: - Configure UI
  
  func fillVisualComponentsWithData() {
    courseName.text = teacher?.cores
    courseRating.text = teacher?.info
    imageView.image = teacher?.image
    nameLabel.text = teacher?.name
    ageLabel.text = teacher?.age
    descriptionLabel.text = teacher?.info
    experienceLabel.text = "\(teacher!.exper) سنوات"
    stageLabel.text = teacher?.stage
  }
  
  func configureNavigationController() {
    let navigationBar = navigationController!.navigationBar
    
    navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationBar.shadowImage = UIImage()
    navigationBar.isTranslucent = true
  }
  
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case "reservationShow":
      if let vc = segue.destination as? InvoiceController {
        vc.teacher = teacher
        vc.dateTimes = teacher?.reservationDate
      }
    case "requestShow":
      if let vc = segue.destination as? InvoiceController {
        vc.teacher = teacher
        vc.dateTimes = teacher?.requestDate
      }
    default:
      print("Other")
    }
  }
  
}
