
import UIKit

class NavigationController: UINavigationController {
    // MARK: - ViewDidLoad ///////////////////////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let mainController = MainController()
        viewControllers = [mainController]
        
        if !isNotFirstExcuteIn() {
            DispatchQueue.main.async {
                UserDefaults.standard.setIsLoggedIn(value: false)
                self.showInitController()
            }
        }
    }
    
    
    deinit {
        print("Navigation deinit")
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - 함수 선언 ///////////////////////////////////////////////////////////////////////////////////
    
    fileprivate func isNotFirstExcuteIn() -> Bool {
        return UserDefaults.standard.isFirstExcuteIn()
    }
    
    private func showInitController() {
        let initController = InitController()
        present(initController, animated: true, completion: nil)
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
}
