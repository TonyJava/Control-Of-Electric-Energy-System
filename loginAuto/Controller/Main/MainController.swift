
import UIKit

class MainController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // MARK: - 변수 선언 ///////////////////////////////////////////////////////////////////////////////////
    
    let mainCellId = "mainCellId"
    
    private let rightsImage: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "bg_rights"))
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        
        return cv
    }()
    
    private let mainImage: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "bg_mainCenter"))
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
    private lazy var configButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(#imageLiteral(resourceName: "btn_config"), for: .normal)
        //button.setAttributedTitle(NSAttributedString(string: "LogOut", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20), NSAttributedStringKey.foregroundColor: UIColor.blue]), for: .normal)
        button.addTarget(self, action: #selector(handleLogOut), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var electricbillButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(#imageLiteral(resourceName: "btn_electricbill"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleBill), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - 뷰 ///////////////////////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        collectionView.register(MainCell.self, forCellWithReuseIdentifier: mainCellId)
    }
    
    deinit {
        print("Main deinit")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        (UIApplication.shared.value(forKey: "statusBar") as AnyObject).setValue(UIColor.white, forKey: "foregroundColor")
        (UIApplication.shared.value(forKey: "statusBar") as AnyObject).setValue(UIColor.black, forKey: "backgroundColor")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        (UIApplication.shared.value(forKey: "statusBar") as AnyObject).setValue(UIColor.black, forKey: "foregroundColor")
        (UIApplication.shared.value(forKey: "statusBar") as AnyObject).setValue(UIColor.white, forKey: "backgroundColor")
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - 레이아웃 함수 ///////////////////////////////////////////////////////////////////////////////////
    
    private func setupLayout(){
        view.addSubview(mainImage)
        view.addSubview(collectionView)
        view.addSubview(electricbillButton)
        view.addSubview(configButton)
        view.addSubview(rightsImage)
        let margin = view.layoutMarginsGuide
        
        _ = rightsImage.anchor(nil, leading: margin.leadingAnchor, bottom: margin.bottomAnchor, trailing: margin.trailingAnchor, topConstant: 0, leadingConstant: 0, bottomConstant: 0, trailingConstant: 0, widthConstant: 0, heightConstant: view.frame.height / 22)
        
        _ = mainImage.anchor(view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, topConstant: 0, leadingConstant: 0, bottomConstant: 0, trailingConstant: 0, widthConstant: 0, heightConstant: view.frame.height / 3)
        
        _ = collectionView.anchor(mainImage.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, topConstant: 10, leadingConstant: 15, bottomConstant: 0, trailingConstant: 15, widthConstant: 0, heightConstant: 0)
        
        _ = configButton.anchor(view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, topConstant: 30, leadingConstant: 0, bottomConstant: 0, trailingConstant: 30, widthConstant: view.frame.width / 12, heightConstant: view.frame.height / 20)
        
        _ = electricbillButton.anchor(nil, leading: mainImage.leadingAnchor, bottom: mainImage.bottomAnchor, trailing: mainImage.trailingAnchor, topConstant: 0, leadingConstant: 30, bottomConstant: 25, trailingConstant: 30, widthConstant: 0, heightConstant: mainImage.frame.height / 6.5)
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - 핸들링 함수 ///////////////////////////////////////////////////////////////////////////////////
    
    @objc func handleLogOut(){
        navigationController?.pushViewController(ConfigController(), animated: true)
    }
    
    @objc func handleBill(){
        navigationController?.pushViewController(BillController(), animated: true)
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
}
