//
//  OnboardingView.swift
//  onboarding-flow
//
//  Created by jay on 9/11/26.
//

import SwiftUI

struct OnboardingView: View {
    
    @State private var viewModel: OnboardingViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(steps: [OnboardingStep], onComplete: @escaping () -> Void = {}) {
        self._viewModel = State(wrappedValue: OnboardingViewModel(steps: steps, onComplete: onComplete))
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                headerView
                contentScrollView
                 bottomNavigationView
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
            .onAppear {
                viewModel.updateScreenSize(geometry.size)
            }
            .onChange(of: geometry.size) { _, newValue in
                viewModel.updateScreenSize(newValue)
            }
            .preferredColorScheme(.dark)
        }
    }
    
    private var headerView: some View {
        HStack {
            Spacer()
            
            Button("Skip") {
                dismiss()
            }
            .foregroundStyle(.white)
            .font(.body.weight(.medium))
            .padding()
            .background(.ultraThinMaterial, in: Capsule())

        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        
    }
    
    private var contentScrollView: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(Array(viewModel.steps.enumerated()), id: \.element.id) { idx, step in
                    OnboardingStepView(step: step, screenSize: viewModel.screenSize)
                        .containerRelativeFrame(.horizontal)
                        .id(idx)
                }
                
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $viewModel.currentIndex)
        .scrollTargetBehavior(.paging)
        .scrollIndicators(.hidden)
    }
    
    private var bottomNavigationView: some View {
        
        HStack(alignment: .bottom, spacing: 24) {
            PaginationIndicator(totalPages: viewModel.steps.count, currentIndex: viewModel.currentIndex ?? 0)
            
            Spacer()
            
            OnboardingNavigationButton(
                action: viewModel.navigateToNext,
                backgroundColor: viewModel.currentStep.accentColor,
                iconName: viewModel.isLastStep ? "checkmark" : "chevron.right",
                accessibilityLabel: viewModel.isLastStep ? "Complete onboarding" : "Next step"
            )
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 32)
    }
}
