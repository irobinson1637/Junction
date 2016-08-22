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
 
      //  let tesTer = shareData.sharedInstance
 
    //Socket server
    let addr = "10.189.22.21"
    let port = 8080
    
    //Network variables
    var inStream : NSInputStream?
    var outStream: NSOutputStream?
    
    //Data received
    var buffer = [UInt8](count: 200, repeatedValue: 0)
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
        
    }
    
    @IBAction func walkTapped(sender: AnyObject) {
        print("tapped")
        let taskViewController = ORKTaskViewController(task: WalkTask, taskRunUUID: nil)
        taskViewController.delegate = self
        taskViewController.outputDirectory = NSURL(fileURLWithPath:
            NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0],
                                                   isDirectory: true)
        presentViewController(taskViewController, animated: true, completion: nil)
        HealthKitManager.startMockHeartData()
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
   @IBAction func getStatistics(){
        stats.getStats()
    }
    
    @IBAction func commitSymptom(sender: AnyObject) {
         averageHeart3Day=shareData.sharedInstance.averageHeartRate
        symStore = shareData.sharedInstance.symptomArray
        print("average rate: ")
        print(averageHeart3Day)
        symStore[symStore.endIndex-1] = averageHeart3Day
        print("sym Store:")
        print(symStore)
        stringSymptomStore = arrayToString(symStore)
        print("sendong...")
        print(stringSymptomStore)
        let data : NSData = stringSymptomStore.dataUsingEncoding(NSUTF8StringEncoding)!
        outStream?.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
        
       
    
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
            print("EndEncountered")
            theRealLabel.text = "Connection stopped by server"
            connectButto.enabled = true
            inStream?.close()
            inStream?.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
            outStream?.close()
            print("Stop outStream currentRunLoop")
            outStream?.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        case NSStreamEvent.ErrorOccurred:
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
                theRealLabel.text = bufferStr! as String
                print(bufferStr!)
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

