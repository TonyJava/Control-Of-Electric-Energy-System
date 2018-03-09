
import UIKit

class SignUpController: UIViewController {
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
    
    private let textfieldPwChk: LeftPaddedTextField = {
        let textfield = LeftPaddedTextField()
        textfield.placeholder = "Enter Password Check"
        textfield.background = UIImage(named: "input_pwd")
        textfield.isSecureTextEntry = true
        
        return textfield
    }()
    
    private lazy var signUpCompleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(#imageLiteral(resourceName: "btn_signUp"), for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        return button
    }()
    
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
        print("SignUp deinit")
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - 레이아웃 함수 ///////////////////////////////////////////////////////////////////////////////////
    
    private func setupLayout(){
        view.addSubview(centerImage)
        view.addSubview(textfieldId)
        view.addSubview(textfieldPw)
        view.addSubview(textfieldPwChk)
        view.addSubview(signUpCompleteButton)
        view.addSubview(rightsImage)
        view.addSubview(backButton)
        let margin = view.layoutMarginsGuide
        
        _ = rightsImage.anchor(nil, leading: margin.leadingAnchor, bottom: margin.bottomAnchor, trailing: margin.trailingAnchor, topConstant: 0, leadingConstant: 0, bottomConstant: 0, trailingConstant: 0, widthConstant: 0, heightConstant: view.frame.height / 22)
        
        backButton.anchorToTop(margin.topAnchor, leading: margin.leadingAnchor, bottom: nil, trailing: nil)
        
        _ = centerImage.anchor(view.centerYAnchor, leading: nil, bottom: nil, trailing: nil, topConstant: -view.frame.height / 2.7, leadingConstant: 0, bottomConstant: 0, trailingConstant: 0, widthConstant: 120, heightConstant: 140)
        centerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        _ = textfieldId.anchor(centerImage.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, topConstant: 10, leadingConstant: 30, bottomConstant: 0, trailingConstant: 30, widthConstant: 0, heightConstant: 45)
        
        _ = textfieldPw.anchor(textfieldId.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, topConstant: 5, leadingConstant: 30, bottomConstant: 0, trailingConstant: 30, widthConstant: 0, heightConstant: 45)
        
        _ = textfieldPwChk.anchor(textfieldPw.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, topConstant: 5, leadingConstant: 30, bottomConstant: 0, trailingConstant: 30, widthConstant: 0, heightConstant: 45)
        
        _ = signUpCompleteButton.anchor(textfieldPwChk.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, topConstant: 5, leadingConstant: 30, bottomConstant: 0, trailingConstant: 30, widthConstant: 0, heightConstant: 45)
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - 핸들링 함수 ///////////////////////////////////////////////////////////////////////////////////
    
    @objc func handleSignUp() {
        let id = textfieldId.text!
        let pw = textfieldPw.text!
        let pwc = textfieldPwChk.text!
        var message = (0, "회원가입을 축하합니다!")
        
        if id == "" {
            message = (1, "아이디를 입력해주세요!")
        } else if pw == "" {
            message = (2, "비밀번호를 입력해주세요!")
        } else if pwc == "" {
            message = (3, "비밀번호 재확인란을 입력해주세요!")
        } else if pw != pwc {
            message = (4, "비밀번호가 일치하지 않습니다!")
        } else {
            let apiClient = APIClient()
            apiClient.signUp(id, pw: pw, signUpController: self)
            
        }
        
        if message.0 != 0 {
            let alert = customAlertReturnAlert(message.1)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in
                switch message.0{
                case 1:
                    self.textfieldId.becomeFirstResponder()
                case 2, 4:
                    self.textfieldPw.becomeFirstResponder()
                case 3:
                    self.textfieldPwChk.becomeFirstResponder()
                default:
                    break;
                }
                
                alert.removeFromParentViewController()
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - 함수 ///////////////////////////////////////////////////////////////////////////////////
    
    func completeSignUp() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
}
