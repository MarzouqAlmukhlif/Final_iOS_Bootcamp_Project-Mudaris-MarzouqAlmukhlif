//
//  LoginViewController.swift
//  Salon
//
//  Created by Marzoog Almoklif on 17/04/1443 AH.
//

import UIKit

class LoginViewController: UIViewController {
  
  // MARK: - IBOutlets
  
  @IBOutlet var loginLable: UILabel!
  @IBOutlet var backgroundImageView: UIImageView!
  @IBOutlet var loginButton: UIButton!
  @IBOutlet var loginStackView: UIStackView!
  @IBOutlet var signUpButton: UIButton!
  @IBOutlet var signUpLabel: UILabel!
  @IBOutlet var emailTextField: UITextField!
  @IBOutlet var passwordTextField: UITextField!
  
  
  
  // MARK: - View controler lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    //      let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    //
    //       let path = "\(documentDirectory)/profile.plist"
    //      let nsDictionary = NSDictionary(contentsOfFile: path)!
    //      if nsDictionary["email"] != nil && nsDictionary["password"] != nil {
    //        login(email: nsDictionary["email"] as! String, password: nsDictionary["password"] as! String)
    //      }
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    fideInAnimation()
  }
  
  
  
  // MARK: - IBActions
  
  @IBAction func loginButtonTapped(_ sender: UIButton) {
    login(email: emailTextField.text!, password: passwordTextField.text!)
  }
  
  
  @IBAction func signUpButtonTapped(_ sender: UIButton) {
    signUp()
  }
  
  
  
  
  // MARK: - Authenciation methods
  
  func signUp() {
    fideOutAnimation()
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1) + .microseconds(50)) {
      self.performSegue(withIdentifier: K.Storyboard.signUpSegue,
                        sender: nil)
    }
  }
  
  
  func login(email: String, password: String) {
    
    let parameters = ["email": email, "password": password]
    
    //create the url with URL
    let url = URL(string: NetworkEndPoints.endPoints + "login.php")! //change the url
    
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
        if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
          print(json)
          if json["state"] as! Int == 200 {
            let user = json["user"] as! [String:String]
            DispatchQueue.main.async {
              let firstName = user["firstName"]!
              let lastName = user["lastName"]!
              let id = user["id"]!
              let phone = user["phone"]!
              self.saveUserInfo(email: email,
                                password:password,
                                firstName: firstName,
                                lastName: lastName,
                                id: id,
                                phone: phone)
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
  
  
  
  // MARK: - Save information locally
  
  func saveUserInfo(email:String,
                    password:String,
                    firstName:String,
                    lastName:String,
                    id:String,
                    phone:String) {
    let fileManager = FileManager.default
    
    let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                .userDomainMask,
                                                                true)[0] as String
    let path = "\(documentDirectory)/profile.plist"
    var isWritten: Bool
    let data : [String: String] = [
      "email": email,
      "password": password,
      "firstName": firstName,
      "lastName": lastName,
      "id": id,
      "phone": phone,
    ]
    
    let someData = NSDictionary(dictionary: data)
    
    if (!fileManager.fileExists(atPath: path)){
      print(path)
      isWritten = someData.write(toFile: path, atomically: true)
      print("is the file created: \(isWritten)")
    } else {
      isWritten = someData.write(toFile: path, atomically: true)
      print("file exists")
    }
    
    if isWritten {
      let storyboard = UIStoryboard(name: K.Storyboard.storyBoardName, bundle: nil)
      let vc = storyboard
        .instantiateViewController(withIdentifier: K.Storyboard.mainVCIdentifier)
      
      present(vc, animated: true, completion: nil)
    }
  }

  
  
  // MARK: - Animations
  
  func fideInAnimation() {
    let left = CGAffineTransform(translationX: -300, y: 0)
    let right = CGAffineTransform(translationX: 300, y: 0)
    let top = CGAffineTransform(translationX: 0, y: 0)
    
    loginStackView.layer.opacity = 0
    loginLable.layer.opacity = 0
    loginButton.layer.opacity = 0
    signUpButton.layer.opacity = 0
    signUpLabel.layer.opacity = 0
    loginLable.transform = CGAffineTransform(translationX: -300, y: 0)
    
    backgroundImageView.transform = CGAffineTransform(translationX: 0, y: 400)
    
    UIView.animate(withDuration: 1.0,delay: 0.5) {
      self.loginStackView.layer.opacity = 1
      self.loginButton.layer.opacity = 1
      self.signUpButton.layer.opacity = 1
      self.signUpLabel.layer.opacity = 1
    }
    
    UIView.animate(withDuration: 1.0,delay: 0.5) {
      self.loginLable.transform = top
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
      self.loginLable.transform = top
      self.loginStackView.layer.opacity = 0
      self.loginLable.layer.opacity = 0
      self.loginButton.layer.opacity = 0
      self.signUpButton.layer.opacity = 0
      self.signUpLabel.layer.opacity = 0
      self.backgroundImageView.transform = buttom
      self.view.backgroundColor = .white
    }
  }
  
  
}
