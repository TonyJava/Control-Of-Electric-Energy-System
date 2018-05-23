
import UIKit

protocol AdminDelegate {
    func authorityButton(tag: Int)
    func visiblePickerView(tag: Int)
}

class AdminController: UIViewController, UITableViewDelegate, UITableViewDataSource, AdminDelegate{
    
    // MARK: - 변수 선언 ///////////////////////////////////////////////////////////////////////////////////
    
    let adminCellId = "adminCellId"
    
    let rightsImage: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "bg_rights"))
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setAttributedTitle(NSAttributedString(string: "< Back", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.mainPink]), for: .normal)
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        return button
    }()
    
    let centerImage: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "bg_admin"))
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
        
        tableView.register(AdminCell.self, forCellReuseIdentifier: adminCellId)
        let apiCliecnt = APIClient()
        apiCliecnt.adminLoad(self)
        setupLayout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeData()
    }
    
    deinit {
        print("admin deinit")
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - 레이아웃 함수 ///////////////////////////////////////////////////////////////////////////////////
    
    func setupLayout(){
        view.addSubview(rightsImage)
        view.addSubview(backButton)
        view.addSubview(centerImage)
        view.addSubview(tableView)
    
        tableView.addSubview(refreshControl)
        
        
        let margin = view.layoutMarginsGuide
        
        _ = rightsImage.anchor(nil, leading: margin.leadingAnchor, bottom: margin.bottomAnchor, trailing: margin.trailingAnchor, topConstant: 0, leadingConstant: 0, bottomConstant: 0, trailingConstant: 0, widthConstant: 0, heightConstant: view.frame.height / 22)
        
        backButton.anchorToTop(margin.topAnchor, leading: margin.leadingAnchor, bottom: nil, trailing: nil)
        
        _ = centerImage.anchor(margin.topAnchor, leading: nil, bottom: nil, trailing: nil, topConstant: 0, leadingConstant: 0, bottomConstant: 0, trailingConstant: 0, widthConstant: view.frame.width / 2, heightConstant: view.frame.height / 5.5)
        centerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        _ = tableView.anchor(centerImage.bottomAnchor, leading: margin.leadingAnchor, bottom: rightsImage.topAnchor, trailing: margin.trailingAnchor, topConstant: 0, leadingConstant: 0, bottomConstant: 0, trailingConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - 핸들링 함수 ///////////////////////////////////////////////////////////////////////////////////
    
    @objc func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func refreshTableView(){
        removeData()
        let apiClient = APIClient()
        apiClient.adminLoad(self)
        
        refreshControl.endRefreshing()
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    func removeData(){
        adminUseridData.removeAll()
        adminlevelData.removeAll()
    }
    
    // MARK: - 프로토콜함수 ///////////////////////////////////////////////////////////////////////////////////
    
    func authorityButton(tag: Int) {
        let cell = tableView.cellForRow(at: IndexPath(row: tag, section: 0)) as! AdminCell
        
        if let id = cell.userId.text, let level = cell.levelTextfield.text {
            let apiClient = APIClient()
            apiClient.adminUpdate(self, id: id, level: level)
            //refreshTableView()
        }
    }
    
    private var leveltag = 0
    
    func visiblePickerView(tag: Int){
        
        
        leveltag = tag
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
