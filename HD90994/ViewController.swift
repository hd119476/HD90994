//
//  ViewController.swift
//  HD90994
//
//  Created by Kimi on 2018/4/4.
//  Copyright © 2018年 Kimi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    @IBAction func FastBut(sender: UIButton) {
        
        
        var benYaoArr = [Int]() //爻陣列
        benYaoArr = [ 0, 0, 0, 0, 0, 0]
        for index in 0...5 {
            benYaoArr[index] = Int(6 + arc4random()%4)
        }
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "JieGuaViewController") as! JieGuaViewController
        vc.benYaoArr = benYaoArr
        self.present(vc, animated: true, completion: nil)
        
    }
    @IBAction func ZhouYiBut(sender: UIButton) {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "GuaViewController") as! GuaViewController
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    }


}

