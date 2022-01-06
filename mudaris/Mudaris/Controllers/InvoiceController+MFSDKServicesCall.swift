//
//  ViewController+MFSDKServicesCall.swift
//  MFSDKDemo-Swift
//
//  Created by Elsayed Hussein on 8/29/19.
//  Copyright © 2019 Elsayed Hussein. All rights reserved.
//

import MFSDK
import UIKit

extension InvoiceController {
  func initiatePayment() {
    payButton.isEnabled = false
      let request = generateInitiatePaymentModel()
//      startLoading()
      MFPaymentRequest.shared.initiatePayment(request: request, apiLanguage: .arabic, completion: { [weak self] (result) in
//          self?.stopLoading()
          switch result {
          case .success(let initiatePaymentResponse):
              self?.paymentMethods = initiatePaymentResponse.paymentMethods
              self?.collectionView.reloadData()
          case .failure(let failError):
//              self?.showFailError(failError)
            print("")
          }
      })
  }

  
  func executeApplePayPayment(paymentMethodId: Int) {
      let request = getExecutePaymentRequest(paymentMethodId: paymentMethodId)
      if #available(iOS 13.0, *) {
          MFPaymentRequest.shared.executeApplePayPayment(request: request, apiLanguage: .arabic) { (response, invoiceId) in
              switch response {
              case .success(let executePaymentResponse):
                  if let invoiceStatus = executePaymentResponse.invoiceStatus {
                    print("showSuccess1 \(invoiceStatus)")
                    self.configOrderState(imageName: "success", success:true)
                  }
              case .failure(let failError):
                self.dismiss(animated: true, completion: nil)
                print("showFailError1 \(failError.errorDescription)")
                self.configOrderState(imageName: "failure", success:false)

                
              }
          }
      } else {
        MFPaymentRequest.shared.executeApplePayPayment(request: request, apiLanguage: .arabic) {  response, invoiceId  in
              switch response {
              case .success(let executePaymentResponse):
                  if let invoiceStatus = executePaymentResponse.invoiceStatus {
                    self.dismiss(animated: true, completion: nil)
                    print("showSuccess2 \(invoiceStatus)")
                    self.configOrderState(imageName: "success", success:true)

                  }
              case .failure(let failError):
                self.dismiss(animated: true, completion: nil)
                print("showFailError2 \(failError.errorDescription)")
                self.configOrderState(imageName: "failure", success:false)

              }
          }
      }
  }

  func executePayment(paymentMethodId: Int) {
      let request = getExecutePaymentRequest(paymentMethodId: paymentMethodId)
      MFPaymentRequest.shared.executePayment(request: request, apiLanguage: .arabic) { response, invoiceId  in
          switch response {
          case .success(let executePaymentResponse):
              if let invoiceStatus = executePaymentResponse.invoiceStatus {
                print("showSuccess3 \(invoiceStatus)")
                self.configOrderState(imageName: "success", success:true)


              }
          case .failure(let failError):
            print("showFailError3 \(failError.errorDescription)")
            self.configOrderState(imageName: "failure", success:false)

            
          }
      }
  }
  
  
  func sendPayment() {
      let request = getSendPaymentRequest()
      MFPaymentRequest.shared.sendPayment(request: request, apiLanguage: .arabic) { [weak self] (result) in
          switch result {
          case .success(let sendPaymentResponse):
              if let invoiceURL = sendPaymentResponse.invoiceURL {
//                  self?.errorCodeLabel.text = "Success"
//                  self?.resultTextView.text = "result: send this link to your customers \(invoiceURL)"
              }
          case .failure(let failError):
//              self?.showFailError(failError)
            print("showFailError \(failError.errorDescription)")
          }

      }
  }
  
  
  private func generateInitiatePaymentModel() -> MFInitiatePaymentRequest {
      let request = MFInitiatePaymentRequest()
      return request
  }


  
////  PAY
  private func getExecutePaymentRequest(paymentMethodId: Int) -> MFExecutePaymentRequest {
      let request = MFExecutePaymentRequest(invoiceValue: invoiceValue , paymentMethod: paymentMethodId)
      request.customerEmail = "test@myfatoorah.com"// must be email
      request.customerMobile = "112233"
      request.customerName = "Test MyFatoorah"
      let address = MFCustomerAddress(block: "ddd", street: "sss", houseBuildingNo: "sss", address: "sss", addressInstructions: "sss")
      request.customerAddress = address
      request.language = .arabic
    request.mobileCountryCode = MFMobileCountryCodeISO.saudiArabia.rawValue
    request.displayCurrencyIso = .saudiArabia_SAR
      return request
  }
  
  
  
  func getSendPaymentRequest() -> MFSendPaymentRequest {
//      let invoiceValue = Decimal(string: amountTextField.text ?? "") ?? 0
      let request = MFSendPaymentRequest(invoiceValue: invoiceValue, notificationOption: .all, customerName: "Test")

      //request.userDefinedField = ""
      request.customerEmail = "a@b.com"// must be email
      request.customerMobile = "mobile no"//Required
      request.customerCivilId = ""
    request.mobileCountryIsoCode = MFMobileCountryCodeISO.saudiArabia.rawValue
      request.customerReference = ""
      request.language = .arabic
      let address = MFCustomerAddress(block: "ddd", street: "sss", houseBuildingNo: "sss", address: "sss", addressInstructions: "sss")
      request.customerAddress = address
      request.language = .arabic
      request.displayCurrencyIso = .saudiArabia_SAR
      let date = Date().addingTimeInterval(1000)
      request.expiryDate = date
      return request
  }

  
}

