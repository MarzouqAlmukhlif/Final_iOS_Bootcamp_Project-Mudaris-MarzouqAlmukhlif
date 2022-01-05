//
//  ShopViewController.swift
//  Mudaris
//
//  Created by Marzouq Almukhlif on 27/04/1443 AH.
//

import UIKit

class TeacherViewController: UIViewController,
                              UITableViewDelegate {
  
  // MARK: - Properties
  
  var teachers:[Teacher] = [Teacher]()
  var filterData:[Teacher]!
  var selectedData:Teacher!
  
  
  
  // MARK: - Outlets
  @IBOutlet weak var locationButton: UIButton!
  @IBOutlet var SearchBar: UISearchBar!
  @IBOutlet weak var topBarStackView: UIStackView!
  @IBOutlet weak var tableView: UITableView!
  
  

  // MARK: - View controller lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.rowHeight = 100
    tableView.delegate = self
    tableView.dataSource = self
    view.layer.borderWidth = 0.5
    view.layer.borderColor = UIColor.blue.cgColor
    
    filterData = teachers
    
    
    locationButton.layer.borderColor = UIColor(red: 122/255,
                                               green: 167/255,
                                               blue: 220/255,
                                               alpha: 1.0).cgColor
    getTechers()
  }
  
  
  
  func getTechers() {
    
   
    //create the url with URL
    let url = URL(string: NetworkEndPoints.endPoints + "teachers.php")! //change the url
    
    //create the session object
    let session = URLSession.shared
    
    //now create the URLRequest object using the url object
    var request = URLRequest(url: url)
    request.httpMethod = K.HTTP.getHttpMethod //set http method as POST
    
  
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
//          print(json)
          for techer in json {
            let user = techer as! [String:String]
            
            
            
            var requestDate = [DateTime]()
            
            let requestData = Data(user["requestDate"]!.utf8)
            if let jsone = try JSONSerialization.jsonObject(with: requestData, options: .mutableContainers) as? [[String: Any]] {
              for dateTime in jsone {
                let date = DateTime(date: dateTime["date"]! as! String, time: dateTime["time"]! as! Array<String>)
                requestDate.append(date)
              }

            }
            
            
            
            var reservationDate = [DateTime]()
            
            let reservationData = Data(user["reservationDate"]!.utf8)
            if let jsone = try JSONSerialization.jsonObject(with: reservationData, options: .mutableContainers) as? [[String: Any]] {
              for dateTime in jsone {
                let date = DateTime(date: dateTime["date"]! as! String, time: dateTime["time"]! as! Array<String>)
                reservationDate.append(date)
              }

            }
            
            
            DispatchQueue.main.async {
              
              
              
              let techar = Teacher(
                id:user["id"]!,
                name: user["name"]!,
                cores: user["cores"]!,
                age: user["age"]!,
                info: user["info"]!,
                exper: user["exper"]!,
                stage: user["stage"]!,
                requestDate: requestDate,
                reservationDate: reservationDate,
                image: ((UIImage(named: user["image"]!) ??  UIImage(named: "icon"))!)
              )
              
              self.teachers.append(techar)
              self.filterData = self.teachers
              self.tableView.reloadData()
//              let firstName = user["firstName"]!
//              let lastName = user["lastName"]!
//              let id = user["id"]!
//              let phone = user["phone"]!
            
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
  
  
  
  // MARK: Navigation
  
  override func prepare(for segue: UIStoryboardSegue,
                        sender: Any?) {
    
    switch segue.identifier {
    case "showDetail":
      
      if let row = tableView.indexPathForSelectedRow?.row {
        
        let detailsViewController = segue.destination as! DetailTeacherViewController
        detailsViewController.teacher = filterData[row]
      }
    default:
      preconditionFailure("Unexpected segue identifier.")
    }
  }
  
}








// MARK: Extension for Table view data source

extension TeacherViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return filterData.count
  }
  
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView
      .dequeueReusableCell(withIdentifier: "Cell",
                                             for: indexPath) as? TeacherTableViewCell
    
    if filterData.count != 0 {
      cell?.shopImageView.image = filterData[indexPath.row].image
      cell?.shopImageView.backgroundColor = .random
      cell?.shopName.text = filterData[indexPath.row].cores
      cell?.shopDescription.text = filterData[indexPath.row].info
    } else {
      cell?.shopImageView.image = teachers[indexPath.row].image
      cell?.shopImageView.backgroundColor = .random
      cell?.shopName.text = teachers[indexPath.row].cores
      cell?.shopDescription.text = teachers[indexPath.row].info
    }
    
    return cell!
  }
  
}



// MARK: Extension for Search bar delegate

extension TeacherViewController: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar,
                 textDidChange searchText: String) {
    filterData = searchText.isEmpty ? teachers : teachers.filter {
      (item : Teacher) -> Bool in
      
      return item.cores.range(of: searchText,
                              options: .caseInsensitive ,
                              range: nil,
                              locale: nil) != nil
    }
    
    tableView.reloadData()
  }
  
}
