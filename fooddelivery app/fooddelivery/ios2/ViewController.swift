//
//  ViewController.swift
//  ios2
//
//  Created by MacStudent on 2020-03-10.
//  Copyright © 2020 MacStudent. All rights reserved.
//

/*
 
 */

import UIKit

class ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    var pp = 0.0
    var qq = 0.0
    
    var prod = ["Pizza","Biryani","Momos"]
    var p = [9.33,20.66,5.3]
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return prod.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return prod[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        image.image = UIImage(named: prod[row])
        price.text = String(p[row])
        pp = p[row]
    }

    @IBOutlet weak var final: UILabel!
    
    @IBOutlet weak var qu: UIStepper!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var quant: UILabel!
    @IBOutlet weak var swit: UISwitch!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var product: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.product.delegate = self
        self.product.dataSource = self
    }
    @IBAction func quantt(_ sender: Any) {
        qq = qu.value
        quant.text = String(Int(qq))
    }
    
    @IBAction func date(_ sender: Any) {
        
       
    }
    
    
    @IBAction func finaal(_ sender: Any) {
        var t = qq*pp
        let cdate = Date()
        
        let date = Date().addingTimeInterval(2880)
        if cdate<date
        {
        if swit.isOn
        {
            if t<50
            {
                t = 0.9*t
            }
            final.text = String(format: "%.2f",t)
        }
        }
        else
        {
            final.text = "null"
        }
    }
    


}

