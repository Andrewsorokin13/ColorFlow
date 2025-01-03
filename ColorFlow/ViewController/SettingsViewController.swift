import UIKit

final class SettingsViewController: UIViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var preViewColor: UIView!
    
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var alphaLabel: UILabel!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var alphaSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var redTextField: UITextField!
    @IBOutlet weak var greenTextField: UITextField!
    @IBOutlet weak var blueTextField: UITextField!
    @IBOutlet weak var AlphaTextField: UITextField!
    
    // MARK: Properties
    
    weak var delegate: SettingsViewControllerDelegate?
    var colorMainView: UIColor!
    
    // MARK: Private properties
    
    private var navigationTextFields: [UITextField] = []
    
    // MARK: - Overrides Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSliders()
        configurePreViewColor()
        updateUIWithMainViewColor()
        setupTextFields()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - private IB Actions
    
    @IBAction private func slidersDidChangeColor(_ sender: UISlider) {
        updateUI(for: sender)
        updatePreviewColor()
    }
    
    @IBAction private func onDoneClick() {
        let newColor = UIColor(
            red: redSlider.value.makeCGFloat(),
            green: greenSlider.value.makeCGFloat(),
            blue: blueSlider.value.makeCGFloat(),
            alpha: alphaSlider.value.makeCGFloat()
        )
        
        delegate?.setColor(newColor)
        delegate?.getRGB(
            String.stringFormater(redSlider),
            String.stringFormater(greenSlider),
            String.stringFormater(blueSlider),
            String.stringFormater(alphaSlider)
        )
        dismiss(animated: true)
    }
}

// MARK: - Set UI

private extension SettingsViewController {
    
    func getColorComponents(from color: UIColor) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        return color.getRed(&red, green: &green, blue: &blue, alpha: &alpha) ? (red, green, blue, alpha) : nil
    }
    
    func updateUIWithMainViewColor() {
        guard let components = getColorComponents(from: colorMainView) else { return }
        preViewColor.backgroundColor = colorMainView
        updateSliderAndLabels(for: components)
    }
    
    func updateUI(for slider: UISlider) {
        switch slider {
        case redSlider:
            updateLabelAndTextField(redLabel, redTextField, with: slider)
        case greenSlider:
            updateLabelAndTextField(greenLabel, greenTextField, with: slider)
        case blueSlider:
            updateLabelAndTextField(blueLabel, blueTextField, with: slider)
        case alphaSlider:
            updateLabelAndTextField(alphaLabel, AlphaTextField, with: slider)
        default:
            break
        }
    }
    
    func updatePreviewColor() {
        preViewColor.backgroundColor = UIColor(
            red: redSlider.value.makeCGFloat(),
            green: greenSlider.value.makeCGFloat(),
            blue: blueSlider.value.makeCGFloat(),
            alpha: alphaSlider.value.makeCGFloat()
        )
    }
    
    func updateSliderAndLabels(for components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)) {
        redSlider.value = Float(components.red)
        greenSlider.value = Float(components.green)
        blueSlider.value = Float(components.blue)
        alphaSlider.value = Float(components.alpha)
        
        updateLabelAndTextField(redLabel, redTextField, with: redSlider)
        updateLabelAndTextField(greenLabel, greenTextField, with: greenSlider)
        updateLabelAndTextField(blueLabel, blueTextField, with: blueSlider)
        updateLabelAndTextField(alphaLabel, AlphaTextField, with: alphaSlider)
    }
    
    func updateLabelAndTextField(_ label: UILabel, _ textField: UITextField, with slider: UISlider) {
        let formattedValue = String.stringFormater(slider)
        label.text = formattedValue
        textField.text = formattedValue
    }
    
    func setupSliders() {
        configureSlider(redSlider, with: .systemRed)
        configureSlider(greenSlider, with: .systemGreen)
        configureSlider(blueSlider, with: .systemBlue)
        configureSlider(alphaSlider, with: .systemGray)
    }
    
    func configurePreViewColor() {
        preViewColor.layer.cornerRadius = 14
        preViewColor.layer.borderWidth = 2
        preViewColor.layer.borderColor = UIColor.systemGray.cgColor
    }
    
    func configureSlider(_ slider: UISlider, with color: UIColor) {
        slider.thumbTintColor = color
        slider.tintColor = color
    }
    
    func updateSliderLabelAndPreview(for slider: UISlider, label: UILabel, value: Float) {
        slider.value = value
        label.text = String.stringFormater(slider)
        updatePreviewColor()
    }
    
    func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Set textFields and createToolbar

private extension SettingsViewController {
    
    func setupTextFields() {
        navigationTextFields = [redTextField, greenTextField, blueTextField, AlphaTextField]
        navigationTextFields.enumerated().forEach { index, textField in
            textField.keyboardType = .decimalPad
            textField.delegate = self
            textField.inputAccessoryView = createToolbar(for: index)
        }
    }
    
    func createToolbar(for index: Int) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let prevButton = UIBarButtonItem(title: "🔺", style: .plain, target: self, action: #selector(navigateToPreviousField))
        prevButton.tag = index
        
        let nextButton = UIBarButtonItem(title: "🔻", style: .plain, target: self, action: #selector(navigateToNextField))
        nextButton.tag = index
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        
        toolbar.items = [prevButton, nextButton, spacer, doneButton]
        return toolbar
    }
    
    @objc func navigateToPreviousField(_ sender: UIBarButtonItem) {
        let currentIndex = sender.tag
        if currentIndex > 0 {
            navigationTextFields[currentIndex - 1].becomeFirstResponder()
        }
    }
    
    @objc func navigateToNextField(_ sender: UIBarButtonItem) {
        let currentIndex = sender.tag
        if currentIndex < navigationTextFields.count - 1 {
            navigationTextFields[currentIndex + 1].becomeFirstResponder()
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate

extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text,
              let value = Float(text),
              value >= 0.0, value <= 1.0 else {
            showAlert(
                with: "Ошибка ввода",
                message: "Введите число от 0 до 1"
            )
            return
        }
        
        switch textField {
        case redTextField:
            updateSliderLabelAndPreview(for: redSlider, label: redLabel, value: value)
        case greenTextField:
            updateSliderLabelAndPreview(for: greenSlider, label: greenLabel, value: value)
        case blueTextField:
            updateSliderLabelAndPreview(for: blueSlider, label: blueLabel, value: value)
        case AlphaTextField:
            updateSliderLabelAndPreview(for: alphaSlider, label: alphaLabel, value: value)
        default:
            break
        }
    }
}
