//
//  DisplayViewController.swift
//  GPUImage3Demo
//
//  Created by 苍蓝猛兽 on 2023/6/20.
//

import UIKit

class DisplayViewController: FliterDiaplayBaseViewController {
    
    var filterModel: FilterModel!
    var pictureInput: PictureInput!
    var filter: AnyObject!
    
    var renderView: RenderView = {
        let render = RenderView(frame: CGRect(origin: CGPoint.zero, size: CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)))
        render.fillMode = .preserveAspectRatio
        render.backgroundRenderColor = .white
        return render
    }()
    
    var slider: UISlider?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(renderView)
        self.title = filterModel.name
        self.slider = self.buildSlider(sliderPosition: CGPoint(x: 20, y: self.view.bounds.height - 70), sel: #selector(sliderValueChanged(slider: )))
        self.setupFilterChain()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        pictureInput.removeAllTargets()
        super.viewWillDisappear(animated)
    }
    
    deinit {
        print("deinit")
    }
    
    func setupFilterChain() {
        
        pictureInput = PictureInput(image: MaYuImage)
        slider?.minimumValue = filterModel.range?.0 ?? 0
        slider?.maximumValue = filterModel.range?.1 ?? 0
        slider?.value = filterModel.range?.2 ?? 0
        filter = filterModel.initCallback()
        
        switch filterModel.filterType! {
            
        case .imageGenerators:
            filter as! ImageSource --> renderView
            
        case .basicOperation:
            if let actualFilter = filter as? BasicOperation {
                pictureInput --> actualFilter --> renderView
                pictureInput.processImage()
            }
            
        case .operationGroup:
            if let actualFilter = filter as? OperationGroup {
                pictureInput --> actualFilter --> renderView
            }
            
        case .blend:
            if let actualFilter = filter as? BasicOperation {
                let blendImgae = PictureInput(image: flowerImage)
                blendImgae --> actualFilter
                pictureInput --> actualFilter --> renderView
                blendImgae.processImage()
                pictureInput.processImage()
            }
            
        case .custom:
            filterModel.customCallback!(pictureInput, filter, renderView)
        }
        
        if let _s = slider {
            self.sliderValueChanged(slider: _s)
        }
    }
    
    @objc func sliderValueChanged(slider: UISlider) {
        
        print("slider value: \(slider.value)")
        
        if let actualCallback = filterModel.valueChangedCallback {
            actualCallback(filter, slider.value)
        } else {
            slider.isHidden = true
        }
        
        if filterModel.filterType! != .imageGenerators {
            pictureInput.processImage()
        }
    }
}
