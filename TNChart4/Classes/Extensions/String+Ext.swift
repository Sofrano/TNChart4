//
//  String+Ext.swift
//  terminal
//
//  Created by Dmitriy Safarov on 13.05.2021.
//

import Foundation

extension StringProtocol where Self: RangeReplaceableCollection {
    /// Insert Separator every n characters
    mutating func insert(separator: String, every nth: Int) {
        indices.reversed().forEach {
            if $0 != startIndex { if distance(from: startIndex, to: $0) % nth == 0 { insert(contentsOf: separator, at: $0) } }
        }
    }

    /// Insert Separator every n characters
    func inserting(separator: String, every nth: Int) -> Self {
        var string = self
        string.insert(separator: separator, every: nth)
        return string
    }
}
