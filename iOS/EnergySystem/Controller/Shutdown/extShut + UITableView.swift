
import UIKit

extension ShutdownController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shutdownLocationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: shutdownCellId, for: indexPath) as! ShutdownCell
        
        cell.locationTitle.text = shutdownLocationData[indexPath.row]
        cell.countLabel.text = "\(shutdownOncountData[indexPath.row]) / \(shutdownTotalData[indexPath.row])"
        cell.shutdownButton.tag = indexPath.row
        cell.delegate = self
        
        return cell
    }
    
}
