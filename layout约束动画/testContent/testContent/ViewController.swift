//
//  ViewController.swift
//  testContent
//
//  Created by Lff on 16/12/2.
//  Copyright © 2016年 Lff. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    ///容器
    @IBOutlet weak var contentView: UIView!
    
    ///容器高 Constraint约束
    @IBOutlet weak var contenHeightCons: NSLayoutConstraint!
    
    ///冲击波
    @IBOutlet weak var scanView: UIImageView!

    //高的 Constraint约束
    @IBOutlet weak var scanlineCons: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.scanlineCons.constant = -300
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.scanlineCons.constant = 300
        UIView.animate(withDuration: 1.0) {
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.view.layoutIfNeeded()
        }
    }


}

