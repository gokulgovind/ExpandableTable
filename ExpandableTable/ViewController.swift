//
//  ViewController.swift
//  ExpandableTable
//
//  Created by VividMacmini7 on 21/01/17.
//  Copyright © 2017 vivid. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var sectionHeader = ["Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.","Consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."]
    
    
    var isSectionHeaderOpen:NSMutableArray!
    var receivedheight:CGFloat!
    
    @IBOutlet weak var tableView:UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isSectionHeaderOpen = NSMutableArray()
        for _ in 0..<sectionHeader.count {
            isSectionHeaderOpen.addObject(false)
        }
        
        receivedheight = 44
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(receiveNotification(_:)), name: "keyGetCalculatedHeight", object: nil)
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.registerNib(UINib(nibName: "MainTableViewCell",bundle: nil), forCellReuseIdentifier: "MainTableViewCell")
        tableView.registerNib(UINib(nibName: "SubTableViewCell",bundle: nil), forCellReuseIdentifier: "SubTableViewCell")
        tableView.dataSource = self;
        tableView.delegate = self;
//        getHeight()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func receiveNotification(notification: NSNotification){
        let userInfo = notification.userInfo
        receivedheight = userInfo!["height"] as! CGFloat
        print("Main: \(receivedheight)")
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionHeader.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let isExpand = isSectionHeaderOpen[section] as! Bool
        return isExpand ? 2 : 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell:MainTableViewCell = tableView.dequeueReusableCellWithIdentifier("MainTableViewCell", forIndexPath: indexPath) as! MainTableViewCell
            cell.textLbl?.text = sectionHeader[indexPath.row]
            return cell
        }else{
            let cell:SubTableViewCell = tableView.dequeueReusableCellWithIdentifier("SubTableViewCell", forIndexPath: indexPath) as! SubTableViewCell
            cell.setDelegate(receivedheight)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let check:Bool = isSectionHeaderOpen[indexPath.section] as! Bool
        if check {
            isSectionHeaderOpen.replaceObjectAtIndex(indexPath.section, withObject: false)
        }else{
            isSectionHeaderOpen = NSMutableArray()
            for _ in 0..<sectionHeader.count {
                isSectionHeaderOpen.addObject(false)
            }
            isSectionHeaderOpen.replaceObjectAtIndex(indexPath.section, withObject: true)
        }
        
        print(isSectionHeaderOpen)
        receivedheight = 44
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return UITableViewAutomaticDimension
        }
        return receivedheight
    }

}

