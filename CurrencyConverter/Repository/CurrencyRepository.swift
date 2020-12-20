//
//  CurrencyRepository.swift
//  CurrencyConverter
//
//  Created by Yousef on 12/20/20.
//

import Foundation

class CurrencyRepository {
    
    private var service: CurrencyService
    private var cachedCurrencies: [Currency] = []
    
    init(service: CurrencyService) {
        self.service = service
    }
    
    func clearCache() {
        cachedCurrencies = []
    }
    
    func getAllCurrencies(completion: @escaping(Result<[Currency], APIErrorType>)-> Void) {
        if cachedCurrencies.isEmpty {
            service.getAllCurrencies{ [weak self] res in
                guard let self = self else {return}
                switch res {
                case .success(let currency):
                    let currencies = currency.rates?.map{ Currency(code: $0.key, fraction: $0.value) } ?? []
                    self.cachedCurrencies = currencies.sorted(by: {$0.code < $1.code})
                    completion(.success(self.cachedCurrencies))
                case .failure(let err):
                    completion(.failure(err))
                }
            }
        } else {
            completion(.success(cachedCurrencies))
        }
    }
    
    func getCurrencies(basedOn base: String, completion: @escaping (Result<[Currency], APIErrorType>)-> Void) {
        getAllCurrencies() { [weak self] res in
            guard let self = self else {return}
            switch res {
            case .success(_):
                completion(.success(self.calculateCurrencies(forBase: base)))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
    
    func calculateCurrencies(forBase base: String)-> [Currency] {
        var currenies = cachedCurrencies
        guard let newBase = currenies.first(where: { $0.code == base }) else {
            assert(false, "No such base \(base)")
        }
        let newBaseFraction = 1 / Double(newBase.fraction)!
        currenies.mutateEach{ currency in
            let newFraction = newBaseFraction / (1 / Double(currency.fraction)!)
            currency.fraction = String(format: "%.3f", newFraction)
        }
        return currenies.sorted(by: {$0.code < $1.code})
    }
    
}
