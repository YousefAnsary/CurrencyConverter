//
//  CurrencyService.swift
//  CurrencyConverter
//
//  Created by Yousef on 12/20/20.
//

import Foundation

class CurrencyService {
    
    func getAllCurrencies(completion: @escaping(Result<CurrencyResponse, APIErrorType>)-> Void) {
        
        URLSessionManager.shared.request(endpoint: Endpoint.latest) { (data, res, err) in
            
            let statusCode = (res as? HTTPURLResponse)?.statusCode
            guard let data = data, statusCode == 200, err == nil else {
                completion(.failure(APIErrorType(rawValue: statusCode ?? 0)))
                return
            }
            
            do {
                let decodedData = try data.decode(to: CurrencyResponse.self)
                completion(.success(decodedData))
            } catch {
                completion(.failure(APIErrorType.decodingFailed))
            }
            
        }
        
    }
    
}
