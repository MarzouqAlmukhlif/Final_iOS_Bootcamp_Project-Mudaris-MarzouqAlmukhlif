//
//  InvoiceController.swift
//  Mudaris
//
//  Created by Marzouq Almukhlif on 08/05/1443 AH.
//

import UIKit
import FSCalendar
import MFSDK

class InvoiceController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,UICollectionViewDelegate,UICollectionViewDataSource {

  // MARK: - Properties
  var paymentMethods: [MFPaymentMethod]?
  var selectedPaymentMethodIndex: Int?
  
  
  //MARK: IBOutlets
  @IBOutlet weak var collectionView: UICollectionView!
  
  @IBOutlet var timeCollectionView: UICollectionView!
  
  @IBOutlet var foregroundView: UIView!
  @IBOutlet var backgroundView: UIView!
  @IBOutlet var calender: FSCalendar!
  @IBOutlet var teacherSelected: UILabel!
  @IBOutlet var ordarLabel: UILabel!
  @IBOutlet var dayLabel: UILabel!
  @IBOutlet var dateLabel: UILabel!
  @IBOutlet var timeLabel: UILabel!
  @IBOutlet var InvoiceOneStackView: UIStackView!
  @IBOutlet var InvoiceTwoStackView: UIStackView!
  @IBOutlet var payButton: UIButton!
  
  
  var teacher: Teacher?
  var dateTimes: [DateTime]?
  var selectedDate: String?
  var selectedTime: String?
  let invoiceValue: Decimal = 5
  var times = [String]()


  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureViews()
    
    calender.delegate = self
    calender.dataSource = self
    
    setupCalendar()
    
//    setCardInfo()
    initiatePayment()
    
    // Do any additional setup after loading the view.
  }
  
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn) {
      self.backgroundView.layer.opacity = 1
    }
    self.InvoiceTwoStackView.layer.opacity = 0
  }
  
  
  
  @IBAction func dissmisView(_ sender: Any) {
    
    UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn) {
      self.backgroundView.layer.opacity = 0
      
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
      self.dismiss(animated: true, completion: nil)
    }
    
    
  }
  
  
 
  
  
  func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
    let array = dateTimes
    var dateArray = [String]()
    let dateCalendar = getDate(date)
    times.removeAll()

    array?.forEach({ DateTime in
      dateArray.append(DateTime.date)
      
      if DateTime.date == dateCalendar {
        DateTime.time.forEach { time in
          times.append(time)
          print("~~ \(time)")
        }
      }
      
    })
    timeCollectionView.reloadData()
//    buttonTimeOne.setTitle(timeArray[0], for: .normal)
//    buttonTimeTwo.setTitle(timeArray[1], for: .normal)
//    buttonTimeThree.setTitle(timeArray[2], for: .normal)
    selectedTime = nil
    selectedDate = dateCalendar;
    return true
  }
  
  func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
    
    let dateCalendar = getDate(date)
    
    let array = dateTimes
    var dateArray = [String]()
    
    array?.forEach({ DateTime in
      if getDateStringToDate(DateTime.date) <= date {
      dateArray.append(DateTime.date)
        if dateArray.contains(dateCalendar) {
          cell.titleLabel.textColor = UIColor(red: 119/255, green: 119/255, blue: 119/255, alpha: 1.0)
          cell.isUserInteractionEnabled = true
        }else {
          cell.titleLabel.textColor = UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1.0)
          cell.isUserInteractionEnabled = false
        }
        
      } else {
        cell.titleLabel.textColor = UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1.0)
        cell.isUserInteractionEnabled = false
        

      }
    })
    

//    if dateArray.contains(dateCalendar) {
//      cell.titleLabel.textColor = UIColor(red: 119/255, green: 119/255, blue: 119/255, alpha: 1.0)
//    }else {
//      cell.titleLabel.textColor = UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1.0)
//      cell.isUserInteractionEnabled = false
//    }
//
    
  }
  
  func getDate(_ date:Date) -> String {
    let date : Date = date
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.locale = NSLocale(localeIdentifier: "en-US") as Locale
    let dateCalendar = dateFormatter.string(from: date)
    return dateCalendar
  }
  
  
  func getDateStringToDate(_ date:String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.locale = NSLocale(localeIdentifier: "en-US") as Locale
    let dateCalendar = dateFormatter.date(from: date)
    return dateCalendar!
  }
  
  func minimumDate(for calendar: FSCalendar) -> Date {
    return Date()
  }
  
  
  @IBAction func timeButtonTapped(_ sender: UIButton) {
    selectedTime(sender)
  }
  
  
  @IBAction func payDidPRessed(_ sender: Any) {
      if let paymentMethods = paymentMethods, !paymentMethods.isEmpty {
        
          if let selectedIndex = selectedPaymentMethodIndex {
              
              if paymentMethods[selectedIndex].paymentMethodCode == MFPaymentMethodCode.applePay.rawValue {
                  executeApplePayPayment(paymentMethodId: paymentMethods[selectedIndex].paymentMethodId)
              } else {
                  executePayment(paymentMethodId: paymentMethods[selectedIndex].paymentMethodId)
              }
          }
      }
  }
  
  
  @IBAction func moveToPayButtonTapped(_ sender: UIButton) {
    
    if (selectedDate == nil) {
      let alert = UIAlertController(title: "Date", message: "Place select the date", preferredStyle: .alert)
      
      let action = UIAlertAction(title: "Ok", style: .default) { UIAlertAction in
        
      }
      alert.addAction(action)
      present(alert, animated: true, completion: nil)
    } else if (selectedTime == nil) {
      let alert = UIAlertController(title: "time", message: "Place select the time", preferredStyle: .alert)
      
      let action = UIAlertAction(title: "Ok", style: .default) { UIAlertAction in
        
      }
      alert.addAction(action)
      present(alert, animated: true, completion: nil)
    } else {
      
      print("~~ \(selectedDate!) - \(selectedTime!)")
      
      teacherSelected.text = teacher?.cores
      ordarLabel.text = teacher?.cores
      dayLabel.text = "The"
      dateLabel.text = selectedDate
      timeLabel.text = selectedTime
      
      UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn) {
        self.InvoiceTwoStackView.layer.opacity = 1
        self.InvoiceOneStackView.layer.opacity = 0
        
      }
      
      
    }
    
  }
  
  
  func selectedTime(_ sender:UIButton) {
    
    let colorSelected = UIColor(red: 84/255, green: 110/255, blue: 138/255, alpha: 1.0)
    
    let colorUnSelected = UIColor(red: 119/255, green: 119/255, blue: 119/255, alpha: 1.0)
    
    for button in sender.superview!.superview!.superview!.subviews {
      if NSStringFromClass(button.classForCoder) == "_UIScrollViewScrollIndicator" {
      } else if button.subviews[0].subviews[0] is UIButton
      {
        let isButton:UIButton = button.subviews[0].subviews[0] as! UIButton
        if isButton.tag == sender.tag {
          sender.setTitleColor(colorSelected, for: .normal)
          sender.superview!.layer.borderColor = colorSelected.cgColor
          sender.superview!.layer.borderWidth = 1
        } else {
          isButton.setTitleColor(colorUnSelected, for: .normal)
          isButton.superview!.layer.borderColor = colorUnSelected.cgColor
          isButton.superview!.layer.borderWidth = 1
        }
      }
      
    }
    selectedTime = sender.titleLabel?.text
  }
  
  
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
  }
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == self.collectionView {
      guard let paymentMethods = paymentMethods else {
          return 0
      }
      return paymentMethods.count
    } else {
      return times.count
    }
  }
  
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    selectedPaymentMethodIndex = indexPath.row
    payButton.isEnabled = true
    
      collectionView.reloadData()
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let colorUnSelected = UIColor(red: 119/255, green: 119/255, blue: 119/255, alpha: 1.0)

    if collectionView == self.collectionView {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "payMethodsCell", for: indexPath) as! payMethodsCell
      if let paymentMethods = paymentMethods, !paymentMethods.isEmpty {
          let selectedIndex = selectedPaymentMethodIndex ?? -1
          cell.configure(paymentMethod: paymentMethods[indexPath.row], selected: selectedIndex == indexPath.row)
      }
      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timeCell", for: indexPath) as! TimeCell
      cell.timeButton.setTitle(times[indexPath.row], for: .normal)
      cell.timeButton.tag = indexPath.row
      cell.timeButton.superview!.layer.borderColor = colorUnSelected.cgColor
      cell.timeButton.superview!.layer.borderWidth = 1
      return cell
    }
  }
  
  
  
  
 // MARK: - Configure UI
  
  func configureViews() {
    backgroundView.layer.opacity = 0
    foregroundView.clipsToBounds = true
    foregroundView.layer.cornerRadius = 50
    
    foregroundView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
  }
  
  
  func setupCalendar() {
    calender.appearance.selectionColor = UIColor(red: 78/255, green: 119/255, blue: 160/255, alpha: 1.0)
    //    calender.appearance.todayColor = .clear
    calender.appearance.titleTodayColor = UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1.0)
    
    
    
    calender.appearance.headerTitleColor = UIColor(red: 122/255, green: 167/255, blue: 220/255, alpha: 1.0)
    
    calender.appearance.weekdayTextColor = UIColor(red: 122/255, green: 167/255, blue: 220/255, alpha: 1.0)
    
    
    calender.appearance.titleFont = UIFont.boldSystemFont(ofSize: calender.appearance.titleFont.pointSize)
    calender.appearance.weekdayFont = UIFont(name: "DIN Next LT W23 Medium", size: calender.appearance.weekdayFont.pointSize + 2)
    
    calender.appearance.subtitleFont = UIFont(name: "DIN Next LT W23 Medium", size: calender.appearance.subtitleFont.pointSize + 2)
    
    calender.appearance.headerTitleFont = UIFont(name: "DIN Next LT W23 Bold", size: calender.appearance.headerTitleFont.pointSize + 2)
    
  }
  


}

  
