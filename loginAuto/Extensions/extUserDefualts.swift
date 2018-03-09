
import Foundation

extension UserDefaults {
    
    enum UserDefaultsKeys: String {
        case isLoggedIn
        case buildingNumber
        case token
        case rights
        case isFirstExcuteIn
        case loginId
    }
    
    
    func setloginId(value: String){
        set(value, forKey: UserDefaultsKeys.loginId.rawValue)
        synchronize()
    }
    
    func getloginId() -> String {
        return string(forKey: UserDefaultsKeys.loginId.rawValue
            )!
    }
    
    func setisFirstExcuteIn(value: Bool){
        set(value, forKey: UserDefaultsKeys.isFirstExcuteIn.rawValue)
        synchronize()
    }
    
    func isFirstExcuteIn() -> Bool {
        return bool(forKey: UserDefaultsKeys.isFirstExcuteIn.rawValue)
    }
    
    func setIsLoggedIn(value: Bool){
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        synchronize()
    }
    
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    func setBuildingNumber(value: Int){
        set(value, forKey: UserDefaultsKeys.buildingNumber.rawValue)
        synchronize()
    }
    
    func getBuildingNumber() -> Int {
        return integer(forKey: UserDefaultsKeys.buildingNumber.rawValue)
    }
    
    func setToken(value: String) {
        set(value, forKey: UserDefaultsKeys.token.rawValue)
        synchronize()
    }
    
    func getToken() -> String {
        return string(forKey: UserDefaultsKeys.token.rawValue)!
    }
    
    func setRights(value: Int) {
        set(value, forKey: UserDefaultsKeys.rights.rawValue)
        synchronize()
    }
    
    func getRights() -> Int {
        return integer(forKey: UserDefaultsKeys.rights.rawValue)
    }
}
