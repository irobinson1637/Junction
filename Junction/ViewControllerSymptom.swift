//
//  ViewControllerSymptom.swift
//  Junction
//
//  Created by Isaac Robinson on 8/25/16.
//  Copyright © 2016 Isaac Robinson. All rights reserved.
//

import UIKit

class ViewControllerSymptom: UIViewController,UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var selectedLabel: UILabel!
    @IBOutlet weak var symptomTable: UITableView!
    let sicks: [String] = ["Cough", "Runny Nose", "Fever", "Aches", "Headache", "Bleeding Gums", "Shortness of breadth", "Arm pain", ]
    let sickKey: [Int] = [3, 4, 5, 6, 7, 8, 9, 10]
    let textCellIdentifier = "proCell"
    var prevRow = 0
    var selectedArray:String = " "
    override func viewDidLoad() {
        super.viewDidLoad()
        symptomTable.delegate = self
        symptomTable.dataSource = self
        
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
        print("It's lit fam")
        shareData.sharedInstance.symptomArray[row] = 1
        prevRow = row
        print(shareData.sharedInstance.symptomArray)
        selectedArray+=", "+sicks[row]
        selectedLabel.text = selectedArray
        
    }
    
    @IBAction func undoButton(sender: UIButton) {
        shareData.sharedInstance.symptomArray[prevRow] = 0
        let tempStringRemove = sicks[prevRow]
        selectedArray = selectedArray.stringByReplacingOccurrencesOfString(tempStringRemove, withString: "")
        print(shareData.sharedInstance.symptomArray)
        selectedLabel.text = selectedArray
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
    

}
