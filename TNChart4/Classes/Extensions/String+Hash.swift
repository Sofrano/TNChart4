//
//  String+Hash.swift
//  terminal
//
//  Created by Dmitriy Safarov on 23.01.2021.
//

import Foundation

extension String {
    
    /// Javascript hash of string
    public var jsHash: String {
        var hash: Int32 = 0
        for char in self {
            guard let asciiValue = char.asciiValue else { continue }
            hash = (hash << 5 &- hash) &+ Int32(asciiValue)
        }
        return String(hash)
    }
    
}
