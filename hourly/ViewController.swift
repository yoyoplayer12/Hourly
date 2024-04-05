import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var hourlyLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    var inputTextField: UITextField!
    var isEditingMode = false
    var pricePerHour: Double = 10.000 // Move pricePerHour declaration here
    var moneyMade: Double?
    var timer: Timer?
    var startTime: Date?
    @IBOutlet weak var editbutton: UIButton!
    @IBOutlet weak var startworkingbutton: UIButton!
    @IBOutlet weak var stopworkingbutton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        loadPricePerHourFromLocal()
        loadMoneyMadeFromLocal()
        startworkingbutton.tintColor = .systemBlue
        
        startworkingbutton.layer.cornerRadius = startworkingbutton.frame.width / 2
        startworkingbutton.layer.masksToBounds = true
        
        checkMoneyState()
        updateUI()
    }

    func updateUI() {
        if inputTextField != nil {
            inputTextField.removeFromSuperview()
            inputTextField = nil
        }
        let formattedPrice = String(format: "€%.4f/hour", pricePerHour) // Define formattedPrice here
        hourlyLabel.text = formattedPrice
        
        let workedMoney = String(format: "€%.4f", moneyMade ?? 0.000) // Define formattedPrice here
        moneyLabel.text = workedMoney
    }
    

    
    //buttons
    //start working
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
    @IBAction func startWorkingButtonClicked(_ sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        if startworkingbutton.title(for: .normal) == "Pause" {
            //pause timer
            //restart the timer below
            pauseTimer()
            saveMoneyMadeFromLocal()
            stopworkingbutton.isHidden = false
            startworkingbutton.setTitle("Resume", for: .normal)
            startworkingbutton.tintColor = .systemOrange
        }
        else if startworkingbutton.title(for: .normal) == "Resume" {
            //continue timer
            //pause the timer below
            startTimer()
            loadMoneyMadeFromLocal()
            stopworkingbutton.isHidden = false
            startworkingbutton.setTitle("Pause", for: .normal)
            startworkingbutton.tintColor = .systemOrange
        }
        else {
            //start timer
            startTimer()
            stopworkingbutton.isHidden = false
            editbutton.isHidden = true
            startworkingbutton.setTitle("Pause", for: .normal)
            startworkingbutton.tintColor = .systemOrange
        }
    }
    @IBAction func stopWorkingButtonClicked(_ sender: UIButton) {
        //stop money timer + empty
        stopTimer()
        moneyMade = 0.0000
        removeMoneyMadeFromLocal()
        editbutton.isHidden = false
        startworkingbutton.setTitle("Start Working", for: .normal)
        startworkingbutton.tintColor = .systemBlue
        stopworkingbutton.isHidden = true
        //TODO: money saved popup
    }
    
    //functions
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
    func saveMoneyMadeFromLocal(){
        UserDefaults.standard.set(moneyMade, forKey: "MoneyMade")
    }
    func loadMoneyMadeFromLocal() {
        if let savedMoney = UserDefaults.standard.value(forKey: "MoneyMade") as? Double {
            moneyMade = savedMoney
        }
        else{
            moneyMade = 0.0000
        }
    }
    func removeMoneyMadeFromLocal(){
        UserDefaults.standard.removeObject(forKey: "MoneyMade")
        moneyMade = 0.0000
        UserDefaults.standard.synchronize() // Make sure changes are immediately saved
    }
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
    func startTimer() {
        updateUI()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateMoneyMade), userInfo: nil, repeats: true)
    }
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        removeMoneyMadeFromLocal()
        
        //TODO: add money to db?
    }
    func pauseTimer(){
        timer?.invalidate()
        timer = nil
    }
    @objc func updateMoneyMade() {
        moneyMade! += pricePerHour / 36000.0 // Increment money made every second
        saveMoneyMadeFromLocal()
        //print("Money made: \(moneyMade)")
        // Update UI if needed
        updateUI()
    }
    func checkMoneyState(){
        if (UserDefaults.standard.value(forKey: "MoneyMade") != nil) {
            startTimer()
            editbutton.isHidden = true
            stopworkingbutton.isHidden = false
            startworkingbutton.setTitle("Pause", for: .normal)
            startworkingbutton.tintColor = .systemOrange
        } else {
            stopworkingbutton.isHidden = true
        }
    }
}
