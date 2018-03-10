
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var launchCount:Int = 0
    var container = UIView()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
    
        window?.rootViewController = NavigationController()
        if launchCount == 0 {
            UserDefaults.standard.setisFirstExcuteIn(value: true)
            launchCount += 1
        } else{
            UserDefaults.standard.setisFirstExcuteIn(value: false)
        }
        
        UserDefaults.standard.setloginId(value: "")
        UserDefaults.standard.setToken(value: "")
        UserDefaults.standard.setRights(value: 0)
        UserDefaults.standard.setIsLoggedIn(value: false)
        
        return true
    }
    
    // Indicator 보여주기
    func isshowActivityIndicatory() {
        container.frame = UIScreen.main.bounds
        container.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        
        let loadingView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = container.center
        loadingView.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        let actInd = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.activityIndicatorViewStyle = .whiteLarge
        actInd.center = CGPoint(x: loadingView.frame.width / 2, y: loadingView.frame.height / 2)
        
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        window?.addSubview(container)
        actInd.startAnimating()
    }
    
    // Indicator 감추기
    func invisibleActivityIndicatory() {
        for view in (window?.subviews)! {
            if view.isEqual(container){
                view.removeFromSuperview()
            }
        }
    }
    
    // Alert 보여주기
    func showAlert(_ message:String){
        let alert = UIAlertController(title: "Information", message: "\n\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        
        DispatchQueue.main.async {
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

