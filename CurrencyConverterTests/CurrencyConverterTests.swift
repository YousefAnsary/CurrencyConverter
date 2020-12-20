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
                print(currencues)
                expectation.fulfill()
            case .failure(let err):
                XCTFail("Failed with error: \(err.localizedDescription)")
            }
        })
        self.waitForExpectations(timeout: 5)
    }
    
    
    #warning("Remove")
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
