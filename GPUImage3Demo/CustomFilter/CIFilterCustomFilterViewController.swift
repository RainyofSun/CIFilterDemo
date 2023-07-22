//
//  CIFilterCustomFilterViewController.swift
//  GPUImage3Demo
//
//  Created by 苍蓝猛兽 on 2023/7/14.
//

import UIKit

class CIFilterCustomFilterViewController: FliterDiaplayBaseViewController {
    
    enum CustomFilterType: String {
        case RedEyeCorrection = "红眼矫正"
        case ColorInvert = "反色"
        case OldFilmEffect = "老电影效果"
        case ReplaceBackground = "替换照片背景"
        case BlackAndWhiteFilter = "黑白滤镜"
        case AirFilter = "AirFilter"
        case CrystalFilter = "CrystalFilter"
        case VividFilter = "VividFilter"
        case ClarendonFilter = "ClarendonFilter"
        case NashvilleFilter = "nashvilleFilter"
        case Apply1977Filter = "apply1977Filter"
        case ToasterFilter = "toasterFilter"
        case HazeRemoveFilter = "HazeRemoveFilter"
    }
    
    private(set) lazy var beforImgView: UIImageView = {
        return UIImageView(frame: CGRect.zero)
    }()
    
    private(set) lazy var afterImgView: UIImageView = {
        return UIImageView(frame: CGRect.zero)
    }()
    
    private lazy var filterLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    private lazy var filterCollectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: filterLayout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    var _data_source: [String] = [CustomFilterType.RedEyeCorrection.rawValue, CustomFilterType.ColorInvert.rawValue,CustomFilterType.OldFilmEffect.rawValue,
                                  CustomFilterType.ReplaceBackground.rawValue,CustomFilterType.BlackAndWhiteFilter.rawValue, CustomFilterType.AirFilter.rawValue,
                                  CustomFilterType.CrystalFilter.rawValue,CustomFilterType.VividFilter.rawValue, CustomFilterType.ClarendonFilter.rawValue,
                                  CustomFilterType.NashvilleFilter.rawValue, CustomFilterType.Apply1977Filter.rawValue, CustomFilterType.ToasterFilter.rawValue,
                                  CustomFilterType.HazeRemoveFilter.rawValue]
    
    private lazy var _ci_context: CIContext = CIContext(options: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bgImageView.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.bgImageView.isHidden = false
    }
    
    func didSelectedFilter(indexPath: IndexPath) {
        guard let _filterType = CustomFilterType(rawValue: _data_source[indexPath.item]) else {
            return
        }
        
        if _filterType == .RedEyeCorrection || _filterType == .ColorInvert {
            self.applyFilter(originalImg: UIImage(named: "redEye")!, filterType: _filterType)
        }
        
        if _filterType == .OldFilmEffect {
            self.applyFilter(originalImg: UIImage(named: "Image")!, filterType: _filterType)
        }
        
        if _filterType == .ReplaceBackground || _filterType == .BlackAndWhiteFilter {
            self.applyFilter(originalImg: UIImage(named: "Image2")!, filterType: _filterType)
        }
        
        if _filterType == .AirFilter || _filterType == .CrystalFilter || _filterType == .VividFilter || _filterType == .ClarendonFilter
            || _filterType == .NashvilleFilter || _filterType == .Apply1977Filter || _filterType == .ToasterFilter || _filterType == .HazeRemoveFilter {
            self.applyFilter(originalImg: UIImage(named: "sample2.jpg")!, filterType: _filterType)
        }
    }
}

private extension CIFilterCustomFilterViewController {
    func setupUI() {
        
        self.beforImgView.contentMode = .scaleAspectFit
        self.afterImgView.contentMode = .scaleAspectFit
        self.beforImgView.backgroundColor = UIColor.cyan.withAlphaComponent(0.5)
        self.afterImgView.backgroundColor = UIColor.cyan.withAlphaComponent(0.5)
        let width: CGFloat = (self.view.frame.width - 30) * 0.5
        self.beforImgView.frame = CGRect(x: 10, y: 80, width: width, height: width * 2)
        self.view.addSubview(self.beforImgView)
        self.afterImgView.frame = CGRect(x: width + 20.0, y: 80, width: width, height: width * 2)
        self.view.addSubview(self.afterImgView)
        
        self.filterCollectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: "FilterCell")
        self.filterCollectionView.delegate = self
        self.filterCollectionView.dataSource = self
        self.filterCollectionView.frame = CGRect(origin: CGPoint(x: .zero, y: self.beforImgView.frame.maxY + 100), size: CGSize(width: self.view.frame.width, height: 90))
        self.view.addSubview(self.filterCollectionView)
    }
    
    func applyFilter(originalImg: UIImage, filterType: CustomFilterType) {
        self.beforImgView.image = originalImg
        guard let inputImage = CIImage(image: originalImg) else {
            return
        }
        
        var _ouputImg: CIImage?
        
        switch filterType {
        case .RedEyeCorrection:
            self.redEyeCorrectionFilter(inputImage: inputImage)
        case .ColorInvert:
            _ouputImg = self.colorInvertFilter(inputImage: inputImage)
        case .OldFilmEffect:
            _ouputImg = self.oldFilmEffect(inputImage: inputImage)
        case .ReplaceBackground:
            _ouputImg = self.replacePictureBackground(inputImage: inputImage)
        case .BlackAndWhiteFilter:
            _ouputImg = self.blackAndWhiteFilter(inputImage: inputImage)
        case .AirFilter:
            _ouputImg = self.airFilter(inputImage: inputImage)
        case .CrystalFilter:
            _ouputImg = self.crystalFilter(inputImage: inputImage)
        case .VividFilter:
            _ouputImg = self.vividFilter(inputImage: inputImage)
        case .ClarendonFilter:
            _ouputImg = self.clarendonFilter(inputImage: inputImage)
        case .NashvilleFilter:
            _ouputImg = self.nashvilleFilter(inputImage: inputImage)
        case .Apply1977Filter:
            _ouputImg = self.apply1977Filter(inputImage: inputImage)
        case .ToasterFilter:
            _ouputImg = self.toasterFilter(inputImage: inputImage)
        case .HazeRemoveFilter:
            _ouputImg = self.hazeRemoveFilter(inputImage: inputImage)
        }
        
        if let _o_i = _ouputImg, let _cgImg = _ci_context.createCGImage(_o_i, from: _o_i.extent) {
            self.afterImgView.image = UIImage(cgImage: _cgImg)
        }
    }
    
    /// 红眼矫正
    func redEyeCorrectionFilter(inputImage: CIImage) {
        var _correctionImg = inputImage
        let filters = _correctionImg.autoAdjustmentFilters()
        for filter: CIFilter in filters {
            filter.setValue(_correctionImg, forKey: kCIInputImageKey)
            if let _o_i = filter.outputImage {
                _correctionImg = _o_i
            }
        }
        
        if let cgImage = _ci_context.createCGImage(_correctionImg, from: _correctionImg.extent) {
            self.afterImgView.image = UIImage(cgImage: cgImage)
        }
    }
    
    /// 反色
    func colorInvertFilter(inputImage: CIImage) -> CIImage? {
        return CIFF.ColorMatrix(inputImage: inputImage, rVector: CIVector(x: -1, y: .zero, z: .zero), gVector: CIVector(x: .zero, y: -1, z: .zero),  bVector: CIVector(x: .zero, y: .zero, z: -1), biasVector: CIVector(x: 1, y: 1, z: 1))?.outputImage
    }
    
    /// 老电影效果
    func oldFilmEffect(inputImage: CIImage) -> CIImage? {
        let _spiaToneFilter = CIFF.SepiaTone(inputImage: inputImage, intensity: 1)
        // 创建噪点图
        guard var _whiteNoiseImg = CIFF.RandomGenerator()?.outputImage else {
            return nil
        }
        _whiteNoiseImg = _whiteNoiseImg.cropped(to: inputImage.extent)
        // 创建白斑图滤镜
        let _whiteSpecksFilter = CIFF.ColorMatrix(inputImage: _whiteNoiseImg, rVector:
                                                    CIVector(x: .zero, y: 1, z: .zero), gVector:
                                                    CIVector(x: .zero, y: 1, z: .zero), bVector:
                                                    CIVector(x: .zero, y: 1, z: .zero), biasVector:
                                                    CIVector(x: .zero, y: .zero, z: .zero))
        // 把CISepiaTone滤镜和白班图滤镜以源覆盖(source over)的方式先组合起来
        let _sourceOverCompostingFilter = CIFF.SourceOverCompositing(inputImage: _spiaToneFilter?.outputImage, backgroundImage: _whiteSpecksFilter?.outputImage)
        // 用CIAffineTransform滤镜先对随机噪点图进行处理
        guard var _noiseImg = CIFF.RandomGenerator()?.outputImage else {
            return nil
        }
        _noiseImg = _noiseImg.cropped(to: inputImage.extent)
        
        let _affineTransformFilter = CIFilter.init(name: "CIAffineTransform")
        _affineTransformFilter?.setValue(_noiseImg, forKey: kCIInputImageKey)
        _affineTransformFilter?.setValue(CGAffineTransform(scaleX: 1.5, y: 25), forKey: kCIInputTransformKey)
        // 创建蓝绿色磨砂图滤镜
        let _darkScratchesFilter = CIFF.ColorMatrix(inputImage: _affineTransformFilter?.outputImage, rVector:
                                                        CIVector(x: 4, y: .zero, z: .zero), gVector:
                                                        CIVector(x: .zero, y: .zero, z: .zero), bVector:
                                                        CIVector(x: .zero, y: .zero, z: .zero), aVector:
                                                        CIVector(x: .zero, y: .zero, z: CGFloat.zero), biasVector:
                                                        CIVector(x: .zero, y: 1, z: 1, w: 1))
        // 用CIMinimumComponent滤镜把蓝绿色磨砂图滤镜处理成黑色磨砂图滤镜
        let _minimumComponentFilter = CIFF.MinimumComponent(inputImage: _darkScratchesFilter?.outputImage)
        // 组合
        let _multiplyCompositingFilter = CIFF.MultiplyCompositing(inputImage: _minimumComponentFilter?.outputImage, backgroundImage: _sourceOverCompostingFilter?.outputImage)
        return _multiplyCompositingFilter?.outputImage
    }
    
    /// 替换照片背景色
    func replacePictureBackground(inputImage: CIImage) -> CIImage? {
        guard let _bgImg = CIImage(image: UIImage(named: "background")!) else {
            return nil
        }
        let cubeMap = createCubeMap(60, 90)
        let data = NSData(bytesNoCopy: cubeMap.data, length: Int(cubeMap.length), freeWhenDone: true)
        let _colorCubeFilter = CIFF.ColorCube(inputImage: inputImage, cubeDimension: UInt(cubeMap.dimension), cubeData: data as Data)
            
        let _sourceOverCompositionFilter = CIFF.SourceOverCompositing(inputImage: _colorCubeFilter?.outputImage, backgroundImage: _bgImg)
        return _sourceOverCompositionFilter?.outputImage
    }
    
    /// 黑白滤镜
    func blackAndWhiteFilter(inputImage: CIImage) -> CIImage? {
        return CIFF.PhotoEffectNoir(inputImage: inputImage)?.outputImage
    }
    
    /// AirFilter
    func airFilter(inputImage: CIImage) -> CIImage? {
        let _exposureAdjustFilter = CIFF.ExposureAdjust(inputImage: inputImage, eV: 0.25)
        let _temperatureAndTintFilter = CIFF.TemperatureAndTint(inputImage: _exposureAdjustFilter?.outputImage, neutral: CGPoint(x: 6000, y: .zero))
        let _highlightShadowAdjustFilter = CIFF.HighlightShadowAdjust(inputImage: _temperatureAndTintFilter?.outputImage, highlightAmount: 1.05)
        let _colorControlsFilter = CIFF.ColorControls(inputImage: _highlightShadowAdjustFilter?.outputImage, saturation: 1.05, brightness: 0.01, contrast: 1.05)
        let _sharpenLuminanceFilter = CIFF.SharpenLuminance(inputImage: _colorControlsFilter?.outputImage, sharpness: 0.1)
        return _sharpenLuminanceFilter?.outputImage
    }
    
    /// 水晶过滤器
    func crystalFilter(inputImage: CIImage) -> CIImage? {
        let _exposureAdjustFilter = CIFF.ExposureAdjust(inputImage: inputImage, eV: 0.15)
        let _highlightShadowAdjustFilter = CIFF.HighlightShadowAdjust(inputImage: _exposureAdjustFilter?.outputImage, shadowAmount: -0.05, highlightAmount: 1.1)
        let _colorControlsFilter = CIFF.ColorControls(inputImage: _highlightShadowAdjustFilter?.outputImage, saturation: 1.05, brightness: 0.01)
        let _sharpenLuminanceFilter = CIFF.SharpenLuminance(inputImage: _colorControlsFilter?.outputImage, sharpness: 0.6)
        return _sharpenLuminanceFilter?.outputImage
    }
    
    /// vividFilter
    func vividFilter(inputImage: CIImage) -> CIImage? {
        let _exposureAdjustFilter = CIFF.ExposureAdjust(inputImage: inputImage, eV: 0.1)
        let _colorControlsFilter = CIFF.ColorControls(inputImage: _exposureAdjustFilter?.outputImage, saturation: 1.5, brightness: 0.01, contrast: 1.05)
        let _temperatureAndTintFilter = CIFF.TemperatureAndTint(inputImage: _colorControlsFilter?.outputImage, neutral: CGPoint(x: 6800, y: .zero))
        let _gaussianBlurFilter = CIFF.GaussianBlur(inputImage: _temperatureAndTintFilter?.outputImage, radius: 0.4)
        return _gaussianBlurFilter?.outputImage
    }
    
    /// clarendonFilter
    func clarendonFilter(inputImage: CIImage) -> CIImage? {
        let backgroundImage = UIColor.getColorImage(red: 127, green: 187, blue: 227, alpha: Int(255 * 0.2), rect: inputImage.extent)
        let _overlayBlendModeFilter = CIFF.OverlayBlendMode(inputImage: inputImage, backgroundImage: backgroundImage)
        let _colorControlsFilter = CIFF.ColorControls(inputImage: _overlayBlendModeFilter?.outputImage, saturation: 1.35, brightness: 0.05, contrast: 1.1)
        return _colorControlsFilter?.outputImage
    }
    
    /// nashvilleFilter
    func nashvilleFilter(inputImage: CIImage) -> CIImage? {
        let backgroundImage = UIColor.getColorImage(red: 247, green: 176, blue: 153, alpha: Int(255 * 0.56), rect: inputImage.extent)
        let backgroundImage2 = UIColor.getColorImage(red: 0, green: 70, blue: 150, alpha: Int(255 * 0.4), rect: inputImage.extent)
        let _darkBlendModeFilter = CIFF.DarkenBlendMode(inputImage: inputImage, backgroundImage: backgroundImage)
        let _sepiaToneFilter = CIFF.SepiaTone(inputImage: _darkBlendModeFilter?.outputImage, intensity: 0.2)
        let _colorControlFilter = CIFF.ColorControls(inputImage: _sepiaToneFilter?.outputImage, saturation: 1.2, brightness: 0.05, contrast: 1.1)
        let _lightenBlendModeFilter = CIFF.LightenBlendMode(inputImage: _colorControlFilter?.outputImage, backgroundImage: backgroundImage2)
        return _lightenBlendModeFilter?.outputImage
    }
    
    /// apply1977Filter
    func apply1977Filter(inputImage: CIImage) -> CIImage? {
        let filterImage = UIColor.getColorImage(red: 243, green: 106, blue: 188, alpha: Int(255 * 0.1), rect: inputImage.extent)
        let _colorControlsFilter = CIFF.ColorControls(inputImage: inputImage, saturation: 1.3, brightness: 0.1, contrast: 1.05)
        let _hueAdjustFilter = CIFF.HueAdjust(inputImage: _colorControlsFilter?.outputImage, angle: 0.3)
        let _screenBlendModeFilter = CIFF.ScreenBlendMode(inputImage: filterImage, backgroundImage: _hueAdjustFilter?.outputImage)
        let _toneCurveFilter = CIFF.ToneCurve(inputImage: _screenBlendModeFilter?.outputImage, point0: CGPointZero, point1: CGPoint(x: 0.25, y: 0.2), point2: CGPoint(x: 0.5, y: 0.5), point3: CGPoint(x: 0.75, y: 0.8), point4: CGPoint(x: 1, y: 1))
        return _toneCurveFilter?.outputImage
    }
    
    /// toasterFilter
    func toasterFilter(inputImage: CIImage) -> CIImage? {
        let width = inputImage.extent.width
        let height = inputImage.extent.height
        let centerWidth = width / 2.0
        let centerHeight = height / 2.0
        let radius0 = min(width / 4.0, height / 4.0)
        let radius1 = min(width / 1.5, height / 1.5)
        
        let color0 = CIColor(red: 128/255.0, green: 78/255.0, blue: 15/255.0, alpha: 1)
        let color1 = CIColor(red: 79/255.0, green: 0, blue: 79/255.0, alpha: 1)
        let _radisalGradientFilter = CIFF.RadialGradient(center: CGPoint(x: centerWidth, y: centerHeight), radius0: radius0, radius1: radius1, color0: color0, color1: color1)
        let _colorControlsFilter = CIFF.ColorControls(inputImage: inputImage, saturation: 1.0, brightness: 0.01, contrast: 1.1)
        let _screenBlendModeFilter = CIFF.ScreenBlendMode(inputImage: _colorControlsFilter?.outputImage, backgroundImage: _radisalGradientFilter?.outputImage?.cropped(to: inputImage.extent))
        return _screenBlendModeFilter?.outputImage
    }
    /// 去雾滤镜
    func hazeRemoveFilter(inputImage: CIImage) -> CIImage? {
        let filter = HazeRemovalFilter()
        filter.inputImage = inputImage
        return filter.outputImage
    }
}

extension CIFilterCustomFilterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _data_source.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let _cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as? FilterCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        _cell.filterLab.text = _data_source[indexPath.item]
        return _cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectedFilter(indexPath: indexPath)
    }
}
