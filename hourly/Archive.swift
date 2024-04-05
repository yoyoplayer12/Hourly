import UIKit

class Archive: UIViewController {
    struct MoneyArchive: Codable {
        var money: Double
        var date: Date
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve money and date array
        let moneyArchiveArray = getMoneyArchiveArray()
        // Print money and date information
        for moneyArchive in moneyArchiveArray {
            print("Money: \(moneyArchive.money), Date: \(moneyArchive.date)")
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
