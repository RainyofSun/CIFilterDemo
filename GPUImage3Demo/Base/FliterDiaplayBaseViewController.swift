//
//  FliterDiaplayBaseViewController.swift
//  GPUImage3Demo
//
//  Created by 苍蓝猛兽 on 2023/6/21.
//

import UIKit

class FliterDiaplayBaseViewController: UIViewController {

    lazy var bgImageView: UIImageView = {
        return UIImageView(image: UIImage(named: "Flower.jpg"))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        self.view.addSubview(self.bgImageView)
        self.bgImageView.frame = self.view.bounds
    }

    @discardableResult
    func buildSlider(testName: String? = nil, sliderPosition: CGPoint, sel: Selector) -> UISlider {
        var _sliderP: CGPoint = sliderPosition
        var _sliderW: CGFloat = self.view.bounds.width - sliderPosition.x * 2
        if let _name = testName {
            let lab: UILabel = UILabel(frame: CGRect(origin: sliderPosition, size: CGSize(width: 80, height: 40)))
            lab.font = UIFont.systemFont(ofSize: 14)
            lab.text = _name
            self.view.addSubview(lab)
            _sliderP = CGPoint(x: sliderPosition.x + 90, y: sliderPosition.y)
            _sliderW -= 90
        }
        let slider = UISlider(frame: CGRect(origin: _sliderP, size: CGSize(width: _sliderW, height: 40)))
        slider.addTarget(self, action: sel, for: UIControl.Event.valueChanged)
        self.view.addSubview(slider)
        return slider
    }
    
    deinit {
        print("DEALLOC -------------\(NSStringFromClass(type(of: self)))")
    }
}
