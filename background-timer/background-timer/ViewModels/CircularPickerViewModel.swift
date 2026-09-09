//
//  CircularPickerViewModel.swift
//  background-timer
//
//  Created by jay on 9/9/26.
//

import SwiftUI

@Observable
final class CircularPickerViewModel {
    var selectedValue: Int = 5
    
    let totalValues: Int = 12
    
    func selectValue(_ value: Int) {
        selectedValue = value
    }
}
