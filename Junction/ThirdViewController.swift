//
//  ThirdViewController.swift
//  Junction
//
//  Created by Isaac Robinson on 8/18/16.
//  Copyright © 2016 Isaac Robinson. All rights reserved.
//

import UIKit


protocol VCTwoDelegate {
    //func updateData(data: String)
}


class ThirdViewController: UIViewController {
    
    var selectedName: String = "Anonymous"
    var delegate2: ViewController!


    @IBAction func choiceMade(sender: AnyObject) {
    self.delegate2?.updateData("d")
        print("choice made")
    }
  

    var sympStore : [Int] = [0, 0, 0]
    
    @IBAction func b1(sender: UIButton) {
        sympStore[0]=1
    }
    @IBAction func b2(sender: UIButton) {
        sympStore[1]=1
    }
    
    @IBAction func b3(sender: UIButton) {
        
   
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
