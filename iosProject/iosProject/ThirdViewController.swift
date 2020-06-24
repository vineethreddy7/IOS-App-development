//
//  ThirdViewController.swift
//  iosProject
//
//  Created by VRBX on 2020-06-15.
//  Copyright © 2020 VRBX All rights reserved.
//

import UIKit
import Foundation
import CoreData
import CoreLocation
import MapKit
import AVFoundation

class ThirdViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,CLLocationManagerDelegate,MKMapViewDelegate, AVAudioRecorderDelegate,AVAudioPlayerDelegate {
    var cname: [String] = []
    var cdate = NSDate.now
    var img: UIImage? = nil
    var lat: Double = 0
    var long: Double = 0
    let locationManager = CLLocationManager()
    var latitude: Double = 0
    var longitude: Double = 0
    var audio: URL!
    var audio1: URL!
    
    var recorder: AVAudioRecorder!
    var player: AVAudioPlayer!
    var session: AVAudioSession!
    
    
    @IBOutlet var recordButton: UIButton!
    @IBOutlet weak var mpView: MKMapView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var noteName: UILabel!
    @IBOutlet weak var noteDesc: UITextView!
    @IBOutlet weak var timestamp: UILabel!
    var details: String = ""
    var dManager : NSManagedObjectContext!
    var pArray = [NSManagedObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        mpView.delegate = self
        dManager = appDelegate.persistentContainer.viewContext
     
        mpView.showsUserLocation = true
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        //    locationM.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
         // locationManager.startUpdatingLocation()
            locationManager.requestLocation()
       //   locationManager.stopUpdatingLocation()
        print(CLLocationManager.authorizationStatus())
        mpView.showsUserLocation = true
    
       
        noteName.text? = details
    
        fetch()
        
        setup()
        
        
        // Do any additional setup after loading the view.
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            lat = location.coordinate.latitude
            long = location.coordinate.longitude
            print("1: \(lat)")
            print("2: \(long)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
    }
    
    func setup(){
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDir = path[0]
        
        let audioname = documentsDir.appendingPathComponent("audio.m4a")
   //     audio = documentsDir
        
     //   print(audioname)
        
        
        
        
        let settings = [AVFormatIDKey: Int(kAudioFormatAppleLossless),AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,AVEncoderBitRateKey: 32000,AVNumberOfChannelsKey: 2,AVSampleRateKey: 44100.0] as [String: Any]
        
        var error: NSError?
        
        do{
            recorder = try AVAudioRecorder(url: audioname, settings: settings)
        }catch{
            recorder = nil
        }
        if let err = error{
            print("Error")
        }
        else{
            recorder.delegate = self
            recorder.prepareToRecord()
        }
    }

    func prepare(){
        do{
            player = try AVAudioPlayer(contentsOf: getURL())
            player.delegate = self
            player.volume = 2.0
        }
        catch{
            print("Error")
            player = nil
        }
    }
    
    func getURL() -> URL{
        let fm = FileManager.default
        let url = fm.urls(for: .documentDirectory, in: .userDomainMask)
        let directory = url[0] as URL
        let surl = directory.appendingPathComponent("audio.m4a")
        audio = surl
        return surl
    }
    
    
    
    
    @IBAction func doneBtn(_ sender: UIButton) {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Description", into: dManager)
        
            entity.setValue(noteDesc.text!, forKey: "text")
        entity.setValue(details, forKey: "classname")
        entity.setValue(dateToString(fromDate: cdate), forKey: "timestamp")
        entity.setValue(img?.pngData(), forKey: "image")
        entity.setValue(lat, forKey: "latitude")
        entity.setValue(long, forKey: "longitude")
        entity.setValue(audio, forKey: "audio")
        
        do{
            try self.dManager.save()
            pArray.append(entity)
            
        }
        catch{
            print("Error")
        }
        fetch()
    
    }
    
    
   func fetch(){
        let fetch : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Description")
        do{
            let res = try dManager.fetch(fetch)
            pArray = res as! [NSManagedObject]
            for b in pArray{
                let classn = b.value(forKey: "classname") as! String
                let classdesc = b.value(forKey: "text") as! String
                let datetime = b.value(forKey: "timestamp") as! String
                
                
                let latt = b.value(forKey: "latitude") as! Double
                let longg = b.value(forKey: "longitude") as! Double
                
            //    print(URL(fileURLWithPath: rec))
                if classn == details{
                    noteDesc.text? = classdesc
                    timestamp.text? = datetime
                    if b.value(forKey: "image") != nil {
                    let image = b.value(forKey: "image") as! Data
                        imageView.image = UIImage(data: image)
                    }
                    latitude = latt
                    longitude = longg
                    if b.value(forKey: "audio") != nil{
                        let rec = b.value(forKey: "audio") as! URL
                        audio1 = rec
                    }
                    
                }
                
                
            }
        }
        catch{
            print("Error")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let mapVC = segue.destination as? MapViewController{
            mapVC.lat = latitude
            mapVC.long = longitude
            
        }
    }
    func dateToString(fromDate date: Date) -> String {
        let dateFormmater = DateFormatter()
        dateFormmater.timeZone = TimeZone(identifier: "EDT")
        dateFormmater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormmater.string(from: date)
    }
    @IBAction func fetchImage(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedimage = info[.editedImage] as? UIImage else { return }
        imageView.image = pickedimage
        img = pickedimage

        picker.dismiss(animated: true)
    }
    @IBAction func mapBtn(_ sender: UIButton) {
        fetch()
        
    }
    @IBAction func record(_ sender: UIButton) {
        if sender.titleLabel?.text == "Record"{
            recorder.record()
            sender.setTitle("Stop", for: .normal)
        }else{
            recorder.stop()
            sender.setTitle("Record", for: .normal)
        }
    }
    @IBAction func play(_ sender: UIButton) {
        if sender.titleLabel?.text == "Play"{
            fetch()
            sender.setTitle("Stop", for: .normal)
            prepare()
            player.play()
        }
        else{
            player.stop()
            sender.setTitle("Play", for: .normal)
        }
    }
    @IBAction func playrec(_ sender: UIButton) {
        fetch()
        do{
        player = try AVAudioPlayer(contentsOf: audio1)
        player.delegate = self
        player.play()
        }catch{
            player = nil
        }
        
    }
    
   
    
}
