//
//  SubTableViewCell.swift
//  ExpandableTable
//
//  Created by VividMacmini7 on 21/01/17.
//  Copyright © 2017 vivid. All rights reserved.
//

import UIKit

class SubTableViewCell: UITableViewCell,UITableViewDataSource,UITableViewDelegate {

    var mainHeader = ["Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua","Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua"]
    var subHeader = ["Lorem ipsum dolor sit er elit lamet, consectetaur","Lorem ipsum dolor sit er elit lamet, consectetaur","SubThree Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliquaLorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua"]
    
    var isMainHeaderOpen:NSMutableArray!
    var tableHeight:CGFloat = 0
    @IBOutlet weak var subTableView:UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subTableView.estimatedRowHeight = 44
        subTableView.rowHeight = UITableViewAutomaticDimension
        subTableView.registerNib(UINib(nibName: "SubSubTableViewCell",bundle: nil), forCellReuseIdentifier: "SubSubTableViewCell")
       
        isMainHeaderOpen = NSMutableArray()
        for _ in 0..<mainHeader.count {
            isMainHeaderOpen.addObject(false)
        }
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDelegate(oldHeight:CGFloat) {
        subTableView.dataSource = self
        subTableView.delegate = self
        subTableView.reloadData()
        if oldHeight == tableHeight {
            return
        }
        isMainHeaderOpen = NSMutableArray()
        for _ in 0..<mainHeader.count {
            isMainHeaderOpen.addObject(false)
        }
        tableHeight = 0
        calculateVisibleHeight()
    }
    
    func calculateVisibleHeight() {
        tableHeight = 0
        for i in 0..<mainHeader.count {
            tableHeight = tableHeight + getHeight(mainHeader[i])
        }
        var i = 0
        for isOpen in isMainHeaderOpen {
            if isOpen as! Bool {
                for i in 0..<subHeader.count {
                    tableHeight = tableHeight + getHeight(subHeader[i])
                }
                break
            }
            i = i + 1
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("keyGetCalculatedHeight", object: nil, userInfo: ["height":tableHeight])
        
    }
    
    func getHeight(str:NSString) -> CGFloat {
        let labelSize = rectForText(str as String, font: UIFont.systemFontOfSize(17), maxSize: CGSizeMake((self.window?.frame.size.width)! - 16 ,999))
        return labelSize.height + 16
        
    }
    
    func rectForText(text: String, font: UIFont, maxSize: CGSize) -> CGSize {
        let attrString = NSAttributedString.init(string: text, attributes: [NSFontAttributeName:font])
        let rect = attrString.boundingRectWithSize(maxSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
        let size = CGSizeMake(rect.size.width, rect.size.height)
        return size
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return mainHeader.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let isExpand = isMainHeaderOpen[section] as! Bool
        return isExpand ? subHeader.count + 1: 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
         let cell:SubSubTableViewCell = tableView.dequeueReusableCellWithIdentifier("SubSubTableViewCell", forIndexPath: indexPath) as! SubSubTableViewCell
        if indexPath.row == 0 {
            cell.txtLabel.textColor = UIColor.blackColor()
            cell.bgView.backgroundColor = UIColor.greenColor()
            cell.txtLabel?.text = mainHeader[indexPath.row]
        }else{
            cell.txtLabel.textColor = UIColor.whiteColor()
            cell.bgView.backgroundColor = UIColor.darkGrayColor()
            cell.txtLabel?.text = subHeader[indexPath.row - 1]
        }

        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let check:Bool = isMainHeaderOpen[indexPath.section] as! Bool
        if check {
            isMainHeaderOpen.replaceObjectAtIndex(indexPath.section, withObject: false)
        }else{
            isMainHeaderOpen = NSMutableArray()
            for _ in 0..<mainHeader.count {
                isMainHeaderOpen.addObject(false)
            }
            isMainHeaderOpen.replaceObjectAtIndex(indexPath.section, withObject: true)
        }
        tableView.reloadData()
        calculateVisibleHeight()
    }
    
}

//extension String {
//    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
//        let constraintRect = CGSize(width: width, height: 250)
//        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
//        return boundingBox.height
//    }
//}

//extension String {
//    func height(with width: CGFloat, font: UIFont) -> CGFloat {
//        let maxSize = CGSize(width: width, height: 250)
//        let actualSize = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSFontAttributeName: font], context: nil)
//        return actualSize.height
//    }
//}
