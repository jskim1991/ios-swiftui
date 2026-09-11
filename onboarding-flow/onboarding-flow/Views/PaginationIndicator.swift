//
//  AnimatedPageIndicator.swift
//  onboarding-flow
//
//  Created by jay on 9/11/26.
//

import SwiftUI

struct PaginationIndicator : View {
    let totalPages: Int
    let currentIndex: Int
    let indicatorSpacing: CGFloat = 12
    let indicatorHeight: CGFloat = 7
    let activeIndicatorWidth: CGFloat = 20
    let inactiveIndicatorWidth: CGFloat = 7
    
    var body: some View {
        HStack(spacing: indicatorSpacing) {
            ForEach(0..<totalPages, id: \.self) { idx in
                Capsule()
                    .foregroundStyle(.white.gradient)
                    .frame(
                        width: currentIndex == idx ? activeIndicatorWidth : inactiveIndicatorWidth,
                        height: indicatorHeight
                    )
                    .animation(.easeInOut(duration: 0.3), value: currentIndex)   
            }
        }
    }
}
