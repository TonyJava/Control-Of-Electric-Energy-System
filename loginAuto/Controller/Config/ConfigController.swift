
import UIKit

class ConfigController: UIViewController {
    // MARK: - 변수 선언 ///////////////////////////////////////////////////////////////////////////////////
    
    private let rightsImage: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "bg_rights"))
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setAttributedTitle(NSAttributedString(string: "< Back", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.mainPink]), for: .normal)
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var logInOutButton: UIButton = {
        let button = UIButton(type: .system)
        if UserDefaults.standard.isLoggedIn() {
            button.setAttributedTitle(NSAttributedString(string: "로그아웃", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.mainPink]), for: .normal)
        } else{
            button.setAttributedTitle(NSAttributedString(string: "로그인", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.mainPink]), for: .normal)
        }
        
        button.addTarget(self, action: #selector(handleLogInOut), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var adminButton: UIButton = {
        let button = UIButton(type: .system)
        button.setAttributedTitle(NSAttributedString(string: "관리자 권한", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.mainPink]), for: .normal)
        button.addTarget(self, action: #selector(handleAdmin), for: .touchUpInside)
        
        return button
    }()
    
    private let centerImage: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "bg_face"))
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
    private lazy var howToButton: UIButton = {
        let button = UIButton(type: .system)
        button.setAttributedTitle(NSAttributedString(string: "How To", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.mainPink]), for: .normal)
        button.addTarget(self, action: #selector(handleHowTo), for: .touchUpInside)
        
        return button
    }()
    
    private let loginIdLabel:UILabel = {
        let lb = UILabel()
        lb.attributedText = NSAttributedString(string: UserDefaults.standard.getloginId(), attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.mainPink])
       
        return lb
    }()
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - 뷰 ///////////////////////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupLayout()
        if UserDefaults.standard.getRights() != 99 || !UserDefaults.standard.isLoggedIn(){
            adminButton.isHidden = true
        }
    }
    
    deinit {
        print("config deinit")
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - 레이아웃 함수 ///////////////////////////////////////////////////////////////////////////////////
    
    func setupLayout(){
        view.addSubview(rightsImage)
        view.addSubview(backButton)
        view.addSubview(logInOutButton)
        view.addSubview(adminButton)
        view.addSubview(centerImage)
        view.addSubview(howToButton)
        view.addSubview(loginIdLabel)
        
        let margin = view.layoutMarginsGuide
        
        _ = rightsImage.anchor(nil, leading: margin.leadingAnchor, bottom: margin.bottomAnchor, trailing: margin.trailingAnchor, topConstant: 0, leadingConstant: 0, bottomConstant: 0, trailingConstant: 0, widthConstant: 0, heightConstant: view.frame.height / 22)
        
        backButton.anchorToTop(margin.topAnchor, leading: margin.leadingAnchor, bottom: nil, trailing: nil)
        
        _ = logInOutButton.anchor(nil, leading: view.leadingAnchor, bottom: rightsImage.bottomAnchor, trailing: view.trailingAnchor, topConstant: 0, leadingConstant: 0, bottomConstant: 30, trailingConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = adminButton.anchor(nil, leading: view.leadingAnchor, bottom: logInOutButton.topAnchor, trailing: view.trailingAnchor, topConstant: 0, leadingConstant: 0, bottomConstant: 30, trailingConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = centerImage.anchor(margin.topAnchor, leading: nil, bottom: nil, trailing: nil, topConstant: 0, leadingConstant: 0, bottomConstant: 0, trailingConstant: 0, widthConstant: view.frame.width / 3, heightConstant: view.frame.height / 3)
        centerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        loginIdLabel.anchorToTop(centerImage.bottomAnchor, leading: nil, bottom: nil, trailing: nil)
        loginIdLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        _ = howToButton.anchor(nil, leading: view.leadingAnchor, bottom: adminButton.topAnchor, trailing: view.trailingAnchor, topConstant: 0, leadingConstant: 0, bottomConstant: 30, trailingConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - 핸들링 함수 ///////////////////////////////////////////////////////////////////////////////////
    
    @objc func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleLogInOut() {
        if UserDefaults.standard.isLoggedIn() {
            print("로그아웃")
            UserDefaults.standard.setIsLoggedIn(value: false)
            UserDefaults.standard.setRights(value: 0)
            UserDefaults.standard.setloginId(value: "")
            navigationController?.popViewController(animated: true)
        } else {
            print("로그인")
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navigationController = UINavigationController(rootViewController: loginController)
                
                self.present(navigationController, animated: true, completion: nil)
            }
        }
    }
    
    @objc func handleAdmin() {
        // 권한이 99인지 확인부터 하고
        // 로그인이 제대로 되어 있는지 확인 해야해
        if UserDefaults.standard.getRights() == 99 && UserDefaults.standard.isLoggedIn() {
            navigationController?.pushViewController(AdminController(), animated: true)
            
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.showAlert("잘못된 접근입니다.")
        }
    }
    
    @objc func handleHowTo() {
        DispatchQueue.main.async {
            let initController = InitController()
            self.present(initController, animated: true, completion: nil)
        }
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
}
