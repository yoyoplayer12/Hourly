import UIKit

var pricePerHour: Double = 10.00

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var myLabel: UILabel!
    var inputTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        updateUI()
    }

    func updateUI() {
        if inputTextField != nil {
            inputTextField.removeFromSuperview()
            inputTextField = nil
        }
        let formattedPrice = String(format: "€%.2f/hour", pricePerHour)
        myLabel.text = formattedPrice
    }

    @IBAction func editButtonClicked(_ sender: UIButton) {
        if inputTextField == nil {
            let textField = UITextField(frame: myLabel.frame)
            textField.borderStyle = .roundedRect
            textField.text = String(pricePerHour)
            textField.textAlignment = .center
            textField.delegate = self
            textField.keyboardType = .decimalPad
            view.addSubview(textField)
            inputTextField = textField
            myLabel.isHidden = true
            
            // Make the keyboard pop up automatically
            textField.becomeFirstResponder()
        } else {
            myLabel.isHidden = false
            if let text = inputTextField.text {
                // Replace commas with dots before attempting to convert to Double
                let cleanedText = text.replacingOccurrences(of: ",", with: ".")
                pricePerHour = Double(cleanedText) ?? 0.00
            }
            updateUI()
        }
    }

    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text {
            let cleanedText = text.replacingOccurrences(of: ",", with: ".")
            pricePerHour = Double(cleanedText) ?? 0.00
        }
        updateUI()
        myLabel.isHidden = false
        return true
    }
}
