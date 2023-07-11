//
//  ViewController.swift
//  GPUImage3Demo
//
//  Created by 苍蓝猛兽 on 2023/6/20.
//
/*
 请先阅读 README
 */
import UIKit

class ViewController: UIViewController, HideNavigationBarProtocol {

    enum FliterType: String {
        case CIFliter = "CiFliterNameTableViewController"
        case GPUImage2 = "FilterTableViewController"
    }
    
    private lazy var gpuImageBtn: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setTitle("GPUImage2编辑", for: UIControl.State.normal)
        btn.setTitle("GPUImage2编辑", for: UIControl.State.highlighted)
        return btn
    }()
    
    private lazy var ciFliterBtn: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setTitle("CIFliter编辑", for: UIControl.State.normal)
        btn.setTitle("CIFliter编辑", for: UIControl.State.highlighted)
        return btn
    }()
    
    private var _fliter_type: FliterType = .CIFliter
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.gpuImageBtn.frame = CGRect(origin: CGPoint(x: 100, y: 100), size: CGSize(width: 200, height: 60))
        self.ciFliterBtn.frame = CGRect(origin: CGPoint(x: 100, y: 170), size: CGSize(width: 200, height: 60))
        self.view.backgroundColor = .black
        self.gpuImageBtn.addTarget(self, action: #selector(clickEditImage(sender: )), for: UIControl.Event.touchUpInside)
        self.ciFliterBtn.addTarget(self, action: #selector(clickEditImage(sender: )), for: UIControl.Event.touchUpInside)
        
        self.view.addSubview(self.gpuImageBtn)
        self.view.addSubview(self.ciFliterBtn)
    }
    
    @objc func clickEditImage(sender: UIButton) {
        if let _tab = addChildViewController(childVcName: _fliter_type.rawValue) {
            self.navigationController?.pushViewController(_tab, animated: true)
        }
    }
    
    private func addChildViewController(childVcName: String) -> UITableViewController? {
        // 1. 获取去命名空间,由于项目肯定有info.plist文件所有可以机型强制解包.
        guard let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            print("没有获取到命名空间")
            return nil
        }
        // 2. 根据类名获取对应的类
        print("\(nameSpace).\(childVcName)")
        guard let childVcClass = NSClassFromString("\(nameSpace).\(childVcName)") else {
            print("没有获取到对应的类")
            return nil
        }
        // 3. 将AnyObject转换成控制器类型
        guard let childVcType = childVcClass as? UITableViewController.Type else {
            print("没有转换成控制器类型")
            return nil
        }
        // 4. 创建控制器实例
        let childVc = childVcType.init()
        return childVc
    }
}

