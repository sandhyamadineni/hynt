//
//  ViewController.swift
//  hynt
//
//  Created by Apple on 8/1/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class HYViewController: UIViewController {
    
    @IBOutlet var carousel:iCarousel!

    var x:CGFloat = 0  , y:CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        //carousel.type = .timeMachine
        
        
        
        /*let arr = ["a" :"b", "b":"c"]
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        let docPath = path?.appendingPathComponent("docFile.png")
        let pngFile = UIImagePNGRepresentation(UIImage.init(named: "caller.png")!)
        if !FileManager.default.fileExists(atPath: (docPath?.path)!) {
            do {
                try pngFile?.write(to: docPath!)
            }
            catch {
                print("Failed to save")
            }
        }
        
        let dicPath = path?.appendingPathComponent("doc.plist")
        if !FileManager.default.fileExists(atPath: (dicPath?.path)!) {
            let dict:NSMutableDictionary = ["a":"b", "b":"c"]
            dict.write(toFile: (dicPath?.path)!, atomically: true)
        }
        
        if FileManager.default.fileExists(atPath: (dicPath?.path)!) {
            let data = NSMutableDictionary(contentsOfFile: (dicPath?.path)!)
            print(data)
        }*/
    }
    
    /*func numberOfItems(in carousel: iCarousel) -> Int {
        return 5
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        var backView: UIView
        
        //reuse view if available, otherwise create a new view
        if let view = view {
            backView = view
            //itemView.removeFromSuperview()
            //get a reference to the label in the recycled view
            label = backView.viewWithTag(1) as! UILabel
        } else {
            //don't do anything specific to the index within
            //this `if ... else` statement because the view will be
            //recycled and used with other index values later
            
            backView = UIView(frame: CGRect(x: x, y: y, width: self.view.frame.size.width-40, height: carousel.frame.size.height-20))
            backView.tag = 3
            
            
            label = UILabel.init(frame: CGRect(x: 10, y: backView.frame.size.height/2-20, width: backView.frame.size.width-20, height: backView.frame.size.height-20))
            label.backgroundColor = UIColor.clear
            label.textAlignment = .center
            label.numberOfLines = 2
            label.textColor = UIColor.blue
            label.font = UIFont(name: "OpenSans-Semibold", size: 28)
            label.tag = 1
            label.text = "Hello Text \(x)"
            
            
            backView.addSubview(label)
        }
        
        
        
        //set item label
        //remember to always set any properties of your carousel item
        //views outside of the `if (view == nil) {...}` check otherwise
        //you'll get weird issues with carousel item content appearing
        //in the wrong place in the carousel
        
        //backView.layer.borderWidth = 5.0
        backView.layer.cornerRadius = 10.0
        
        //if index == carousel.currentItemIndex {
            backView.backgroundColor = UIColor(red: 240/255.0, green: 91/255.0, blue: 125/255.0, alpha: 1)
        /*}
        else {
            backView.backgroundColor = UIColor.clear
        }*/
        
        return backView
    }
    
    func carousel(_ carousel:iCarousel, valueFor: iCarouselOption, withDefault: CGFloat) -> CGFloat {
        if  valueFor == iCarouselOption.spacing {
            print(withDefault)
            return withDefault * 1.2
        }
        return withDefault
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

