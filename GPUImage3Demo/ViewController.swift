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

    enum FilterType: String {
        case CIFliter = "CiFliterNameTableViewController"
        case GPUImage2 = "FilterTableViewController"
        case CIFilterCustomFilter = "CIFilterCustomFilterViewController"
        case RealTimeFilter = "RealTimeFilterViewController"
        case VividFilter = "VividFilterViewController"
        case KernalFilter = "KernalFilterViewController"
        
        static func allFilters() -> [FilterType] {
            return [.CIFliter, .GPUImage2, .CIFilterCustomFilter, .RealTimeFilter, .VividFilter, .KernalFilter]
        }
    }
    
    private lazy var filterTableView: UITableView = {
        let view = UITableView(frame: CGRectZero, style: UITableView.Style.plain)
        view.separatorStyle = .singleLine
        view.separatorColor = .white
        view.separatorInset = UIEdgeInsets(top: .zero, left: 15, bottom: .zero, right: 15)
        view.backgroundColor = .clear
        return view
    }()
    
    private let CELL_ID: String = "FILTER_CELL"
    private var filter_source: [FilterType] = FilterType.allFilters()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        self.filterTableView.frame = self.view.frame
        self.filterTableView.delegate = self
        self.filterTableView.dataSource = self
        self.filterTableView.register(UITableViewCell.self, forCellReuseIdentifier: CELL_ID)
        self.view.addSubview(self.filterTableView)
    }
}

private extension ViewController {
    func addChildViewController(childVcName: String) -> UIViewController? {
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
        guard let childVcType = childVcClass as? UIViewController.Type else {
            print("没有转换成控制器类型")
            return nil
        }
        // 4. 创建控制器实例
        let childVc = childVcType.init()
        return childVc
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filter_source.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)
        cell.textLabel?.text = filter_source[indexPath.row].rawValue
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if filter_source[indexPath.row] == FilterType.RealTimeFilter {
            let vc = RealTimeFilterViewController(nibName: "RealTimeFilterViewController", bundle: .main)
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        if let _tab = addChildViewController(childVcName: filter_source[indexPath.row].rawValue) {
            self.navigationController?.pushViewController(_tab, animated: true)
        }
    }
}

