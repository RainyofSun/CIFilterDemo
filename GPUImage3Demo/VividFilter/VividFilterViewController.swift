//
//  VividFilterViewController.swift
//  GPUImage3Demo
//
//  Created by 苍蓝猛兽 on 2023/7/19.
//

import UIKit

class VividFilterViewController: CIFilterCustomFilterViewController {
    
    enum VividFilterType: String {
        /// 双边滤波
        case YUCIBilateralFilter = "YUCIBilateralFilter"
        /// 斑点生成器
        case YUCIBlobsGenerator = "YUCIBlobsGenerator"
        case YUCICLAHE = "YUCICLAHE"
        /// 颜色查找
        case YUCIColorLookup = "YUCIColorLookup"
        case YUCICrossZoomTransition = "YUCICrossZoomTransition"
        case YUCIFilmBurnTransition = "YUCIFilmBurnTransition"
        case YUCIFlashTransition = "YUCIFlashTransition"
        case YUCIFXAA = "YUCIFXAA"
        case YUCIHistogramEqualization = "YUCIHistogramEqualization"
        case YUCIReflectedTile = "YUCIReflectedTile"
        case YUCIRGBToneCurve = "YUCIRGBToneCurve"
        case YUCISkyGenerator = "YUCISkyGenerator"
        case YUCIStarfieldGenerator = "YUCIStarfieldGenerator"
        case YUCISurfaceBlur = "YUCISurfaceBlur"
        case YUCITriangularPixellate = "YUCITriangularPixellate"
        case CausticNoise = "Caustic Noise"
        case CausticRefraction = "Caustic Refraction"
        
        static func allVividFilters() -> [String] {
            return [self.YUCIBilateralFilter.rawValue, self.YUCIBlobsGenerator.rawValue, self.YUCICLAHE.rawValue, self.YUCIColorLookup.rawValue,
                    self.YUCICrossZoomTransition.rawValue, self.YUCIFilmBurnTransition.rawValue, self.YUCIFlashTransition.rawValue,
                    self.YUCIFXAA.rawValue, self.YUCIHistogramEqualization.rawValue,self.YUCIReflectedTile.rawValue,
                    self.YUCIRGBToneCurve.rawValue,self.YUCISkyGenerator.rawValue, self.YUCIStarfieldGenerator.rawValue, self.YUCISurfaceBlur.rawValue,
                    self.YUCITriangularPixellate.rawValue, self.CausticNoise.rawValue, self.CausticRefraction.rawValue]
        }
    }
    
    private let context = CIContext(options: [CIContextOption.workingColorSpace: CGColorSpace(name: CGColorSpace.sRGB)!])
    private var _vivid_filter: CIFilter?
    private var _input_filter_img: CIImage?
    private var linkTimer: CADisplayLink?
    private var time: Float = 0.0
    private var STEP_TIME: Float = 0.01
    private var MAX_TIME: Float = MAXFLOAT
    
    override func viewDidLoad() {
        _data_source = VividFilterType.allVividFilters()
        // 注册所有的自定义滤镜
        CustomFiltersVendor.registerFilters()
        super.viewDidLoad()
        self.beforImgView.image = UIImage(named: "sample.jpg")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if linkTimer != nil {
            linkTimer?.invalidate()
            linkTimer = nil
        }
    }
    
    override func didSelectedFilter(indexPath: IndexPath) {
        guard let _img = self.beforImgView.image?.cgImage else {
            return
        }
        time = .zero
        linkTimer?.invalidate()
        linkTimer = nil
        self._input_filter_img = CIImage(cgImage: _img)
        let _filter_name = _data_source[indexPath.row]
        let _type = VividFilterType(rawValue: _filter_name)
        switch _type {
        case.YUCIBilateralFilter:
            if let _filter: CIFilter = CIFilter(name: _filter_name, parameters: ["inputRadius": 20, "inputDistanceNormalizationFactor": 6.0, "inputTexelSpacingMultiplier": 1.0]) {
                _vivid_filter = _filter
            }
        case .YUCIBlobsGenerator:
            if let _filter: CIFilter = CIFilter(name: _filter_name, parameters: ["inputExtent": CIVector(cgRect: CGRect(origin: CGPointZero, size: CGSize(width: 1200, height: 800))), "inputTime": 10.0]) {
                _vivid_filter = _filter
                linkTimer = CADisplayLink(target: self, selector: #selector(stepTime))
                linkTimer?.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
            }
        case .YUCICLAHE:
            if let _filter: CIFilter = CIFilter(name: _filter_name, parameters: ["inputClipLimit": 2.0, "inputTileGridSize": CIVector(x: 10, y: 10)]) {
                _vivid_filter = _filter
            }
        case .YUCIColorLookup:
            if let _tableImg = CIImage(contentsOf: Bundle.main.url(forResource: "Ccx32", withExtension: "webp")!), let _filter: CIFilter = CIFilter(name: _filter_name, parameters: ["inputColorLookupTable": _tableImg]) {
                _vivid_filter = _filter
            }
        case .YUCICrossZoomTransition:
            if let _targetImg = CIImage(contentsOf: Bundle.main.url(forResource: "sample2", withExtension: "jpg")!), let _filter: CIFilter = CIFilter(name: _filter_name, parameters: ["inputTargetImage" :_targetImg, "inputStrength": 0.5]) {
                _vivid_filter = _filter
                MAX_TIME = 1.0
//                linkTimer = CADisplayLink(target: self, selector: #selector(stepTime))
//                linkTimer?.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
            }
        case .YUCIFilmBurnTransition:
            if let _targetImg = CIImage(contentsOf: Bundle.main.url(forResource: "sample2", withExtension: "jpg")!), let _filter: CIFilter = CIFilter(name: _filter_name, parameters: ["inputTargetImage" :_targetImg]) {
                _vivid_filter = _filter
                MAX_TIME = 1.0
//                linkTimer = CADisplayLink(target: self, selector: #selector(stepTime))
//                linkTimer?.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
            }
        case .YUCIFlashTransition:
            if let _targetImg = CIImage(contentsOf: Bundle.main.url(forResource: "sample2", withExtension: "jpg")!), let _filter: CIFilter = CIFilter(name: _filter_name, parameters: ["inputTargetImage" :_targetImg]) {
                _vivid_filter = _filter
                MAX_TIME = 1.0
//                linkTimer = CADisplayLink(target: self, selector: #selector(stepTime))
//                linkTimer?.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
            }
        case .YUCIFXAA:
            if let _filter: CIFilter = CIFilter(name: _filter_name) {
                _vivid_filter = _filter
            }
        case .YUCIHistogramEqualization:
            if let _filter: CIFilter = CIFilter(name: _filter_name) {
                _vivid_filter = _filter
            }
        case .YUCIReflectedTile:
            if let _filter: CIFilter = CIFilter(name: _filter_name, parameters: ["inputMode": 0]) {
                _vivid_filter = _filter
            }
        case .YUCIRGBToneCurve:
            if let _filter: CIFilter = CIFilter(name: _filter_name, parameters: ["inputRGBCompositeControlPoints": [CIVector(x: .zero, y: .zero), CIVector(x: 0.5, y: 0.7), CIVector(x: 1, y: 1)]]) {
                _vivid_filter = _filter
            }
        case .YUCISkyGenerator:
            if let _filter: CIFilter = CIFilter(name: _filter_name, parameters: ["inputExtent": CIVector(cgRect: CGRect(origin: .zero, size: CGSize(width: 1200, height: 800))), "inputSunIntensity": 0.8, "inputSunPosition": CIVector(x: 200, y: 300)]) {
                _vivid_filter = _filter
            }
        case .YUCIStarfieldGenerator:
            if let _filter: CIFilter = CIFilter(name: _filter_name, parameters: ["inputExtent": CIVector(cgRect: CGRect(origin: .zero, size: CGSize(width: 200, height: 200)))]) {
                STEP_TIME = 0.5
                _vivid_filter = _filter
                linkTimer = CADisplayLink(target: self, selector: #selector(stepTime))
                linkTimer?.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
            }
        case .YUCISurfaceBlur:
            if let _filter: CIFilter = CIFilter(name: _filter_name, parameters: ["inputRadius": 15, "inputThreshold": 130]) {
                _vivid_filter = _filter
            }
        case .YUCITriangularPixellate:
            if let _filter: CIFilter = CIFilter(name: _filter_name, parameters: ["inputScale": 15, "inputVertexAngle": Double.pi * 0.7, "inputCenter": CIVector(x: 200, y: 200)]) {
                _vivid_filter = _filter
            }
        case .CausticNoise:
            let _filter = CausticNoise()
            _filter.inputTileSize = 50
            _filter.inputWidth = 200
            _filter.inputHeight = 200
            self._vivid_filter = _filter
            linkTimer = CADisplayLink(target: self, selector: #selector(stepTime))
            linkTimer?.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
        case .CausticRefraction:
            let _filter = CausticRefraction()
            _filter.inputRefractiveIndex = 10.0
            _filter.inputLensScale = 20
            _filter.inputLightingAmount = 2.5
            _filter.inputTileSize = 500
            _filter.inputSoftening = 5
            self._vivid_filter = _filter
            linkTimer = CADisplayLink(target: self, selector: #selector(stepTime))
            linkTimer?.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
        default:
            break
        }
        
        guard let _filter = _vivid_filter, !_filter.inputKeys.contains(kCIInputTimeKey) else {
            return
        }
        
        guard let _filter = _vivid_filter, !_filter.inputKeys.contains(kCICategoryTransition) else {
            self.showImageWithTransition(filter: _filter, _inputImg: _input_filter_img)
            return
        }
        
        self.showImageAfterFilterProcessing(_filter: _filter, _inputImg: _input_filter_img)
    }
}

private extension VividFilterViewController {
    func showImageAfterFilterProcessing(_filter: CIFilter, _inputImg: CIImage? = nil) {
        if _filter.inputKeys.contains(kCIInputImageKey), let _i_img = _inputImg {
            _filter.setValue(_i_img, forKey: kCIInputImageKey)
        }
        if let _outputImg = _filter.outputImage {
            var _outputExtent = _outputImg.extent
            if _outputExtent.isInfinite {
                _outputExtent = CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 400))
            }
            
            if let _o_img = self.context.createCGImage(_outputImg, from: _outputExtent) {
                self.afterImgView.image = UIImage(cgImage: _o_img)
            }
        }
    }
    
    func showImageWithTransition(filter: CIFilter, _inputImg: CIImage?) {
        

    }
}

@objc private extension VividFilterViewController {
    func stepTime() {
        if time >= MAX_TIME {
            linkTimer?.remove(from: RunLoop.main, forMode: RunLoop.Mode.common)
            linkTimer?.invalidate()
            linkTimer = nil
            return
        }
        time += STEP_TIME
        if let _filter = self._vivid_filter, _filter.inputKeys.contains(kCIInputTimeKey) {
            _filter.setValue(time, forKey: kCIInputTimeKey)
            self.showImageAfterFilterProcessing(_filter: _filter, _inputImg: _input_filter_img)
        }
    }
}
