//
//  InvoiceController.swift
//  Mudaris
//
//  Created by Marzouq Almukhlif on 08/05/1443 AH.
//

import UIKit
import FSCalendar
import MFSDK

struct OrderCustomer {
  
  let studentName:String
  let studentID:String
  let studentPhone:String
  let studentLocation:String

  
  let teacherID:String
  let teacherName:String
  let image:String
  
  
  let coresName:String
  let lessonDate:String
  let lessonTime:String

  
  let state:String
}

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
  @IBOutlet var invoiceThreeStackView: UIStackView!
  
  
  @IBOutlet var imageOrderState: UIImageView!
  @IBOutlet var messageOrderState: UILabel!
  @IBOutlet var buttonOrderState: UIButton!
  
  
  
  
  @IBOutlet var payButton: UIButton!
  
  
  var teacher: Teacher?
  var dateTimes: [DateTime]?
  var selectedDate: String?
  var selectedTime: String?
  let invoiceValue: Decimal = 5
  var times = [String]()
  var stateOrder = false
  
  var order:OrderCustomer!

  
//  coresName
//  id
//  image
//  lessonDate
//  lessonTime
//  location
//  state
//  teacherID
//  teacherName
//  userID
//
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureViews()
    
    calender.delegate = self
    calender.dataSource = self
    
    setupCalendar()
    
//    setCardInfo()
    initiatePayment()
        
    UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn) {
      self.backgroundView.layer.opacity = 1
    }
    InvoiceTwoStackView.layer.opacity = 0
    invoiceThreeStackView.layer.opacity = 0
    
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
    
  }
  
  
  @IBAction func closeOrderState(_ sender: UIButton) {
    if stateOrder {
      dismiss(animated: true, completion: nil)
      
    } else {
    UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn) {
      self.invoiceThreeStackView.layer.opacity = 0
      self.InvoiceTwoStackView.layer.opacity = 1
      self.imageOrderState.image = UIImage()
      self.buttonOrderState.setTitle("", for: .normal)
      self.buttonOrderState.backgroundColor = .clear
    }
    }
  }
  
  
  func configOrderState(imageName:String,success:Bool) {
    stateOrder = success
    invoiceThreeStackView.layer.opacity = 1
    imageOrderState.image = UIImage(named: imageName)
    buttonOrderState.setTitle("اغلاق", for: .normal)
    let successColor = UIColor(red: 78/255, green: 119/255, blue: 160/255, alpha: 1.0)
    let filuerColor = UIColor(red: 160/255, green: 78/255, blue: 78/255, alpha: 1.0)
    if success {
      
      messageOrderState.text = "تم بنجاح طلب المعلم وسيصلك في الموعد\nيمكنك الوصول للطلب من قائمة الطلبات"
      messageOrderState.textColor = successColor
      buttonOrderState.backgroundColor = successColor
    } else {
    messageOrderState.text = "لم يتم ارسال الطلب بنجاح\nالرجاء اعادة المحاولة"
      messageOrderState.textColor = filuerColor
      buttonOrderState.backgroundColor = filuerColor

    }
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
//    postOrder()
    
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
  
  
  

  func postOrder() {


    let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    let path = "\(documentDirectory)/profile.plist"
    let nsDictionary = NSDictionary(contentsOfFile: path) ?? NSDictionary()

    let id = nsDictionary["id"] as! String
    let name = "\(nsDictionary["firstName"] as! String) \(nsDictionary["lastName"] as! String)"
    let phone = nsDictionary["phone"] as! String
//    let location = nsDictionary["location"] as! String

    


   order =  OrderCustomer(studentName: name,
                          studentID: id,
                          studentPhone: phone,
                          studentLocation: location,
                          teacherID: teacher!.id,
                          teacherName: teacher!.name,
                          image: "teacher?.name",
                          coresName: teacher!.cores,
                          lessonDate: selectedDate!,
                          lessonTime: selectedTime!,
                          state: "تم ارسال الطلب")
//
//    postOrder()
    
    //create the url with URL
    let url = URL(string: NetworkEndPoints.endPoints + "addOrder.php")! //change the url


    

    let parameters = ["email": nsDictionary["email"] as! String,
                                            "studentName":order.studentName,
                                            "studentID":order.studentID,
                                            "studentPhone":order.studentPhone,
                                            "studentLocation":order.studentLocation,
                                            "teacherID":order.teacherID,
                                            "teacherName":order.teacherName,
                                            "image":order.image,
                                            "coresName":order.coresName,
                                            "lessonDate":order.lessonDate,
                                            "lessonTime":order.lessonTime,
                                            "state":order.state]
    
    
    //create the session object
    let session = URLSession.shared

    //now create the URLRequest object using the url object
    var request = URLRequest(url: url)
    request.httpMethod = K.HTTP.postHttpMethod //set http method as POST

    do {
      request.httpBody = try JSONSerialization
        .data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body

      
    } catch let error {
      print(error.localizedDescription)
    }

    request.addValue(K.HTTP.jsonContentType,
                     forHTTPHeaderField: "Content-Type")
    request.addValue(K.HTTP.jsonContentType,
                     forHTTPHeaderField: "Accept")

    //create dataTask using the session object to send data to the server
    let task = session.dataTask(with: request as URLRequest,
                                completionHandler: { data, response, error in

      guard error == nil else {
        return
      }

      guard let data = data else {
        return
      }

      do {
        //create json object from data
        if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] {
          print(json)

//            let user = json as! [String: Any]

          
//          print("~~ ")
//            let gg = user["location"] as! String
//            let fullNameArr = gg.components(separatedBy:"|")
//            let longE = Double(fullNameArr[0])
//            let lag = Double(fullNameArr[1])
//            let location = [CGFloat(longE!), CGFloat(lag!)]

            DispatchQueue.main.async {


            }
            // handle json...
          
        }
      } catch let error {
        print(error.localizedDescription)
      }
    })
    task.resume()
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

  
