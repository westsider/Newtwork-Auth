//
//  ViewController.swift
//  Newtwork Auth
//
//  Created by Warren Hansen on 1/10/18.
//  Copyright © 2018 Warren Hansen. All rights reserved.
//

import UIKit
//import Foundation
class ViewController: UIViewController {

    let user = "someUser"
    let password = "somePassWord"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callNetwork(ticker: "AAPL", user: user, password: password)
    }

    //MARK: - TODO - Refactor to network file
    func callNetwork(ticker:String, user:String, password:String) {
        
        let loginData = String(format: "%@:%@", user, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        let urlString = "https://api.intrinio.com/prices?ticker=\(ticker)"
        // create the request
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
        
        //making the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("\(error.debugDescription)")
                return
            }
            
            self.parseData(data: data, showJson: false)
            
            if let httpStatus = response as? HTTPURLResponse {
                // check status code returned by the http server
                print("status code = \(httpStatus.statusCode)")
                // process result
            }
        }
        task.resume()
    }
    
    func parseData(data: Data, showJson:Bool) {
        let jsonObj = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
        if showJson {
            print(jsonObj!.value(forKey: "data")!)
        }
        if let priceArray = jsonObj!.value(forKey: "data") as? NSArray {
            //looping through all the elements
            for each in priceArray {
                
                //converting the element to a dictionary
                if let priceDict = each as? NSDictionary {
                    //getting the name from the dictionary
                    if let date = priceDict.value(forKey: "date"), let close = priceDict.value(forKey: "close") {
                        print(date, close)
                    }
                }
            }
        }
    }
}

