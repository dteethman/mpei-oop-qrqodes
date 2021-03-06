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
        
        backButton = UIButton()
        backButton.setTitle("Cancel", for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
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
        cancelButton.layer.cornerRadius = 12
        cancelButton.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
        cardView.addSubview(cancelButton)
        
        retakeButton = UIButton()
        retakeButton.setTitle("Retake", for: .normal)
        retakeButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        retakeButton.translatesAutoresizingMaskIntoConstraints = false
        retakeButton.layer.cornerRadius = 8
        retakeButton.layer.cornerCurve = .continuous
        retakeButton.addTarget(self, action: #selector(doneAction(_:)), for: .touchUpInside)
        cardView.addSubview(retakeButton)
        
        doneButton = UIButton()
        doneButton.setTitle("Continue", for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.layer.cornerRadius = 8
        doneButton.layer.cornerCurve = .continuous
        doneButton.addTarget(self, action: #selector(doneAction(_:)), for: .touchUpInside)
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
            cardView.heightAnchor.constraint(equalTo: cardView.widthAnchor, constant: 144),
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            cancelButton.heightAnchor.constraint(equalToConstant: 24),
            cancelButton.widthAnchor.constraint(equalTo: cancelButton.heightAnchor),
            
            retakeButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -18),
            retakeButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 36),
            retakeButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -36),
            retakeButton.heightAnchor.constraint(equalToConstant: 50),
            
            doneButton.bottomAnchor.constraint(equalTo: retakeButton.topAnchor, constant: -10),
            doneButton.leadingAnchor.constraint(equalTo: retakeButton.leadingAnchor),
            doneButton.trailingAnchor.constraint(equalTo: retakeButton.trailingAnchor),
            doneButton.heightAnchor.constraint(equalToConstant: 50),
            
            qrPreviewView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -28),
            qrPreviewView.leadingAnchor.constraint(equalTo: doneButton.leadingAnchor),
            qrPreviewView.trailingAnchor.constraint(equalTo: doneButton.trailingAnchor),
            qrPreviewView.heightAnchor.constraint(equalTo: qrPreviewView.widthAnchor),
        ])
        
    }
    
    func setAppearance(_ isDarkMode: Bool) {
        self.view.backgroundColor = ColorSet.Theme.background.colorForMode(isDarkMode)
        cardView?.backgroundColor = ColorSet.Theme.background.colorForMode(isDarkMode)
        
        backButton?.backgroundColor = .white
        cancelButton?.backgroundColor = .systemGray6
        retakeButton?.backgroundColor = .clear
        doneButton?.backgroundColor = .systemBlue
        
        backButton?.setTitleColor(.systemGray4, for: .normal)
        doneButton?.setTitleColor(.white, for: .normal)
        cancelButton?.tintColor = .systemGray4
        retakeButton?.setTitleColor(.systemBlue, for: .normal)
        
        qrPreviewView?.layer.borderWidth = isDarkMode ? 0 : 1
        qrPreviewView?.layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    func updateLayout(state: LayoutState) {
        switch state {
        case .scanning:
            currentState = .scanning
            
            if (captureSession?.isRunning == false) {
                captureSession.startRunning()
            }
            
            cardViewBottomConstraint.constant = 800
            
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
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 9, weight: .black, scale: .large)
        let image = UIImage(systemName: imageName, withConfiguration: imageConfig)
        
        let button = UIButton()
        button.setImage(image, for: .normal)
        return button
    }
}
