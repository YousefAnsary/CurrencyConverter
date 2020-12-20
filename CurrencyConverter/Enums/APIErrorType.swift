//
//  APIErrorType.swift
//  QuantumSitTask
//
//  Created by Yousef on 12/9/20.
//

import Foundation

enum APIErrorType: LocalizedError {
    case unAuthenticated
    case unAuthorized
    case notFound
    case methodNotAllowed
    case internalServerError
    case other(statusCode: Int)
    case decodingFailed
    
    var localizedDescription: String? {
        get {
            switch self {
            case .unAuthenticated:
                return "There is some problem with your session, please Re-Login"
            case .unAuthorized:
                return "You are not allowed to do this operation"
            case .notFound:
                return "Not Found"
            case .methodNotAllowed:
                return "Unexpected problem with code: 405 please try again"
            case .internalServerError:
                return "Unexpected problem with code: 405 please try again"
            case .other(let statusCode):
                return "Unexpected problem with code: \(statusCode) please try again"
            case .decodingFailed:
                return "Failed decoding response"
            }
        }
    }
    
    var isRetryable: Bool {
        get {
            switch self {
            case .unAuthenticated:
                return false
            case .unAuthorized:
                return false
            case .notFound:
                return true
            case .methodNotAllowed:
                return true
            case .internalServerError:
                return true
            case .other(let statusCode):
                return true
            case .decodingFailed:
                return true
            }
        }
    }
    
    init(rawValue: Int) {
        switch rawValue {
        case 200:
            self = .decodingFailed
        case 401:
            self = .unAuthenticated
        case 403:
            self = .unAuthorized
        case 404:
            self = .notFound
        case 405:
            self = .methodNotAllowed
        case 500:
            self = .internalServerError
        default:
            self = .other(statusCode: rawValue)
        }
    }
    
}
