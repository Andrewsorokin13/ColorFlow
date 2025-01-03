import UIKit

final class SettingsViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var alphaLabel: UILabel!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var alphaSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfigurationSlider()
        setupColorView()
    }
    
    // MARK: - private IB Actions
    @IBAction private func slidersDidChangeColor(_ sender: UISlider) {
        switch sender {
        case redSlider:
            redLabel.text = String.stringFormater(redSlider)
        case greenSlider:
            greenLabel.text = String.stringFormater(greenSlider)
        case blueSlider:
            blueLabel.text = String.stringFormater(blueSlider)
        default:
            alphaLabel.text = String.stringFormater(alphaSlider)
        }
        setupColorView()
    }
    
    // MARK: - Private Methods
    private func setupConfigurationSlider(){
        setupSliderColor(redSlider, .systemRed)
        setupSliderColor(greenSlider, .systemGreen)
        setupSliderColor(blueSlider, .systemBlue)
        setupSliderColor(alphaSlider, .systemGray)
    }
    
    private func setupColorView(){
        view.backgroundColor = UIColor(
            red: redSlider.value.makeCGFloat(),
            green: greenSlider.value.makeCGFloat(),
            blue: blueSlider.value.makeCGFloat(),
            alpha: alphaSlider.value.makeCGFloat()
        )
    }
    
    private func setupSliderColor(_ slider: UISlider, _ color: UIColor){
        slider.thumbTintColor = color
        slider.tintColor = color
    }
}
