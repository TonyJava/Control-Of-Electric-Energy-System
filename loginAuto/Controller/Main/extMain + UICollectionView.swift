
import UIKit

extension MainController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buildings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mainCellId, for: indexPath) as! MainCell
        
        let building = buildings[indexPath.item]
        cell.building = building
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 3 - 20, height: view.frame.width / 3.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if UserDefaults.standard.isLoggedIn() {
            UserDefaults.standard.setBuildingNumber(value: indexPath.row + 1)
            navigationController?.pushViewController(ShutdownController(), animated: true)
        } else {
            let alert = customAlertReturnAlert("로그인이 필요한 서비스입니다.")
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            alert.addAction(UIAlertAction(title: "로그인", style: .destructive) { (action) in
                DispatchQueue.main.async {
                    let loginController = LoginController()
                    let navigationController = UINavigationController(rootViewController: loginController)

                    self.present(navigationController, animated: true, completion: nil)
                }
            })
            present(alert, animated: true, completion: nil)
        }
    }
}










