
import UIKit
import Alamofire

private enum siteURL: String {
    case server       = "http://bug.lasel.kr/"
    case signUp       = "users/registration"
    case login        = "users/login"
    case adminLoad    = "admin/adminLoad"
    case adminUpdate  = "admin/adminUpdate"
    case ask          = "shutdown/askdb"
    case turnOff      = "shutdown/turnoff"
}

class Network{
    let url: URL
    let method: HTTPMethod
    let parameters: Parameters
    let viewController: UIViewController
    
    init(_ path: String, method: HTTPMethod = .post, parameters: Parameters = [:], viewController:UIViewController) {
        if let url = URL(string: siteURL.server.rawValue + path) {
            self.url = url
        } else {
            self.url = URL(string: siteURL.server.rawValue)!
        }
        
        self.method = method
        self.parameters = parameters
        self.viewController = viewController
    }
    
    deinit {
        print("network deinit")
    }
    
    func connetion(completion: @escaping ( [String: AnyObject] ) -> Void) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.isshowActivityIndicatory()
        
        Alamofire.request(url, method: method, parameters: parameters).responseJSON { response in
            if let JSON = response.result.value{
                completion(JSON as! [String : AnyObject])
            } else{
                appdelegate.showAlert("서버와의 연결이 불안정합니다.")
            }
            appdelegate.invisibleActivityIndicatory()
        }
    }
}

class APIClient {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func signUp(_ id:String, pw:String, signUpController:SignUpController) {
        var parameters: Parameters = ["id" : "", "pwd" : ""]
        parameters["id"] = id
        parameters["pwd"] = pw
        
        let network = Network(siteURL.signUp.rawValue, method: .post, parameters: parameters, viewController: signUpController)
        network.connetion(){ response in
            
            if let resultCode = response["code"] as? Int, let resultMessage = response["message"] as? String {
                switch resultCode {
                case 200:
                    signUpController.completeSignUp()
                    break
                default:
                    self.appDelegate.showAlert(resultMessage)
                    break
                }
            }
            self.appDelegate.showAlert("오류가 발생하였습니다. 재 접속해주세요")
        }
    }
    
    func logIn(_ id:String, pw:String, loginController:LoginController){
        var parameters: Parameters = ["id" : "", "pwd" : ""]
        parameters["id"] = id
        parameters["pwd"] = pw
        
        let network = Network(siteURL.login.rawValue, method: .post, parameters: parameters, viewController: loginController)
        network.connetion() { response in
            
            if let resultCode = response["code"] as? Int, let resultMessage = response["message"] as? String, let resultToken = response["token"] as? String {
                switch resultCode {
                case 200:
                    UserDefaults.standard.setToken(value: resultToken)
                    UserDefaults.standard.setRights(value: 1)
                    UserDefaults.standard.setloginId(value: id)
                    loginController.completeLogin()
                    break
                case 201:
                    UserDefaults.standard.setToken(value: resultToken)
                    UserDefaults.standard.setRights(value: 99)
                    UserDefaults.standard.setloginId(value: id)
                    loginController.completeLogin()
                    break
                default:
                    self.appDelegate.showAlert(resultMessage)
                    break
                }
            } else {
                self.appDelegate.showAlert("오류가 발생하였습니다. 재 접속해주세요")
            }
        }
    }
    
    func adminLoad(_ adminController:AdminController){
        var parameters: Parameters = ["token" : ""]
        parameters["token"] = UserDefaults.standard.getToken()
        
        let network = Network(siteURL.adminLoad.rawValue, method: .post, parameters: parameters, viewController: adminController)
        network.connetion() { response in
            
            if let resultCode = response["code"] as? Int, let resultMessage = response["message"] as? String, let resultData = response["data"] as? [[String: String]], let resultToken = response["token"] as? String {
                
                switch resultCode {
                case 200:
                    for index in resultData {
                        if let level = index["level"], let id = index["user_id"] {
                            adminlevelData.append(level)
                            adminUseridData.append(id)
                        }
                    }
                    UserDefaults.standard.setToken(value: resultToken)
                    adminController.tableView.reloadData()
                    break
                default:
                    self.appDelegate.showAlert(resultMessage)
                    break
                }
            }
        }
    }
    
    func adminUpdate(_ adminController:AdminController, id:String, level:String){
        var parameters: Parameters = ["token" : "", "id" : "", "level" : ""]
        parameters["token"] = UserDefaults.standard.getToken()
        parameters["id"] = id
        parameters["level"] = level
        
        let network = Network(siteURL.adminUpdate.rawValue, method: .post, parameters: parameters, viewController: adminController)
        network.connetion() { response in
            
            if let resultmessage = response["message"] as? String, let resultToken = response["token"] as? String {
                UserDefaults.standard.setToken(value: resultToken)
                self.appDelegate.showAlert(resultmessage)
            }
        }
    }
    
    func askdb(_ shutdownController:ShutdownController){
        var parameters: Parameters = ["token" : "", "building" : ""]
        parameters["token"] = UserDefaults.standard.getToken()
        parameters["building"] = UserDefaults.standard.getBuildingNumber()
        
        let network = Network(siteURL.ask.rawValue, method: .post, parameters: parameters, viewController: shutdownController)
        network.connetion() { response in
            
            if let resultCode = response["code"] as? Int, let resultMessage = response["message"] as? String, let resultData = response["data"] as? [[String: String]], let resultToken = response["token"] as? String{
                
                switch resultCode {
                case 200:
                    for index in resultData {
                        if let location = index["location"], let total = index["total"], let oncount = index["oncount"] {
                            shutdownLocationData.append(location)
                            shutdownTotalData.append(total)
                            shutdownOncountData.append(oncount)
                        }
                    }
                    shutdownController.tableView.reloadData()
                    UserDefaults.standard.setToken(value: resultToken)
                    break
                default:
                    self.appDelegate.showAlert(resultMessage)
                    break
                }
            }
        }
    }
    
    func turnoff(_ shutdownController:ShutdownController, location:String){
        var parameters: Parameters = ["token" : "", "location" : ""]
        parameters["token"] = UserDefaults.standard.getToken()
        parameters["location"] = location
        
        let network = Network(siteURL.turnOff.rawValue, method: .post, parameters: parameters, viewController: shutdownController)
        network.connetion() { response in
            
            if let resultmessage = response["message"] as? String, let resultToken = response["token"] as? String {
                self.appDelegate.showAlert(resultmessage)
                UserDefaults.standard.setToken(value: resultToken)
            }
        }
    }
}

