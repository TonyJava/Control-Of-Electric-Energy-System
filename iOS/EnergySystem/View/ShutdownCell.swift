
import UIKit

class ShutdownCell: UITableViewCell {
    // MARK: - 변수 선언 ///////////////////////////////////////////////////////////////////////////////////
    
    var delegate: ShutdownDelegate!
    
    private let leftImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "btn_login"))
        iv.contentMode = .scaleAspectFit
        
        return iv
    }()
    
    let locationTitle:UILabel = {
        let lb = UILabel()
        
        return lb
    }()
    
    let countLabel:UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        
        return lb
    }()
    
    lazy var shutdownButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(#imageLiteral(resourceName: "btn_off"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleShutdown), for: .touchUpInside)
        
        return button
    }()
    
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - 뷰 ///////////////////////////////////////////////////////////////////////////////////
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - 레이아웃 함수 ///////////////////////////////////////////////////////////////////////////////////
    
    private func setupLayout() {
        addSubview(leftImage)
        addSubview(locationTitle)
        addSubview(countLabel)
        addSubview(shutdownButton)
        
        let margin = layoutMarginsGuide
        
        _ = leftImage.anchor(margin.topAnchor, leading: margin.leadingAnchor, bottom: margin.bottomAnchor, trailing: nil, topConstant: 0, leadingConstant: 0, bottomConstant: 0, trailingConstant: 0, widthConstant: 50, heightConstant: 0)
        
        _ = locationTitle.anchor(margin.topAnchor, leading: leftImage.trailingAnchor, bottom: margin.bottomAnchor, trailing: nil, topConstant: 0, leadingConstant: 10, bottomConstant: 0, trailingConstant: 0, widthConstant: 0, heightConstant: 0)
        
        countLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        countLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        _ = shutdownButton.anchor(margin.topAnchor, leading: nil, bottom: margin.bottomAnchor, trailing: margin.trailingAnchor, topConstant: 0, leadingConstant: 0, bottomConstant: 0, trailingConstant: 0, widthConstant: 50, heightConstant: 35)
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - 핸들링 함수 ///////////////////////////////////////////////////////////////////////////////////
    
    @objc func handleShutdown() {
        delegate.shutdownButton(tag: shutdownButton.tag)
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
}
