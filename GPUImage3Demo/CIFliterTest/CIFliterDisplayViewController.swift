//
//  CIFliterDisplayViewController.swift
//  GPUImage3Demo
//
//  Created by 苍蓝猛兽 on 2023/6/21.
//
/*
 https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/filter/ci/CIBoxBlur
 https://www.jianshu.com/p/f111f759d524
 */
import UIKit

class CIFliterDisplayViewController: FliterDiaplayBaseViewController {
    
    open var filterModel: CIFliterModel?
    
    private var _slider: UISlider?
    private var _filter: CIFilter?
    private var _CIFFFilter: NSObject?
    private var linkTimer: CADisplayLink?
    var time = 0.0
    var dt = 0.01
    private var _filter_name: String = ""
    private lazy var _ci_context: CIContext = CIContext(options: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(filterModel?.fliterName ?? "")
        
        self._slider = buildSlider(sliderPosition: CGPoint(x: 20, y: self.view.bounds.height - 70), sel: #selector(sliderValueChanged(sender: )))
        if let _name = filterModel?.fliterName {
//            GeometryAdjustmentFilter(filterName: _name)
//            CICategoryBlur(filterName: _name)
//            CICategoryColorAdjustment(filterName: _name)
//            CICategoryColorEffect(filterName: _name)
//            CICategoryCompositeOperation(filterName: _name)
//            CICategoryDistortionEffect(filterName: _name)
//            CICategoryGenerator(filterName: _name)
//            CICategoryGradient(filterName: _name)
//            CICategoryHalftoneEffect(filterName: _name)
//            CICategoryReduction(filterName: _name)
//            CICategorySharpen(filterName: _name)
//            CICategoryStylize(filterName: _name)
//            CICategoryTileEffect(filterName: _name)
            CICategoryTransition(filterName: _name)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        linkTimer?.remove(from: RunLoop.main, forMode: RunLoop.Mode.common)
        linkTimer?.invalidate()
        linkTimer = nil
    }
    func RGBtoHSV(r : Float, g : Float, b : Float) -> (h : Float, s : Float, v : Float) {
        var h : CGFloat = 0
        var s : CGFloat = 0
        var v : CGFloat = 0
        let col = UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1.0)
        col.getHue(&h, saturation: &s, brightness: &v, alpha: nil)
        return (Float(h), Float(s), Float(v))
    }
    
    func colorCubeFilterForChromaKey(hueAngle: Float) -> (Int, Data) {

        let hueRange: Float = 60 // degrees size pie shape that we want to replace
        let minHueAngle: Float = (hueAngle - hueRange/2.0) / 360
        let maxHueAngle: Float = (hueAngle + hueRange/2.0) / 360

        let size = 64
        var cubeData = [Float](repeating: 0, count: size * size * size * 4)
        var rgb: [Float] = [0, 0, 0]
        var hsv: (h : Float, s : Float, v : Float)
        var offset = 0

        for z in 0 ..< size {
            rgb[2] = Float(z) / Float(size) // blue value
            for y in 0 ..< size {
                rgb[1] = Float(y) / Float(size) // green value
                for x in 0 ..< size {

                    rgb[0] = Float(x) / Float(size) // red value
                    hsv = RGBtoHSV(r: rgb[0], g: rgb[1], b: rgb[2])
                    // the condition checking hsv.s may need to be removed for your use-case
                    let alpha: Float = (hsv.h > minHueAngle && hsv.h < maxHueAngle && hsv.s > 0.5) ? 0 : 1.0

                    cubeData[offset] = rgb[0] * alpha
                    cubeData[offset + 1] = rgb[1] * alpha
                    cubeData[offset + 2] = rgb[2] * alpha
                    cubeData[offset + 3] = alpha
                    offset += 4
                }
            }
        }
        let b = cubeData.withUnsafeBufferPointer { Data(buffer: $0) }
        return (size,b)
    }
    
    @objc func sliderValueChanged(sender: UISlider) {
        guard let _name = filterModel?.fliterName else {
            return
        }
        
        if _name == "CIAffineTransform" {
            self._filter?.setValue(CGAffineTransform(rotationAngle: Double.pi * Double(sender.value)), forKey: kCIInputTransformKey)
            if let _f_i = _filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CICrop", let _f = _CIFFFilter as? CIFF.Crop {
            _f.rectangle = self.bgImageView.bounds.insetBy(dx: 50 * CGFloat(sender.value), dy: 50 * CGFloat(sender.value))
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIStraightenFilter", let _f = _CIFFFilter as? CIFF.StraightenFilter {
            _f.angle = Double.pi * Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIBoxBlur", let _f = _CIFFFilter as? CIFF.BoxBlur {
            _f.radius = 80 * Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIDiscBlur", let _f = _CIFFFilter as? CIFF.DiscBlur {
            _f.radius = 80 * Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIGaussianBlur", let _f = _CIFFFilter as? CIFF.GaussianBlur {
            _f.radius = 80 * Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIMaskedVariableBlur", let _f = _CIFFFilter as? CIFF.MaskedVariableBlur {
            _f.radius = 80 * Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIMotionBlur", let _f = _CIFFFilter as? CIFF.MotionBlur {
            _f.radius = 80 * Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CINoiseReduction", let _f = _CIFFFilter as? CIFF.NoiseReduction {
            _f.sharpness = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIZoomBlur", let _f = _CIFFFilter as? CIFF.ZoomBlur {
            _f.amount = 30.0 * Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIColorClamp", let _f = _CIFFFilter as? CIFF.ColorClamp {
            _f.minComponents = CIVector(x: CGFloat(sender.value), y: CGFloat(sender.value), z: 0.5)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIColorControls", let _f = _CIFFFilter as? CIFF.ColorControls {
            _f.brightness = CGFloat(sender.value)
//            _f.saturation = CGFloat(sender.value)
//            _f.contrast = CGFloat(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIColorMatrix", let _f = _CIFFFilter as? CIFF.ColorMatrix {
            _f.rVector = CIVector(x: CGFloat(sender.value))
            _f.bVector = CIVector(x: CGFloat(sender.value))
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIColorPolynomial", let _f = _CIFFFilter as? CIFF.ColorPolynomial {
            _f.redCoefficients = CIVector(x: CGFloat(sender.value))
//            _f.blueCoefficients = CIVector(x: CGFloat(sender.value))
//            _f.greenCoefficients = CIVector(x: CGFloat(sender.value))
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIExposureAdjust", let _f = _CIFFFilter as? CIFF.ExposureAdjust {
            _f.eV = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIGammaAdjust", let _f = _CIFFFilter as? CIFF.GammaAdjust {
            _f.power = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIHueAdjust", let _f = _CIFFFilter as? CIFF.HueAdjust {
            _f.angle = Double.pi * Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CITemperatureAndTint", let _f = _CIFFFilter as? CIFF.TemperatureAndTint {
            _f.neutral = CGPoint(x: 100, y: 100)
            _f.targetNeutral = CGPoint(x: 100 * Int(sender.value), y: 200 * Int(sender.value))
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIToneCurve", let _f = _CIFFFilter as? CIFF.ToneCurve {
            _f.point1 = CGPoint(x: 0.25, y: Double(sender.value))
//            _f.point3 = CGPoint(x: Double(sender.value), y: 0.75)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIVibrance", let _f = _CIFFFilter as? CIFF.Vibrance {
            _f.amount = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIColorCrossPolynomial", let _f = _CIFFFilter as? CIFF.ColorCrossPolynomial {
            _f.redCoefficients = CIVector(x: CGFloat(sender.value))
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIColorMonochrome", let _f = _CIFFFilter as? CIFF.ColorMonochrome {
            _f.intensity = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIColorPosterize", let _f = _CIFFFilter as? CIFF.ColorPosterize {
            _f.levels = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CISepiaTone", let _f = _CIFFFilter as? CIFF.SepiaTone {
            _f.intensity = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIVignette", let _f = _CIFFFilter as? CIFF.Vignette {
            _f.radius = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIVignetteEffect", let _f = _CIFFFilter as? CIFF.VignetteEffect {
            _f.radius = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIBumpDistortion", let _f = _CIFFFilter as? CIFF.BumpDistortion {
            _f.center = CGPoint(x: self.bgImageView.image!.size.width * CGFloat(sender.value), y: self.bgImageView.image!.size.height * CGFloat(sender.value))
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIBumpDistortionLinear", let _f = _CIFFFilter as? CIFF.BumpDistortionLinear {
            _f.center = CGPoint(x: self.bgImageView.image!.size.width * CGFloat(sender.value), y: self.bgImageView.image!.size.height * CGFloat(sender.value))
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CICircleSplashDistortion", let _f = _CIFFFilter as? CIFF.CircleSplashDistortion {
            _f.center = CGPoint(x: self.bgImageView.image!.size.width * CGFloat(sender.value), y: self.bgImageView.image!.size.height * CGFloat(sender.value))
            if let _f_i = _f.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
        
        if _name == "CICircularWrap", let _f = _CIFFFilter as? CIFF.CircularWrap {
            _f.center = CGPoint(x: self.bgImageView.image!.size.width * CGFloat(sender.value), y: self.bgImageView.image!.size.height * CGFloat(sender.value))
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIDroste", let _f = _CIFFFilter as? CIFF.Droste {
            _f.strands = Double(sender.value)
            if let _f_i = _f.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
        
        if _name == "CIDisplacementDistortion", let _f = _CIFFFilter as? CIFF.DisplacementDistortion {
            _f.scale = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIGlassDistortion", let _f = _CIFFFilter as? CIFF.GlassDistortion {
            _f.scale = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIGlassLozenge", let _f = _CIFFFilter as? CIFF.GlassLozenge {
            _f.refraction = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIHoleDistortion", let _f = _CIFFFilter as? CIFF.HoleDistortion {
            _f.center = CGPoint(x: self.bgImageView.image!.size.width * CGFloat(sender.value), y: self.bgImageView.image!.size.height * CGFloat(sender.value))
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CILightTunnel", let _f = _CIFFFilter as? CIFF.LightTunnel {
            _f.center = CGPoint(x: self.bgImageView.image!.size.width * CGFloat(sender.value), y: self.bgImageView.image!.size.height * CGFloat(sender.value))
            if let _f_i = _f.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
        
        if _name == "CIPinchDistortion", let _f = _CIFFFilter as? CIFF.PinchDistortion {
            _f.scale = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CITorusLensDistortion", let _f = _CIFFFilter as? CIFF.TorusLensDistortion {
            _f.refraction = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CITwirlDistortion", let _f = _CIFFFilter as? CIFF.TwirlDistortion {
            _f.angle = Double.pi * Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIVortexDistortion", let _f = _CIFFFilter as? CIFF.VortexDistortion {
            _f.angle = 150 * Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIStarShineGenerator", let _f = _CIFFFilter as? CIFF.StarShineGenerator {
            _f.radius = 100 * Double(sender.value)
            if let _f_i = _f.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
        
        if _name == "CIStripesGenerator", let _f = _CIFFFilter as? CIFF.StripesGenerator {
            _f.width = Double(sender.value)
            if let _f_i = _f.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
        
        if _name == "CISunbeamsGenerator", let _f = _CIFFFilter as? CIFF.SunbeamsGenerator {
            _f.sunRadius = Double(sender.value)
            if let _f_i = _f.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
        
        if _name == "CIRadialGradient", let _f = _CIFFFilter as? CIFF.RadialGradient {
            _f.radius1 = Double(sender.value)
            if let _f_i = _f.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
        
        if _name == "CIGaussianGradient", let _f = _CIFFFilter as? CIFF.GaussianGradient {
            _f.radius = Double(sender.value)
            if let _f_i = _f.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
        
        if _name == "CICircularScreen", let _f = _CIFFFilter as? CIFF.CircularScreen {
            _f.width = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CICMYKHalftone", let _f = _CIFFFilter as? CIFF.CMYKHalftone {
            _f.width = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIDotScreen", let _f = _CIFFFilter as? CIFF.DotScreen {
            _f.width = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIHatchedScreen", let _f = _CIFFFilter as? CIFF.HatchedScreen {
            _f.width = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CILineScreen", let _f = _CIFFFilter as? CIFF.LineScreen {
            _f.width = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CISharpenLuminance", let _f = _CIFFFilter as? CIFF.SharpenLuminance {
            _f.radius = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIUnsharpMask", let _f = _CIFFFilter as? CIFF.UnsharpMask {
            _f.radius = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIBloom", let _f = _CIFFFilter as? CIFF.Bloom {
            _f.radius = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CICrystallize", let _f = _CIFFFilter as? CIFF.Crystallize {
            _f.radius = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIDepthOfField", let _f = _CIFFFilter as? CIFF.DepthOfField {
            _f.unsharpMaskRadius = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIEdges", let _f = _CIFFFilter as? CIFF.Edges {
            _f.intensity = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIEdgeWork", let _f = _CIFFFilter as? CIFF.EdgeWork {
            _f.radius = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIGloom", let _f = _CIFFFilter as? CIFF.Gloom {
            _f.intensity = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIHeightFieldFromMask", let _f = _CIFFFilter as? CIFF.HeightFieldFromMask {
            _f.radius = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIHexagonalPixellate", let _f = _CIFFFilter as? CIFF.HexagonalPixellate {
            _f.scale = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIHighlightShadowAdjust", let _f = _CIFFFilter as? CIFF.HighlightShadowAdjust {
            _f.shadowAmount = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIPixellate", let _f = _CIFFFilter as? CIFF.Pixellate {
            _f.scale = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIPointillize", let _f = _CIFFFilter as? CIFF.Pointillize {
            _f.radius = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CIShadedMaterial", let _f = _CIFFFilter as? CIFF.ShadedMaterial {
            _f.scale = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if _name == "CISpotLight", let _f = _CIFFFilter as? CIFF.SpotLight {
            _f.brightness = Double(sender.value)
            if let _f_i = _f.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
    }
}

// MARK: 展示不同滤镜
extension CIFliterDisplayViewController {
    func CICategoryBlur(filterName: String) {
        guard let img = UIImage(named: "Domestic_cat_mean_face") else {
            return
        }
        self.bgImageView.contentMode = .scaleAspectFit
        self.bgImageView.image = img
        if filterName == "CIBoxBlur" {
            let filter = CIFF.BoxBlur(inputImage: img.convertUIImageToCIImage())
            self._CIFFFilter = filter
        }
        
        if filterName == "CIDiscBlur" {
            let filter = CIFF.DiscBlur(inputImage: img.convertUIImageToCIImage())
            self._CIFFFilter = filter
        }
        
        if filterName == "CIGaussianBlur" {
            // 按高斯分布指定的量扩展源像素
            let filter = CIFF.GaussianBlur(inputImage: img.convertUIImageToCIImage())
            self._CIFFFilter = filter
        }
        
        if filterName == "CIMaskedVariableBlur" {
            guard let _mask = UIImage(named: "mask") else {
                return
            }
            // 根据蒙版图像中的亮度级别模糊源图像。
            let filter = CIFF.MaskedVariableBlur(inputImage: img.convertUIImageToCIImage(), mask: _mask.convertUIImageToCIImage())
            self._CIFFFilter = filter
        }
        
        if filterName == "CIMedianFilter" {
            // 计算一组相邻像素的中值，并用中值替换每个像素值。
            let filter = CIFF.MedianFilter(inputImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIMotionBlur" {
            // 模糊图像以模拟使用相机在捕获图像时移动指定角度和距离的效果。
            let filter = CIFF.MotionBlur(inputImage: img.convertUIImageToCIImage(), angle: Double.pi * 0.3)
            self._CIFFFilter = filter
        }
        
        if filterName == "CINoiseReduction" {
            // 使用阈值来定义什么被视为噪声来减少噪声
            let filter = CIFF.NoiseReduction(inputImage: img.convertUIImageToCIImage(), noiseLevel: 0.05)
            self._CIFFFilter = filter
        }
        
        if filterName == "CIZoomBlur" {
            // 模拟拍摄图像时变焦相机的效果
            let filter = CIFF.ZoomBlur(inputImage: img.convertUIImageToCIImage(), center: CGPoint(x: img.size.width * 0.5, y: img.size.height * 0.5))
            self._CIFFFilter = filter
        }
    }
    
    func CICategoryColorAdjustment(filterName: String) {
        guard let img = UIImage(named: "Domestic_cat_mean_face") else {
            return
        }
        self.bgImageView.contentMode = .scaleAspectFit
        self.bgImageView.image = img
        
        if filterName == "CIColorClamp" {
            guard let img = UIImage(named: "MaYu.jpg") else {
                return
            }
            // 修改颜色值以使其保持在指定范围内。
            let filter = CIFF.ColorClamp(inputImage: img.convertUIImageToCIImage())
            self._CIFFFilter = filter
        }
        
        if filterName == "CIColorControls" {
            let filter = CIFF.ColorControls(inputImage: img.convertUIImageToCIImage(), saturation: 0.4, brightness: 0.7, contrast: 0.8)
            self._CIFFFilter = filter
        }
        
        if filterName == "CIColorMatrix" {
            let filter = CIFF.ColorMatrix(inputImage: img.convertUIImageToCIImage())
            self._CIFFFilter = filter
        }
        
        if filterName == "CIColorPolynomial" {
            let filter = CIFF.ColorPolynomial(inputImage: img.convertUIImageToCIImage())
            self._CIFFFilter = filter
        }
        
        if filterName == "CIExposureAdjust" {
            let filter = CIFF.ExposureAdjust(inputImage: img.convertUIImageToCIImage())
            self._CIFFFilter = filter
        }
        
        if filterName == "CIGammaAdjust" {
            let filter = CIFF.GammaAdjust(inputImage: img.convertUIImageToCIImage())
            self._CIFFFilter = filter
        }
        
        if filterName == "CIHueAdjust" {
            guard let img = UIImage(named: "MaYu.jpg") else {
                return
            }
            self.bgImageView.image = img
            // 修改颜色值以使其保持在指定范围内。
            let filter = CIFF.HueAdjust(inputImage: img.convertUIImageToCIImage())
            self._CIFFFilter = filter
        }
        
        if filterName == "CILinearToSRGBToneCurve" {
            let filter = CIFF.LinearToSRGBToneCurve(inputImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CISRGBToneCurveToLinear" {
            let filter = CIFF.SRGBToneCurveToLinear(inputImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CITemperatureAndTint" {
            let filter = CIFF.TemperatureAndTint(inputImage: img.convertUIImageToCIImage())
            self._CIFFFilter = filter
        }
        
        if filterName == "CIToneCurve" {
            // 调整图像的 R、G 和 B 通道的色调响应。
            let filter = CIFF.ToneCurve(inputImage: img.convertUIImageToCIImage())
            self._CIFFFilter = filter
        }
        
        if filterName == "CIVibrance" {
            // 调整图像的饱和度，同时保持令人愉悦的肤色。
            self._slider?.maximumValue = 1.0
            self._slider?.minimumValue = -1.0
            self._slider?.value = .zero
            guard let img = UIImage(named: "MaYu.jpg") else {
                return
            }
            self.bgImageView.image = img
            let filter = CIFF.Vibrance(inputImage: img.convertUIImageToCIImage())
            self._CIFFFilter = filter
        }
        
        if filterName == "CIWhitePointAdjust" {
            // 调整图像的参考白点并使用新参考映射源中的所有颜色。
            let filter = CIFF.WhitePointAdjust(inputImage: img.convertUIImageToCIImage(), color: CIColor(color: UIColor.orange.withAlphaComponent(0.5)))
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
    }
    
    func CICategoryColorEffect(filterName: String) {
        guard let img = UIImage(named: "Flower.jpg") else {
            return
        }
        self.bgImageView.contentMode = .scaleAspectFill
        self.bgImageView.image = img
        
        if filterName == "CIColorCrossPolynomial" {
            // 通过应用一组多项式叉积来修改图像中的像素值。
            let filter = CIFF.ColorCrossPolynomial(inputImage: img.convertUIImageToCIImage())
            self._CIFFFilter = filter
        }
        
        if filterName == "CIColorCube" {
            let _cubeElement = colorCubeFilterForChromaKey(hueAngle: 120)
            // 使用三维颜色表来变换源图像像素。
            let filter = CIFF.ColorCube(inputImage: img.convertUIImageToCIImage(), cubeDimension: UInt(_cubeElement.0), cubeData: _cubeElement.1)
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIColorCubeWithColorSpace" {
            let _cubeElement = colorCubeFilterForChromaKey(hueAngle: 80)
            // TODO 使用三维颜色表对源图像像素进行变换，并将结果映射到指定的颜色空间
            let filter = CIFF.ColorCubeWithColorSpace(inputImage: img.convertUIImageToCIImage(), cubeDimension: UInt(_cubeElement.0), cubeData: _cubeElement.1, extrapolate: 3, colorSpace: UIColor.orange)
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIColorInvert" {
            // 反转图像中的颜色
            let filter = CIFF.ColorInvert(inputImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIColorMap" {
            // 使用表中提供的映射值对源颜色值执行非线性变换
            let filter = CIFF.ColorMap(inputImage: img.convertUIImageToCIImage(), gradientImage: CIImage(image: UIImage(named: "mask")!))
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIColorMonochrome" {
            // 重新映射颜色，使它们落入单一颜色的阴影范围内。
            let filter = CIFF.ColorMonochrome(inputImage: img.convertUIImageToCIImage(), color: CIColor(color: UIColor.systemPink))
            self._CIFFFilter = filter
        }
        
        if filterName == "CIColorPosterize" {
            self._slider?.minimumValue = 1
            self._slider?.maximumValue = 15
            self._slider?.value = 6
            let filter = CIFF.ColorPosterize(inputImage: img.convertUIImageToCIImage())
            self._CIFFFilter = filter
        }
        
        if filterName == "CIFalseColor" {
            // 将亮度映射到两种颜色的色带。
            let filter = CIFF.FalseColor(inputImage: img.convertUIImageToCIImage(), color0: CIColor.cyan, color1: CIColor.blue)
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIMaskToAlpha" {
            // 将灰度图像转换为由 Alpha 遮蔽的白色图像。
            let filter = CIFF.MaskToAlpha(inputImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIMaximumComponent" {
            let filter = CIFF.MaximumComponent(inputImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIMinimumComponent" {
            let filter = CIFF.MinimumComponent(inputImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIPhotoEffectChrome" {
            // 应用一组预先配置的效果，模仿具有夸张色彩的老式摄影胶片
            let filter = CIFF.PhotoEffectChrome(inputImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIPhotoEffectFade" {
            // 应用一组预先配置的效果，模仿色彩减弱的老式摄影胶片。
            let filter = CIFF.PhotoEffectFade(inputImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIPhotoEffectInstant" {
            // 应用一组预先配置的效果，模仿具有扭曲颜色的老式摄影胶片。
            let filter = CIFF.PhotoEffectInstant(inputImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIPhotoEffectMono" {
            // 应用一组预配置的效果来模仿低对比度的黑白摄影胶片。。
            let filter = CIFF.PhotoEffectMono(inputImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIPhotoEffectNoir" {
            // 应用一组预先配置的效果，模仿具有夸张对比度的黑白摄影胶片
            let filter = CIFF.PhotoEffectNoir(inputImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIPhotoEffectProcess" {
            // 应用一组预配置的效果，模仿复古摄影胶片，强调冷色调。
            let filter = CIFF.PhotoEffectProcess(inputImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIPhotoEffectTonal" {
            // 应用一组预先配置的效果来模仿黑白摄影胶片，而不会显着改变对比度
            let filter = CIFF.PhotoEffectTonal(inputImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIPhotoEffectTransfer" {
            // 应用一组预配置的效果，模仿复古摄影胶片，强调暖色
            let filter = CIFF.PhotoEffectTransfer(inputImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CISepiaTone" {
            self._slider?.value = 1
            // 将图像的颜色映射为各种深浅的棕色。
            let filter = CIFF.SepiaTone(inputImage: img.convertUIImageToCIImage())
            self._CIFFFilter = filter
        }
        
        if filterName == "CIVignette" {
            self._slider?.minimumValue = 0
            self._slider?.maximumValue = 2
            self._slider?.value = 1
            // 降低图像边缘的亮度。
            let filter = CIFF.Vignette(inputImage: img.convertUIImageToCIImage(), intensity: 0.5)
            self._CIFFFilter = filter
        }
        
        if filterName == "CIVignetteEffect" {
            self._slider?.minimumValue = 0
            self._slider?.maximumValue = 2
            self._slider?.value = 1
            // 修改指定区域周围图像的亮度。
            let filter = CIFF.VignetteEffect(inputImage: img.convertUIImageToCIImage(), center: CGPoint(x: 150, y: 150), intensity: 0.5, falloff: CIFF.VignetteEffect.falloffDefault)
            self._CIFFFilter = filter
        }
    }
    
    func CICategoryCompositeOperation(filterName: String) {
        guard let img = UIImage(named: "Flower.jpg"), let _forImg = UIImage(named: "Domestic_cat_mean_face") else {
            return
        }
        self.bgImageView.contentMode = .scaleAspectFill
        self.bgImageView.image = img
        self.bgImageView.clipsToBounds = true
        
        if filterName == "CIAdditionCompositing" {
            let filter = CIFF.AdditionCompositing(inputImage: _forImg.convertUIImageToCIImage(), backgroundImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIColorBlendMode" {
            // 使用背景的亮度值以及源图像的色调和饱和度值。
            let filter = CIFF.ColorBlendMode(inputImage: _forImg.convertUIImageToCIImage(), backgroundImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIColorBurnBlendMode" {
            // 使背景图像样本变暗以反映源图像样本。
            let filter = CIFF.ColorBurnBlendMode(inputImage: _forImg.convertUIImageToCIImage(), backgroundImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIColorDodgeBlendMode" {
            // 使背景图像样本变亮以反映源图像样本
            let filter = CIFF.ColorDodgeBlendMode(inputImage: _forImg.convertUIImageToCIImage(), backgroundImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIDarkenBlendMode" {
            // 通过选择较暗的样本（来自源图像或背景）来创建合成图像样本
            let filter = CIFF.DarkenBlendMode(inputImage: _forImg.convertUIImageToCIImage(), backgroundImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIDifferenceBlendMode" {
            // 从背景图像样本颜色中减去源图像样本颜色，或者相反，具体取决于哪个样本具有更大的亮度值。
            let filter = CIFF.DifferenceBlendMode(inputImage: _forImg.convertUIImageToCIImage(), backgroundImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIDivideBlendMode" {
            // 将背景图像样本颜色与源图像样本颜色分开。
            let filter = CIFF.DivideBlendMode(inputImage: _forImg.convertUIImageToCIImage(), backgroundImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIExclusionBlendMode" {
            // 产生与 CIDifferenceBlendMode 滤镜相似的效果，但对比度较低。
            let filter = CIFF.ExclusionBlendMode(inputImage: _forImg.convertUIImageToCIImage(), backgroundImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIHardLightBlendMode" {
            // 根据源图像样本颜色，相乘或屏蔽颜色。
            let filter = CIFF.HardLightBlendMode(inputImage: _forImg.convertUIImageToCIImage(), backgroundImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIHueBlendMode" {
            // 将背景图像的亮度和饱和度值与输入图像的色调结合使用。
            let filter = CIFF.HueBlendMode(inputImage: _forImg.convertUIImageToCIImage(), backgroundImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CILightenBlendMode" {
            // 通过选择较亮的样本（来自源图像或背景）来创建合成图像样本。
            let filter = CIFF.LightenBlendMode(inputImage: _forImg.convertUIImageToCIImage(), backgroundImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CILinearBurnBlendMode" {
            // 使背景图像样本变暗以反映源图像样本，同时增加对比度。
            let filter = CIFF.LinearBurnBlendMode(inputImage: _forImg.convertUIImageToCIImage(), backgroundImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CILinearDodgeBlendMode" {
            // 使背景图像样本变亮以反映源图像样本，同时还增加对比度。
            let filter = CIFF.LinearDodgeBlendMode(inputImage: _forImg.convertUIImageToCIImage(), backgroundImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CILuminosityBlendMode" {
            // 使用背景图像的色调和饱和度以及输入图像的亮度。
            let filter = CIFF.LuminosityBlendMode(inputImage: _forImg.convertUIImageToCIImage(), backgroundImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIMaximumCompositing" {
            // 按颜色分量计算两个输入图像的最大值，并使用最大值创建输出图像。
            let filter = CIFF.MaximumCompositing(inputImage: _forImg.convertUIImageToCIImage(), backgroundImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIMinimumCompositing" {
            // 按颜色分量计算两个输入图像的最小值，并使用最小值创建输出图像。
            let filter = CIFF.MinimumCompositing(inputImage: _forImg.convertUIImageToCIImage(), backgroundImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIMultiplyBlendMode" {
            // 将输入图像样本与背景图像样本相乘。
            let filter = CIFF.MultiplyBlendMode(inputImage: _forImg.convertUIImageToCIImage(), backgroundImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIMultiplyCompositing" {
            // 将两个输入图像的颜色分量相乘并使用相乘值创建输出图像。
            let filter = CIFF.MultiplyCompositing(inputImage: _forImg.convertUIImageToCIImage(), backgroundImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIOverlayBlendMode" {
            // 根据背景颜色，将输入图像样本与背景图像样本相乘或筛选。
            let filter = CIFF.OverlayBlendMode(inputImage: _forImg.convertUIImageToCIImage(), backgroundImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIPinLightBlendMode" {
            // 根据源图像样本的亮度，有条件地将背景图像样本替换为源图像样本。
            let filter = CIFF.PinLightBlendMode(inputImage: _forImg.convertUIImageToCIImage(), backgroundImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CISaturationBlendMode" {
            // 使用背景图像的亮度和色调值以及输入图像的饱和度。
            let filter = CIFF.SaturationBlendMode(inputImage: _forImg.convertUIImageToCIImage(), backgroundImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIScreenBlendMode" {
            // 将输入图像样本的倒数与背景图像样本的倒数相乘。
            let filter = CIFF.ScreenBlendMode(inputImage: _forImg.convertUIImageToCIImage(), backgroundImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CISoftLightBlendMode" {
            // 使颜色变暗或变亮，具体取决于输入图像样本颜色。
            let filter = CIFF.SoftLightBlendMode(inputImage: _forImg.convertUIImageToCIImage(), backgroundImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CISourceAtopCompositing" {
            // 将输入图像放置在背景图像上，然后使用背景图像的亮度来确定要显示的内容。
            let filter = CIFF.SourceAtopCompositing(inputImage: _forImg.convertUIImageToCIImage(), backgroundImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CISourceInCompositing" {
            // 使用背景图像来定义输入图像中保留的内容，从而有效地裁剪输入图像。
            let filter = CIFF.SourceInCompositing(inputImage: _forImg.convertUIImageToCIImage(), backgroundImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CISourceOutCompositing" {
            // 使用背景图像来定义从输入图像中提取哪些内容。
            let filter = CIFF.SourceOutCompositing(inputImage: _forImg.convertUIImageToCIImage(), backgroundImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CISourceOverCompositing" {
            // 将输入图像放置在输入背景图像上。
            let filter = CIFF.SourceOverCompositing(inputImage: _forImg.convertUIImageToCIImage(), backgroundImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CISubtractBlendMode" {
            // 从源图像样本颜色中减去背景图像样本颜色。
            let filter = CIFF.SubtractBlendMode(inputImage: _forImg.convertUIImageToCIImage(), backgroundImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
    }
    
    func CICategoryDistortionEffect(filterName: String) {
        guard let img = UIImage(named: "Flower.jpg"), let _forImg = UIImage(named: "CICircularWrap") else {
            return
        }
        self.bgImageView.contentMode = .scaleAspectFill
        self.bgImageView.image = img
        
        if filterName == "CIBumpDistortion" {
            // 创建源自图像中指定点的凹凸。
            let filter = CIFF.BumpDistortion(inputImage: img.convertUIImageToCIImage(), radius: 100.0, scale: 0.5)
            self._CIFFFilter = filter
        }
        
        if filterName == "CIBumpDistortionLinear" {
            // 创建源于图像中的一条线的凹形或凸形扭曲。
            let filter = CIFF.BumpDistortionLinear(inputImage: img.convertUIImageToCIImage(), radius: 200.0, angle: Double.pi * 0.3, scale: 0.5)
            self._CIFFFilter = filter
        }
        
        if filterName == "CICircleSplashDistortion" {
            // 扭曲从圆的圆周开始并向外发散的像素。
            let filter = CIFF.CircleSplashDistortion(inputImage: img.convertUIImageToCIImage(), radius: 100.0)
            self._CIFFFilter = filter
        }
        
        if filterName == "CICircularWrap" {
            self.bgImageView.image = _forImg
            // 扭曲从圆的圆周开始并向外发散的像素。
            let filter = CIFF.CircularWrap(inputImage: _forImg.convertUIImageToCIImage(), radius: 200.0, angle: Double.pi * 0.3)
            self._CIFFFilter = filter
        }
        
        if filterName == "CIDroste" {
            self._slider?.minimumValue = -10
            self._slider?.maximumValue = 10
            self._slider?.value = 1
            // 模仿 M. C. Escher 绘图，递归绘制图像的一部分。
            let filter = CIFF.Droste(inputImage: img.convertUIImageToCIImage(), insetPoint0: CGPoint(x: 200, y: 200), insetPoint1: CGPoint(x: 400, y: 400), periodicity: 1.0, rotation: .zero, zoom: CIFF.Droste.zoomDefault)
            self._CIFFFilter = filter
        }
        
        if filterName == "CIDisplacementDistortion" {
            self._slider?.minimumValue = 0
            self._slider?.maximumValue = 100
            self._slider?.value = 50
            // 将第二个图像的灰度值应用到第一个图像。
            let filter = CIFF.DisplacementDistortion(inputImage: img.convertUIImageToCIImage(), displacementImage: _forImg.convertUIImageToCIImage())
            self._CIFFFilter = filter
        }
        
        if filterName == "CIGlassDistortion" {
            self._slider?.minimumValue = 0
            self._slider?.maximumValue = 100
            self._slider?.value = 50
            // 通过应用类似玻璃的纹理来扭曲图像。
            let filter = CIFF.GlassDistortion(inputImage: img.convertUIImageToCIImage(), texture: _forImg.convertUIImageToCIImage(), center: CIFF.GlassDistortion.centerDefault)
            self._CIFFFilter = filter
        }
        
        if filterName == "CIGlassLozenge" {
            self._slider?.minimumValue = 0
            self._slider?.maximumValue = 10
            self._slider?.value = 1.7
            // 通过应用类似玻璃的纹理来扭曲图像。
            let filter = CIFF.GlassLozenge(inputImage: img.convertUIImageToCIImage(),point0: CGPoint(x: img.size.width * 0.4, y: img.size.height * 0.4), point1: CGPoint(x: img.size.width * 0.7, y: img.size.height * 0.8), radius: CIFF.GlassLozenge.radiusDefault)
            self._CIFFFilter = filter
        }
        
        if filterName == "CIHoleDistortion" {
            // 创建一个圆形区域，将图像像素向外推，使最接近圆形的像素变形最多。
            let filter = CIFF.HoleDistortion(inputImage: img.convertUIImageToCIImage(), radius: CIFF.HoleDistortion.radiusDefault)
            self._CIFFFilter = filter
        }
        
        if filterName == "CILightTunnel" {
            // 旋转由中心和半径参数指定的输入图像的一部分以产生隧道效果。
            let filter = CIFF.LightTunnel(inputImage: img.convertUIImageToCIImage(), rotation: CIFF.LightTunnel.rotationDefault, radius: CIFF.LightTunnel.radiusDefault)
            self._CIFFFilter = filter
        }
        
        if filterName == "CIPinchDistortion" {
            // 创建一个圆形区域，将图像像素向外推，使最接近圆形的像素变形最多。
            let filter = CIFF.PinchDistortion(inputImage: self.bgImageView.image!.convertUIImageToCIImage(), center: CGPoint(x: img.size.width * 0.5, y: img.size.height * 0.5), radius: CIFF.PinchDistortion.radiusDefault * 0.3)
            self._CIFFFilter = filter
        }
        
        if filterName == "CIStretchCrop" {
            self._slider?.minimumValue = 0.5
            self._slider?.maximumValue = 10
            // 通过拉伸和/或裁剪图像来扭曲图像以适合目标尺寸。
            let filter = CIFF.StretchCrop(inputImage: img.convertUIImageToCIImage(), size: CGPoint(x: img.size.width * 0.3, y: img.size.height * 0.3), cropAmount: 0.5, centerStretchAmount: 0.6)
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CITorusLensDistortion" {
            self._slider?.minimumValue = 0
            self._slider?.maximumValue = 10
            self._slider?.value = 1.7
            // 创建环形透镜并扭曲放置透镜的图像部分。
            let filter = CIFF.TorusLensDistortion(inputImage: img.convertUIImageToCIImage(), center: CGPoint(x: img.size.width * 0.5, y: img.size.height * 0.5), radius: CIFF.TorusLensDistortion.radiusDefault, width: CIFF.TorusLensDistortion.widthDefault)
            self._CIFFFilter = filter
        }
        
        if filterName == "CITwirlDistortion" {
            // 围绕点旋转像素以产生旋转效果。
            let filter = CIFF.TwirlDistortion(inputImage: img.convertUIImageToCIImage(), center: CGPoint(x: img.size.width * 0.5, y: img.size.height * 0.5), radius: CIFF.TwirlDistortion.radiusDefault)
            self._CIFFFilter = filter
        }
        
        if filterName == "CIVortexDistortion" {
            // 围绕点旋转像素以模拟漩涡。
            let filter = CIFF.VortexDistortion(inputImage: img.convertUIImageToCIImage(), center: CGPoint(x: img.size.width * 0.5, y: img.size.height * 0.5), radius: CIFF.VortexDistortion.radiusDefault)
            self._CIFFFilter = filter
        }
    }
    
    func CICategoryGenerator(filterName: String) {
        if filterName == "CIAztecCodeGenerator" {
            let filter = CIFF.AztecCodeGenerator(message: "xiao yu xi li li".data(using: String.Encoding.isoLatin1)!, layers: 4, compactStyle: true)
            if let _f_i = filter?.outputImage {
                self.bgImageView.contentMode = .scaleAspectFit
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CICheckerboardGenerator" {
            let filter = CIFF.CheckerboardGenerator(center: CGPoint.zero, color0: CIColor(color: UIColor.white), color1: CIColor(color: UIColor.black), width: 20.0, sharpness: 1.0)
            if let _f_i = filter?.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
        
        if filterName == "CICode128BarcodeGenerator" {
            let filter = CIFF.Code128BarcodeGenerator(message: "xiaoyu xilili".data(using: String.Encoding.utf8)!, quietSpace: 10)
            if let _f_i = filter?.outputImage {
                self.bgImageView.contentMode = .scaleAspectFit
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIConstantColorGenerator" {
            // 生成纯色图片
            let filter = CIFF.ConstantColorGenerator(color: CIColor(color: UIColor.systemPink))
            if let _f_i = filter?.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
        
        if filterName == "CILenticularHaloGenerator" {
            // 模拟镜头光晕。
            let filter = CIFF.LenticularHaloGenerator(center: CGPoint(x: 200, y: 500), color: CIColor(color: UIColor.systemPink), haloRadius: 30, haloWidth: 50, haloOverlap: 0, striationStrength: 0.5, striationContrast: CIFF.LenticularHaloGenerator.striationContrastDefault, time: 0.5)
            if let _f_i = filter?.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
        
        if filterName == "CIPDF417BarcodeGenerator" {
            // TODO 条形码生成错误
            // 从输入数据生成 PDF417 代码（二维条形码）
            let filter = CIFF.PDF417BarcodeGenerator(message: "xiaoyu xilili".data(using: String.Encoding.ascii)!, minWidth: 100, maxWidth: 200, minHeight: 50, maxHeight: 80, dataColumns: .zero, rows: .zero, preferredAspectRatio: 3.0, compactionMode: 3, compactStyle: true, correctionLevel: 5, alwaysSpecifyCompaction: false)
            if let _f_i = filter?.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
        
        if filterName == "CIQRCodeGenerator" {
            func createUIImageFromCIImage(image: CIImage, size: CGFloat) -> UIImage {
                let extent = image.extent.integral
                let scale = min(size / extent.width, size / extent.height)
                
                /// Create bitmap
                let width: size_t = size_t(extent.width * scale)
                let height: size_t = size_t(extent.height * scale)
                let cs: CGColorSpace = CGColorSpaceCreateDeviceGray()
                let bitmap: CGContext = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 1)!
                
                ///
                let context = CIContext.init()
                let bitmapImage = context.createCGImage(image, from: extent)
                bitmap.interpolationQuality = .none
                bitmap.scaleBy(x: scale, y: scale)
                bitmap.draw(bitmapImage!, in: extent)
                
                let scaledImage = bitmap.makeImage()
                return UIImage.init(cgImage: scaledImage!)
            }
            // 从输入数据生成快速响应代码（二维条形码）。
            let filter = CIFF.QRCodeGenerator(text: "德云社德云社德云社德云社德云社德云社德云社", correction: CIFF.QRCodeGenerator.Level.M)
            if let _f_i = filter?.outputImage {
                self.bgImageView.contentMode = .scaleAspectFit
                self.bgImageView.image = createUIImageFromCIImage(image: _f_i, size: 200)
            }
        }
        
        if filterName == "CIRandomGenerator" {
            // 生成无限范围的图像，其像素值由 0 到 1 范围内的四个独立、均匀分布的随机数组成。
            let filter = CIFF.RandomGenerator()
            if let _f_i = filter?.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
        
        if filterName == "CIStarShineGenerator" {
            self.bgImageView.image = nil
            // 产生类似于超新星的星爆图案； 可用于模拟镜头光晕。
            let filter = CIFF.StarShineGenerator(center: CGPoint(x: 200, y: 500), color: CIColor(color: UIColor.white), radius: 80, crossScale: 20, crossAngle: Double.pi * 0.7, crossOpacity: -2.0, crossWidth: 4, epsilon: -3.0)
            self._CIFFFilter = filter
        }
        
        if filterName == "CIStripesGenerator" {
            self._slider?.minimumValue = 30
            self._slider?.maximumValue = 100
            self._slider?.value = 40
            self.bgImageView.image = nil
            // 生成条纹图案。
            let filter = CIFF.StripesGenerator(center: CGPoint(x: 200, y: 400), color0: CIColor(color: UIColor.white), color1: CIColor(color: UIColor.black), width: 80, sharpness: 1.0)
            self._CIFFFilter = filter
        }
        
        if filterName == "CISunbeamsGenerator" {
            self._slider?.minimumValue = 30
            self._slider?.maximumValue = 150
            self._slider?.value = 40
            self.bgImageView.image = nil
            // 产生阳光效果。
            let filter = CIFF.SunbeamsGenerator(center: CGPoint(x: 200, y: 400), color: CIColor(color: UIColor.white), sunRadius: 80, maxStriationRadius: 5, striationStrength: 0.8, striationContrast: 2, time: 0.5)
            self._CIFFFilter = filter
        }
    }
    
    func GeometryAdjustmentFilter(filterName: String) {
        if filterName == "CIAffineTransform" {
            let filter = CIFilter.init(name: "CIAffineTransform")
            var _ciImage: CIImage? = self.bgImageView.image?.ciImage
            if _ciImage == nil, let _cgImage = self.bgImageView.image?.cgImage {
                _ciImage = CIImage(cgImage: _cgImage)
            }
            
            if _ciImage == nil {
                print("CIImage nil")
            }
            
            filter?.setValue(_ciImage, forKey: kCIInputImageKey)
            filter?.setValue(CGAffineTransform(rotationAngle: Double.pi * 0.2), forKey: kCIInputTransformKey)
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
            self._filter = filter
        }
        
        if filterName == "CICrop" {
//            if let _f_i = self.bgImageView.image?.convertUIImageToCIImage()?.applyingCrop(rectangle: self.bgImageView.bounds.insetBy(dx: 50, dy: 100), isActive: true) {
//                self.bgImageView.image = UIImage(ciImage: _f_i)
//            }
            let filter = CIFF.Crop(inputImage: self.bgImageView.image?.convertUIImageToCIImage())
            self._CIFFFilter = filter
        }
        
        if filterName == "CILanczosScaleTransform" {
            // 改变图片大小,并返回一个高质量的图片
            guard let img = UIImage(named: "Domestic_cat_mean_face") else {
                return
            }
            print("缩放之前图片尺寸 = \(img.size)")
            let filter = CIFF.LanczosScaleTransform(inputImage: img.convertUIImageToCIImage(), scale: 0.4, aspectRatio: 1.0)
            if let _f_i = filter?.outputImage {
                self.bgImageView.contentMode = .scaleAspectFit
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
            print("缩放之后图片尺寸更改为 = \(self.bgImageView.image!.size)")
        }
        
        if filterName == "CIPerspectiveCorrection" {
            // 应用透视校正，将源图像中的任意四边形区域转换为矩形输出图像
            guard let img = UIImage(named: "jiedao") else {
                return
            }
            let filter = CIFF.PerspectiveCorrection(inputImage: img.convertUIImageToCIImage(), topLeft: CGPoint(x: img.size.width * 0.3, y: img.size.height * 0.5), topRight: CGPointZero, bottomRight: CGPoint(x: img.size.width, y: img.size.height * 0.3), bottomLeft: CGPoint(x: img.size.width * 0.3, y: img.size.height * 0.3), crop: true)
            if let _f_i = filter?.outputImage {
                self.bgImageView.contentMode = .scaleAspectFit
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIPerspectiveTransform" {
            guard let img = UIImage(named: "Domestic_cat_mean_face") else {
                return
            }
            // 改变图像的几何形状以模拟观察者改变观看位置
            let filter = CIFF.PerspectiveTransform(inputImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIPerspectiveTransformWithExtent" {
            guard let img = UIImage(named: "Domestic_cat_mean_face") else {
                return
            }
            // 改变图像的几何形状以模拟观察者改变观看位置
            let filter = CIFF.PerspectiveTransformWithExtent(inputImage: img.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIStraightenFilter" {
            guard let img = UIImage(named: "Domestic_cat_mean_face") else {
                return
            }
            self.bgImageView.image = img
            self.bgImageView.contentMode = .scaleAspectFit
            // 改变图像的几何形状以模拟观察者改变观看位置
            let filter = CIFF.StraightenFilter(inputImage: img.convertUIImageToCIImage())
            self._CIFFFilter = filter
        }
    }
    
    func CICategoryGradient(filterName: String) {
        guard let img = UIImage(named: "MaYu.jpg") else {
            return
        }
        self.bgImageView.clipsToBounds = true
        self.bgImageView.contentMode = .scaleAspectFill
        self.bgImageView.image = img
        if filterName == "CIGaussianGradient" {
            self.bgImageView.image = nil
            self._slider?.minimumValue = 200
            self._slider?.maximumValue = 500
            // 使用高斯分布生成从一种颜色到另一种颜色变化的渐变。
            let filter = CIFF.GaussianGradient(center: CGPoint(x: 200, y: 400), color0: CIColor(color: UIColor.white), color1: CIColor(color: UIColor.cyan))
            self._CIFFFilter = filter
        }
        
        if filterName == "CILinearGradient" {
            // 生成沿两个定义端点之间的线性轴变化的渐变。
            let filter = CIFF.LinearGradient(point0: CGPoint(x: 100, y: 200), point1: CGPoint(x: 400, y: 600), color0: CIColor(color: UIColor.orange), color1: CIColor(color: UIColor.blue))
            if let _f_i = filter?.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
        
        if filterName == "CIRadialGradient" {
            // 生成在具有相同中心的两个圆之间径向变化的渐变。
            self._slider?.minimumValue = 100
            self._slider?.maximumValue = 200
            let filter = CIFF.RadialGradient(center: CGPoint(x: 200, y: 500), radius0: 10, radius1: 120, color0: CIColor.cyan, color1: CIColor.yellow)
            self._CIFFFilter = filter
        }
        
        if filterName == "CISmoothLinearGradient" {
            // 生成使用 S 曲线函数沿两个定义端点之间的线性轴混合颜色的渐变。
            self._slider?.minimumValue = 100
            self._slider?.maximumValue = 200
            let filter = CIFF.SmoothLinearGradient(point0: CGPoint(x: 200, y: 200), point1: CGPoint(x: 300, y: 600), color0: CIColor.cyan, color1: CIColor.yellow)
            if let _f_i = filter?.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
    }
    
    func CICategoryHalftoneEffect(filterName: String) {
        guard let _img = self.bgImageView.image else {
            return
        }
        let center = CGPoint(x: _img.size.width * 0.3, y: _img.size.height * 0.5)
        self.bgImageView.image = nil
        self._slider?.minimumValue = 1
        self._slider?.maximumValue = 20
        if filterName == "CICircularScreen" {
            // 模拟圆形半色调屏幕。
            let filter = CIFF.CircularScreen(inputImage: _img.convertUIImageToCIImage(), center: center, sharpness: 0.8)
            self._CIFFFilter =  filter
        }
        
        if filterName == "CICMYKHalftone" {
            // 使用青色、品红色、黄色和黑色墨水在白页上创建源图像的彩色半色调再现。
            let filter = CIFF.CMYKHalftone(inputImage: _img.convertUIImageToCIImage(), center: center, angle: 30, sharpness: 0.8, gCR: CIFF.CMYKHalftone.gCRDefault, uCR: CIFF.CMYKHalftone.uCRDefault)
            self._CIFFFilter =  filter
        }
        
        if filterName == "CIDotScreen" {
            // 模拟半色调屏幕的点图案。
            let filter = CIFF.DotScreen(inputImage: _img.convertUIImageToCIImage(), center: center, angle: 30, sharpness: CIFF.DotScreen.sharpnessDefault)
            self._CIFFFilter =  filter
        }
        
        if filterName == "CIHatchedScreen" {
            // 模拟半色调屏幕的阴影图案。
            let filter = CIFF.HatchedScreen(inputImage: _img.convertUIImageToCIImage(), center: center, angle: 30, sharpness: CIFF.HatchedScreen.sharpnessDefault)
            self._CIFFFilter =  filter
        }
        
        if filterName == "CILineScreen" {
            // 模拟半色调网屏的线条图案。
            let filter = CIFF.LineScreen(inputImage: _img.convertUIImageToCIImage(), center: center, angle: 30, sharpness: CIFF.HatchedScreen.sharpnessDefault)
            self._CIFFFilter =  filter
        }
    }
    
    func CICategoryReduction(filterName: String) {
        guard let _img = self.bgImageView.image else {
            return
        }
        let _rect = CGRect(origin: CGPoint(x: 100, y: 100), size: CGSize(width: 50, height: 50))
        if filterName == "CIAreaAverage" {
            // 返回包含感兴趣区域的平均颜色的单像素图像
            let filter = CIFF.AreaAverage(inputImage: _img.convertUIImageToCIImage(), extent: _rect)
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIAreaHistogram" {
            // 返回一个 1D 图像（inputCount 宽 x 一个像素高），其中包含为指定矩形区域计算的分量直方图。
            let filter = CIFF.AreaHistogram(inputImage: _img.convertUIImageToCIImage(), extent: _rect, scale: CIFF.AreaHistogram.scaleDefault, count: CIFF.AreaHistogram.countDefault)
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIRowAverage" {
            // 返回 1 像素高的图像，其中包含每个扫描行的平均颜色。
            let filter = CIFF.RowAverage(inputImage: _img.convertUIImageToCIImage(), extent: _rect)
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIColumnAverage" {
            // 返回 1 像素高的图像，其中包含每个扫描列的平均颜色。
            let filter = CIFF.ColumnAverage(inputImage: _img.convertUIImageToCIImage(), extent: _rect)
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIHistogramDisplayFilter" {
            // 从 CIAreaHistogram 滤波器的输出生成直方图图像。
            let filter = CIFF.HistogramDisplayFilter(inputImage: _img.convertUIImageToCIImage(), height: CIFF.HistogramDisplayFilter.heightDefault, highLimit: CIFF.HistogramDisplayFilter.highLimitDefault, lowLimit: CIFF.HistogramDisplayFilter.lowLimitDefault)
            if let _f_i = filter?.outputImage {
                let tempImgView: UIImageView = UIImageView(image: UIImage(ciImage: _f_i))
                self.bgImageView.addSubview(tempImgView)
                tempImgView.frame = CGRect(origin: CGPoint(x: 0, y: 10), size: CGSize(width: self.view.bounds.width, height: 100))
            }
        }
        
        if filterName == "CIAreaMaximum" {
            // 返回包含感兴趣区域的最大颜色分量的单像素图像。
            let filter = CIFF.AreaMaximum(inputImage: _img.convertUIImageToCIImage(), extent: _rect)
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIAreaMinimum" {
            // 返回包含感兴趣区域的最小颜色分量的单像素图像。
            let filter = CIFF.AreaMinimum(inputImage: _img.convertUIImageToCIImage(), extent: _rect)
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIAreaMaximumAlpha" {
            // 返回一个单像素图像，其中包含具有感兴趣区域的最大 alpha 值的颜色向量。
            let filter = CIFF.AreaMaximumAlpha(inputImage: _img.convertUIImageToCIImage(), extent: _rect)
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIAreaMinimumAlpha" {
            // 返回一个单像素图像，其中包含具有感兴趣区域的最小 alpha 值的颜色向量。
            let filter = CIFF.AreaMinimumAlpha(inputImage: _img.convertUIImageToCIImage(), extent: _rect)
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
    }
    
    func CICategorySharpen(filterName: String) {
        guard let _img = self.bgImageView.image else {
            return
        }
        self._slider?.minimumValue = 1
        self._slider?.maximumValue = 20
        
        if filterName == "CISharpenLuminance" {
            // 通过锐化增加图像细节。
            let filter = CIFF.SharpenLuminance(inputImage: _img.convertUIImageToCIImage(), sharpness: 0.5)
            self._CIFFFilter = filter
        }
        
        if filterName == "CIUnsharpMask" {
            // 增加图像中不同颜色像素之间的边缘对比度。
            let filter = CIFF.UnsharpMask(inputImage: _img.convertUIImageToCIImage(), intensity: 0.5)
            self._CIFFFilter = filter
        }
    }
    
    func CICategoryStylize(filterName: String) {
        guard let _img = self.bgImageView.image, let _bgImg = UIImage(named: "mask"), let _maskImg = UIImage(named: "maskA"), let _pImg = UIImage(named: "MaYu.jpg") else {
            return
        }
        
        if filterName == "CIBlendWithAlphaMask" {
            // 使用蒙版中的 Alpha 值在图像和背景之间进行插值。
            let filter = CIFF.BlendWithMask(inputImage: _bgImg.convertUIImageToCIImage(), backgroundImage: _img.convertUIImageToCIImage(), maskImage: _maskImg.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIBlendWithMask" {
            // 使用灰度蒙版中的值在图像和背景之间进行插值。
            let filter = CIFF.BlendWithMask(inputImage: _bgImg.convertUIImageToCIImage(), backgroundImage: _img.convertUIImageToCIImage(), maskImage: _maskImg.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIBloom" {
            // 柔化边缘并为图像带来宜人的光泽。
            self._slider?.minimumValue = 1
            self._slider?.maximumValue = 30
            let filter = CIFF.Bloom(inputImage: _img.convertUIImageToCIImage(), intensity: 0.5)
            self._CIFFFilter = filter
        }
        
        if filterName == "CIComicEffect" {
            // 通过勾勒边缘并应用颜色半色调效果来模拟漫画书绘画。
            let filter = CIFF.ComicEffect(inputImage: _pImg.convertUIImageToCIImage())
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIConvolution3X3" {
            // 通过执行 3x3 矩阵卷积来修改像素值。
            let filter = CIFF.Convolution3X3(inputImage: _img.convertUIImageToCIImage(), weights: CIVector(values: [0.3, 0.3, 0.3, 0.5, 1.0, 0.8, 0.3, 0.3, 0.2], count: 9), bias: 0.6)
            if let _f_i = filter?.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
        
        if filterName == "CIConvolution5X5" {
            // 通过执行 5x5 矩阵卷积来修改像素值。
            let filter = CIFF.Convolution5X5(inputImage: _img.convertUIImageToCIImage(), weights: CIFF.Convolution5X5.weightsDefault, bias: 0.6)
            if let _f_i = filter?.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
        
        if filterName == "CIConvolution7X7" {
            // 通过执行 7x7 矩阵卷积来修改像素值。
            let filter = CIFF.Convolution7X7(inputImage: _img.convertUIImageToCIImage(), weights: CIFF.Convolution7X7.weightsDefault, bias: 0.6)
            if let _f_i = filter?.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
        
        if filterName == "CIConvolution9Horizontal" {
            // 通过执行 9 元素水平卷积来修改像素值。
            let filter = CIFF.Convolution9Horizontal(inputImage: _img.convertUIImageToCIImage(), weights: CIVector(values: [1.0, -1.0, 1.0, 0.0, 1.0, 0.0, -1.0, 1.0, -1.0], count: 9), bias: 0.6)
            if let _f_i = filter?.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
        
        if filterName == "CIConvolution9Vertical" {
            // 通过执行 9 元素垂直卷积来修改像素值。
            let filter = CIFF.Convolution9Vertical(inputImage: _img.convertUIImageToCIImage(), weights: CIVector(values: [1.0, -1.0, 1.0, 0.0, 1.0, 0.0, -1.0, 1.0, -1.0], count: 9), bias: 0.6)
            if let _f_i = filter?.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
        
        if filterName == "CICrystallize" {
            self._slider?.minimumValue = 10
            self._slider?.maximumValue = 100
            // 通过聚合源像素颜色值创建多边形颜色块。
            let filter = CIFF.Crystallize(inputImage: _img.convertUIImageToCIImage(), center: CGPoint(x: _img.size.width * 0.4, y: _img.size.height * 0.5))
            self._CIFFFilter = filter
        }
        
        if filterName == "CIDepthOfField" {
            // 模拟景深效果。
            let filter = CIFF.DepthOfField(inputImage: _img.convertUIImageToCIImage(), point0: CGPoint(x: _img.size.width * 0.4, y: _img.size.height * 0.5), point1: CGPoint(x: _img.size.width * 0.8, y: _img.size.height * 0.9), saturation: 0.8, unsharpMaskIntensity: 0.8, radius: 0.8)
            self._CIFFFilter = filter
        }
        
        if filterName == "CIEdges" {
            // 查找图像中的所有边缘并以颜色显示它们。
            let filter = CIFF.Edges(inputImage: _pImg.convertUIImageToCIImage())
            self._CIFFFilter = filter
        }
        
        if filterName == "CIEdgeWork" {
            self._slider?.minimumValue = 1
            self._slider?.maximumValue = 30
            // 查找图像中的所有边缘并以颜色显示它们。
            let filter = CIFF.EdgeWork(inputImage: _pImg.convertUIImageToCIImage())
            self._CIFFFilter = filter
        }
        
        if filterName == "CIGloom" {
            // 使图像的亮点变得暗淡。
            let filter = CIFF.Gloom(inputImage: _pImg.convertUIImageToCIImage(), radius: 20)
            self._CIFFFilter = filter
        }
        
        if filterName == "CIHeightFieldFromMask" {
            guard let _ziImg = UIImage(named: "zi") else {
                return
            }
            self._slider?.minimumValue = 3
            self._slider?.maximumValue = 100
            // 从灰度蒙版产生连续的三维、阁楼形状的高度场。
            let filter = CIFF.HeightFieldFromMask(inputImage: _ziImg.convertUIImageToCIImage())
            self._CIFFFilter = filter
        }
        
        if filterName == "CIHexagonalPixellate" {
            self._slider?.minimumValue = 3
            self._slider?.maximumValue = 20
            // 将图像映射到彩色六边形，其颜色由替换的像素定义。
            let filter = CIFF.HexagonalPixellate(inputImage: _img.convertUIImageToCIImage(), center: CGPoint(x: _img.size.width * 0.4, y: _img.size.height * 0.5))
            self._CIFFFilter = filter
        }
        
        if filterName == "CIHighlightShadowAdjust" {
            self._slider?.minimumValue = -1
            self._slider?.maximumValue = 1
            // 调整图像的色调映射，同时保留空间细节。
            let filter = CIFF.HighlightShadowAdjust(inputImage: _img.convertUIImageToCIImage(), highlightAmount: 1.0)
            self._CIFFFilter = filter
        }
        
        if filterName == "CILineOverlay" {
            // 创建以黑色勾勒出图像边缘的草图。
            let filter = CIFF.LineOverlay(inputImage: _img.convertUIImageToCIImage(), nRNoiseLevel: 0.07, nRSharpness: 0.31, edgeIntensity: 0.3, threshold: 0.3, contrast: 30)
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIPixellate" {
            self._slider?.minimumValue = 3
            self._slider?.maximumValue = 20
            // 通过将图像映射到彩色方块（其颜色由替换的像素定义）来使图像变得块状。
            let filter = CIFF.Pixellate(inputImage: _img.convertUIImageToCIImage(), center: CGPoint(x: _img.size.width * 0.4, y: _img.size.height * 0.5))
            self._CIFFFilter = filter
        }
        
        if filterName == "CIPointillize" {
            self._slider?.minimumValue = 3
            self._slider?.maximumValue = 50
            // 以点画风格渲染源图像。
            let filter = CIFF.Pointillize(inputImage: _img.convertUIImageToCIImage(), center: CGPoint(x: _img.size.width * 0.4, y: _img.size.height * 0.5))
            self._CIFFFilter = filter
        }
        
        if filterName == "CIShadedMaterial" {
            guard let _ziImg = UIImage(named: "zi") else {
                return
            }
            self._slider?.minimumValue = 3
            self._slider?.maximumValue = 50
            // 从高度场生成阴影图像。
            let filter = CIFF.ShadedMaterial(inputImage: _ziImg.convertUIImageToCIImage(), shadingImage: _bgImg.convertUIImageToCIImage())
            self._CIFFFilter = filter
        }
        
        if filterName == "CISpotColor" {
            // 用专色替换一种或多种颜色范围。
            let filter = CIFF.SpotColor(inputImage: _img.convertUIImageToCIImage(), centerColor1: CIColor.green, replacementColor1: CIColor.red, closeness1: 0.22, contrast1: 0.9, centerColor2: CIColor.yellow, replacementColor2: CIColor.cyan, closeness2: 0.3, contrast2: 0.6, centerColor3: CIColor.blue, replacementColor3: CIColor.cyan, closeness3: 0.6, contrast3: 0.9)
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CISpotLight" {
            self._slider?.minimumValue = 3
            self._slider?.maximumValue = 20
            // 将定向聚光灯效果应用于图像。
            let filter = CIFF.SpotLight(inputImage: _img.convertUIImageToCIImage(), lightPosition: CIFF.CIPosition3.init(x: 400, y: 600, z: 150), lightPointsAt: CIFF.CIPosition3.init(x: 100, y: 200, z: .zero), concentration: 0.3, color: CIColor.red)
            self._CIFFFilter = filter
        }
    }
    
    func CICategoryTileEffect(filterName: String) {
        guard let _img = self.bgImageView.image, let colorImg = UIImage(named: "color"), let _myImg = UIImage(named: "MaYu.jpg") else {
            return
        }
        
        if filterName == "CIAffineClamp" {
            // 对源图像执行仿射变换，然后夹紧变换图像边缘的像素，并将其向外延伸。
            let filter = CIFF.AffineClamp(inputImage: _img.convertUIImageToCIImage(), transform: CIFF.CIAffineTransform(CGAffineTransform(scaleX: 0.4, y: 0.8)))
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIAffineTile" {
            // 对图像应用仿射变换，然后平铺变换后的图像。
            let filter = CIFF.AffineTile(inputImage: _img.convertUIImageToCIImage(), transform: CIFF.CIAffineTransform(CGAffineTransform(rotationAngle: Double.pi * 0.3)))
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
        
        if filterName == "CIEightfoldReflectedTile" {
            self.bgImageView.image = colorImg
            self.bgImageView.contentMode = .scaleAspectFit
            // 通过应用 8 向反射对称性从源图像生成平铺图像。
            let filter = CIFF.EightfoldReflectedTile(inputImage: colorImg.convertUIImageToCIImage(), center: CGPoint(x: _img.size.width * 0.4, y: _img.size.height * 0.7), angle: Double.pi * 0.7, width: 100)
            if let _f_i = filter?.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
        
        if filterName == "CIFourfoldReflectedTile" {
            self.bgImageView.image = colorImg
            self.bgImageView.contentMode = .scaleAspectFit
            // 通过应用 4 向反射对称性从源图像生成平铺图像。
            let filter = CIFF.FourfoldReflectedTile(inputImage: colorImg.convertUIImageToCIImage(), center: CGPoint(x: _img.size.width * 0.4, y: _img.size.height * 0.7), angle: Double.pi * 0.7, width: 100)
            if let _f_i = filter?.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
        
        if filterName == "CIFourfoldRotatedTile" {
            self.bgImageView.image = colorImg
            self.bgImageView.contentMode = .scaleAspectFit
            // 通过以 90 度的增量旋转源图像，从源图像生成平铺图像。
            let filter = CIFF.FourfoldRotatedTile(inputImage: colorImg.convertUIImageToCIImage(), center: CGPoint(x: _img.size.width * 0.4, y: _img.size.height * 0.7), angle: Double.pi * 0.7, width: 100)
            if let _f_i = filter?.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
        
        if filterName == "CIFourfoldTranslatedTile" {
            self.bgImageView.image = colorImg
            self.bgImageView.contentMode = .scaleAspectFit
            // 通过应用 4 次平移操作，从源图像生成平铺图像。
            let filter = CIFF.FourfoldTranslatedTile(inputImage: colorImg.convertUIImageToCIImage(), center: CGPoint(x: _img.size.width * 0.4, y: _img.size.height * 0.7), angle: Double.pi * 0.7, width: 100, acuteAngle: 2)
            if let _f_i = filter?.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
        
        if filterName == "CIGlideReflectedTile" {
            self.bgImageView.image = colorImg
            self.bgImageView.contentMode = .scaleAspectFit
            // 通过平移和涂抹图像，从源图像生成平铺图像。
            let filter = CIFF.GlideReflectedTile(inputImage: colorImg.convertUIImageToCIImage(), center: CGPoint(x: _img.size.width * 0.4, y: _img.size.height * 0.7), angle: Double.pi * 0.7, width: 100)
            if let _f_i = filter?.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
        
        if filterName == "CIKaleidoscope" {
            self.bgImageView.image = _myImg
            // 通过应用 12 向对称性从源图像生成万花筒图像。
            let filter = CIFF.Kaleidoscope(inputImage: _myImg.convertUIImageToCIImage(), count: 10, center: self.view.center, angle: Double.pi * 0.5)
            if let _f_i = filter?.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
        
        if filterName == "CIOpTile" {
            self.bgImageView.image = colorImg
            self.bgImageView.contentMode = .scaleAspectFit
            // 应用任何指定的缩放和旋转来分割图像，然后再次组合图像以提供欧普艺术外观。
            let filter = CIFF.OpTile(inputImage: colorImg.convertUIImageToCIImage(), scale: 3, angle: Double.pi * 1.3, width: 100)
            if let _f_i = filter?.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
        
        if filterName == "CIParallelogramTile" {
            // 通过将图像反射为平行四边形来扭曲图像，然后平铺结果。
            let filter = CIFF.ParallelogramTile(inputImage: _img.convertUIImageToCIImage(), center: CGPoint(x: _img.size.width * 0.3, y: _img.size.height * 0.4), angle: Double.pi * 0.5, acuteAngle: 2.0, width: 100)
            if let _f_i = filter?.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
        
        if filterName == "CIPerspectiveTile" {
            // 对图像应用透视变换，然后平铺结果。
            let filter = CIFF.PerspectiveTile(inputImage: _img.convertUIImageToCIImage(), topLeft: CGPoint(x: _img.size.width * 0.2, y: _img.size.height * 0.2), topRight: CGPoint(x: _img.size.width * 0.8, y: _img.size.height * 0.2), bottomRight: CGPoint(x: _img.size.width * 0.8, y: _img.size.height * 0.8), bottomLeft: CGPoint(x: _img.size.width * 0.2, y: _img.size.height * 0.8))
            if let _f_i = filter?.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
        
        if filterName == "CISixfoldReflectedTile" {
            self.bgImageView.image = colorImg
            self.bgImageView.contentMode = .scaleAspectFit
            // 通过应用 6 向反射对称性从源图像生成平铺图像。
            let filter = CIFF.SixfoldReflectedTile(inputImage: colorImg.convertUIImageToCIImage(), center: CGPoint(x: colorImg.size.width * 0.5, y: colorImg.size.height * 0.5), angle: Double.pi * 1.5, width: 100)
            if let _f_i = filter?.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
        
        if filterName == "CISixfoldRotatedTile" {
            self.bgImageView.image = colorImg
            self.bgImageView.contentMode = .scaleAspectFit
            // 通过以 60 度的增量旋转源图像，从源图像生成平铺图像。
            let filter = CIFF.SixfoldRotatedTile(inputImage: colorImg.convertUIImageToCIImage(), center: CGPoint(x: colorImg.size.width * 0.5, y: colorImg.size.height * 0.5), angle: Double.pi * 1.5, width: 100)
            if let _f_i = filter?.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
        
        if filterName == "CITriangleKaleidoscope" {
            // 映射输入图像的三角形部分以创建万花筒效果。
            let filter = CIFF.TriangleKaleidoscope(inputImage: _img.convertUIImageToCIImage(), point: CGPoint(x: _img.size.width * 0.4, y: _img.size.height * 0.5), size: 100, rotation: Double.pi * 0.6, decay: 0.8)
            if let _f_i = filter?.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
        
        if filterName == "CITriangleTile" {
            // 将图像的三角形部分映射到三角形区域，然后平铺结果。
            let filter = CIFF.TriangleTile(inputImage: _img.convertUIImageToCIImage(), center: CGPoint(x: _img.size.width * 0.4, y: _img.size.height * 0.5), angle: Double.pi * 0.6, width: 100)
            if let _f_i = filter?.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
        
        if filterName == "CITwelvefoldReflectedTile" {
            // 通过以 30 度的增量旋转源图像，从源图像生成平铺图像。
            let filter = CIFF.TwelvefoldReflectedTile(inputImage: _img.convertUIImageToCIImage(), center: CGPoint(x: _img.size.width * 0.4, y: _img.size.height * 0.5), angle: Double.pi * 0.6, width: 100)
            if let _f_i = filter?.outputImage, let cgimg = CIContext().createCGImage(_f_i, from: self.bgImageView.bounds) {
                self.bgImageView.image = UIImage(cgImage: cgimg)
            }
        }
    }
    
    @objc func stepTime() {
        time += dt
        if time >= 1 {
            linkTimer?.remove(from: RunLoop.main, forMode: RunLoop.Mode.common)
            linkTimer?.invalidate()
            linkTimer = nil
            print("定时器暂停 -----------")
        } else {
            guard let _img = self.bgImageView.image, let ziImg = UIImage(named: "zi"), let _myImg = UIImage(named: "MaYu.jpg"), let _shadingImg = UIImage(named: "jiedao") else {
                return
            }
            if _filter_name == "CIAccordionFoldTransition" {
                // 通过展开和交叉淡入淡出，从一幅图像过渡到另一幅不同尺寸的图像。
                let filter = CIFF.AccordionFoldTransition(inputImage: _img.convertUIImageToCIImage(), targetImage: _myImg.convertUIImageToCIImage(), bottomHeight: 100, numberOfFolds: 10, foldShadowAmount: 0.5, time: time)
                if let _f_i = filter?.outputImage {
                    self.bgImageView.image = UIImage(ciImage: _f_i)
                }
            }
            
            if _filter_name == "CIBarsSwipeTransition" {
                // 通过在源图像上传递一个条，从一个图像过渡到另一个图像。
                let filter = CIFF.BarsSwipeTransition(inputImage: _img.convertUIImageToCIImage(), targetImage: _myImg.convertUIImageToCIImage(), angle: Double.pi * 0.4, width: 50, barOffset: 40, time: time)
                if let _f_i = filter?.outputImage {
                    self.bgImageView.image = UIImage(ciImage: _f_i)
                }
            }
            
            if _filter_name == "CIDisintegrateWithMaskTransition" {
                dt = 0.03
                // 使用蒙版定义的形状从一幅图像过渡到另一幅图像。
                let filter = CIFF.DisintegrateWithMaskTransition(inputImage: _img.convertUIImageToCIImage(), targetImage: _myImg.convertUIImageToCIImage(), maskImage: ziImg.convertUIImageToCIImage(), time: time, shadowRadius: 10, shadowDensity: 0.7, shadowOffset: CGPoint(x: 3, y: 10))
                if let _f_i = filter?.outputImage {
                    self.bgImageView.image = UIImage(ciImage: _f_i)
                }
            }
            
            if _filter_name == "CIDissolveTransition" {
                dt = 0.001
                // 使用溶解从一张图像过渡到另一张图像。
                let filter = CIFF.DissolveTransition(inputImage: _img.convertUIImageToCIImage(), targetImage: _myImg.convertUIImageToCIImage(), time: time)
                if let _f_i = filter?.outputImage {
                    self.bgImageView.image = UIImage(ciImage: _f_i)
                }
            }
            
            if _filter_name == "CIFlashTransition" {
                // 通过创建闪光从一张图像过渡到另一张图像。
                let filter = CIFF.FlashTransition(inputImage: _img.convertUIImageToCIImage(), targetImage: _myImg.convertUIImageToCIImage(), center: CGPoint(x: _img.size.width * 0.4, y: _img.size.height * 0.4), extent: CGRect(x: 0, y: 0, width: 300, height: 300), color: CIColor.cyan, time: time, maxStriationRadius: 3.0, striationStrength: 0.8, striationContrast: 10, fadeThreshold: 0.9)
                if let _f_i = filter?.outputImage {
                    self.bgImageView.image = UIImage(ciImage: _f_i)
                }
            }
            
            if _filter_name == "CIModTransition" {
                // 通过不规则形状的孔显示目标图像，从一幅图像过渡到另一幅图像。
                let filter = CIFF.ModTransition(inputImage: _img.convertUIImageToCIImage(), targetImage: _myImg.convertUIImageToCIImage(), center: CGPoint(x: _img.size.width * 0.7, y: _img.size.height * 0.7), time: time, angle: Double.pi * 0.4, radius: 150, compression: 200)
                if let _f_i = filter?.outputImage {
                    self.bgImageView.image = UIImage(ciImage: _f_i)
                }
            }
            
            if _filter_name == "CIPageCurlTransition" {
                dt = 0.05
                // 通过模拟卷曲页面，从一张图像过渡到另一张图像，并在页面卷曲时显示新图像。
                let filter = CIFF.PageCurlTransition(inputImage: _img.convertUIImageToCIImage(), targetImage: _myImg.convertUIImageToCIImage(), backsideImage: ziImg.convertUIImageToCIImage(), shadingImage: _shadingImg.convertUIImageToCIImage(), extent: CGRect(origin: CGPoint.zero, size: CGSize(width: _img.size.width * 0.4, height: _img.size.height * 0.5)), time: time, angle: Double.pi * 0.7, radius: 200)
                if let _f_i = filter?.outputImage {
                    self.bgImageView.image = UIImage(ciImage: _f_i)
                }
            }
            
            if _filter_name == "CIPageCurlWithShadowTransition" {
                dt = 0.03
                // 通过模拟卷曲页面，从一张图像过渡到另一张图像，并在页面卷曲时显示新图像。
                let filter = CIFF.PageCurlWithShadowTransition(inputImage: _img.convertUIImageToCIImage(), targetImage: _myImg.convertUIImageToCIImage(), backsideImage: ziImg.convertUIImageToCIImage(), extent: CGRect(origin: CGPoint.zero, size: CGSize(width: _img.size.width * 0.4, height: _img.size.height * 0.5)), time: time, angle: Double.pi * 0.9, radius: 200, shadowSize: 0.8, shadowAmount: 0.8, shadowExtent: CGRect(origin: CGPointZero, size: CGSize(width: _img.size.width * 0.5, height: _img.size.height * 0.4)))
                if let _f_i = filter?.outputImage {
                    self.bgImageView.image = UIImage(ciImage: _f_i)
                }
            }
            
            if _filter_name == "CIRippleTransition" {
                dt = 0.03
                // 通过创建从中心点扩展的圆形波浪，从一个图像过渡到另一个图像，在波浪之后显示新图像。
                let filter = CIFF.RippleTransition(inputImage: _img.convertUIImageToCIImage(), targetImage: _myImg.convertUIImageToCIImage(), shadingImage: ziImg.convertUIImageToCIImage(), center: CGPoint(x: _img.size.width * 0.4, y: _img.size.height * 0.5), extent: CGRect(origin: CGPointZero, size: _img.size), time: time, width: 200, scale: 70)
                if let _f_i = filter?.outputImage {
                    self.bgImageView.image = UIImage(ciImage: _f_i)
                }
            }
            
            if _filter_name == "CISwipeTransition" {
                // 通过模拟滑动动作从一张图像过渡到另一张图像。
                let filter = CIFF.SwipeTransition(inputImage: _img.convertUIImageToCIImage(), targetImage: _myImg.convertUIImageToCIImage(), extent: CGRect(origin: CGPointZero, size: _img.size), color: CIColor.green, time: time, angle: Double.pi * 0.6, width: 200, opacity: 0.8)
                if let _f_i = filter?.outputImage {
                    self.bgImageView.image = UIImage(ciImage: _f_i)
                }
            }
        }
    }
    
    func CICategoryTransition(filterName: String) {
        guard let _img = self.bgImageView.image, let ziImg = UIImage(named: "zi"), let _myImg = UIImage(named: "MaYu.jpg"), let _shadingImg = UIImage(named: "jiedao") else {
            return
        }

        linkTimer = CADisplayLink(target: self, selector: #selector(stepTime))
        linkTimer?.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
        self._filter_name = filterName
        
        if filterName == "CICopyMachineTransition" {
            // 通过模拟复印机的效果从一张图像过渡到另一张图像。
            let filter = CIFF.CopyMachineTransition(inputImage: _img.convertUIImageToCIImage(), targetImage: _myImg.convertUIImageToCIImage(), extent: CGRect(x: _img.size.width * 0.1, y: _img.size.height * 0.2, width: _img.size.width * 0.3, height: _img.size.height * 0.4), color: CIColor.cyan, angle: Double.pi * 1.3, width: _img.size.width * 0.1, opacity: 0.5)
            if let _f_i = filter?.outputImage {
                self.bgImageView.image = UIImage(ciImage: _f_i)
            }
        }
    }
}

extension UIImage {
    func convertUIImageToCIImage() -> CIImage? {
        var ciImage = self.ciImage
        if ciImage == nil {
            if let _cgImage = self.cgImage {
                ciImage = CIImage(cgImage: _cgImage)
            }
        }
        return ciImage
    }
}
