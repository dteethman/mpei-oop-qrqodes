import AVFoundation
import UIKit
import DTBunchOfExt

class QRScanerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    enum LayoutState {
        case scanning
        case taken
    }
    
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
    
    var currentState: LayoutState?
    
    var qr: QRCode?
    

    //MARK:- ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        prepareCaptureSession()

        setupLayout()
        updateLayout(state: .scanning)
        setApperance(isDarkMode)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

        if captureSession?.isRunning == false && currentState == .scanning {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)

        if captureSession?.isRunning == false && currentState == .scanning {
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
        
        setApperance(isDarkMode)
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
            found(code: stringValue)
        }
    }

    //Function called when QR found 
    func found(code: String) {
        print(code)
        qr = QRCode(stringValue: code)
        let image = qr?.getImage() 
        
        if let i = image {
            TapticProvider.entry.provide(.notificationSuccess)
            qrPreviewView.image = i.resizableImage(withCapInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), resizingMode: .stretch)
            updateLayout(state: .taken)
        } else {
            TapticProvider.entry.provide(.notoficationError)
        }
    }

    //Function used to be called on device without camera
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    @objc func backAction(_ sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func retakeAction(_ sender: UIButton!) {
        updateLayout(state: .scanning)
    }
    
    @objc func doneAction(_ sender: UIButton!) {
        let vc = QRSaverViewController()
        vc.qr = self.qr
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
