//
//  Popup.swift
//  CurrencyConverter
//
//  Created by Yousef on 12/20/20.
//

import UIKit

class Popup: UIView {
 
    private var isVisible = false
    
    class func instanceFromNib() -> Self {
//        UINib(nibName: String(describing: self), bundle: nil)
        let view =  UINib(nibName: String(describing: self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! Self
        return view
    }
    
    func addToController(_ controller: UIViewController, height: CGFloat) {
        guard !isVisible else {return}
        controller.view.addSubview(self)
        let safeArea = controller.view.safeAreaLayoutGuide
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        self.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
        UIView.animate(withDuration: 0.6, animations: {
            self.transform = .identity
        })
        self.isVisible = true
    }
    
    func removeFromController() {
        UIView.animate(withDuration: 0.6, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
        }, completion: { _ in
            self.removeFromSuperview()
            self.isVisible = false
        })
    }
    
}
