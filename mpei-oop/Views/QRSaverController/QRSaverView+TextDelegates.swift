import UIKit

extension QRSaverView: UITextFieldDelegate, UITextViewDelegate {
    //MARK:- Text Field Delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField {
            descriptionTextView?.becomeFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if textField == titleTextField {
            if newString.count > 0 {
                self.codeViewModel.updateTitle(newString)
                saveButton?.isEnabled = true
            } else {
                self.codeViewModel.updateTitle(nil)
                saveButton?.isEnabled = false
            }
            
        }
        
        return true
    }
    
    //MARK:- Text View Delegates
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == descriptionTextView {
            if textView.text == descriptionPlaceholderString && textView.textColor == .tertiaryLabel {
                textView.textColor = .label
                textView.text = ""
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == descriptionTextView {
            if textView.text == "" {
                textView.textColor = .tertiaryLabel
                textView.text = descriptionPlaceholderString
            }
            
            if textView.textColor != .tertiaryLabel {
                codeViewModel.updateDescription(textView.text)
            } else {
                codeViewModel.updateDescription(nil)
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        let newString = (textView.text! as NSString).replacingCharacters(in: range, with: text)
        if textView == descriptionTextView {
            textView.textColor = .label
        }
        return true
    }
}
