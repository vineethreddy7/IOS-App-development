//
//  ViewController.swift
//  iosProject
//
//  Created by VRBX on 6/12/20.
//  Copyright © 2020 VRBX All rights reserved.
//

import UIKit
import CoreData
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "task", for: indexPath)

        cell.textLabel?.text = tableData[indexPath.row]
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        task = tableData[indexPath.row]
        
    }
   
    
    

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var newCategory: UITextField!
    var tableData: [String] = []
    var task: String = ""
    
    var dm : NSManagedObjectContext!
    var lA = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        // Do any additional setup after loading the view.
        
        let appDel = UIApplication.shared.delegate as! AppDelegate
        dm = appDel.persistentContainer.viewContext
        fetch()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let secondVC = segue.destination as? SecondViewController{
            secondVC.note = tableData[table.indexPathForSelectedRow!.row]
            
        }
    }

    @IBAction func add(_ sender: UIButton) {
        tableData.removeAll()
       let entity = NSEntityDescription.insertNewObject(forEntityName: "Category", into: dm)
        
        entity.setValue(newCategory.text!, forKey: "name")
        do{
            try self.dm.save()
            lA.append(entity)
          
        }
        catch{
            print("Error saving data")
        }
        newCategory.text! = ""
        fetch()
        
        
        

        
    }
    @IBAction func del(_ sender: UIButton) {
        tableData.removeAll()
        let delItem = newCategory.text!
        for item in lA{
            if item.value(forKey: "name") as! String == delItem{
                dm.delete(item)
            }
        }
        do{
            try self.dm.save()
            //table.reloadData()
            
        }catch{
            print("Error deleting data")
        }
        newCategory.text! = ""
        fetch()
    
    }
    
    func fetch(){
        //self.table.reloadData()
        let fetchreq : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Category")
        do{
            let result = try dm.fetch(fetchreq)
            lA = result as! [NSManagedObject]
            for item in lA{
                let note = item.value(forKey: "name") as! String
                tableData.append(note)
                table.reloadData()
                
            }
            
        
        }catch{
            print("Error retrieving data")
        }
    }
    
   
    
    
    
}

