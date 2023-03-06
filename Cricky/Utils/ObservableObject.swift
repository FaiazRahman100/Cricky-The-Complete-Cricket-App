//
//  ObservableObject.swift
//  Cricky
//
//  Created by Faiaz Rahman on 18/2/23.
//

import Foundation

class ObservableObject<T> {
    private var listener: ((T) -> Void)?
    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func bind(listener: @escaping (T) -> Void) {
        self.listener = listener
    }
}
