//
//  customAlert.swift
//  loginAuto
//
//  Created by kimun on 2017. 12. 26..
//  Copyright © 2017년 bugking. All rights reserved.
//

import UIKit

func customAlertJustEnter(_ message:String, viewController:UIViewController){
    // 이렇게 하니깐 되는데 상태바 까지는 색이 안칠해지는데 어떻게 해결해야함??????
    let alert = UIAlertController(title: "Information", message: "\n\(message)", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in
        alert.removeFromParentViewController()
    }))
    
    viewController.present(alert, animated: true, completion: nil)
}

func customAlertReturnAlert(_ message:String) -> UIAlertController {
    let alert = UIAlertController(title: "Information", message: "\n\(message)", preferredStyle: .alert)
    
    return alert
}

private let activityIndicator: UIActivityIndicatorView = {
    let atv = UIActivityIndicatorView()
    atv.activityIndicatorViewStyle = .gray
    atv.frame = UIScreen.main.bounds
    atv.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    atv.startAnimating()
    
    atv.hidesWhenStopped = true
    
    return atv
}()

func startActivityIndicator(viewController:UIViewController) {
    viewController.view.addSubview(activityIndicator)
    activityIndicator.startAnimating()
}

func stopActivityIndicator() {
    activityIndicator.stopAnimating()
}
