//
//  Array+.swift
//  iAlgoDS
//
//  Created by Yousef on 12/19/20.
//

import Foundation

extension Array {
    
    public mutating func mutateEach(by transform: (inout Element) throws -> Void) rethrows {
        self = try map { obj in
            var obj = obj
            try transform(&obj)
            return obj
        }
    }
    
}
