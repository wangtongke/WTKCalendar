//
//  ViewController.swift
//  WTKCalendar
//
//  Created by 王同科 on 16/8/11.
//  Copyright © 2016年 王同科. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let kWIDTH = UIScreen.mainScreen().bounds.width
    let kHEIGHT = UIScreen.mainScreen().bounds.height
    var collectionView  : WTKCalCollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let layout  = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        
        collectionView  = WTKCalCollectionView.init(frame: CGRectMake(0, 60, kWIDTH, kHEIGHT), collectionViewLayout: layout)
        self.view.addSubview(collectionView)
        
        collectionView.clickPage = {
            (dateString:String) ->Void in
            print(dateString)
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

