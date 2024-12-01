import Foundation
import UIKit

extension String {
    static func stringFormater(_ slider: UISlider) -> Self {
        return  String(format: "%.2f", slider.value)
    }
}
