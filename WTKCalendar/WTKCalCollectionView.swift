//
//  WTKCalCollectionView.swift
//  WTKCalendar
//
//  Created by 王同科 on 16/8/11.
//  Copyright © 2016年 王同科. All rights reserved.
//

import UIKit

class WTKCalCollectionView: UICollectionView,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    var dataArray       = NSMutableArray()
    var headTitle       = ""
    var currentDate     = NSDate.init()
    var clickPage       : ((dateString : String) -> Void)!
    
    
   override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.backgroundColor    = UIColor.whiteColor()
        self.refreshDataWithDate(NSDate.init())
        self.configView()
    
    
    }
    
    func configView(){
        self.dataSource     = self
        self.delegate       = self
        self.registerNib(UINib.init(nibName: "wtkCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        self.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header1")
        self.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header2")
    }
    
    func refreshDataWithDate(date:NSDate){
        
        dataArray.removeAllObjects()
        let totalDays = self.getTotalDaysInMonth(date)
        for i in 1...totalDays
        {
            dataArray.addObject("\(i)")
        }
        
        let firstDays = self.getWeek(date)
        for _ in 0..<firstDays
        {
            dataArray.insertObject("-", atIndex: 0)
        }
        
        if firstDays < 5
        {
            for _ in 0..<(35 - firstDays - totalDays)
            {
                dataArray.addObject("-")
            }
        }
        else
        {
            for _ in 1...(42 - firstDays - totalDays)
            {
                dataArray.addObject("-")
            }
        }
     
        
        self.reloadData()
        
    }
    
    func btnClick(btn:UIButton)
    {
        if btn.tag == 111
        {
            let timeInterval : Double   = 24 * 60 * 60 * 30
            
            let date    = NSDate.init(timeIntervalSince1970: currentDate.timeIntervalSince1970 - timeInterval)
            
            currentDate = date
            self.refreshDataWithDate(currentDate)
        }
        else
        {
            let timeInterval : Double   = 24 * 60 * 60 * 30
            
            let date    = NSDate.init(timeIntervalSince1970: currentDate.timeIntervalSince1970 + timeInterval)
            
            currentDate = date
            self.refreshDataWithDate(currentDate)
        }
    }
    
//    MARK: - Delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        if self.dataArray[indexPath.row] as! String == "-" {
            return
        }
        if self.clickPage != nil
        {
            let date = "\(self.getMonthWithDate(currentDate))-\(self.dataArray[indexPath.row] as! String)"
            self.clickPage(dateString:date)
        }
    }
    
//    MARK: - delegate dataSource
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! wtkCollectionViewCell
        cell.wtkLabel.text = dataArray[indexPath.row] as? String
        if self.getMonthWithDate(currentDate) == self.getMonthWithDate(NSDate.init())
        {
            if cell.wtkLabel.text == self.getDay(NSDate.init()) || "0\(cell.wtkLabel.text)" == self.getDay(NSDate.init())
            {
                cell.wtkLabel.textColor       = UIColor.redColor()
            }
            else
            {
                cell.wtkLabel.textColor       = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
            }
        }
        else
        {
            cell.wtkLabel.textColor       = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
    {
        
        if indexPath.section == 0
        {
          let  header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "header1", forIndexPath: indexPath)
            if header.viewWithTag(100) == nil
            {
                let label               = UILabel.init(frame: CGRectMake((self.frame.width - 150) / 2, 0, 150, 53))
                label.textAlignment     = NSTextAlignment.Center
                label.font              = UIFont.systemFontOfSize(14)
                label.text              = self.getMonthWithDate(currentDate)
                label.textColor         = UIColor.init(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
                label.tag               = 100
                header.addSubview(label)
                
                
                let left                = UIButton.init(type: UIButtonType.Custom)
                left.frame              = CGRectMake(0, 0, 130, 53)
                left.titleLabel?.textAlignment  = NSTextAlignment.Right
                left.titleLabel?.font   = UIFont.systemFontOfSize(20)
                left.setTitle("<", forState: UIControlState.Normal)
                left.setTitleColor(UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1), forState: UIControlState.Normal)
                left.tag                = 111
                left.addTarget(self, action: #selector(WTKCalCollectionView.btnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                header.addSubview(left)
                
                let right               = UIButton.init(type: UIButtonType.Custom)
                right.frame             = CGRectMake(self.frame.width - 130, 0, 130, 53)
                right.titleLabel?.textAlignment  = NSTextAlignment.Left
                right.titleLabel?.font  = UIFont.systemFontOfSize(20)
                right.setTitleColor(UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1), forState: UIControlState.Normal)
                right.setTitle(">", forState: UIControlState.Normal)
                right.tag               = 222
                right.addTarget(self, action: #selector(WTKCalCollectionView.btnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                header.addSubview(right)
                
            }
            else
            {
                let label : UILabel = header.viewWithTag(100) as! UILabel
                label.text  = self.getMonthWithDate(currentDate)
            }
            
            return header
        }
        if indexPath.section == 1
        {
           let  header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "header2", forIndexPath: indexPath)
            if header.viewWithTag(101) == nil
            {
                let array           = ["日","一","二","三","四","五","六"]
                let width       = self.frame.width / 7.0
                for i in 0...6
                {
                    
                    let label       = UILabel.init(frame: CGRectMake(CGFloat(i) * width, 0, width, width))
                    label.text      = array[i]
                    label.textColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
                    label.font      = UIFont.systemFontOfSize(16)
                    label.textAlignment = NSTextAlignment.Center
                    header.addSubview(label)
                }
                let line            = UIView.init(frame: CGRectMake(0, width - 0.5, self.frame.width, 0.5))
                line.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
                line.tag            = 101
                header.addSubview(line)
            }
            return header
        }
        
        return UICollectionReusableView.init()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0
        {
            return 0
        }
        return dataArray.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 2
    }
    
    
//    MARK: - LAYOUT
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSizeMake(self.frame.width / 7.0, self.frame.width / 7.0)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        if section == 0 {
            return CGSizeMake(self.frame.width, 53)
        }
        return CGSizeMake(self.frame.width, self.frame.width / 7.0)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
    {
        return CGSizeZero
    }
    
//    MARK: - date
//    本月第一天是周几
    func getWeek(date:NSDate) ->Int
    {
     
        let calendar            = NSCalendar.currentCalendar()
        calendar.firstWeekday   = 1
        
        let aaa                 = NSCalendarUnit(rawValue:NSCalendarUnit.Year.rawValue | NSCalendarUnit.Month.rawValue | NSCalendarUnit.Day.rawValue)
    
        let comp                =  calendar.components(aaa, fromDate: date)

        comp.day                = 1
        
        let firstDayOfMonthDate = calendar.dateFromComponents(comp)
        
        let firstWeekDay        = calendar.ordinalityOfUnit(NSCalendarUnit.Weekday, inUnit: NSCalendarUnit.WeekOfMonth, forDate: firstDayOfMonthDate!)
        
        return firstWeekDay - 1
    }
    
//    获取本月的天数
    func getTotalDaysInMonth(date:NSDate) -> Int
    {
        let daysRange   = NSCalendar.currentCalendar().rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: date)
        
        return daysRange.length
    }
    
//    获取月份
    func getMonthWithDate(date:NSDate) -> String
    {
        
        let dateFormatter   = NSDateFormatter.init()
        
        dateFormatter.dateFormat = "YYYY-MM"
        
        
        return dateFormatter.stringFromDate(date)
    }

//    获取哪一天
    func getDay(date:NSDate) ->String
    {
        let dateFormatter   = NSDateFormatter.init()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.stringFromDate(date)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
