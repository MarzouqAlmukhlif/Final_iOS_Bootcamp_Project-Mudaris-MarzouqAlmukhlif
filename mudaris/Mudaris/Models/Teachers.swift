//
//  Shops.swift
//  Salon
//
//  Created by Marzouq Almukhlif on 17/04/1443 AH.
//

import UIKit


struct DateTime {
  let date:String
  let time:[String]
}


let arrayOrders:[Order] = [
  Order(teacherName: "احمد الخالدي",
        coresName:"مدرس لغة انجليزية",
         lessonDate: "2021-12-30",
         lessonTime: "9:00ص - 11:00ص",
         state: "Ok",
         location: [32.5,26.5],
        image: UIImage(named: "icon"))
]


struct Teacher {
  let id:String
  let name:String
  let cores:String
  let age:String
  let info:String
  let exper:String
  let stage:String
  let requestDate:[DateTime]
  let reservationDate:[DateTime]
  let image:UIImage
}
