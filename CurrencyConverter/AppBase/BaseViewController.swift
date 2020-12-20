//
//  ViewController.swift
//  iContacts
//
//  Created by Yousef on 12/5/20.
//  Copyright © 2020 Yousef. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import JGProgressHUD

class BaseViewController: UIViewController {
    
    let hud = JGProgressHUD(style: .dark)
    let isLoadingObservable = BehaviorRelay<Bool>(value: false)
    let msgsObservable = BehaviorRelay<String>(value: "")
    let apiErrorObservable = BehaviorRelay<APIErrorType?>(value: nil)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hud.textLabel.text = "Loading..."
    }
    
    func configureViewModel(viewModel: ViewModel) {
        
        viewModel.isLoadingObservable.bind(to: self.isLoadingObservable).disposed(by: disposeBag)
        viewModel.msgsObservable.bind(to: self.msgsObservable).disposed(by: disposeBag)
        viewModel.apiErrorObservable.bind(to: self.apiErrorObservable).disposed(by: disposeBag)
        
        isLoadingObservable.subscribe(onNext: { [unowned self] bool in
            DispatchQueue.main.async {
                if bool { hud.show(in: self.view) } else { hud.dismiss() }
            }
        }).disposed(by: disposeBag)
        
        msgsObservable.skip(1).subscribe(onNext: { [unowned self] msg in
            self.displayAlert(withMsg: msg)
        }).disposed(by: disposeBag)
        
        apiErrorObservable.skip(1).subscribe(onNext: { [unowned self] err in
            guard let err = err else {return}
            self.displayError(error: err)
        }).disposed(by: disposeBag)
        
    }
    
}
