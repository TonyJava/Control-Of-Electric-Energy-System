
import UIKit
import Alamofire

private var userParameters: Parameters = [ "id": "", "pwd": ""]
private var adminParameters: Parameters = ["token": "", "id": "", "level": ""]
private var askParameter: Parameters = ["token": "", "building": ""]
private var turnOffparameter: Parameters = ["token": "", "location": ""]

private let server:String = "http://bug.lasel.kr/"
private let signUpURL:String = "users/registration"
private let loginUrl:String = "users/login"
private let adminLoadUrl:String = "admin/adminLoad"
private let adminUpdateUrl:String = "admin/adminUpdate"
private let askUrl:String = "shutdown/askdb"
private let turnOffURL:String = "shutdown/turnoff"

class Network{
    let url: String
    let method: HTTPMethod
    let parameters: Parameters
    let viewController: UIViewController
    
    init(_ path: String, method: HTTPMethod = .post, parameters: Parameters = [:], viewController:UIViewController) {
        url = server + path
        self.method = method
        self.parameters = parameters
        self.viewController = viewController
    }
    
    deinit {
        print("network deinit")
    }
    
    func connetion(completion: @escaping ( [String: AnyObject] ) -> Void) {
        startActivityIndicator(viewController: viewController)
        
        Alamofire.request(url, method: method, parameters: parameters).responseJSON { [unowned self] response in
            //print(response)
            if let JSON = response.result.value{
                completion(JSON as! [String : AnyObject])
            } else{
                customAlertJustEnter("서버와의 연결이 불안정합니다.", viewController: self.viewController)
            }
            stopActivityIndicator()
        }
    }
}

class APIClient {
    func signUp(_ id:String, pw:String, signUpController:SignUpController) {
        userParameters["id"] = id
        userParameters["pwd"] = pw
        
        let network = Network(signUpURL, method: .post, parameters: userParameters, viewController: signUpController)
        network.connetion(){ response in
            if let resultCode = response["code"] as? Int, let resultMessage = response["message"] as? String {
                switch resultCode {
                case 200:
                    signUpController.completeSignUp()
                    break
                default:
                    customAlertJustEnter(resultMessage, viewController: signUpController)
                    break
                }
            }
            customAlertJustEnter("오류가 발생하였습니다. 재 접속해주세요", viewController: signUpController)
        }
    }
    
    func logIn(_ id:String, pw:String, loginController:LoginController){
        userParameters["id"] = id
        userParameters["pwd"] = pw
        
        let network = Network(loginUrl, method: .post, parameters: userParameters, viewController: loginController)
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
                    customAlertJustEnter(resultMessage, viewController: loginController)
                    break
                }
            }
            customAlertJustEnter("오류가 발생하였습니다. 재 접속해주세요", viewController: loginController)
        }
    }
    
    func adminLoad(_ adminController:AdminController){
        adminParameters["token"] = UserDefaults.standard.getToken()
        
        let network = Network(adminLoadUrl, method: .post, parameters: adminParameters, viewController: adminController)
        network.connetion() { response in
            //startActivityIndicator(viewController: adminController)
            
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
                    //stopActivityIndicator()
                    break
                default:
                    //stopActivityIndicator()
                    customAlertJustEnter(resultMessage, viewController: adminController)
                    
                    break
                }
            }
        }
    }
    
    func adminUpdate(_ adminController:AdminController, id:String, level:String){
        adminParameters["token"] = UserDefaults.standard.getToken()
        adminParameters["id"] = id
        adminParameters["level"] = level
        
        let network = Network(adminUpdateUrl, method: .post, parameters: adminParameters, viewController: adminController)
        network.connetion() { response in
            startActivityIndicator(viewController: adminController)
            
            if let resultmessage = response["message"] as? String, let resultToken = response["token"] as? String {
                stopActivityIndicator()
                UserDefaults.standard.setToken(value: resultToken)
                customAlertJustEnter(resultmessage, viewController: adminController)
                
            }
            
        }
    }
    
    func askdb(_ shutdownController:ShutdownController){
        askParameter["token"] = UserDefaults.standard.getToken()
        askParameter["building"] = UserDefaults.standard.getBuildingNumber()
        
        let network = Network(askUrl, method: .post, parameters: askParameter, viewController: shutdownController)
        
        network.connetion() { response in
            startActivityIndicator(viewController: shutdownController)
            
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
                    stopActivityIndicator()
                    break
                default:
                    stopActivityIndicator()
                    customAlertJustEnter(resultMessage, viewController: shutdownController)
                    break
                }
            }
        }
    }
    
    func turnoff(_ shutdownController:ShutdownController, location:String){
        turnOffparameter["token"] = UserDefaults.standard.getToken()
        turnOffparameter["location"] = location
        
        let network = Network(turnOffURL, method: .post, parameters: turnOffparameter, viewController: shutdownController)
        network.connetion() { response in
            startActivityIndicator(viewController: shutdownController)
            
            if let resultmessage = response["message"] as? String, let resultToken = response["token"] as? String {
               
                stopActivityIndicator()
                customAlertJustEnter(resultmessage, viewController: shutdownController)
                UserDefaults.standard.setToken(value: resultToken)
            }
        }
    }
    
}

