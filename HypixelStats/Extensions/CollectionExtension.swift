//
//  CollectionExtension.swift
//  HypixelStats
//
//  Created by Edison Ooi on 10/8/21.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
