//
//  Endpoints.swift
//  QuantumSitTask
//
//  Created by Yousef on 12/9/20.
//

import Foundation

enum Endpoint: String {
    
    case latest = "latest"
    
    var httpMethod: HTTPMethod {
        get {
            switch self {
            case .latest:
                return .get
            }
        }
    }
    
}
