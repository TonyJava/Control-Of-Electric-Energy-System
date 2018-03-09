
import UIKit

class LoginController: UIViewController {
    // MARK: - 변수 선언 ///////////////////////////////////////////////////////////////////////////////////
    
    private let centerImage: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "bg_loginCenter"))
        
        return image
    }()
    
    private let textfieldId: LeftPaddedTextField = {
        let textfield = LeftPaddedTextField()
        textfield.placeholder = "Enter ID"
        textfield.background = UIImage(named: "input_id")
        textfield.autocorrectionType = .no
        
        return textfield
    }()
    
    private let textfieldPw: LeftPaddedTextField = {
        let textfield = LeftPaddedTextField()
        textfield.placeholder = "Enter Password"
        textfield.background = UIImage(named: "input_pwd")
        textfield.isSecureTextEntry = true
        
        return textfield
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(#imageLiteral(resourceName: "btn_login"), for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setAttributedTitle(NSAttributedString(string: "Sign Up", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15), NSAttributedStringKey.foregroundColor: UIColor.mainPink]), for: .normal)
        button.addTarget(self, action: #selector(handleSIgnUp), for: .touchUpInside)
        
        return button
    }()
    
    private let rightsImage: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "bg_rights"))
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
    private let exitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setAttributedTitle(NSAttributedString(string: "X", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20), NSAttributedStringKey.foregroundColor: UIColor.mainPink]), for: .normal)
        button.addTarget(self, action: #selector(handleExit), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - 뷰 ///////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        definesPresentationContext = true
        setupLayout()
    }
    
    deinit {
        print("Login deinit")
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - 레이아웃 함수 ///////////////////////////////////////////////////////////////////////////////////
    
    private func setupLayout(){
        view.addSubview(centerImage)
        view.addSubview(textfieldId)
        view.addSubview(textfieldPw)
        view.addSubview(loginButton)
        view.addSubview(signUpButton)
        view.addSubview(rightsImage)
        view.addSubview(exitButton)
        let margin = view.layoutMarginsGuide
        
        _ = centerImage.anchor(view.centerYAnchor, leading: nil, bottom: nil, trailing: nil, topConstant: -view.frame.height / 2.7, leadingConstant: 0, bottomConstant: 0, trailingConstant: 0, widthConstant: 120, heightConstant: 140)
        centerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        _ = textfieldId.anchor(centerImage.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, topConstant: 10, leadingConstant: 10, bottomConstant: 0, trailingConstant: 0, widthConstant: 260, heightConstant: 45)
        
        _ = textfieldPw.anchor(textfieldId.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, topConstant: 5, leadingConstant: 10, bottomConstant: 0, trailingConstant: 0, widthConstant: 260, heightConstant: 45)
        
        _ = loginButton.anchor(textfieldId.topAnchor, leading: textfieldId.trailingAnchor, bottom: textfieldPw.bottomAnchor, trailing: view.trailingAnchor, topConstant: 0, leadingConstant: 3, bottomConstant: 0, trailingConstant: 10, widthConstant: 0, heightConstant: 0)
        
        _ = signUpButton.anchor(loginButton.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, topConstant: 3, leadingConstant: 0, bottomConstant: 0, trailingConstant: 10, widthConstant: 70, heightConstant: 30)
        
        _ = rightsImage.anchor(nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, topConstant: 0, leadingConstant: 20, bottomConstant: 0, trailingConstant: 20, widthConstant: 0, heightConstant: 30)
        
        _ = exitButton.anchor(margin.topAnchor, leading: margin.leadingAnchor, bottom: nil, trailing: nil, topConstant: 0, leadingConstant: 0, bottomConstant: 0, trailingConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - 핸들링 함수 ///////////////////////////////////////////////////////////////////////////////////
    
    @objc func handleExit(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSIgnUp(){
        
        
        navigationController?.pushViewController(SignUpController(), animated: true)
    }
    
    @objc func handleLogin() {
        let id = textfieldId.text!
        let pw = textfieldPw.text!
        var message = (0, "로그인 성공!")
        
        if id == "" {
            message = (1, "아이디를 입력해주세요!")
        } else if pw == "" {
            message = (2, "비밀번호를 입력해주세요!")
        } else {
            let apiClient = APIClient()
            apiClient.logIn(id, pw: pw, loginController: self)
        }
        
        if message.0 != 0 {
            let alert = customAlertReturnAlert(message.1)
            
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [unowned self] (Action) in
                switch message.0{
                case 1:
                    self.textfieldId.becomeFirstResponder()
                case 2, 4:
                    self.textfieldPw.becomeFirstResponder()
                default:
                    break;
                }
                
                alert.removeFromParentViewController()
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - 함수 ///////////////////////////////////////////////////////////////////////////////////
    
    func completeLogin() {
        
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        guard let mainNavigationController = rootViewController as? NavigationController else { return }
        
        mainNavigationController.viewControllers = [MainController()]
        
        UserDefaults.standard.setIsLoggedIn(value: true)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
}
