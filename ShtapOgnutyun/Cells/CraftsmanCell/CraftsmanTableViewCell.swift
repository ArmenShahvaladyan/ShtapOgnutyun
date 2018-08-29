//
//  CraftsmanTableViewCell.swift
//  ShtapOgnutyun
//
//  Created by Gohar on 16/04/2018.
//  Copyright © 2018 Gohar. All rights reserved.
//

import UIKit

class CraftsmanTableViewCell: BaseTableViewCell {
    
    // MARK: IBOutlets
    @IBOutlet private weak var cmContentView: UIView?
    @IBOutlet private weak var barView: UIView?
    @IBOutlet private weak var craftsManImageView: UIImageView?
    @IBOutlet private weak var expandButton: UIButton?
    @IBOutlet private weak var nameLabel: UILabel?
    @IBOutlet private weak var starsImageView: UIImageView?
    @IBOutlet private weak var ratesView: FloatRatingView!
    @IBOutlet weak var rateLabel: UILabel?
    
    // MARK: Variables
    var onOpenCell: ((UIButton) -> Void)?
    private var frameWidth = 0
    private var onePart = 0.0
    var master: Master?
    
    var cellSelected: Bool = false {
        didSet {
            if cellSelected {
                UIView.animate(withDuration: 0.35) {
                    self.expandButton?.transform = CGAffineTransform(rotationAngle: 2 * -CGFloat.pi / 2.0)

                }
                appearView(animated: true)
            } else {
                disappearView(animated: true)
                UIView.animate(withDuration: 0.35) {
                    self.expandButton?.transform = CGAffineTransform.identity
                }
            }
        }
    }
    
    //MARK: Lifecycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        cmContentView?.layer.cornerRadius = 5.0
        self.contentView.backgroundColor = UIColor.clear
        barView?.isHidden = true
        starsImageView?.isHidden = true
        let a = UITapGestureRecognizer.init(target: self, action: #selector(drawChart))
        ratesView.addGestureRecognizer(a)
        //        if UIDevice.isIpad(){
        //            frameWidth = (Int((self.barView?.frame.width)!))
        //            onePart = Double(frameWidth) / Double(100)
        //        } else {
        //            frameWidth = (Int(((self.barView?.frame.width))!) - Int((starsImageView?.frame.width)!) - Int((expandButton?.frame.width)!) - 30)
        //            onePart = Double(frameWidth) / Double(100)
        //       // }
        //        createBars()
    }
    
    override func draw(_ rect: CGRect) {
        drawChart()
    }
    
    override func prepareForReuse() {
        barView?.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
    
    func fillWith(master m: Master) {
        self.startLoading()
        self.nameLabel?.text = m.name?.value
        self.selectionStyle = .none
        self.ratesView.rating = m.rate
        self.rateLabel?.text = String(m.rate)
        self.craftsManImageView?.image = #imageLiteral(resourceName: "master_default")
        
        if let data = m.imageData {
            self.craftsManImageView?.image = UIImage(data: data)
            self.stopLoading()
        }
    }
    
    @objc func drawChart() {
        frameWidth = (Int((self.barView?.frame.width)!) - Int((expandButton?.frame.width)!) - 10)
        onePart = Double(frameWidth) / Double(100)
        createBars()
    }
    
    private func createBars() {
        if let chartRate = master?.chartRate {
            if let cost = Double((chartRate.maxRate)) {
                if let excelent = master?.chartRate?.excellent as NSString? {
                    if excelent != "0" {
                        self.drawlines(lineNumber: 1, percent: Double(excelent.doubleValue * 100 / cost), linename: "Bar1", color: UIColor.soBarColor_1, rate: (master?.chartRate?.excellent)!)
                    } else {
                        if UIDevice.isIpad() {
                            self.drawlines(lineNumber: 1, percent: 3, linename: "Bar1", color: UIColor.soBarColor_1, rate: (master?.chartRate?.excellent)!)
                        } else {
                            self.drawlines(lineNumber: 1, percent: 5, linename: "Bar1", color: UIColor.soBarColor_1, rate: (master?.chartRate?.excellent)!)
                        }
                    }
                }
                if let good = master?.chartRate?.good as NSString? {
                    if good != "0" {
                        self.drawlines(lineNumber: 2, percent: Double(good.doubleValue * 100 / cost), linename: "Bar2", color: UIColor.soBarColor_2, rate: (master?.chartRate?.good)!)
                    } else {
                        if UIDevice.isIpad() {
                            self.drawlines(lineNumber: 2, percent: 3, linename: "Bar2", color: UIColor.soBarColor_2, rate: (master?.chartRate?.good)!)
                        } else {
                            self.drawlines(lineNumber: 2, percent: 5, linename: "Bar2", color: UIColor.soBarColor_2, rate: (master?.chartRate?.good)!)
                        }
                    }
                }
                if let average = master?.chartRate?.average as NSString? {
                    if average != "0" {
                        self.drawlines(lineNumber: 3, percent: Double(average.doubleValue * 100 / cost), linename: "Bar3", color: UIColor.soBarColor_3, rate: (master?.chartRate?.average)!)
                    } else {
                        if UIDevice.isIpad() {
                            self.drawlines(lineNumber: 3, percent: 3, linename: "Bar3", color: UIColor.soBarColor_3, rate: (master?.chartRate?.average)!)
                        } else {
                            self.drawlines(lineNumber: 3, percent: 5, linename: "Bar3", color: UIColor.soBarColor_3, rate: (master?.chartRate?.average)!)
                        }
                    }
                }
                // bellowAverage
                if let bellowAverage = master?.chartRate?.bellowAverage as NSString? {
                    if bellowAverage != "0" {
                        self.drawlines(lineNumber: 4, percent: Double(bellowAverage.doubleValue * 100 / cost), linename: "Bar4", color: UIColor.soBarColor_4, rate: (master?.chartRate?.bellowAverage)!)
                    } else {
                        if UIDevice.isIpad() {
                            self.drawlines(lineNumber: 4, percent: 3, linename: "Bar4", color: UIColor.soBarColor_4, rate: (master?.chartRate?.bellowAverage)!)
                        } else {
                            self.drawlines(lineNumber: 4, percent: 5, linename: "Bar4", color: UIColor.soBarColor_4, rate: (master?.chartRate?.bellowAverage)!)
                        }
                    }
                }
                // poor
                if let poor = master?.chartRate?.poor as NSString? {
                    if poor != "0" {
                        self.drawlines(lineNumber: 5, percent: Double(poor.doubleValue * 100 / cost), linename: "Bar5", color: UIColor.soBarColor_5, rate: (master?.chartRate?.poor)!)
                    } else {
                        if UIDevice.isIpad() {
                            self.drawlines(lineNumber: 5, percent: 3, linename: "Bar5", color: UIColor.soBarColor_5, rate: (master?.chartRate?.poor)!)
                        } else {
                            self.drawlines(lineNumber: 5, percent: 5, linename: "Bar5", color: UIColor.soBarColor_5, rate: (master?.chartRate?.poor)!)
                        }
                    }
                }
            }
            
        }
        
    }
    
    func appearView(animated anim: Bool) {
        if anim {
            self.barView?.alpha = 0
            self.starsImageView?.alpha = 0
            self.barView?.isHidden = false
            self.starsImageView?.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.barView?.alpha = 1
                self.starsImageView?.alpha = 1
            }, completion: {
                finished in
                self.barView?.isHidden = false
                self.starsImageView?.isHidden = false
            })
        } else {
            self.barView?.alpha = 1
            self.starsImageView?.alpha = 1
            self.barView?.isHidden = false
            self.starsImageView?.isHidden = false
        }
    }
    
     func disappearView(animated anim: Bool) {
        if anim {
            UIView.animate(withDuration: 0.2, animations: {
                self.barView?.alpha = 0
                self.starsImageView?.alpha = 0
            }, completion: {
                finished in
                self.barView?.isHidden = true
                self.starsImageView?.isHidden = true
            })
        } else {
            self.barView?.alpha = 0
            self.starsImageView?.alpha = 0
            self.barView?.isHidden = true
            self.starsImageView?.isHidden = true
        }
    }
    
    // MARK: Horizontal Bar
    private func drawlines (lineNumber num:Int , percent val:Double, linename name: String, color:UIColor, rate: String) {
        
        let startpoint = 0
        let distance = 20
        let start = CGPoint(x: 5,y: Int(num * distance) + startpoint)
        let end = CGPoint(x: Int(val * onePart),y: Int(num * distance) + startpoint)
        
        
        //white part of line
        //        let nextpt = Int(Double(100 - val) * onePart) + Int(val * onePart)
        //        let nstart = CGPoint(x: Int(val * onePart),y: Int(num * distance) + startpoint)
        //        let nend = CGPoint(x: nextpt,y: Int(num * distance) + startpoint)
        //
        //        let ratePosition = findTheDifference(location: nstart)
        //        let rateXPosition = findTheDifference(location: nend)
        
        //orange part of line
        drawLine(startpoint: start, endpint: end,linecolor: color.cgColor,linewidth: 5.0, rate: rate, xPosition: end.x + 5, yPosition: start.y - 7)
        
        //  drawLine(startpoint: nstart, endpint: nend, linecolor: UIColor.red.cgColor,linewidth: 8.0, rate: "",xPosition: CGFloat(nextpt), yPosition: nstart.y - 10.0 )
    }
    
    private func drawLine(startpoint start:CGPoint, endpint end:CGPoint, linecolor color:CGColor , linewidth widthline:CGFloat, rate: String, xPosition: CGFloat, yPosition: CGFloat) {
        
        let width = distance(start, end)
        let size = CGSize.init(width: width, height: widthline)
        
        let rect = CGRect.init(origin: start, size: size)
        
        let path = UIBezierPath.init(roundedRect: rect, cornerRadius: 5.0)
        
        path.move(to: start)
        path.addLine(to: end)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = widthline
        //shapeLayer.masksToBounds = true
        // shapeLayer.contents = createTextLayer(rate: "22")
        
        //
        //
        //        let cornerRadius: CGFloat = 8
        //        let maskLayer = CAShapeLayer()
        //
        //        shapeLayer.path = UIBezierPath(
        //            roundedRect: shapeLayer.bounds,
        //            byRoundingCorners: [.bottomLeft, .bottomRight],
        //            cornerRadii: CGSize(width: 10.0, height: 10.0)
        //            ).cgPath
        //
        //        barView?.layer.mask = shapeLayer
        
        barView?.layer.cornerRadius = 15
        barView?.layer.masksToBounds = true
        barView?.layer.addSublayer(shapeLayer)
        barView?.layer.addSublayer(createTextLayer(rate: rate,x: xPosition, y: yPosition))
    }
    
    private func findTheDifference(location: CGPoint) -> Double {
        return Double(location.y - location.x)
    }
    
    private func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
    
    private func createTextLayer(rate: String, x: CGFloat, y: CGFloat) -> CATextLayer {
        
        let textLayer = CATextLayer()
        textLayer.string = rate
        //rate.count
        textLayer.foregroundColor = UIColor.soOrangeColor.cgColor
        textLayer.font = UIFont(name: "Avenir", size: 15.0)
        textLayer.fontSize = 14.0
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.frame = CGRect(x: x, y: y, width: 20.0, height: 20.0)
        textLayer.contentsScale = UIScreen.main.scale
        
        return textLayer
    }
    
    
    @IBAction func showBars(_ sender: UIButton) {
        if onOpenCell != nil {
            onOpenCell!(sender)
        }
    }
}
