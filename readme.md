
# 인절미 APP



무슨 프로그램인지 이해가 안되신다면 http://bug.lasel.kr/blog/?p=198 를 참고해주세요!!



## 핵심코드 Network 설명

    import UIKit
    import Alamofire

    private enum siteURL: String {
        case server       = "서버URL"
        case signUp       = "회원가입URL"
        case login        = "로그인URL"
        case adminLoad    = "관리자URL"
        case adminUpdate  = "관리자권한변경URL"
        case ask          = "접속된컴퓨터URL"
        case turnOff      = "종료URL"    
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
