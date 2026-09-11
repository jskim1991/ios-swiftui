//
//  OnboardingViewModel.swift
//  onboarding-flow
//
//  Created by jay on 9/11/26.
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class OnboardingViewModel {
    var currentIndex: Int? = 0
    var screenSize: CGSize = .zero
    
    let steps: [OnboardingStep]
    private let onComplete: () -> Void
    
    init(steps: [OnboardingStep], onComplete: @escaping () -> Void = {}) {
        self.steps = steps
        self.onComplete = onComplete
    }
    
    var isLastStep: Bool {
        guard let currentIndex = currentIndex else { return false }
        
        return currentIndex >= steps.count - 1
    }
    
    var currentStep: OnboardingStep {
        guard let currentIndex = currentIndex else {
            return steps.first!
        }
        
        
        return steps[safe: currentIndex] ?? steps.first!
    }
    
    func updateScreenSize(_ size: CGSize) {
        self.screenSize = size
    }
    
    func updateCurrentIndex(_ index: Int) {
        guard index >= 0 && index < steps.count else { return }
        
        if index != currentIndex {
            currentIndex = index
        }
    }
    
    func navigateToNext() {
        guard !isLastStep else {
            commpleteOnboarding()
            return
        }
        
        let current = currentIndex ?? 0
        let nextIndex = min(current + 1, steps.count - 1)
        withAnimation(.easeInOut(duration: 0.3)) {
            currentIndex = nextIndex
        }
    }
    
    private func commpleteOnboarding() {
        onComplete()
    }
}

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
