//
//  GuaViewController.swift
//  HD90994
//
//  Created by Kimi on 2018/4/11.
//  Copyright © 2018年 Kimi. All rights reserved.
//

import UIKit

class GuaViewController: UIViewController {
    

    enum Step{
        case TaiJi //太極
        case SzYing //四營
        case ChengYao //成爻
        case ChengGua //成卦
    }
    enum ChengYao: Int{ //三變成爻
        case YiBian = 1 //一變
        case ErBian = 2 //二變
        case SanBian = 3 //三變
    }
    enum SzYing{ //四營
        case FenEr //分二為天地：隨機將49策分為兩半
        case GuaYi //掛一為人：取其中一半之一策，掛（夾）於手指間。
        case DieSz //揲四為四季：兩邊分別以四根四根計算其策數
        case GueiJi //歸奇：將所計算的餘數（奇）放在一起
    }
    
    enum AchilleaTag: Int{ //蓍草目前任務
        case TaiJi = 0 //太極
        case Tse = 2 //策
        case GueiJi = 1 //歸奇：將所計算的餘數（奇）放在一起
    }
    
    enum GuaYiDirection{
        case Erect //正像
        case Mirror //鏡像
        
    }
    
    var achilleaArr = [UIImageView]() //蓍草陣列
    var yaoArr = [Int]() //爻陣列
    
    
    var nowStep = Step.TaiJi
    var nowChengYao = ChengYao.YiBian.rawValue
    var nowSzYing = SzYing.FenEr
    var nowGuaYiDirection = GuaYiDirection.Erect
    var nowYao = 0 //第幾爻
    var pinchPenMidPoint = CGPoint(x: -1,y :-1) //分開中點
    let achilleaSize = CGSize(width: 5, height: 150)
    
    var pinchPenImg = UIImageView()
    var taijiIndex = -1 //太極：第一根取出的蓍草
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        yaoArr = [7, 9, 8, 9, 7, 7]
//        bianYaoArr = [0, 0, 0, 0, 0, 0]
//        print("GuaViewController:",yaoArr)
        
        pinchPenImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 2, height: 300))
        pinchPenImg.backgroundColor = UIColor.yellow
        self.view.addSubview(pinchPenImg)
        
        
        for index in 1...50 {
            let imageView = UIImageView(frame: CGRect(x: CGFloat(70+index*10), y: CGFloat(150), width: achilleaSize.width, height: achilleaSize.height))
            imageView.backgroundColor = UIColor.brown
            imageView.tag = AchilleaTag.Tse.rawValue
            //            imageView.transform = CGAffineTransform(rotationAngle: CGFloat( (CGFloat)(index) / 180.0 * CGFloat(Double.pi)))
            
            achilleaArr.append(imageView)
            self.view.addSubview(imageView)
        }
        yaoArr = [ 0, 0, 0, 0, 0, 0]
        nowStep = Step.TaiJi
        nowChengYao = ChengYao.YiBian.rawValue
        nowSzYing = SzYing.FenEr
        nowGuaYiDirection = GuaYiDirection.Erect
        nowYao = 0
        taijiIndex = -1
        
        //拖曳手勢
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(GuaViewController.respondsToPenGesture))
        self.view.addGestureRecognizer(panGesture)
        //捏合手勢
        let panPinchGesture = UIPinchGestureRecognizer(target:self , action: #selector(GuaViewController.respondsToPinchPenGesture))
        self.view.addGestureRecognizer(panPinchGesture)
    
        
    }
    
    
    //拖曳手勢
    @objc func respondsToPenGesture(sender: UIPanGestureRecognizer)
    {
        if( nowStep == Step.TaiJi )
        {
            let point = sender.location(in: self.view)
            
            
            if (sender.state == UIGestureRecognizerState.began)
            {
                for (index, imageView) in achilleaArr.enumerated()  {
                    
                    if ( point.x > imageView.frame.origin.x && point.x < imageView.frame.origin.x + imageView.frame.width
                        && point.y > imageView.frame.origin.y && point.y < imageView.frame.origin.y + imageView.frame.height )
                    {
                        imageView.tag = AchilleaTag.TaiJi.rawValue
                        taijiIndex = index
                        break
                    }
                    
                }
            }
            else if (sender.state == UIGestureRecognizerState.changed)
            {
                if( taijiIndex >= 0 )
                {
                    achilleaArr[taijiIndex].frame.origin.x = point.x + achilleaArr[taijiIndex].frame.width*0.5
                    achilleaArr[taijiIndex].frame.origin.y = point.y - achilleaArr[taijiIndex].frame.height*0.5
                    //                imageView.transform = imageView.transform.rotated(by: CGFloat(5-arc4random()%10))
                }
            }
            else if (sender.state == UIGestureRecognizerState.ended)
            {
                if( taijiIndex != -1 )
                {
                    achilleaArr[taijiIndex].frame = CGRect(x: view.center.x-achilleaArr[taijiIndex].frame.height*0.5, y: 40, width: achilleaArr[taijiIndex].frame.height, height: achilleaArr[taijiIndex].frame.width)
                    nowStep = Step.SzYing
                }
                
            }
        }
        
    }
    
    //捏合手勢
    @objc func respondsToPinchPenGesture(sender:UIPinchGestureRecognizer) {
        
        if( nowStep == Step.SzYing && nowSzYing == SzYing.FenEr )
        {
            if (sender.state == UIGestureRecognizerState.began &&  sender.numberOfTouches == 2 )
            {
                let point1 = sender.location(ofTouch: 0,in: self.view)
                let point2 = sender.location(ofTouch: 1,in: self.view)
                pinchPenMidPoint = CGPoint(x:(point1.x + point2.x)*0.5, y:(point1.y + point2.y)*0.5)
                
                pinchPenImg.frame.origin.x = pinchPenMidPoint.x
                
            }
            else if (sender.state == UIGestureRecognizerState.changed)
            {
                if( sender.scale > 1 ) //散開 scale：捏和比例
                {
                    for (index, imageView) in achilleaArr.enumerated()  {
                        if( imageView.tag == AchilleaTag.Tse.rawValue )
                        {
                            if( imageView.frame.origin.x > pinchPenMidPoint.x && imageView.frame.origin.x < self.view.frame.width - 20){
                                imageView.frame.origin.x += (CGFloat)(arc4random()%10) }
                            else if( imageView.frame.origin.x < pinchPenMidPoint.x && imageView.frame.origin.x > 20 ){
                                imageView.frame.origin.x -= (CGFloat)(arc4random()%10) }
                            
                            //                            if( imageView.frame.origin.y > pinchPenMidPoint.y ){
                            //                                imageView.frame.origin.y += (CGFloat)(arc4random()%10) }
                            //                            else {
                            //                                imageView.frame.origin.y -= (CGFloat)(arc4random()%10) }
                            
                            achilleaArr[index] = imageView
                        }
                        
                    }
                    
                }
                else //捏合
                {
                    for (index, imageView) in achilleaArr.enumerated()  {
                        if( imageView.tag == AchilleaTag.Tse.rawValue )
                        {
                            if( imageView.frame.origin.x > pinchPenMidPoint.x ){
                                imageView.frame.origin.x -= (CGFloat)(arc4random()%10) }
                            else {
                                imageView.frame.origin.x += (CGFloat)(arc4random()%10) }
                            
                            //                            if( imageView.frame.origin.y > pinchPenMidPoint.y ){
                            //                                imageView.frame.origin.y -= (CGFloat)(arc4random()%10) }
                            //                            else {
                            //                                imageView.frame.origin.y += (CGFloat)(arc4random()%10) }
                            achilleaArr[index] = imageView
                        }
                        
                    }
                }
                
                
            }
            else if (sender.state == UIGestureRecognizerState.ended)
            {
                //                print("sender:%i",sender.scale)
                if( sender.scale > 1 ) //散開 scale：捏和比例
                {
                    nowSzYing = SzYing.GuaYi
                    
                }
                else //捏合
                {
                    //                    print("sender:%i",sender.scale)
                    for (index, imageView) in achilleaArr.enumerated()  {
                        if( imageView.tag == AchilleaTag.Tse.rawValue )
                        {
                            if( imageView.frame.origin.x > pinchPenMidPoint.x ){
                                imageView.frame.origin.x += (CGFloat)(arc4random()%75) }
                            else {
                                imageView.frame.origin.x -= (CGFloat)(arc4random()%75) }
                            
                            if( imageView.frame.origin.x < 50 ) {
                                imageView.frame.origin.x = 50 + (CGFloat)(arc4random()%75)   }
                            else if( imageView.frame.origin.x > view.frame.width - 50 ) {
                                imageView.frame.origin.x = view.frame.width - 50 - (CGFloat)(arc4random()%75)   }
                            
                            achilleaArr[index] = imageView
                        }
                        
                    }
                    
                }
            }
        }
        
    }
    
    
    
    
    //    @IBOutlet weak var nextStepBut: UIButton!
    @IBAction func nextStepBut(sender: UIButton) {
        
        
        if( nowStep == Step.SzYing &&  nowSzYing == SzYing.GuaYi )
        {
            var nowLeft = 0
            var nowRight = 0
            
            for (index, imageView) in achilleaArr.enumerated()  {
                if( imageView.tag == AchilleaTag.Tse.rawValue )
                {
                    //                    imageView.frame = CGRect(x: Int(imageView.frame.origin.x), y: 10+index*8, width: 5, height: 5)
                    
                    if( imageView.frame.origin.x < pinchPenMidPoint.x ){
                        if( nowSzYing == SzYing.GuaYi && nowGuaYiDirection == GuaYiDirection.Erect )
                        {
                            nowSzYing = SzYing.DieSz
                            imageView.tag = AchilleaTag.GueiJi.rawValue
                            imageView.frame = CGRect(x: CGFloat(50 + CGFloat(nowChengYao-1)*(achilleaSize.height+50)), y: CGFloat(80), width: achilleaSize.height, height: achilleaSize.width)
                            achilleaArr[index] = imageView
                        }
                        else{
                            nowLeft = nowLeft + 1
                        }
                    }
                    else{
                        if( nowSzYing == SzYing.GuaYi && nowGuaYiDirection == GuaYiDirection.Mirror )
                        {
                            nowSzYing = SzYing.DieSz
                            imageView.tag = AchilleaTag.GueiJi.rawValue
                            imageView.frame = CGRect(x: CGFloat(50 + CGFloat(nowChengYao-1)*(achilleaSize.height+50)), y: CGFloat(80), width: achilleaSize.height, height: achilleaSize.width)
                            achilleaArr[index] = imageView
                        }
                        else{
                            nowRight = nowRight  + 1
                        }
                    }
                }
            }
            
            nowLeft = nowLeft%4
            nowRight = nowRight%4
            if( nowLeft == 0 ){
                nowLeft = 4
            }
            if( nowRight == 0 ){
                nowRight = 4
            }
            
            for (index, imageView) in achilleaArr.enumerated()  {
                if( imageView.tag == AchilleaTag.Tse.rawValue )
                {
                    if( imageView.frame.origin.x < pinchPenMidPoint.x && nowLeft > 0 )
                    {
                        nowLeft = nowLeft - 1
                        imageView.tag = AchilleaTag.GueiJi.rawValue
                        imageView.frame = CGRect(x: CGFloat(50 + CGFloat(nowChengYao-1)*(achilleaSize.height+50)), y: CGFloat(80), width: achilleaSize.height, height: achilleaSize.width)
                        achilleaArr[index] = imageView
                    }
                    else if( imageView.frame.origin.x >= pinchPenMidPoint.x && nowRight > 0 )
                    {
                        nowRight = nowRight - 1
                        imageView.tag = AchilleaTag.GueiJi.rawValue
                        imageView.frame = CGRect(x: CGFloat(50 + CGFloat(nowChengYao-1)*(achilleaSize.height+50)), y: CGFloat(80), width: achilleaSize.height, height: achilleaSize.width)
                        achilleaArr[index] = imageView
                    }
                    
                    if( nowLeft == 0 && nowRight == 0 )
                    {
                        nowSzYing = SzYing.GueiJi
                        break
                    }
                }
                
            }
            
            if( nowSzYing == SzYing.GueiJi )
            {
                if( nowChengYao == ChengYao.YiBian.rawValue )
                {
                    nowChengYao = ChengYao.ErBian.rawValue
                    nowSzYing = SzYing.FenEr
                }
                else if( nowChengYao == ChengYao.ErBian.rawValue)
                {
                    nowChengYao = ChengYao.SanBian.rawValue
                    nowSzYing = SzYing.FenEr
                }
                else if( nowChengYao == ChengYao.SanBian.rawValue)
                {
                    nowStep = Step.ChengYao
                }
            }
            var nowTse = 0
            if( nowStep == Step.ChengYao )
            {
                for (_, imageView) in achilleaArr.enumerated()  {
                    //                    print("index:%i ,tag:%i",index,imageView.tag)
                    if( imageView.tag == AchilleaTag.Tse.rawValue )
                    {
                        nowTse = nowTse + 1
                    }
                    
                }
                
                yaoArr[nowYao] = Int(nowTse/4)
                nowYao = nowYao + 1
                for (index, imageView) in achilleaArr.enumerated()  {
                    if( imageView.tag != AchilleaTag.TaiJi.rawValue )
                    {
                        imageView.tag = AchilleaTag.Tse.rawValue
                        imageView.frame = CGRect(x: CGFloat(70+index*10), y: CGFloat(150), width: achilleaSize.width, height: achilleaSize.height)
                        achilleaArr[index] = imageView
                    }
                    
                }
                nowStep = Step.SzYing
                nowChengYao = ChengYao.YiBian.rawValue
                nowSzYing = SzYing.FenEr
                pinchPenMidPoint = CGPoint(x: -1,y :-1)
                pinchPenImg.frame.origin.x = pinchPenMidPoint.x
                
                
                //                print("nowTse:",nowTse)
                //                print("yaoArr:",yaoArr)
                
                if( nowYao == 6 ) //結束
                {
                    nowStep = Step.ChengGua
//                    showGuaView()
                    //解卦
                    let sb = UIStoryboard(name:"Main", bundle: nil)
                    let vc = sb.instantiateViewController(withIdentifier: "JieGuaViewController") as! JieGuaViewController
                    vc.benYaoArr = yaoArr
                    self.present(vc, animated: true, completion: nil)
                }
                
            }
            
        }
        else if( nowStep == Step.ChengGua )
        {
            
            //解卦
            let sb = UIStoryboard(name:"Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "JieGuaViewController") as! JieGuaViewController
            vc.benYaoArr = yaoArr
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //        println("viewDidDisappear")
        yaoArr = [ 0, 0, 0, 0, 0, 0]
        nowStep = Step.TaiJi
        nowChengYao = ChengYao.YiBian.rawValue
        nowSzYing = SzYing.FenEr
        nowGuaYiDirection = GuaYiDirection.Erect
        nowYao = 0
        taijiIndex = -1
        pinchPenMidPoint = CGPoint(x: -1,y :-1) //分開中點
        pinchPenImg.frame =  CGRect(x: 0, y: 0, width: 2, height: 300)
        
        for (index, imageView) in achilleaArr.enumerated()  {
            imageView.tag = AchilleaTag.Tse.rawValue
            imageView.frame = CGRect(x: CGFloat(70+index*10), y: CGFloat(150), width: achilleaSize.width, height: achilleaSize.height)
            achilleaArr[index] = imageView
            
        }
    }
    
   
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
        
        
        
    }
}
