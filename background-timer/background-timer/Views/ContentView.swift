//
//  ContentView.swift
//  background-timer
//
//  Created by jay on 9/9/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
            .environment(TimerViewModel())
            .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
