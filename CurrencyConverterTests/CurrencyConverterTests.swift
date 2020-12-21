//
//  CurrencyConverterTests.swift
//  CurrencyConverterTests
//
//  Created by Yousef on 12/20/20.
//

import XCTest
@testable import CurrencyConverter

class CurrencyConverterTests: XCTestCase {

    var repository: CurrencyRepository?
    
    override func setUpWithError() throws {
        repository = CurrencyRepository(service: CurrencyService())
    }

    override func tearDownWithError() throws {
        repository = nil
    }

    func testGetAllCurrencies() {
        let expectation = self.expectation(description: "Expecting Array of Currencies")
        repository?.getAllCurrencies(completion: { (res) in
            switch res {
            case .success(let currencues):
                XCTAssert(!currencues.isEmpty, "empty data")
                expectation.fulfill()
            case .failure(let err):
                XCTFail("Failed with error: \(err.localizedDescription)")
            }
        })
        self.waitForExpectations(timeout: 5)
    }
    
    func testGetCurrenciesForBase() {
        let expectation = self.expectation(description: "Expecting Array of Currencies")
        repository?.getCurrencies(basedOn: "EGP", completion: { (res) in
            switch res {
            case .success(let currencues):
                let base = currencues.first(where: {$0.code == "EGP"})!
                let usd = currencues.first(where: {$0.code == "USD"})!
                let inr = currencues.first(where: {$0.code == "INR"})!
                XCTAssert(Double(base.fraction) == 1 && usd.fraction == "0.064" && inr.fraction == "4.725", "incorrect calculation")
                expectation.fulfill()
            case .failure(let err):
                XCTFail("Failed with error: \(err.localizedDescription)")
            }
        })
        self.waitForExpectations(timeout: 5)
    }

}
