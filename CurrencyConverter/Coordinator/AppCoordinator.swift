//
//  AppCoordinator.swift
//  iContacts
//
//  Created by Yousef on 12/4/20.
//  Copyright © 2020 Yousef. All rights reserved.
//

import UIKit

class AppCoordinator {
    
    private let window: UIWindow
    private var navigationController: UINavigationController
    
    init(window: UIWindow) {
        self.window = window
        navigationController = UINavigationController()
        navigationController.navigationBar.backgroundColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.1960784314, alpha: 0.9478007277)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func start() {
        let vc = HomeViewController.initialize(fromStoryBoardNamed: "Main")
        vc.viewModel = HomeViewModel(repository: CurrencyRepository(service: CurrencyService()))
        vc.showCalculationPopup = { base, selected in
            let popup = CalculationPopup.instanceFromNib()
            popup.baseCurrency = base
            popup.selectedCurrency = selected
            popup.addToController(vc, height: vc.view.frame.height * 0.9)
        }
        navigationController.pushViewController(vc, animated: true)
        window.rootViewController = navigationController
    }
    
}
