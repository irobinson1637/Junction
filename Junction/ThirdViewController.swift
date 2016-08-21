//
//  ThirdViewController.swift
//  Junction
//
//  Created by Isaac Robinson on 8/18/16.
//  Copyright © 2016 Isaac Robinson. All rights reserved.
//

import UIKit




class ThirdViewController: UIViewController {
    
    var selectedName: String = "Anonymous"
    let delegate = ViewController()

    @IBOutlet weak var b1: UIButton!

    @IBOutlet weak var b2: UIButton!
    
    @IBOutlet weak var b3: UIButton!
    
    @IBOutlet weak var b4: UIButton!
    
    @IBOutlet weak var b5: UIButton!
    
    @IBOutlet weak var b6: UIButton!
    
    @IBOutlet weak var b7: UIButton!
    
    @IBOutlet weak var b8: UIButton!
    
    
    
    
    
    @IBAction func choiceMade(sender: AnyObject) {
        shareData.sharedInstance.symptomArray  = sympStore
     delegate.updateData("reeeee")
        print("choice made")
    }
    
    static func testing(){
        print("hekko")
    }
    


    var sympStore : [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    
    @IBAction func b1(sender: UIButton) {
        sympStore[0]=1
        b1.enabled = false
    }
    @IBAction func b2(sender: UIButton) {
        sympStore[1]=1
        b2.enabled = false
    }
    @IBAction func b3(sender: UIButton) {
        sympStore[2]=1
        b3.enabled = false
    }
    @IBAction func b4(sender: UIButton) {
        sympStore[3]=1
        b4.enabled = false
    }
    @IBAction func b5(sender: UIButton) {
        sympStore[4]=1
        b5.enabled = false
    }
    @IBAction func b6(sender: UIButton) {
         sympStore[5]=1
        b6.enabled = false
    }
    @IBAction func b7(sender: UIButton) {
         sympStore[6]=1
        b7.enabled = false
    }
    @IBAction func b8(sender: UIButton) {
         sympStore[7]=1
        b8.enabled = false
    }
    

    
   
    
    
    
    
    
    
    
/*
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }*/
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
