//
//  CalculationPopupViewController.swift
//  CurrencyConverter
//
//  Created by Yousef on 12/20/20.
//

import RxSwift

class CalculationPopup: Popup {

    @IBOutlet private weak var closeBtn: UIButton!
    @IBOutlet private weak var baseCurrencyTF: UITextField!
    @IBOutlet private weak var baseCurrencyLbl: UILabel!
    @IBOutlet private weak var selectedCurrencyTF: UITextField!
    @IBOutlet private weak var selectedCurrencyLbl: UILabel!
    @IBOutlet private weak var upperView: UIView!
    
    private let disposeBag = DisposeBag()
    
    var baseCurrency, selectedCurrency: Currency?
    
    @IBAction private func closeBtnTapped(_ sender: UIButton) {
        removeFromController()
    }
    
    @objc private func upperViewTapped(_ sender: UIGestureRecognizer) {
        removeFromController()
    }
    
    override func addToController(_ controller: UIViewController, height: CGFloat) {
        super.addToController(controller, height: height)
        setupViews()
    }
    
    private func setupViews() {
        upperView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(upperViewTapped)))
        baseCurrencyTF.rx.text.changed.throttle(1, scheduler: MainScheduler.instance).map{
            guard self.selectedCurrency != nil, self.baseCurrency != nil else {assert(false, "currency not passed")}
            if $0!.isEmpty { return self.selectedCurrency?.fraction ?? "" }
            let fraction = Double($0!)! * Double(self.selectedCurrency!.fraction)!
            return String(format: "%.3f", fraction)
        }.bind(to: selectedCurrencyTF.rx.text).disposed(by: disposeBag)
        baseCurrencyLbl.text = baseCurrency?.code
        selectedCurrencyLbl.text = selectedCurrency?.code
        selectedCurrencyTF.text = selectedCurrency?.fraction
    }
    
}
