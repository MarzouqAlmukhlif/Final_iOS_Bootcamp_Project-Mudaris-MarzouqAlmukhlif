//
//  SignUpViewController.swift
//  Salon
//
//  Created by Marzoog Almoklif on 17/04/1443 AH.
//

import UIKit

class SignUpViewController: UIViewController {
  
  
  @IBOutlet var loginLable: UILabel!
  @IBOutlet var backgroundImageView: UIImageView!
  @IBOutlet var loginButton: UIButton!
  @IBOutlet var signUpStackView: UIStackView!
  @IBOutlet var signUpButton: UIButton!
  @IBOutlet var signUpLabel: UILabel!
  
  @IBOutlet var emailTextField: UITextField!
  @IBOutlet var passwordTextField: UITextField!
  @IBOutlet var firstNameTextField: UITextField!
  @IBOutlet var lastNameTextField: UITextField!
  @IBOutlet var phoneTextField: UITextField!
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  override func viewDidAppear(_ animated: Bool) {
    fideInAnimation()
  }
  
  @IBAction func loginButtonTapped(_ sender: UIButton) {
    login()
  }
  
  
  @IBAction func signUpButtonTapped(_ sender: UIButton) {
    signUp(email: emailTextField.text!, password: passwordTextField.text!, firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, phone: phoneTextField.text!)
  }
  
  
  
  func fideInAnimation() {
    let left = CGAffineTransform(translationX: -300, y: 0)
    let right = CGAffineTransform(translationX: 300, y: 0)
    let top = CGAffineTransform(translationX: 0, y: 0)
    
    signUpStackView.layer.opacity = 0
    loginLable.layer.opacity = 0
    loginButton.layer.opacity = 0
    signUpButton.layer.opacity = 0
    signUpLabel.layer.opacity = 0
    signUpLabel.transform = CGAffineTransform(translationX: -300, y: 0)
    
    backgroundImageView.transform = CGAffineTransform(translationX: 0, y: 400)
    
    UIView.animate(withDuration: 1.0,delay: 0.5) {
      self.signUpStackView.layer.opacity = 1
      self.loginButton.layer.opacity = 1
      self.signUpButton.layer.opacity = 1
      self.signUpLabel.layer.opacity = 1
    }
    
    UIView.animate(withDuration: 1.0,delay: 0.5) {
      self.signUpLabel.transform = top
      self.loginLable.layer.opacity = 1
      self.backgroundImageView.transform = top
    }
  }
  
  
  func fideOutAnimation() {
    let left = CGAffineTransform(translationX: -300, y: 0)
    let right = CGAffineTransform(translationX: 300, y: 0)
    let top = CGAffineTransform(translationX: 0, y: -300)
    let buttom = CGAffineTransform(translationX: 0, y: 400)
    
    
    UIView.animate(withDuration: 0.8,delay: 0.5) {
      self.signUpLabel.transform = top
      self.signUpStackView.layer.opacity = 0
      self.loginLable.layer.opacity = 0
      self.loginButton.layer.opacity = 0
      self.signUpButton.layer.opacity = 0
      self.signUpLabel.layer.opacity = 0
      self.backgroundImageView.transform = buttom
      self.view.backgroundColor = .white
    }
  }
  
  func login() {
    fideOutAnimation()
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1) + .microseconds(50)) {
      self.performSegue(withIdentifier: "login", sender: nil)
    }
  }
  
  func signUp(email:String,
              password:String,
              firstName:String,
              lastName:String,
              phone:String) {
    
    let parameters = ["email": email,
                      "password": password,
                      "firstName": firstName,
                      "lastName": lastName,
                      "phone": phone]
    
    //create the url with URL
    let url = URL(string: "http://tweaky.biz/Mudaris/signup.php")! //change the url
    
    //create the session object
    let session = URLSession.shared
    
    //now create the URLRequest object using the url object
    var request = URLRequest(url: url)
    request.httpMethod = "POST" //set http method as POST
    
    do {
      request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
    } catch let error {
      print(error.localizedDescription)
    }
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    //create dataTask using the session object to send data to the server
    let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
      
      guard error == nil else {
        return
      }
      
      guard let data = data else {
        return
      }
      
      do {
        //create json object from data
        if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
          print(json)
          if json["state"] as! Int == 200 {
            let user = json["user"] as! [String:String]
            DispatchQueue.main.async {
              let firstName = user["firstName"]!
              let lastName = user["lastName"]!
              let id = user["id"]!
              let phone = user["phone"]!
              self.saveUserInfo(email: email,password:password,firstName: firstName, lastName: lastName, id: id, phone: phone)
              
            }
            // handle json...
          }
        }
      } catch let error {
        print(error.localizedDescription)
      }
    })
    task.resume()
  }
  
  
  func saveUserInfo(email:String,
                    password:String,
                    firstName:String,
                    lastName:String,
                    id:String,
                    phone:String) {
    let fileManager = FileManager.default
    
    let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    let path = "\(documentDirectory)/profile.plist"
    var isWritten:Bool
    let data : [String: String] = [
      "email": email,
      "password": password,
      "firstName": firstName,
      "lastName": lastName,
      "id": id,
      "phone": phone,
    ]
    
    let someData = NSDictionary(dictionary: data)
    
    if(!fileManager.fileExists(atPath: path)){
      print(path)
      isWritten = someData.write(toFile: path, atomically: true)
      print("is the file created: \(isWritten)")
    }else{
      isWritten = someData.write(toFile: path, atomically: true)
      print("file exists")
    }
    
    if isWritten {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "MainVC")
      present(vc, animated: true, completion: nil)
    }
  }
}
