//
//  SecondViewController.swift
//  Junction
//
//  Created by Isaac Robinson on 8/23/16.
//  Copyright © 2016 Isaac Robinson. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    let sicks: [String] = ["Food Poisoning", "Flu", "Strep Throat", "Zika", "Infection", "Hepatitis B", "Periodontal Disease", "Heart Disease", ]
    let sickKey: [Int] = [1, 2, 3, 4, 5, 6, 7, 8]
    let textCellIdentifier = "TextCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return sicks.count
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        print(sicks[row])
        shareData.sharedInstance.symptomArray[1] = sickKey[row]
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = sicks[row]
        
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
