//
//  ViewController.swift
//  socketTest
//
//  Created by Isaac Robinson on 8/15/16.
//  Copyright © 2016 Isaac Robinson. All rights reserved.
//

import UIKit
    
    class ViewController: UIViewController,UITextFieldDelegate,NSStreamDelegate {
        
        @IBOutlet weak var conButton: UIButton!
        @IBOutlet weak var theLabel: UILabel!
        @IBOutlet weak var simpleField: UITextField!
       // var value: String
        //Button
        var buttonConnect : UIButton!
        
        //Socket server
        let addr = "10.189.1.64"
        let port = 9866
        
        //Network variables
        var inStream : NSInputStream?
        var outStream: NSOutputStream?
        
        //Data received
        var buffer = [UInt8](count: 200, repeatedValue: 0)
        
        override func viewDidLoad() {
            super.viewDidLoad()
            simpleField.delegate = self
        }
        @IBAction func buttonClicked(sender: AnyObject) {
            simpleField.resignFirstResponder();
            value2 = simpleField.text!;
        }
        //Button Functions
        func btnConnectPressed(sender: UIButton) {
            NetworkEnable()
        }
        @IBAction func connectButton(sender: UIButton) {
             NetworkEnable()
        }
        
        @IBAction func iPhonePressed(sender: UIButton) {
            let data : NSData = "iPhone:Hello".dataUsingEncoding(NSUTF8StringEncoding)!
            outStream?.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
            }
        var value2 = "msg:jj"

        @IBAction func messageButton(sender: UIButton) {
            let data : NSData = value2.dataUsingEncoding(NSUTF8StringEncoding)!
            outStream?.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
            
        }
        @IBAction func quitButtonPressed(sender: UIButton) {
            let data : NSData = "Quit".dataUsingEncoding(NSUTF8StringEncoding)!
            outStream?.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
        }
      
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
                theLabel.text = "Connection stopped by server"
                conButton.enabled = true
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
                theLabel.text="Failed to connect to server"
                conButton.enabled = true
            case NSStreamEvent.HasBytesAvailable:
                print("HasBytesAvailable")
                
                if aStream == inStream {
                    inStream!.read(&buffer, maxLength: buffer.count)
                    let bufferStr = NSString(bytes: &buffer, length: buffer.count, encoding: NSUTF8StringEncoding)
                    theLabel.text = bufferStr! as String
                    print(bufferStr!)
                }
                
            case NSStreamEvent.HasSpaceAvailable:
                print("HasSpaceAvailable")
            case NSStreamEvent.None:
                print("None")
            case NSStreamEvent.OpenCompleted:
                print("OpenCompleted")
                conButton.enabled = false
                theLabel.text="Connected to server"
            default:
                print("Unknown")
            }
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
    }
    




