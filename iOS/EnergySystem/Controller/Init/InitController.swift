
import UIKit

class InitController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // MARK: - 변수 선언 ///////////////////////////////////////////////////////////////////////////////////
    
    let cellId = "cellId"
    
    private var pageControlBottomAnchor: NSLayoutConstraint?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        
        return cv
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = pages.count
        pc.currentPageIndicatorTintColor = .red
        pc.pageIndicatorTintColor = .gray
        
        return pc
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SKIP", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.mainPink, for: .normal)
        button.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.mainPink, for: .normal)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        
        return button
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("시작하기", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(.mainPink, for: .normal)
        button.addTarget(self, action: #selector(handleMain), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - ViewDidLoad ///////////////////////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        setupLayout()
    }
    
    deinit {
        print("Init deinit")
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - 레이아웃 함수 ///////////////////////////////////////////////////////////////////////////////////
    
    private func setupLayout(){
        let bottomControls = UIStackView(arrangedSubviews: [skipButton, pageControl, nextButton])
        bottomControls.translatesAutoresizingMaskIntoConstraints = false
        bottomControls.distribution = .fillEqually
        
        view.addSubview(collectionView)
        view.addSubview(bottomControls)
        view.addSubview(startButton)
        
        collectionView.anchorToTop(view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        pageControlBottomAnchor = bottomControls.anchor(nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, topConstant: 0, leadingConstant: 0, bottomConstant: 0, trailingConstant: 0, widthConstant: 0, heightConstant: 40)[1]
        _ = startButton.anchor(nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, topConstant: 0, leadingConstant: 0, bottomConstant: 0, trailingConstant: 0, widthConstant: 0, heightConstant: view.frame.height / 5)[1]
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startButton.isHidden = true
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - 핸들링 함수 ///////////////////////////////////////////////////////////////////////////////////
    
    @objc private func handleSkip(){
        pageControl.currentPage = pages.count - 1
        handleNext()
    }
    
    @objc private func handleNext(){
        let nextIndex = min(pageControl.currentPage + 1, pages.count - 1)
        
        if pageControl.currentPage + 1 >= pages.count - 1 {
            pageControlBottomAnchor?.constant = 40
            startButton.isHidden = false
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            startButton.isHidden = true
        }
        
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc private func handleMain(){
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        guard let mainNavigationController = rootViewController as? NavigationController else { return }
        
        mainNavigationController.viewControllers = [MainController()]
        
        //UserDefaults.standard.setisFirstExcuteIn(value: false)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - 함수 ///////////////////////////////////////////////////////////////////////////////////
    
    private func registerCells() {
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        //x / view.frame.width 값이 페이지 번호가 됨
        pageControl.currentPage = pageNumber
        
        if pageNumber >= pages.count - 1 {
            pageControlBottomAnchor?.constant = 40
            startButton.isHidden = false
            
            
        } else {
            pageControlBottomAnchor?.constant = 0
            startButton.isHidden = true
            
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        //print(UIDevice.current.orientation.isLandscape)
        
        collectionView.collectionViewLayout.invalidateLayout()
        
        let indexPath = IndexPath(item: pageControl.currentPage, section: 0)
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    // MARK: - 끝 ///////////////////////////////////////////////////////////////////////////////////
    
}



