//
//  test.swift
//  FillMyPantry
//
//  Created by NISHANTH NAGELLA on 7/19/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit
public class LoadingOverlay{
    
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    public func showOverlay(_ views : UIView) {
        if  let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let window = appDelegate.window {
            overlayView.frame = CGRect(x: 0,y: 0,width: 80,height: 80)
            overlayView.center = CGPoint(x: window.frame.width / 2.0, y: window.frame.height / 2.0)
            overlayView.backgroundColor = UIColor.gray
            overlayView.clipsToBounds = true
            overlayView.layer.cornerRadius = 10
           
            activityIndicator.frame =  CGRect(x: 0, y: 0, width: 40, height: 40)
            activityIndicator.activityIndicatorViewStyle = .whiteLarge
            activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
            
            
            overlayView.addSubview(activityIndicator)
            
            
            views.addSubview(overlayView)
            
            activityIndicator.startAnimating()
        }
    }
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}
