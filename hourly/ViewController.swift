import UIKit

var pricePerHour: Double = 10.00

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var myLabel: UILabel! // Connect this IBOutlet to your UILabel in the storyboard
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
        let formattedPrice = String(format: "€%.2f/hour", pricePerHour) // Format the price with 2 decimal places and a euro sign
        myLabel.text = formattedPrice
    }

    @IBAction func editButtonClicked(_ sender: UIButton) {
        if inputTextField == nil {
            let textField = UITextField(frame: myLabel.frame)
            textField.borderStyle = .roundedRect
            textField.text = String(pricePerHour)
            textField.textAlignment = .center
            textField.delegate = self // Set the view controller as the delegate of the text field
            view.addSubview(textField)
            inputTextField = textField
            myLabel.isHidden = true
            
            // Make the keyboard pop up automatically
            textField.becomeFirstResponder()
        } else {
            myLabel.isHidden = false
            pricePerHour = Double(inputTextField.text ?? "") ?? 0.00
            updateUI()
        }
    }

    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Dismiss the keyboard
        pricePerHour = Double(textField.text ?? "") ?? 0.00 // Save the entered value
        updateUI() // Update the label
        myLabel.isHidden = false // Show the label again
        return true
    }
}
