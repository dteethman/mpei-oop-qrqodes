import AVFoundation
import UIKit
import DTBunchOfExt

class QRScanerView: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    //MARK:- Variables
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var qrPreviewView: UIImageView!
    var backButton: UIButton!
    var cancelButton: UIButton!
    var retakeButton: UIButton!
    var doneButton: UIButton!
    var cardView: UIView!
    
    var blurEffect: UIBlurEffect!
    var blurEffectView: UIVisualEffectView!
    
    var cardViewBottomConstraint: NSLayoutConstraint!
    
    private(set) var codeViewModel: QRCodeViewModel
    private(set) var libraryViewModel: LibraryViewModel
    
    var onDismissAction: (() -> Void)!
    
    
    init(codeViewModel: QRCodeViewModel, libraryViewModel: LibraryViewModel) {
        self.codeViewModel = codeViewModel
        self.libraryViewModel = libraryViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
   
        prepareCaptureSession()
        setupLayout()
        setAppearance(isDarkMode)
        
        codeViewModel.bind { code in
            self.updateLayout(code: code)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

        if captureSession?.isRunning == false && codeViewModel.code == nil {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)

        if captureSession?.isRunning == false && codeViewModel.code == nil {
            captureSession.stopRunning()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        setAppearance(isDarkMode)
        self.view.layoutIfNeeded()
    }
    
    //MARK:- Capture Session Prepare
    func prepareCaptureSession() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            guard accessGranted == true else { return }
        })

        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
    }
    
    //MARK:- AVCapture Output Delegate
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            found(stringValue: stringValue)
        }
    }

    //Function called when QR found 
    func found(stringValue: String) {
        codeViewModel.set(stringValue: stringValue)
    }

    //Function used to be called on device without camera
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    //MARK:- Buttons actions
    @objc func backAction(_ sender: UIButton!) {
        self.dismiss(animated: true) {
            self.libraryViewModel.loadLibrary()
        }
    }
    
    @objc func retakeAction(_ sender: UIButton!) {
        codeViewModel.erase()
    }
    
    @objc func doneAction(_ sender: UIButton!) {
        let vc = QRSaverViewController()
        vc.qr = self.codeViewModel.code
        vc.onDismissAction = self.onDismissAction
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
