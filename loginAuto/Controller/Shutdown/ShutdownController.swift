
import UIKit
import Alamofire

protocol ShutdownDelegate {
    func shutdownButton(tag: Int)
}

class ShutdownController: UIViewController, UITableViewDataSource, UITableViewDelegate, ShutdownDelegate {
    // MARK: - 변수 선언 ///////////////////////////////////////////////////////////////////////////////////
    
    let shutdownCellId = "shutdownCellId"
    
    private let rightsImage: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "bg_rights"))
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: view.frame)
        tv.backgroundColor = .white
        tv.dataSource = self
        tv.delegate = self
        
        return tv
    }()
    
    private let centerImage: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "bg_room_01"))
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setAttributedTitle(NSAttributedString(string: "< Back", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.mainPink]), for: .normal)
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        return button
    }()
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "당겨봐요")
        
        return refreshControl
    }()
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - 뷰 ///////////////////////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tableView.register(ShutdownCell.self, forCellReuseIdentifier: shutdownCellId)
        setupLayout()
        
        let apiClient = APIClient()
        apiClient.askdb(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeData()
    }
    
    deinit {
        print("Shutdown deinit \(UserDefaults.standard.getBuildingNumber())")
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - 레이아웃 함수 ///////////////////////////////////////////////////////////////////////////////////
    
    private func setupLayout() {
        view.addSubview(centerImage)
        view.addSubview(backButton)
        view.addSubview(tableView)
        view.addSubview(rightsImage)
        tableView.addSubview(refreshControl)
        let margin = view.layoutMarginsGuide
        
        _ = rightsImage.anchor(nil, leading: margin.leadingAnchor, bottom: margin.bottomAnchor, trailing: margin.trailingAnchor, topConstant: 0, leadingConstant: 0, bottomConstant: 0, trailingConstant: 0, widthConstant: 0, heightConstant: view.frame.height / 22)
        
        backButton.anchorToTop(margin.topAnchor, leading: margin.leadingAnchor, bottom: nil, trailing: nil)
        
        _ = centerImage.anchor(margin.topAnchor, leading: nil, bottom: nil, trailing: nil, topConstant: 0, leadingConstant: 0, bottomConstant: 0, trailingConstant: 0, widthConstant: view.frame.width / 2, heightConstant: view.frame.height / 5.5)
        centerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerImage.image = UIImage(named: rooms[UserDefaults.standard.getBuildingNumber() - 1].image)
        
        _ = tableView.anchor(centerImage.bottomAnchor, leading: view.leadingAnchor, bottom: rightsImage.topAnchor, trailing: view.trailingAnchor, topConstant: 0, leadingConstant: 10, bottomConstant: 0, trailingConstant: 10, widthConstant: 0, heightConstant: 0)
        
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - 핸들링 함수 ///////////////////////////////////////////////////////////////////////////////////
    
    @objc func handleBack(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func refreshTableView(){
        removeData()
        let apiClient = APIClient()
        apiClient.askdb(self)
        
        refreshControl.endRefreshing()
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    func removeData(){
        shutdownLocationData.removeAll()
        shutdownTotalData.removeAll()
        shutdownOncountData.removeAll()
    }
    
    // MARK: - 프로토콜함수 ///////////////////////////////////////////////////////////////////////////////////
    
    func shutdownButton(tag: Int) {
        let cell = tableView.cellForRow(at: IndexPath(row: tag, section: 0)) as! ShutdownCell
        if let location = cell.locationTitle.text {
            let apiCliecnt = APIClient()
            apiCliecnt.turnoff(self, location: location)
            
        }
    }
    
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
}
