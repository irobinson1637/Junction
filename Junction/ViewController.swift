//
//  ViewController.swift
//  Junction
//
//  Created by Isaac Robinson on 8/12/16.
//  Copyright © 2016 Isaac Robinson. All rights reserved.
//

import UIKit
import ResearchKit


extension ViewController : ORKTaskViewControllerDelegate {
    
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        //Handle results with taskViewController.result
        HealthKitManager.stopMockHeartData()
        if (taskViewController.task?.identifier == "WalkTask" //checks if task is walktask and if walktask is completed
            && reason == .Completed) {
            let heartURLs = DataParser.findWalkHeartFiles(taskViewController.result) //parsing!
            for url in heartURLs {
                do {
                    let string = try NSString.init(contentsOfURL: url, encoding: NSUTF8StringEncoding)
                    print("hello")
                    heartStore = string as String
                    heartStore2 += heartStore
                    print(heartStore)
                } catch {}
            }
        }

        taskViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

class ViewController: UIViewController,NSStreamDelegate{  //,UITextFieldDelegate
    @IBOutlet weak var consentButton: UIButton!
    @IBOutlet weak var connectButto: UIButton!
    @IBOutlet weak var theRealLabel: UILabel!
    var heartStore = " "
    var heartStore2 = " "
    var delegate2 = ViewController!.self
    var symStore: [Int] = []
    var stringSymptomStore = ""
    let stats = dataStatistics()
    var averageHeart3Day:Int = 0
    var nameStore = "Name:"
    var justName = "💔"
    var isTaken: String = ""
 
      //  let tesTer = shareData.sharedInstance
 
    //Socket server
    let addr = "10.189.11.223"
    let port = 8146
    
    //Network variables
    var inStream : NSInputStream?
    var outStream: NSOutputStream?
    
    //Data received
    var buffer = [UInt8](count: 200, repeatedValue: 0)
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
        
    }

    @IBAction func sickInput(sender: UIButton) {
       shareData.sharedInstance.symptomArray[0] = 10
    }

    
    @IBAction func consentTapped(sender : AnyObject) {
    let taskViewController = ORKTaskViewController(task: ConsentTask, taskRunUUID: nil)
    taskViewController.delegate = self
    presentViewController(taskViewController, animated: true, completion: nil)
        consentButton.enabled = false
        
}
    @IBAction func authorizeTapped(sender: AnyObject) {
        HealthKitManager.authorizeHealthKit()
        //TODO: disable button
        
    }
 
    @IBAction func connectButton2(sender: UIButton) {
       NetworkEnable()
        popUp()
        
    }
    var valuu = "msg:jj"
    @IBAction func commitButtonPressed2(sender: UIButton) {
        let data : NSData = heartStore.dataUsingEncoding(NSUTF8StringEncoding)!
        outStream?.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
    }
    @IBAction func iButton(sender: UIButton) {
        let data : NSData = "iPhone:Hello".dataUsingEncoding(NSUTF8StringEncoding)!
        outStream?.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
    }
    
    func updateData(ring:String){
       print("Data updataed: ")
    }
    func arrayToString(toConvert:[Int]) -> String{
        var convertedArray = ""
        for items in toConvert{
            let tempStore = String(items)
            convertedArray+=tempStore
            convertedArray+=","
        }
        return convertedArray
        
    }
   @IBAction func getStatistics(){ //gets average heart rate for last 3 days
        stats.getStats() //gets average heart rate for last 3 days
    }
    
    @IBAction func commitSymptom(sender: AnyObject) {
        averageHeart3Day=shareData.sharedInstance.averageHeartRate
        symStore = shareData.sharedInstance.symptomArray
        print("average rate: ")
        print(averageHeart3Day)
        symStore[2] = averageHeart3Day
        print("sym Store:")
        print(symStore)
        stringSymptomStore = arrayToString(symStore)+justName
        print("sendong...")
        print(stringSymptomStore)
        let data : NSData = stringSymptomStore.dataUsingEncoding(NSUTF8StringEncoding)!
        outStream?.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
        
       
    
    }
    func popUp(){
        
        
        //1. Create the alert controller.
        var alert = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = ""
        })
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            print("Text field: \(textField.text)")
            self.nameStore += textField.text!
            self.justName += textField.text!
            let data : NSData = self.nameStore.dataUsingEncoding(NSUTF8StringEncoding)!
            self.outStream?.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
            
        }))
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
        

        
    }
    @IBAction func switchView(sender: UIButton) {
      //  NetworkEnable()
  
    }
  
    //Symptom Input:

    
    
    //Network functions
    func NetworkEnable() {
        
        print("NetworkEnable")
        NSStream.getStreamsToHostWithName(addr, port: port, inputStream: &inStream, outputStream: &outStream)
        
        inStream?.delegate = self
        outStream?.delegate = self
        
        inStream?.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        outStream?.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
        inStream?.open()
        outStream?.open()
        
        buffer = [UInt8](count: 200, repeatedValue: 0)
    }
    
    @IBAction func NetworkDisable(){
        print("Network abandoned")
        nameStore = "Name:"
        justName = "💔"
        inStream?.close()
        inStream?.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        outStream?.close()
        outStream?.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        connectButto.enabled = true
        theRealLabel.text = "Connection stopped by user"
        
    }
    
    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        
        switch eventCode {
        case NSStreamEvent.EndEncountered:
            nameStore = "Name:"
            justName = "💔"
            print("EndEncountered")
            theRealLabel.text = "Connection stopped by server: Try a different UserName"
            connectButto.enabled = true
            inStream?.close()
            inStream?.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
            outStream?.close()
            print("Stop outStream currentRunLoop")
            outStream?.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        case NSStreamEvent.ErrorOccurred:
            nameStore = "Name:"
            justName = "💔"
            print("ErrorOccurred")
            
            inStream?.close()
            inStream?.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
            outStream?.close()
            outStream?.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
                theRealLabel.text="Failed to connect to server"
                connectButto.enabled = true
            
        case NSStreamEvent.HasBytesAvailable:
            print("HasBytesAvailable")
            if aStream == inStream {
                inStream!.read(&buffer, maxLength: buffer.count)
                let bufferStr = NSString(bytes: &buffer, length: buffer.count, encoding: NSUTF8StringEncoding)
                theRealLabel.text =  bufferStr! as String
                print("buffer is: ")
                print(bufferStr! as String)
                isTaken = bufferStr! as String
              }
                
            
            
        case NSStreamEvent.HasSpaceAvailable:
            print("HasSpaceAvailable")
        case NSStreamEvent.None:
            print("None")
        case NSStreamEvent.OpenCompleted:
            print("OpenCompleted")
                connectButto.enabled = false
                theRealLabel.text="Connected to server"

        default:
            print("Unknown")
        }
    }

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//print(dataPassed)
       
    }
    

 
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }


}

