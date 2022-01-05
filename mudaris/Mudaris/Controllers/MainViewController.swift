//
//  MainViewController.swift
//  Salon
//
//  Created by Marzoog Almoklif on 17/04/1443 AH.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var signUpLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String

      let path = "\(documentDirectory)/profile.plist"
      let nsDictionary = NSDictionary(contentsOfFile: path) ?? NSDictionary()
      if nsDictionary["email"] != nil && nsDictionary["password"] != nil {
        loginAc(email: nsDictionary["email"] as! String, password: nsDictionary["password"] as! String)
      }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fideInAnimation()
    }
    
    func fideInAnimation() {
        let left = CGAffineTransform(translationX: -300, y: 0)
        let right = CGAffineTransform(translationX: 300, y: 0)
        let top = CGAffineTransform(translationX: 0, y: 0)
        
        logoImageView.layer.opacity = 0
        loginButton.layer.opacity = 0
        signUpButton.layer.opacity = 0
        signUpLabel.layer.opacity = 0
        logoImageView.transform = CGAffineTransform(translationX: 0, y: -300)
        
        backgroundImageView.transform = CGAffineTransform(translationX: 0, y: 400)
        
        UIView.animate(withDuration: 1.0,delay: 1.0) {
            self.loginButton.layer.opacity = 1
            self.signUpButton.layer.opacity = 1
            self.signUpLabel.layer.opacity = 1
        }
        
        UIView.animate(withDuration: 1.0,delay: 0.5) {
            self.logoImageView.transform = top
            self.logoImageView.layer.opacity = 1
            self.backgroundImageView.transform = top
        }
    }
    
    
    func fideOutAnimation() {
        let left = CGAffineTransform(translationX: -300, y: 0)
        let right = CGAffineTransform(translationX: 300, y: 0)
        let top = CGAffineTransform(translationX: 0, y: -300)
        let buttom = CGAffineTransform(translationX: 0, y: 400)

        
        UIView.animate(withDuration: 0.8,delay: 0.5) {
            self.logoImageView.transform = top
            self.logoImageView.layer.opacity = 0
            self.loginButton.layer.opacity = 0
            self.signUpButton.layer.opacity = 0
            self.signUpLabel.layer.opacity = 0
            self.backgroundImageView.transform = buttom
            self.view.backgroundColor = .white
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        login()
    }
    
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        signUp()
    }
    
    
    
  func loginAc(email:String,password:String) {
      
      let parameters = ["email": email, "password": password]

          //create the url with URL
          let url = URL(string: "http://tweaky.biz/Mudaris/login.php")! //change the url

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
                    DispatchQueue.main.async {
                      let storyboard = UIStoryboard(name: "Main", bundle: nil)
                      let vc = storyboard.instantiateViewController(withIdentifier: "MainVC")
                      self.present(vc, animated: true, completion: nil)
                      
                    }
                      // handle json...
                    } else if json["state"] as! Int == 100 {
                      
                      let fileManager = FileManager.default

                      let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                      let path = "\(documentDirectory)/profile.plist"
                      
                      try fileManager.removeItem(atPath: path)
                    }
                  }
              } catch let error {
                  print(error.localizedDescription)
              }
          })
          task.resume()
      }
  
    func login() {
        fideOutAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1) + .microseconds(50)) {
            self.performSegue(withIdentifier: "login_segue", sender: nil)
        }
        
    }
    
    func signUp() {
        fideOutAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1) + .microseconds(50)) {
            self.performSegue(withIdentifier: "sign_up_segue", sender: nil)
        }
    }
}
