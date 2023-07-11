//
//  FliterBaseNavViewController.swift
//  GPUImage3Demo
//
//  Created by 苍蓝猛兽 on 2023/6/21.
//

import UIKit

class FliterBaseNavViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        let attrs = [NSAttributedString.Key.foregroundColor: UIColor.black,
                     NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
        UINavigationBar.appearance().titleTextAttributes = attrs
        self.delegate = self
        self.interactivePopGestureRecognizer?.isEnabled = false
    }

}

/// 遵循这个协议，可以隐藏导航栏
protocol HideNavigationBarProtocol where Self: UIViewController {}

extension FliterBaseNavViewController: UINavigationControllerDelegate {
    //导航控制器将要显示控制器时调用
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if (viewController is HideNavigationBarProtocol){
            self.setNavigationBarHidden(true, animated: true)
        }else {
            self.setNavigationBarHidden(false, animated: true)
        }
    }
}
