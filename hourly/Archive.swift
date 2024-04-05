import UIKit

class Archive: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    struct MoneyArchive: Codable {
        var money: Double
        var date: Date
    }
    
    var moneyArchiveArray = [MoneyArchive]()
    let numberFormatter = NumberFormatter()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up table view
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // Configure number formatter
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 3
        numberFormatter.maximumFractionDigits = 3
        
        // Configure date formatter
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Retrieve money and date array
        moneyArchiveArray = getMoneyArchiveArray()
    }
    
    // Function to retrieve money archive array from UserDefaults
    func getMoneyArchiveArray() -> [MoneyArchive] {
        var moneyArchiveArray = [MoneyArchive]()
        
        // Load array from UserDefaults
        if let savedDataArray = UserDefaults.standard.array(forKey: "MoneyArchive") as? [Data] {
            let decoder = JSONDecoder()
            for data in savedDataArray {
                // Decode each data into MoneyArchive object and append to the array
                if let moneyArchive = try? decoder.decode(MoneyArchive.self, from: data) {
                    moneyArchiveArray.append(moneyArchive)
                }
            }
        }
        
        return moneyArchiveArray
    }
}

extension Archive: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moneyArchiveArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let moneyArchive = moneyArchiveArray[indexPath.row]
        
        // Configure cell content
        var content = cell.defaultContentConfiguration()
        let formattedMoney = numberFormatter.string(for: moneyArchive.money) ?? ""
        content.text = "€\(formattedMoney)"
        content.secondaryText = dateFormatter.string(from: moneyArchive.date)
        cell.contentConfiguration = content
        
        return cell
    }
    
    // Swipe-to-delete functionality
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove item from data source
            moneyArchiveArray.remove(at: indexPath.row)
            
            // Update UserDefaults
            let encoder = JSONEncoder()
            let encodedDataArray = moneyArchiveArray.map { try? encoder.encode($0) }
            UserDefaults.standard.set(encodedDataArray, forKey: "MoneyArchive")
            
            // Update table view
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
