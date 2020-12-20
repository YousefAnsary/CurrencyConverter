//
//  Data+.swift
//  QuantumSitTask
//
//  Created by Yousef on 12/9/20.
//

import Foundation

public extension Data {
    
    func decode<T: Decodable>(to: T.Type) throws -> T {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return try decoder.decode(T.self, from: self)
    }
    
    func toDictionsay() throws -> [String: Any?]? {
        return try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any?]
    }
    
}
