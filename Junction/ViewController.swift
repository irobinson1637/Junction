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

class ViewController: UIViewController,NSStreamDelegate{//,UITextFieldDelegate
    @IBOutlet weak var consentButton: UIButton!
    @IBOutlet weak var connectButto: UIButton!
    @IBOutlet weak var theRealLabel: UILabel!
    var heartStore = " "
    var heartStore2 = " "
    var delegate2 = ViewController!.self

      //  let tesTer = shareData.sharedInstance
 
    //Socket server
    let addr = "18.111.51.218"
    let port = 8080
    
    //Network variables
    var inStream : NSInputStream?
    var outStream: NSOutputStream?
    
    //Data received
    var buffer = [UInt8](count: 200, repeatedValue: 0)
    
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
    @IBAction func buttonClicked(sender: AnyObject) {
    
    }
    
    @IBAction func connectButton2(sender: UIButton) {
        NetworkEnable()
    }
    var valuu = "msg:jj"
    @IBAction func quitButtonPressed2(sender: UIButton) {
        let data : NSData = heartStore.dataUsingEncoding(NSUTF8StringEncoding)!
        outStream?.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
    }
    @IBAction func iButton(sender: UIButton) {
        let data : NSData = "iPhone:Hello".dataUsingEncoding(NSUTF8StringEncoding)!
        outStream?.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
    }
    
    func updateData(ring:String){
        print("Data updataed")
        print(ring)
       //ThirdViewController.testing()
        
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

