
import UIKit

class BillController: UIViewController {
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
    
    private let billImage: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "bg_bill"))
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - 뷰 ///////////////////////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupLayout()
    }
    
    deinit {
        print("Bill deinit")
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - 레이아웃 함수 ///////////////////////////////////////////////////////////////////////////////////
    
    private func setupLayout() {
        view.addSubview(rightsImage)
        view.addSubview(backButton)
        view.addSubview(billImage)
        let margin = view.layoutMarginsGuide
        
        _ = rightsImage.anchor(nil, leading: margin.leadingAnchor, bottom: margin.bottomAnchor, trailing: margin.trailingAnchor, topConstant: 0, leadingConstant: 0, bottomConstant: 0, trailingConstant: 0, widthConstant: 0, heightConstant: view.frame.height / 22)
        
        backButton.anchorToTop(margin.topAnchor, leading: margin.leadingAnchor, bottom: nil, trailing: nil)
        
        _ = billImage.anchor(margin.topAnchor, leading: margin.leadingAnchor, bottom: rightsImage.topAnchor, trailing: margin.trailingAnchor, topConstant: 0, leadingConstant: 0, bottomConstant: 0, trailingConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - 핸들링 함수 ///////////////////////////////////////////////////////////////////////////////////
    
    @objc func handleBack(){
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
}
