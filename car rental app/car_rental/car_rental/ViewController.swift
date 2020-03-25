//
//  ViewController.swift
//  car_rental
//
//  Created by MacStudent on 2020-03-06.
//  Copyright © 2020 MacStudent. All rights reserved.
//
/*
 create an app for car rental
 menu showing car names
 show its rate and picture
 let the user choose how many days
 let user pick one otion
 <18 8-64 65+
 if <18: add 5$ per day,if 65+ increase the total by 10%
 let the user pick one or more of these options
 Navigator child_seat  unlimited_milege
 add 7$ per day for navigator
 6$ fo child seat
 1.5 times rate for unlimited
 Finally add 13% for total and display
 */

import UIKit

class ViewController:UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return avcars.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return avcars[row].name
    }
    
    var rentals: [rental] = []
    var avcars: [rental] = []
    

    
    @IBOutlet weak var days: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var car: UIPickerView!
    @IBOutlet weak var less: UIButton!
    @IBOutlet weak var med: UIButton!
    @IBOutlet weak var high: UIButton!
    @IBOutlet weak var nav: UIButton!
    @IBOutlet weak var child: UIButton!
    @IBOutlet weak var mil: UIButton!
    @IBOutlet weak var final: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.car.delegate = self
        self.car.dataSource = self
        
        rentals.append(rental(name: "La Ferrari", rate: 1255, status: false, milage: 12000))
        rentals.append(rental(name: "Lamborgini Aventador", rate: 1477, status: true, milage: 10000))
        rentals.append(rental(name: "Bentley Continental GT", rate: 1400, status: true, milage: 4500))
        rentals.append(rental(name: "Tesla Model X", rate: 1122, status: true, milage: 12366))
        rentals.append(rental(name: "Bugatti Chiron", rate: 1788, status: true, milage: 14000))
        rentals.append(rental(name: "Pagani Huyara", rate: 1800, status: true, milage: 17889))
        rentals.append(rental(name: "Audi R8", rate: 1788, status: false, milage: 1455))
        for i in 0..<rentals.count
        {
            if rentals[i].status
            {
                avcars.append(rentals[i])
            }
        }
       
    }
    var fp = 0.0
    /*var cars = ["La Ferrari","Lamborgini Aventador","Bentley Continental GT","Tesla Model X","Bugatti Chiron","Pagani Huyara","Audi R8"]
    var prices = [1255.33,1477.36,1400.33,1155.36,1633.25,1044.36,1788.36]
    */

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        fp=0.0
        price.text = String(avcars[row].rate)
        image.image = UIImage(named: avcars[row].name)
        fp = fp+Double(price.text!)!
    }
    
    
    
    
    
    @IBAction func but1(_ sender: UIButton) {
        if sender.isSelected
        {
            sender.isSelected = false
            fp = fp-(Double(days.text!)!*5)
        }
        else
        {
            sender.isSelected = true
            fp = fp+(Double(days.text!)!*5)
            med.isSelected = false
            high.isSelected = false
            
        }
    }
    
    @IBAction func but2(_ sender: UIButton) {
        if sender.isSelected
        {
            sender.isSelected = false
        }
        else
        {
            less.isSelected = false
            sender.isSelected = true
            high.isSelected = false
        }
    }
    
    @IBAction func but3(_ sender: UIButton) {
        if sender.isSelected
        {
            sender.isSelected = false
            fp = fp/1.1
        }
        else
        {
            less.isSelected = false
            med.isSelected = false
            sender.isSelected = true
            fp = fp*1.1
        }
    }
    
    @IBAction func check1(_ sender: UIButton) {
        if sender.isSelected
        {
            sender.isSelected = false
            fp = fp-(Double(days.text!)!*7)
        }
        else
        {
            sender.isSelected = true
            fp = fp+(Double(days.text!)!*7)
        }
    }
    
    @IBAction func check2(_ sender: UIButton) {
        if sender.isSelected
        {
            sender.isSelected = false
            fp = fp-(Double(days.text!)!*6)
        }
        else
        {
            sender.isSelected = true
            fp = fp+(Double(days.text!)!*6)
        }
    }
    
    @IBAction func check3(_ sender: UIButton) {
        if sender.isSelected
        {
            sender.isSelected = false
            fp = fp/1.5

        }
        else
        {
            sender.isSelected = true
            fp = fp*1.5
        }
    }
    
    @IBAction func bookk(_ sender: Any) {
        final.text = String(fp*Double(days.text!)!)
        
    }
    
    
}

