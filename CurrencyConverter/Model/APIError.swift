//
//  APIError.swift
//  QuantumSitTask
//
//  Created by Yousef on 12/9/20.
//

import Foundation

struct APIError: Error {
    
    internal init(data: Data?, error: Error?, statusCode: Int?) {
        self.data = data
        self.error = error
        self.statusCode = statusCode
        self.errorType = APIErrorType(rawValue: statusCode ?? 0)
    }
    
    let data: Data?
    let error: Error?
    let statusCode: Int?
    let errorType: APIErrorType
    
    
}
