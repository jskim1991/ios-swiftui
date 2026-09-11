//
//  OnboardingStep.swift
//  onboarding-flow
//
//  Created by jay on 9/11/26.
//

import Foundation
import SwiftUI

struct OnboardingStep: Identifiable, Equatable {
    let id = UUID()
    let imageName: String
    let title: String
    let description: String
    let accentColor: Color
    
    static func == (l: OnboardingStep, r: OnboardingStep) -> Bool {
        l.id == r.id
    }
}

extension OnboardingStep {
    static let sample: [OnboardingStep] = [
        OnboardingStep(
            imageName: "food1",
            title: "Choose Your Favorite Menu",
            description: "Discover delicious option tailored to your preferences and dietary needs.",
            accentColor: .blue
        ),
        OnboardingStep(
            imageName: "food2",
            title: "Find the Best Prices & Deals",
            description: "Compare prices across multiple vendors to get the best deals on your favorites",
            accentColor: .yellow
        ),
        OnboardingStep(
            imageName: "food3",
            title: "Fast & Reliable Delivery",
            description: "Your food is prepared with care and delivered quickly to your doorstep.",
            accentColor: .pink
        ),    
    ]
}
