//
//  HomeViewModel.swift
//  CurrencyConverter
//
//  Created by Yousef on 12/20/20.
//

import RxSwift
import RxCocoa

class HomeViewModel: ViewModel {
    
    let currencies = BehaviorRelay<[Currency]>(value: [])
    let baseCurrency = BehaviorRelay<Currency?>(value: nil)
    var currenciesStrings: [String] = []
    var animatedCellIndex = [Int]()
    private let repository: CurrencyRepository
    private let disposeBag = DisposeBag()
    
    init(repository: CurrencyRepository) {
        self.repository = repository
        super.init()
        setupViewModel()
    }
    
    private func setupViewModel() {
        baseCurrency.subscribe(onNext: { [weak self] val in
            guard val != nil else {return}
            self?.fetchCurrencies(base: val!.code)
        }).disposed(by: disposeBag)
    }
    
    func fetchAllCurrencies() {
        animatedCellIndex = []
        isLoadingObservable.accept(true)
        repository.getAllCurrencies { [weak self] res in
            guard let self = self else {return}
            self.isLoadingObservable.accept(false)
            switch res{
            case .success(let currencies):
                self.currencies.accept(currencies)
                self.currenciesStrings = currencies.map({"\($0.emoji!) \($0.code)"})
                self.baseCurrency.accept(currencies.first(where: {Double($0.fraction)! == 1}))
            case .failure(let err):
                self.apiErrorObservable.accept(err)
            }
        }
    }
    
    func fetchCurrencies(base: String) {
        animatedCellIndex = []
        isLoadingObservable.accept(true)
        repository.getCurrencies(basedOn: base) { [weak self] res in
            guard let self = self else {return}
            self.isLoadingObservable.accept(false)
            switch res{
            case .success(let currencies):
                self.currencies.accept(currencies)
                self.currenciesStrings = currencies.map({"\($0.emoji!) \($0.code)"})
            case .failure(let err):
                self.apiErrorObservable.accept(err)
            }
        }
    }
    
    
}
