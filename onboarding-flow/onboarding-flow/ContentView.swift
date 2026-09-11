//
//  ContentView.swift
//  onboarding-flow
//
//  Created by jay on 9/11/26.
//

import SwiftUI

struct ContentView: View {
    @State private var presentOnboardingFlow: Bool = false
    
    var body: some View {
        
        HomeView()
            .sheet(isPresented: $presentOnboardingFlow) {
                OnboardingView(steps: OnboardingStep.sample) {
                    presentOnboardingFlow = false
                }
                .interactiveDismissDisabled(true)
            }
            .onAppear {
                presentOnboardingFlow = true
            }
            
    }
}

#Preview {
    ContentView()
}
