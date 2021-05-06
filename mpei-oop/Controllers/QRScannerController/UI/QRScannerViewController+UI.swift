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
        
//        backButton = makeButton(imageName: "arrow.left")
        backButton = UIButton()
        backButton.setTitle("Cancel", for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.layer.cornerRadius = 8
        backButton.layer.cornerCurve = .continuous
        backButton.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.layer.cornerRadius = 12
        cardView.layer.cornerCurve = .continuous
        self.view.addSubview(cardView)
        
        cancelButton = makeSymbolicButton(imageName: "xmark")
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.tintColor = .red
        cancelButton.layer.cornerRadius = 8
        cancelButton.layer.cornerCurve = .continuous
        cancelButton.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
        cardView.addSubview(cancelButton)
        
        retakeButton = makeSymbolicButton(imageName: "arrow.triangle.2.circlepath")
        retakeButton.translatesAutoresizingMaskIntoConstraints = false
        retakeButton.layer.cornerRadius = 8
        retakeButton.layer.cornerCurve = .continuous
        retakeButton.addTarget(self, action: #selector(retakeAction(_:)), for: .touchUpInside)
        cardView.addSubview(retakeButton)
        
        doneButton = UIButton()
        doneButton.setTitle("Continue", for: .normal)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.layer.cornerRadius = 8
        doneButton.layer.cornerCurve = .continuous
        doneButton.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
        cardView.addSubview(doneButton)
        
        qrPreviewView = UIImageView()
        qrPreviewView.translatesAutoresizingMaskIntoConstraints = false
        qrPreviewView.backgroundColor = .clear
        qrPreviewView.contentMode = .scaleAspectFill

        cardView.addSubview(qrPreviewView)

        cardViewBottomConstraint = cardView.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor, constant: 500)
        NSLayoutConstraint.activate([
            backButton.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor, constant: -28),
            backButton.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 36),
            backButton.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -36),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            
            cardViewBottomConstraint,
            cardView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 6),
            cardView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -6),
            cardView.heightAnchor.constraint(equalTo: cardView.widthAnchor, constant: 70),
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -28),
            cancelButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 36),
            cancelButton.heightAnchor.constraint(equalToConstant: 50),
            cancelButton.widthAnchor.constraint(equalTo: cancelButton.heightAnchor),
            
            retakeButton.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor),
            retakeButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 6),
            retakeButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            retakeButton.widthAnchor.constraint(equalTo: retakeButton.heightAnchor),
            
            doneButton.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor),
            doneButton.leadingAnchor.constraint(equalTo: retakeButton.trailingAnchor, constant: 6),
            doneButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -36),
            doneButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            
            qrPreviewView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -28),
            qrPreviewView.leadingAnchor.constraint(equalTo: cancelButton.leadingAnchor),
            qrPreviewView.trailingAnchor.constraint(equalTo: doneButton.trailingAnchor),
            qrPreviewView.heightAnchor.constraint(equalTo: qrPreviewView.widthAnchor),
        ])
        
    }
    
    func setApperance(_ isDarkMode: Bool) {
        self.view.backgroundColor = ColorSet.Theme.background.colorForMode(isDarkMode)
        cardView.backgroundColor = ColorSet.Theme.background.colorForMode(isDarkMode)
        
        backButton?.backgroundColor = UIColor.systemGray4
        cancelButton?.backgroundColor = UIColor.systemGray4
        retakeButton?.backgroundColor = UIColor.systemGray4
        doneButton?.backgroundColor = UIColor.systemGray4
        
        backButton?.setTitleColor(.label, for: .normal)
        doneButton?.setTitleColor(.label, for: .normal)
    }
    
    func updateLayout(state: LayoutState) {
        switch state {
        case .scanning:
            currentState = .scanning
            
            if (captureSession?.isRunning == false) {
                captureSession.startRunning()
            }
            
            cardViewBottomConstraint.constant = 500
            
            UIView.animate(withDuration: 0.15) { [self] in
                blurEffectView?.alpha = 0
                self.view.layoutIfNeeded()
            }
            
            
        case .taken:
            currentState = .taken
            
            if (captureSession?.isRunning == true) {
                captureSession.stopRunning()
            }
            
            cardViewBottomConstraint.constant = -6
            
            UIView.animate(withDuration: 0.2) { [self] in
                blurEffectView?.alpha = 1
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    func makeSymbolicButton(imageName: String) -> UIButton {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium, scale: .large)
        let image = UIImage(systemName: imageName, withConfiguration: imageConfig)
        
        let button = UIButton()
        button.setImage(image, for: .normal)
        return button
    }
}
