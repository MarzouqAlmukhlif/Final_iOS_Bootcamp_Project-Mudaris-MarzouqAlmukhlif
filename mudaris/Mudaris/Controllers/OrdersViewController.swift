//
//  OrdersViewController.swift
//  Mudaris
//
//  Created by Marzouq Almukhlif on 26/05/1443 AH.
//

import UIKit

class OrdersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate{

  @IBOutlet weak var locationButton: UIButton!
  
  @IBOutlet var SearchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  
  
//  var orders:[Order] = [Order]()
  var orders:[Order] = [Order]()
  var filterData:[Order]!
  var selectedData:Order!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      tableView.dataSource = self
      tableView.delegate = self
        // Do any additional setup after loading the view.
      filterData = orders
      getOrders()
    }
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getOrders()
  }

  
  // MARK: - Table view data source

func numberOfSections(in tableView: UITableView) -> Int {
      return 1
  }

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  return filterData.count
  }

  
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath) as? OrderTableViewCell
   
   if filterData.count != 0 {
     cell?.teacherImage.image = filterData[indexPath.row].image
      cell?.teacherImage.backgroundColor = .random
     cell?.coresName.text = filterData[indexPath.row].coresName
     cell?.teacherName.text = filterData[indexPath.row].teacherName
     cell?.lessonDate.text = filterData[indexPath.row].lessonDate
     cell?.lessonTime.text = filterData[indexPath.row].lessonTime

   } else {
     cell?.teacherImage.image = orders[indexPath.row].image
      cell?.teacherImage.backgroundColor = .random
     cell?.coresName.text = orders[indexPath.row].coresName
     cell?.teacherName.text = orders[indexPath.row].teacherName
     cell?.lessonDate.text = orders[indexPath.row].lessonDate
     cell?.lessonTime.text = orders[indexPath.row].lessonTime
   }
   cell?.selectionStyle = UITableViewCell.SelectionStyle.default

      // Configure the cell...
      
    return cell!
  }
  

  
  func getOrders() {
    
   
    //create the url with URL
    let url = URL(string: NetworkEndPoints.endPoints + "orders.php")! //change the url
    let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    let path = "\(documentDirectory)/profile.plist"
    let nsDictionary = NSDictionary(contentsOfFile: path) ?? NSDictionary()
    


    let parameters = ["email": nsDictionary["email"] as! String]
    //create the session object
    let session = URLSession.shared
    
    //now create the URLRequest object using the url object
    var request = URLRequest(url: url)
    request.httpMethod = K.HTTP.postHttpMethod //set http method as POST
    
    do {
      request.httpBody = try JSONSerialization
        .data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
      print("\n\n \(request.httpBody)")

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
          self.orders.removeAll()
          if json["state"] as! Int == 200 {
            
            let orders = json["orders"] as? [[String: Any]]
            for order in orders! {
            let user = order

            let gg = user["studentLocation"] as! String
            let fullNameArr = gg.components(separatedBy:"|")
            let longE = Double(fullNameArr[0])
            let lag = Double(fullNameArr[1])
            let location = [CGFloat(longE!), CGFloat(lag!)]

            DispatchQueue.main.async {
              
              
              let order = Order(teacherName: user["teacherName"] as! String,
                                coresName: user["coresName"] as! String,
                                lessonDate: user["lessonDate"] as! String,
                                lessonTime: user["lessonTime"] as! String,
                                state: user["state"] as! String,
                                location: location,
                                image: UIImage(named: user["image"] as! String) ?? UIImage(named: "icon") )

              
              self.orders.append(order)
              self.filterData = self.orders
              self.tableView.reloadData()

            
            }
          }
            // handle json...
          } else {
            DispatchQueue.main.async {
              self.filterData = self.orders
            self.tableView.reloadData()
            }
          }
        }
      } catch let error {
        print(error.localizedDescription)
      }
    })
    task.resume()
  }
  
  
  
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

  switch segue.identifier {
    case "showDetailOrder":

      if let row = tableView.indexPathForSelectedRow?.row {
       
      let detailsViewController = segue.destination as! DetailOrderViewController
        detailsViewController.array = filterData[row]


      }
  default:
        preconditionFailure("Unexpected segue identifier.")
    }
}


func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
  filterData = searchText.isEmpty ? orders : orders.filter {
    (item : Order) -> Bool in
    
    return item.teacherName.range(of: searchText, options: .caseInsensitive , range: nil,locale: nil) != nil
  }
  
  tableView.reloadData()
}

}
