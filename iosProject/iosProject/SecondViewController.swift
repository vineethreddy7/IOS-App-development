//
//  SecondViewController.swift
//  iosProject
//
//  Created by VRBX on 6/12/20.
//  Copyright © 2020 VRBX All rights reserved.
//

import UIKit
import Foundation
import CoreData

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "view1", for: indexPath)
        
        view1 = viewData[indexPath.row]
        cell.textLabel?.text = view1
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view1 = viewData[indexPath.row]
        
    }

    
    
    @IBOutlet var sortType: [UIButton]!
    var viewData: [String] = []
    var view1: String = ""
    var note: String = ""
    var date = NSDate.now
    var datesave: [Date] = []
    var sortTitle: [String] = []
   
    
    
    
    
    @IBOutlet weak var newNote: UITextField!
    @IBOutlet weak var llabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var dataManager : NSManagedObjectContext!
    var lArray = [NSManagedObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataManager = appDelegate.persistentContainer.viewContext
        tableView.delegate = self
        tableView.dataSource = self
        
        llabel.text? =  note
        
        // Do any additional setup after loading the view.
        fetch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let thirdVC = segue.destination as? ThirdViewController{
            thirdVC.details = viewData[tableView.indexPathForSelectedRow!.row]
           
            
        }
    }
    
    @IBAction func sortOption(_ sender: UIButton) {
        sortType.forEach{(button) in
            UIView.animate(withDuration: 0.5, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    
    }
    
    @IBAction func addNote(_ sender: UIButton) {
        viewData.removeAll()
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Class", into: dataManager)
        
        entity.setValue(newNote.text!, forKey: "classn")
        entity.setValue(note, forKey: "category")
        entity.setValue(dateToString(fromDate: date), forKey: "timesave")
       
        do{
            try self.dataManager.save()
            lArray.append(entity)
            tableView.reloadData()
        }
        catch{
            print("Error saving data")
        }
        newNote.text! = ""
        fetch()
    
        
    }
    
    @IBAction func delNote(_ sender: UIButton) {
        viewData.removeAll()
        let del = newNote.text!
        for a in lArray{
            if a.value(forKey: "classn") as! String == del{
                dataManager.delete(a)
            }
        }
        do{
            try self.dataManager.save()
        }catch{
            print("Error deleting data")
        }
        newNote.text! = ""
        fetch()
        
    }
    
    func fetch(){
        let fetch : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Class")
        do{
            let res = try dataManager.fetch(fetch)
            lArray = res as! [NSManagedObject]
            for b in lArray{
                let name = b.value(forKey: "classn") as! String
                let category = b.value(forKey: "category") as! String
                let date = b.value(forKey: "timesave") as! Date
                
                if category == note{
                    viewData.append(name)
                    datesave.append(date)
                    tableView.reloadData()
                }
            }
        }
        catch{
            print("Error retrieving data")
        }
    }
    @IBAction func titlesort(_ sender: UIButton) {
        sortT()
        
    }
    
    @IBAction func datesort(_ sender: UIButton) {
        sortD()
    }
    func sortT(){
        sortTitle.removeAll()
        for k in viewData{
            sortTitle.append(k)
        }
        let sortedNames = viewData.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        viewData.removeAll()
        for a in sortedNames{
            viewData.append(a)
            tableView.reloadData()
        }
    }
    
    func sortD(){
        var sorted: [String] = []
        sorted.removeAll()
        for c in sortTitle{
            sorted.append(c)
        }
        viewData.removeAll()
        for a in sorted{
            viewData.append(a)
            tableView.reloadData()
        }
       
        
    }
    
    @IBAction func search(_ sender: UIButton) {
        var index: [String] = []
        index.removeAll()
        for a in viewData{
            index.append(a)
        }
        viewData.removeAll()
        for b in index{
            if newNote.text!.lowercased() == b.lowercased(){
                viewData.append(b)
                tableView.reloadData()
            }
        }
    }
    func dateToString(fromDate date: Date) -> Date {
           let dateFormmater = DateFormatter()
           dateFormmater.timeZone = TimeZone(identifier: "EDT")
           dateFormmater.dateFormat = "yyyy-MM-dd HH:mm:ss"
           
        return dateFormmater.date(from: dateFormmater.dateFormat) ?? date
       }
    
}
