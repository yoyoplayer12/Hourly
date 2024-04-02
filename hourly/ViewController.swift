import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var myLabel: UILabel!
    var inputTextField: UITextField!
    var isEditingMode = false
    var pricePerHour: Double = 10.00 // Move pricePerHour declaration here

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        loadPricePerHourFromLocal() // Load pricePerHour from UserDefaults
        updateUI()
    }

    func updateUI() {
        if inputTextField != nil {
            inputTextField.removeFromSuperview()
            inputTextField = nil
        }
        let formattedPrice = String(format: "€%.2f/hour", pricePerHour) // Define formattedPrice here
        myLabel.text = formattedPrice
    }
    
    // Save pricePerHour to UserDefaults
    func savePricePerHourLocally() {
        UserDefaults.standard.set(pricePerHour, forKey: "PricePerHour")
    }
    
    // Load pricePerHour from UserDefaults
    func loadPricePerHourFromLocal() {
        if let savedPrice = UserDefaults.standard.value(forKey: "PricePerHour") as? Double {
            pricePerHour = savedPrice
        }
    }
    
    @IBAction func editButtonClicked(_ sender: UIButton) {
        if !isEditingMode {
            let textField = UITextField(frame: myLabel.frame)
            textField.text = String(pricePerHour)
            textField.font = UIFont.systemFont(ofSize: 28)
            textField.textAlignment = .center
            textField.delegate = self
            textField.keyboardType = .decimalPad
            view.addSubview(textField)
            inputTextField = textField
            myLabel.isHidden = true
            textField.becomeFirstResponder()
            
            // Change button title to "Done"
            sender.setTitle("Done", for: .normal)
            isEditingMode = true
        } else {
            myLabel.isHidden = false
            if let text = inputTextField?.text {
                let cleanedText = text.replacingOccurrences(of: ",", with: ".")
                pricePerHour = Double(cleanedText) ?? 0.00
            }
            // Save pricePerHour locally
            savePricePerHourLocally()
            updateUI()
            inputTextField?.removeFromSuperview()
            inputTextField = nil
            
            // Change button title back to "Edit"
            sender.setTitle("Edit", for: .normal)
            isEditingMode = false
        }
    }

    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text {
            let cleanedText = text.replacingOccurrences(of: ",", with: ".")
            pricePerHour = Double(cleanedText) ?? 0.00
        }
        // Save pricePerHour locally
        savePricePerHourLocally()
        updateUI()
        myLabel.isHidden = false
        return true
    }
}
