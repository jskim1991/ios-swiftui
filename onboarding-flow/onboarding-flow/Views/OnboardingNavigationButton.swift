//
//  OnboardingNavigationButton.swift
//  onboarding-flow
//
//  Created by jay on 9/11/26.
//

import SwiftUI

struct OnboardingNavigationButton : View {
    let action: () -> Void
    let backgroundColor: Color
    let iconName: String
    let accessibilityLabel: String
    
    var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
                .font(.title2.bold())
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(backgroundColor, in: Circle())
        }
        .accessibilityLabel(accessibilityLabel)
    }
}
