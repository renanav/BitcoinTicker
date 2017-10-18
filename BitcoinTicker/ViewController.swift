//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Renan Avrahami on 10/17/17.
//  Copyright © 2017 Renan Avrahami. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    
    var finalURL = ""
    var currencySymbolIndex = ""
    
    
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 //The picker will have one column
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count // The picker will have as many rows as the numbers of objects in the currencyArray array
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(currencyArray[row])
        finalURL = baseURL + currencyArray[row] // Prepares the query for the selected currency
        print(finalURL)
        
        //get the value with the selected currency
        getBitcoinPrice(url: finalURL)
    }
    
    // To display the name of the currency in the pickers row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        currencySymbolIndex = currencySymbolArray[row]
        return currencyArray[row]
    }
    
    
    //MARK: - Networking
    //    /***************************************************************/
    
    func getBitcoinPrice(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    
                    print("Value retrieved")

                    let priceJSON : JSON = JSON(response.result.value!)
                    print(priceJSON)
                    self.getPriceData(json: priceJSON)
                    
                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
        }
        
    }
    
    //MARK: - JSON Parsing
    //    /***************************************************************/
    
    func getPriceData(json : JSON) {
        
        if let price = json["ask"].double {
            bitcoinPriceLabel.text = currencySymbolIndex + String(price)
            
        }
        else {
            bitcoinPriceLabel.text = "Price unavailable"
        }
        
        
        
    }
}
