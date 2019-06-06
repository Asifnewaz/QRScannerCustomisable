//
//  SwiftQRScanner.swift
//  SwiftQRScanner
//
//  Created by Vinod Jagtap on 12/5/17.
//  Github: https://github.com/vinodiOS
//  Link: https://github.com/vinodiOS/SwiftQRCodeScanner
//
//  Mofified by Asif Newaz on 5/6/19. https://github.com/Asifnewaz
//


import UIKit
import CoreGraphics
import AVFoundation

///QRCodeScannerController is ViewController which calls up method which presents view with AVCaptureSession and previewLayer to scan QR and other codes.

public class QRCodeScannerController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UINavigationBarDelegate {
    
    // Variable for animation
    //扫码区域
    var scanRetangleRect:CGRect = CGRect.zero
    //线条扫码动画封装
    var scanLineAnimation:LBXScanLineAnimation?
    //记录动画状态
    var isAnimationing:Bool = false
    
    // Variable for scanner
    public var mode: QRScanMode = .camera
    var squareView: SquareView?
    public weak var delegate: QRScannerCodeDelegate?
    var flashButton: UIButton = UIButton()
    let nameLabel = UILabel()
    let logoImageView = UIImageView()
    var selectedQRLabel: String = "CashBaba QR"
    
    //Extra images for adding extra features
    public var cameraImage: UIImage?
    public var cancelImage: UIImage?
    public var flashOnImage: UIImage?
    public var flashOffImage: UIImage?
    
    //Default Properties
    let centerFrameWidth: CGFloat = 200.0
    let centerFrameHeight: CGFloat = 200.0
    let qrSelectionViewWidth: CGFloat = 200.0
    let qrSelectionViewHeight: CGFloat = 40.0
    let bottomSpace: CGFloat = 05.0 //60
    let spaceFactor: CGFloat = 16.0
    var devicePosition: AVCaptureDevice.Position = .back
    var delCnt: Int = 0
    
    ///This is for adding delay so user will get sufficient time for align QR within frame
    let delayCount: Int = 15
    
    let imagepicker = UIImagePickerController()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    ///Convinience init for adding extra images (camera, torch, cancel)
    convenience public init(cameraImage: UIImage?, cancelImage: UIImage?, flashOnImage: UIImage?, flashOffImage: UIImage?) {
        self.init()
        self.cameraImage = cameraImage
        self.cancelImage = cancelImage
        self.flashOnImage = flashOnImage
        self.flashOffImage = flashOffImage
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Life cycle methods
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Currently only "Portraint" mode is supported
        

        if imagepicker.isEditing {
            return
        }

        if mode == .camera {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            delCnt = 0
            prepareQRScannerView(self.view)
            startScanningQRCode()
        } else {
            imagepicker.sourceType = .savedPhotosAlbum
            self.present(imagepicker, animated: true, completion: nil)
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.stopScanAnimation()
    }
    
    public override func viewDidLoad() {
         super.viewDidLoad()
        imagepicker.delegate = self
    }
    
    //MARK: - Lazy initialization of properties
    
    ///Initialise CaptureDevice
    lazy var defaultDevice: AVCaptureDevice? = {
        if let device = AVCaptureDevice.default(for: .video) {
            return device
        }
        return nil
    }()
    
    ///Initialise front CaptureDevice
    lazy var frontDevice: AVCaptureDevice? = {
        if #available(iOS 10, *) {
            if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
                return device
            }
        } else {
            for device in AVCaptureDevice.devices(for: .video) {
                if device.position == .front {
                    return device
                }
            }
        }
        return nil
    }()
    
    ///Initialise AVCaptureInput with defaultDevice
    lazy var defaultCaptureInput: AVCaptureInput? = {
        if let captureDevice = defaultDevice {
            do {
                return try AVCaptureDeviceInput(device: captureDevice)
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }()
    
    ///Initialise AVCaptureInput with frontDevice
    lazy var frontCaptureInput: AVCaptureInput?  = {
        if let captureDevice = frontDevice {
            do {
                return try AVCaptureDeviceInput(device: captureDevice)
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }()
    
    lazy var dataOutput = AVCaptureMetadataOutput()
    
    ///Initialise capture session
    lazy var captureSession = AVCaptureSession()
    
    ///Initialise videoPreviewLayer with capture session
    lazy var videoPreviewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        layer.cornerRadius = 10.0
        return layer
    }()
    
    
    /// This calls up methods which makes code ready for scan codes.
    /// - parameter view: UIView in which you want to add scanner.
    func prepareQRScannerView(_ view: UIView) {
        setupCaptureSession(devicePosition) //Default device capture position is rear
        addViedoPreviewLayer(view)
        createCornerFrame()
//        addButtons(view)
    }
    
    
    
    //Toggle torch
    @objc func toggleTorch() {
        //If device postion is front then no need to torch
        if let currentInput = getCurrentInput() {
            if currentInput.device.position == .front {
                return
            }
        }
        
        guard  let defaultDevice = defaultDevice else {return}
        if defaultDevice.isTorchAvailable {
            do {
                try defaultDevice.lockForConfiguration()
                defaultDevice.torchMode = defaultDevice.torchMode == .on ? .off : .on
                if defaultDevice.torchMode == .on {
                    if let flashOnImage = flashOnImage {
                        self.flashButton.setImage(flashOnImage, for: .normal)
                    }
                } else {
                    if let flashOffImage = flashOffImage {
                        self.flashButton.setImage(flashOffImage, for: .normal)
                    }
                }
                
                defaultDevice.unlockForConfiguration()
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
    
    
    @objc func openGallary() {
        imagepicker.sourceType = .savedPhotosAlbum
        self.present(imagepicker, animated: true, completion: nil)
    }
    
    //Switch camera
    @objc func switchCamera() {
        if let frontDeviceInput = frontCaptureInput {
            captureSession.beginConfiguration()
            if let currentInput = getCurrentInput() {
                captureSession.removeInput(currentInput)
                let newDeviceInput = (currentInput.device.position == .front) ? defaultCaptureInput : frontDeviceInput
                captureSession.addInput(newDeviceInput!)
            }
            captureSession.commitConfiguration()
        }
    }
    
    private func getCurrentInput() -> AVCaptureDeviceInput? {
        if let currentInput = captureSession.inputs.first as? AVCaptureDeviceInput {
            return currentInput
        }
        return nil
    }
    
    @objc func dismissVC() {
        self.stopScanAnimation()
        self.dismiss(animated: true, completion: nil)
        delegate?.qrScannerDidCancel(self)
    }
    
    //MARK: - Setup and start capturing session
    
    open func startScanningQRCode() {
        if captureSession.isRunning {
            return
        }
        captureSession.startRunning()
    }
    
    private func setupCaptureSession(_ devicePostion: AVCaptureDevice.Position) {
        if captureSession.isRunning {
            return
        }
        
        switch devicePosition {
        case .front:
            if let frontDeviceInput = frontCaptureInput {
                if !captureSession.canAddInput(frontDeviceInput) {
                    delegate?.qrScannerDidFail(self, error: "Failed to add Input")
                    self.dismiss(animated: true, completion: nil)
                    return
                }
                captureSession.addInput(frontDeviceInput)
            }
            break;
        case .back, .unspecified :
            if let defaultDeviceInput = defaultCaptureInput {
                if !captureSession.canAddInput(defaultDeviceInput) {
                    delegate?.qrScannerDidFail(self, error: "Failed to add Input")
                    self.dismiss(animated: true, completion: nil)
                    return
                }
                captureSession.addInput(defaultDeviceInput)
            }
            break
        }
        
        if !captureSession.canAddOutput(dataOutput) {
            delegate?.qrScannerDidFail(self, error: "Failed to add Output")
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        captureSession.addOutput(dataOutput)
        dataOutput.metadataObjectTypes = dataOutput.availableMetadataObjectTypes
        dataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
    }
    
    ///Inserts layer to view
    private func addViedoPreviewLayer(_ view: UIView) {
        videoPreviewLayer.frame = CGRect(x:view.bounds.origin.x, y: view.bounds.origin.y, width: view.bounds.size.width, height: view.bounds.size.height - bottomSpace)
        view.layer.insertSublayer(videoPreviewLayer, at: 0)
    }
    
    /// This method get called when Scanning gets complete
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        for data in metadataObjects {
            let transformed = videoPreviewLayer.transformedMetadataObject(for: data) as? AVMetadataMachineReadableCodeObject
            if let unwraped = transformed {
                if view.bounds.contains(unwraped.bounds) {
                    delCnt = delCnt + 1
                    if delCnt > delayCount {
                        if let unwrapedStringValue = unwraped.stringValue {
                            delegate?.qrScanner(self, scanDidComplete: unwrapedStringValue)
                        } else {
                            delegate?.qrScannerDidFail(self, error: "Empty string found")
                        }
                        captureSession.stopRunning()
                        self.stopScanAnimation()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    ///This method get called when scan mode is Gallery
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let qrcodeImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let detector:CIDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
            let ciImage:CIImage=CIImage(image:qrcodeImg)!
            var qrCodeLink=""
            
            let features=detector.features(in: ciImage)
            for feature in features as! [CIQRCodeFeature] {
                qrCodeLink += feature.messageString!
            }
            
            if qrCodeLink=="" {
                print("nothing")
            }else{
                print("message: \(qrCodeLink)")
            }
        }
        else{
            print("Something went wrong")
        }
        self.stopScanAnimation()
        self.dismiss(animated: true, completion: nil)
        //dismiss(animated: true, completion: nil)
    }
    
}


///Currently Scanner suppoerts only portrait mode.
///This makes sure orientation is portrait
extension QRCodeScannerController {
    ///Make orientations to portrait
    override public var shouldAutorotate: Bool {
        return false
    }
    
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override public var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
}
