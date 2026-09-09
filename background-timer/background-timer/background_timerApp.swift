//
//  background_timerApp.swift
//  background-timer
//
//  Created by jay on 9/9/26.
//

import SwiftUI

@main
struct background_timerApp: App {
    
    @State var viewModel = TimerViewModel()
    @Environment(\.scenePhase) var scene
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
        }
        .onChange(of: scene) { _, newValue in
            #if !targetEnvironment(simulator)
                if newValue == .background {
                    viewModel.leftTime = Date()
                    print("App entered background")
                }
                
                if newValue == .active && viewModel.leftTime != nil {
                    let diff = Date().timeIntervalSince(viewModel.leftTime)
                    let currentTime = viewModel.selectedTime - Int(diff)
                    print("Diff in time", diff)
                    print("current time", currentTime)
                    
                    if currentTime >= 0 {
                        withAnimation(.default) {
                            viewModel.selectedTime = currentTime
                        }
                    } else {
                        viewModel.resetView()
                    }
                    
                }
            #endif
        }
    }
}
