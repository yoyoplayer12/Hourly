import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var hourlyLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    var inputTextField: UITextField!
    var isEditingMode = false
    var pricePerHour: Double = 10.00 // Move pricePerHour declaration here
    var moneyMade: Double = 0.00
    var timer: Timer?
    @IBOutlet weak var editbutton: UIButton!
    @IBOutlet weak var startworkingbutton: UIButton!

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
        hourlyLabel.text = formattedPrice
        
        let workedMoney = String(format: "€%.2f", moneyMade) // Define formattedPrice here
        moneyLabel.text = workedMoney
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
            let textField = UITextField(frame: hourlyLabel.frame)
            textField.text = String(pricePerHour)
            textField.font = UIFont.systemFont(ofSize: 28)
            textField.textAlignment = .center
            textField.delegate = self
            textField.keyboardType = .decimalPad
            view.addSubview(textField)
            inputTextField = textField
            hourlyLabel.isHidden = true
            textField.becomeFirstResponder()
            
            // Change button title to "Done"
            sender.setTitle("Done", for: .normal)
            isEditingMode = true
        } else {
            hourlyLabel.isHidden = false
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
        hourlyLabel.isHidden = false
        return true
    }
    
    //start working
    @IBAction func startWorkingButtonClicked(_ sender: UIButton) {
        editbutton.isHidden = true
        moneyMade = 0.0 // Reset money made when start working button is clicked
        startTimer()
    }

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateMoneyMade), userInfo: nil, repeats: true)
    }

    @objc func updateMoneyMade() {
        moneyMade += pricePerHour / 3600.0 // Increment money made every second
        print("Money made: \(moneyMade)")
        // Update UI if needed
        updateUI()
    }
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
