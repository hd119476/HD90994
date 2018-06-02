//
//  JieGuaViewController.swift
//  HD90994
//
//  Created by Kimi on 2018/4/12.
//  Copyright © 2018年 Kimi. All rights reserved.
//

import UIKit

class JieGuaViewController: UIViewController {

    var jouYi64GuaArr = [String]() //周易64掛陣列
//    var guaTszArr = [String]() //周易64卦辭陣列
    var benYaoArr = [Int]() //本爻陣列
    var bianYaoArr = [Int]() //變爻陣列
    var yaoBian = 0 //爻變
    
    
    @IBOutlet weak var jieGuaLab: UILabel!
    @IBOutlet weak var jieGuaTszLab: UILabel!
    @IBOutlet weak var benGuaTszWebView: UIWebView! //本卦辭
    @IBOutlet weak var bianGuaTszWebView: UIWebView! //變卦辭
    @IBOutlet weak var guaView: UIView!
    @IBOutlet weak var jieGuaView: UIView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        jouYi64GuaArr = ["坤","剝","比","觀","豫","晉","萃","否",
                         "謙","艮","蹇","漸","小過","旅","咸","遯",
                         "師","蒙","坎","渙","解","未濟","困","訟",
                         "升","蠱","井","巽","恆","鼎","大過","姤",
                         "復","頤","屯","益","震","噬嗑","隨","無妄",
                         "明夷","賁","既濟","家人","豐","離","革","同人",
                         "臨","損","節","中孚","歸妹","睽","兌","履",
                         "泰","大畜","需","小畜","大壯","大有","夬","乾"]
        
        
        
        
        
        
        
        bianYaoArr = [0, 0, 0, 0, 0, 0]
//        benYaoArr = [9, 8, 9, 9, 8, 9]
        
        
        
        var benGuaStr = ""
        var bianGuaStr = ""
        
        
        let benLabel = UILabel(frame: CGRect(x: 100, y: 0, width: 150, height: 30))
        let bianLabel = UILabel(frame: CGRect(x: 300, y: 0, width: 150, height: 30))
        benLabel.text = "本掛"
        bianLabel.text = "變掛"
        benLabel.font = UIFont(name: "Helvetica-Bold", size: 28)
        bianLabel.font = UIFont(name: "Helvetica-Bold", size: 28)
        benLabel.textAlignment = NSTextAlignment.center
        bianLabel.textAlignment = NSTextAlignment.center
        guaView.addSubview(benLabel)
        guaView.addSubview(bianLabel)
        
        
         for index in 0...5 {
            if( benYaoArr[index] == 6 ){
                bianYaoArr[index] = 9
                yaoBian = yaoBian + 1
            }
            else if( benYaoArr[index] == 9 ){
                bianYaoArr[index] = 6
                yaoBian = yaoBian + 1
            }
            else {
                bianYaoArr[index] = benYaoArr[index]
            }
            benGuaStr = benGuaStr + String(benYaoArr[index]%2)
            
            let benFrame = CGRect(x: 100, y: 50 + (5-index)*40, width: 150, height: 20)
            let benCGView = CGView(frame: benFrame, yao: benYaoArr[index] )
            guaView.addSubview(benCGView)
            
            let bianFrame = CGRect(x: 300, y: 50 + (5-index)*40, width: 150, height: 20)
            let bianCGView = CGView(frame: bianFrame, yao: bianYaoArr[index] )
            guaView.addSubview(bianCGView)
            
        }
        for index in 0...5 {
            bianGuaStr = bianGuaStr + String(bianYaoArr[index]%2)   }
        
        
        
        
        
        
        jieGuaLab.text = ""
        
        let benGua = Int(benGuaStr, radix: 2)
        jieGuaLab.text = jouYi64GuaArr[benGua!]
        // 前往網址
        let benGuaUrlStr = "https://zh.wikisource.org/wiki/周易/" + jouYi64GuaArr[benGua!]
        let benGuaUrl = NSURL(string: benGuaUrlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        var bianGuaUrl = NSURL(string:"")
        
        if( yaoBian > 0 )
        {
            let bianGua = Int(bianGuaStr, radix: 2)
            jieGuaLab.text = jieGuaLab.text! + "之" + jouYi64GuaArr[bianGua!]
            
            
            let bianGuaUrlStr = "https://zh.wikisource.org/wiki/周易/" + jouYi64GuaArr[bianGua!]
            bianGuaUrl = NSURL(string: bianGuaUrlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
            
        }
        
       
        
        let bianYaoSeatArr = [["初六","六二","六三","六四","六五","上六"],["初九","九二","九三","九四","九五","上九"]]
        
        switch yaoBian
        {
            case 0  :
//                print( "0 個變爻：以本卦的卦辭、卦義來解卦。")
                benGuaTszWebView.loadRequest(URLRequest(url: benGuaUrl! as URL))
                benGuaTszWebView.isHidden = false
                bianGuaTszWebView.isHidden = true
                jieGuaTszLab.text = ":以本卦的卦辭來解卦"
            case 1  :
//                print( "1 個變爻：以本卦變爻來解卦。")
                benGuaTszWebView.loadRequest(URLRequest(url: benGuaUrl! as URL))
                benGuaTszWebView.isHidden = false
                bianGuaTszWebView.isHidden = true
                for index in 0...5 {
                    if( benYaoArr[index] != bianYaoArr[index]  )
                    {
                        jieGuaTszLab.text = ":以「" + bianYaoSeatArr[benYaoArr[index]%2][index] + "」爻辭來解卦"
                        break
                    }
                }
            case 2  :
//                print( "2 個變爻：以本卦的兩個變爻來解卦。下爻為貞（定、正），上爻為悔（動、改過）。")
                benGuaTszWebView.loadRequest(URLRequest(url: benGuaUrl! as URL))
                benGuaTszWebView.isHidden = false
                bianGuaTszWebView.isHidden = true
                var count = 2
                for index in 0...5 {
                    if( benYaoArr[index] != bianYaoArr[index]  )
                    {
                        if ( count == 2 ){
                            jieGuaTszLab.text = ":以「" + bianYaoSeatArr[benYaoArr[index]%2][index] + "」爻辭為貞, 「"
                            count = count - 1
                        }
                        else if ( count == 1 ){
                            jieGuaTszLab.text = jieGuaTszLab.text! + bianYaoSeatArr[benYaoArr[index]%2][index] + "」爻辭為悔"
                            break
                        }
                    }
                }
            case 3  :
//                print( "3 個變爻：以本卦卦辭和變卦卦辭來解卦。本卦為貞，變卦為悔。")
                benGuaTszWebView.loadRequest(URLRequest(url: benGuaUrl! as URL))
                bianGuaTszWebView.loadRequest(URLRequest(url: bianGuaUrl! as URL))
                benGuaTszWebView.isHidden = false
                bianGuaTszWebView.isHidden = false
                benGuaTszWebView.frame = CGRect(x: benGuaTszWebView.frame.origin.x , y: benGuaTszWebView.frame.origin.y, width: benGuaTszWebView.frame.width*0.5 - 10, height: benGuaTszWebView.frame.height)
                bianGuaTszWebView.frame = CGRect(x: bianGuaTszWebView.frame.origin.x + bianGuaTszWebView.frame.width*0.5 + 10 , y: bianGuaTszWebView.frame.origin.y, width: bianGuaTszWebView.frame.width*0.5 - 10, height: bianGuaTszWebView.frame.height)
                jieGuaTszLab.text = ":以本卦卦辭為貞，變卦卦辭為悔。"
            case 4  :
//                print( "4 個變爻：以變卦的兩個不變爻來解卦。上爻為貞，下爻為悔。")
                bianGuaTszWebView.loadRequest(URLRequest(url: bianGuaUrl! as URL))
                benGuaTszWebView.isHidden = true
                bianGuaTszWebView.isHidden = false
                var count = 2
                for index in 0...5 {
                    if( benYaoArr[index] == bianYaoArr[index]  )
                    {
                        if ( count == 2 ){
                            jieGuaTszLab.text = bianYaoSeatArr[benYaoArr[index]%2][index] + "」爻辭為悔"
                            count = count - 1
                        }
                        else if ( count == 1 ){
                            jieGuaTszLab.text = ":以「" + bianYaoSeatArr[benYaoArr[index]%2][index] + "」爻辭為貞, 「" + jieGuaTszLab.text!
                            break
                        }
                    }
                }
            case 5  :
//                print( "5 個變爻：以變卦的不變之爻來解卦。")
                bianGuaTszWebView.loadRequest(URLRequest(url: bianGuaUrl! as URL))
                benGuaTszWebView.isHidden = true
                bianGuaTszWebView.isHidden = false
                for index in 0...5 {
                    if( benYaoArr[index] == bianYaoArr[index]  )
                    {
                        jieGuaTszLab.text = ":以「" + bianYaoSeatArr[benYaoArr[index]%2][index] + "」爻辭來解卦"
                        break
                    }
                }
            case 6  :
//                print( "6 個變爻：乾卦以「用九」爻辭，坤卦以「用六」爻辭。其餘62卦以變卦卦辭卦義解。")
                if( benGua == 0 ) {
                    benGuaTszWebView.loadRequest(URLRequest(url: benGuaUrl! as URL))
                    benGuaTszWebView.isHidden = false
                    bianGuaTszWebView.isHidden = true
                    jieGuaTszLab.text = ":以「用六」爻辭"
                }
                else if( benGua == 63 ) {
                    benGuaTszWebView.loadRequest(URLRequest(url: benGuaUrl! as URL))
                    benGuaTszWebView.isHidden = false
                    bianGuaTszWebView.isHidden = true
                    jieGuaTszLab.text = ":以「用九」爻辭"
                }
                else {
                    bianGuaTszWebView.loadRequest(URLRequest(url: bianGuaUrl! as URL))
                    benGuaTszWebView.isHidden = true
                    bianGuaTszWebView.isHidden = false
                    jieGuaTszLab.text = ":以變卦卦辭來解卦"
                }
            default :
                print( "錯誤")
        }
        //“点击”手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(JieGuaViewController.respondsToTapGesture))
        tapGesture.numberOfTapsRequired = 1
        jieGuaLab.isUserInteractionEnabled = true
        jieGuaLab.addGestureRecognizer(tapGesture)
        
        guaView.isHidden = false
        jieGuaView.isHidden = true
        
    }
    
    //拖曳手勢
    @objc func respondsToTapGesture(sender: UITapGestureRecognizer)
    {
        if( guaView.isHidden == true ) {
            guaView.isHidden = false
            jieGuaView.isHidden = true
        }
        else{
            guaView.isHidden = true
            jieGuaView.isHidden = false
        }
    }
    
    
    @IBAction func backBut(sender: UIButton) {
//        self.navigationController!.popToRootViewController(animated: true)
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    class CGView:UIView {
        
        var isYang = true //是否為陽
        override init(frame: CGRect ) {
            super.init(frame: frame)
        }
        
        init( frame: CGRect, yao: Int){
            super.init(frame: frame)
            
            if( yao == 8 || yao == 6 ) {
                isYang = false }
            else {
                isYang = true }
            
            if( yao == 6 || yao == 9 ){
                self.backgroundColor = UIColor.red }
            else {
                self.backgroundColor = UIColor.black
            }
            
            
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func draw(_ rect: CGRect) {
            super.draw(rect)
            
            //获取绘图上下文
            guard let context = UIGraphicsGetCurrentContext() else {
                return
            }
            
            if( isYang == false )
            {
                //创建一个矩形，它的所有边都内缩3
                let drawingRect = self.bounds.insetBy(dx: 0, dy: 0)
                let width = CGFloat(drawingRect.width / 5)
                //创建并设置路径
                let path = CGMutablePath()
                path.move(to: CGPoint(x:drawingRect.width*0.5, y:0))
                path.addLine(to:CGPoint(x:drawingRect.width*0.5, y:drawingRect.maxX))
                //            path.addLine(to:CGPoint(x:drawingRect.maxX, y:drawingRect.maxY))
                
                //添加路径到图形上下文
                context.addPath(path)
                
                //设置笔触颜色
                context.setStrokeColor(UIColor.white.cgColor)
                
                //设置笔触宽度
                context.setLineWidth(width)
                
            }
            
            //绘制路径
            context.strokePath()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}





