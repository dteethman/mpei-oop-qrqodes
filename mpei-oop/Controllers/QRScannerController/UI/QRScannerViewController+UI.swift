import UIKit
import AVFoundation

extension QRScanerViewController {
    //MARK:- Setup Layout
    func setupLayout() {
        
        let safeGuide = view.safeAreaLayoutGuide
        if captureSession != nil {
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            let previewBounds = CGRect(x: 0,
                                       y: 0,
                                       width: view.layer.bounds.width,
                                       height: view.layer.bounds.height)
            
            previewLayer.frame = previewBounds
            previewLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(previewLayer)
        }
        
        blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        
        backButton = makeButton(imageName: "arrow.left")
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        retakeButton = makeButton(imageName: "arrow.clockwise")
        retakeButton.translatesAutoresizingMaskIntoConstraints = false
        retakeButton.addTarget(self, action: #selector(retakeAction(_:)), for: .touchUpInside)
        self.view.addSubview(retakeButton)
        
        doneButton = makeButton(imageName: "checkmark")
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.addTarget(self, action: #selector(doneAction(_:)), for: .touchUpInside)
        self.view.addSubview(doneButton)
        
        qrPreviewView = UIImageView()
        qrPreviewView.translatesAutoresizingMaskIntoConstraints = false
        qrPreviewView.backgroundColor = .clear
        qrPreviewView.contentMode = .scaleAspectFill        
        self.view.addSubview(qrPreviewView)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor),
            
            retakeButton.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor, constant: -20),
            retakeButton.trailingAnchor.constraint(equalTo: safeGuide.centerXAnchor, constant: -10),
            retakeButton.heightAnchor.constraint(equalToConstant: 50),
            retakeButton.widthAnchor.constraint(equalTo: backButton.heightAnchor),
            
            doneButton.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor, constant: -20),
            doneButton.leadingAnchor.constraint(equalTo: safeGuide.centerXAnchor, constant: 10),
            doneButton.heightAnchor.constraint(equalToConstant: 50),
            doneButton.widthAnchor.constraint(equalTo: backButton.heightAnchor),
            
            qrPreviewView.bottomAnchor.constraint(equalTo: retakeButton.topAnchor, constant: -30),
            qrPreviewView.centerXAnchor.constraint(equalTo: safeGuide.centerXAnchor),
            qrPreviewView.widthAnchor.constraint(equalTo: safeGuide.widthAnchor, constant: -32),
            qrPreviewView.heightAnchor.constraint(equalTo: qrPreviewView.widthAnchor),
        ])
        
    }
    
    func setApperance(_ isDarkMode: Bool) {
        self.view.backgroundColor = ColorSet.Theme.background.colorForMode(isDarkMode)
        
        backButton?.backgroundColor = ColorSet.Theme.background.colorForMode(isDarkMode)
        retakeButton?.backgroundColor = ColorSet.Theme.background.colorForMode(isDarkMode)
        doneButton?.backgroundColor = ColorSet.Theme.background.colorForMode(isDarkMode)
        
        backButton?.layer.shadowColor = UIColor.systemGray2.cgColor
        backButton?.layer.shadowOpacity = isDarkMode ? 0 : 0.4
        retakeButton?.layer.shadowColor = UIColor.systemGray2.cgColor
        retakeButton?.layer.shadowOpacity = isDarkMode ? 0 : 0.4
        doneButton?.layer.shadowColor = UIColor.systemGray2.cgColor
        doneButton?.layer.shadowOpacity = isDarkMode ? 0 : 0.4
    }
    
    func updateLayout(state: LayoutState) {
        switch state {
        case .scanning:
            currentState = .scanning
            
            if (captureSession?.isRunning == false) {
                captureSession.startRunning()
            }
            if previewLayer?.opacity != 1 {
                let opacityAnimation = CABasicAnimation(keyPath: "opacity")
                opacityAnimation.fromValue = previewLayer?.opacity
                opacityAnimation.toValue = 1
                opacityAnimation.duration = 0.2
                previewLayer?.opacity = 1
                previewLayer?.add(opacityAnimation, forKey: "opacityAnimation")
            }
            
            UIView.animate(withDuration: 0.3) { [self] in
                qrPreviewView?.alpha = 0
                retakeButton?.alpha = 0
                doneButton?.alpha = 0
                blurEffectView?.alpha = 0
            }
            
            
        case .taken:
            currentState = .taken
//            if previewLayer?.opacity != 0 {
//                let opacityAnimation = CABasicAnimation(keyPath: "opacity")
//                opacityAnimation.fromValue = previewLayer?.opacity
//                opacityAnimation.toValue = 0.3
//                opacityAnimation.duration = 0.2
//                previewLayer?.opacity = 0.3
//                previewLayer?.add(opacityAnimation, forKey: "opacityAnimation")
//            }
            
            UIView.animate(withDuration: 0.4) { [self] in
                qrPreviewView?.alpha = 1
                retakeButton?.alpha = 1
                doneButton?.alpha = 1
                blurEffectView?.alpha = 1
            }
        }
        
    }
    
    func makeButton(imageName: String) -> UIButton {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .large)
        let image = UIImage(systemName: imageName, withConfiguration: imageConfig)
        
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 25
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 6
        return button
    }
}
