
import UIKit

extension AdminController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return adminlevelData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: adminCellId, for: indexPath) as! AdminCell
        
        if let level = adminlevelData[indexPath.row] as? String, let userid = adminUseridData[indexPath.row] as? String{
            cell.levelTextfield.text = level
            cell.userId.text = userid
            cell.authorityButton.tag = indexPath.row
            cell.levelTextfield.tag = indexPath.row
            
            cell.delegate = self
        }
        
        return cell
    }
}
