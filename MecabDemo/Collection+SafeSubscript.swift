//
//  Collection+SafeSubscript.swift
//  MecabDemo
//
//  Created by Landon Epps on 10/11/21.
//

import Foundation

extension Array {
    subscript (safe index: Index) -> Element? {
        0 <= index && index < count ? self[index] : nil
    }
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
