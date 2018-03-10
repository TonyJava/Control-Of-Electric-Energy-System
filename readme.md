
# 인절미 APP



무슨 프로그램인지 이해가 안되신다면 http://bug.lasel.kr/blog/?p=198 를 참고해주세요!!



## 핵심코드 Network 설명

    import UIKit
    import Alamofire

    private enum siteURL: String {
        case server       = "서버URL을 추가해주세요"
        case addURL       = "서버URL을 제외한 나머지 부분을 작성해주세요."
    }
    
    class Network{
        let url: URL
        let method: HTTPMethod
        let parameters: Parameters
    
        init(_ path: String, method: HTTPMethod = .post, parameters: Parameters = [:]) {
            if let url = URL(string: siteURL.server.rawValue + path) {
                self.url = url
            } else {
                self.url = URL(string: siteURL.server.rawValue)!
            }
        
            self.method = method
            self.parameters = parameters
        }
    
        deinit {
            print("network deinit")
        }
    
        func connection(completion: @escaping ( [String: AnyObject] ) -> Void) {
            Alamofire.request(url, method: method, parameters: parameters).responseJSON { response in
                if let JSON = response.result.value{
                    completion(JSON as! [String : AnyObject])
                } else{
                    print("서버와의 연결이 불안정합니다.")
                }
            }
        }
    }
\'

Network Class는 Alamofire를 기반으로한 통신 Class입니다. Network Class는 주소, HTTP규약, 파라미터가 필요합니다.

Network 내 connection 함수를 통해 서버와 JSON 통신이 가능해집니다. 

해당 클래스는 비동기로 작동하며 connection 함수가 완료되면 해당 url을 통해 전달받은 JSON을 리턴하게 됩니다.






