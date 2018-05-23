
import UIKit

class AdminCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    // MARK: - 변수 선언 ///////////////////////////////////////////////////////////////////////////////////
    
    var delegate: AdminDelegate!
    let pickerOptions = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    
    private let leftImage:UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "btn_login"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let userId:UILabel = {
        let lb = UILabel()
        
        return lb
    }()
    
    private let currentLevel:UILabel = {
        let la = UILabel()
        la.text = "현재 권한 : "
        
        return la
    }()
    
    lazy var authorityButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(#imageLiteral(resourceName: "btn_authority"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleAuthority), for: .touchUpInside)

        return button
    }()
    
    let pickerView:UIPickerView = {
        let pv = UIPickerView()
        pv.backgroundColor = .white
        
        return pv
    }()
    
    lazy var toolbar:UIToolbar = {
        let tb = UIToolbar()
        tb.barStyle = .default
        tb.tintColor = .blue
        tb.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDone))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tb.items = [cancelButton, spaceButton, doneButton]
        tb.isUserInteractionEnabled = true
        
        return tb
    }()
    
    
    let levelTextfield:UITextField = {
        let tf = UITextField(frame: CGRect(x: 10, y: 10, width: 40, height: 15))
        tf.backgroundColor = .white
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - 뷰 ///////////////////////////////////////////////////////////////////////////////////
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        setupPickerView()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - 레이아웃 함수 ///////////////////////////////////////////////////////////////////////////////////
    private func setupPickerView() {
        levelTextfield.inputView = pickerView
        levelTextfield.inputAccessoryView = toolbar
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    private func setupLayout() {
        addSubview(leftImage)
        addSubview(userId)
        //addSubview(level)
        addSubview(authorityButton)
        addSubview(levelTextfield)
        addSubview(currentLevel)
        
        let margin = layoutMarginsGuide
        
        _ = leftImage.anchor(margin.topAnchor, leading: margin.leadingAnchor, bottom: margin.bottomAnchor, trailing: nil, topConstant: 0, leadingConstant: 0, bottomConstant: 0, trailingConstant: 0, widthConstant: 50, heightConstant: 0)
        
        _ = userId.anchor(margin.topAnchor, leading: leftImage.trailingAnchor, bottom: margin.bottomAnchor, trailing: nil, topConstant: 0, leadingConstant: 10, bottomConstant: 0, trailingConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = authorityButton.anchor(margin.topAnchor, leading: nil, bottom: margin.bottomAnchor, trailing: margin.trailingAnchor, topConstant: 0, leadingConstant: 0, bottomConstant: 0, trailingConstant: 0, widthConstant: 50, heightConstant: 35)
        
        currentLevel.anchorToTop(margin.topAnchor, leading: nil, bottom: margin.bottomAnchor, trailing: levelTextfield.leadingAnchor)
        
        _ = levelTextfield.anchor(margin.topAnchor, leading: nil, bottom: margin.bottomAnchor, trailing: authorityButton.leadingAnchor, topConstant: 0, leadingConstant: 0, bottomConstant: 0, trailingConstant: 10, widthConstant: 30, heightConstant: 0)
        
        //centerTextfield.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        //centerTextfield.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - 핸들링 함수 ///////////////////////////////////////////////////////////////////////////////////
    
    @objc func handleAuthority() {
        delegate.authorityButton(tag: authorityButton.tag)
    }
    
    @objc func handleLevel() {
        delegate.visiblePickerView(tag: levelTextfield.tag)
    }
    
    @objc func handleCancel() {
        levelTextfield.text = pickerOptions[0]
        levelTextfield.endEditing(true)
    }
    
    @objc func handleDone() {
        levelTextfield.endEditing(true)
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        levelTextfield.text = pickerOptions[row]
    }
}

