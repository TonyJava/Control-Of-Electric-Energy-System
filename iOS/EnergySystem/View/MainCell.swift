
import UIKit

class MainCell: UICollectionViewCell {
    // MARK: - 변수 선언 ///////////////////////////////////////////////////////////////////////////////////
    
    var building: Building? {
        didSet {
            guard let building = building else {
                return
            }
            imageView.image = UIImage(named: building.image)
        }
    }
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "btn_building01")
        iv.contentMode = .scaleAspectFill
        //iv.clipsToBounds = true
        
        return iv
    }()
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - 뷰 ///////////////////////////////////////////////////////////////////////////////////
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - 레이아웃 함수 ///////////////////////////////////////////////////////////////////////////////////
    
    private func setupLayout(){
        addSubview(imageView)
        
        imageView.anchorToTop(topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
}
