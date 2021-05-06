import UIKit

struct ColorSet {
    var light: UIColor
    var dark: UIColor
    
    struct Theme {
        static var background : ColorSet { return ColorSet(light: .white, dark: UIColor(hex: "#0d0d0dff"))}
    }
    
    func colorForMode(_ isDarkMode: Bool) -> UIColor {
        if isDarkMode {
            return self.dark
        } else {
            return self.light
        }
        
    }
}

