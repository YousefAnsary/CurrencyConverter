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
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    
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
            return self.calculate(input: Double($0!)!)
        }.bind(to: selectedCurrencyTF.rx.text).disposed(by: disposeBag)
        baseCurrencyLbl.text = baseCurrency?.code
        selectedCurrencyLbl.text = selectedCurrency?.code
        selectedCurrencyTF.text = selectedCurrency?.fraction
        handleKeyboard()
    }
    
    private func calculate(input: Double)-> String {
        let fraction = input * Double(self.selectedCurrency!.fraction)!
        return String(format: "%.3f", fraction)
    }
    
    private func handleKeyboard() {
        baseCurrencyTF.rx.controlEvent(UIControl.Event.editingDidBegin).subscribe(onNext: { [weak self] in
            self?.animateKeyboard(toConstanct: 70)
        }).disposed(by: disposeBag)
        baseCurrencyTF.rx.controlEvent(UIControl.Event.editingDidEnd).subscribe(onNext: { [weak self] in
            self?.animateKeyboard(toConstanct: -6)
        }).disposed(by: disposeBag)
    }
    
    private func animateKeyboard(toConstanct constant: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.bottomConstraint.constant = constant
            self.layoutIfNeeded()
        }
    }
    
}
