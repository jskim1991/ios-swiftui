//
//  CircularPickerView.swift
//  background-timer
//
//  Created by jay on 9/9/26.
//

import SwiftUI

struct CircularPickerView: View {
    
    @Environment(TimerViewModel.self) private var timerVM
    @State private var viewModel = CircularPickerViewModel()
    
    private let radius: CGFloat = 150
    private let centerPoint = CGPoint(x: 150, y: 150)
    
    private var backCircle: some View {
        Circle()
            .stroke(Color.white.opacity(0.3), lineWidth: 40)
            .frame(width: radius * 2, height: radius * 2)
            .shadow(color: .white, radius: 10)
    }
    
    private var centerToNumberLine: some View {
        Path { path in
            path.move(to: centerPoint)
            path.addLine(to: pointForNumber(viewModel.selectedValue))
        }
        .stroke(Color.blue.opacity(0.5), lineWidth: 2)
    }
    
    private var numberCircle: some View {
        Circle()
            .fill(Color.blue)
            .frame(width: 40, height: 40)
            .position(pointForNumber(viewModel.selectedValue))
            .overlay {
                Text("\(viewModel.selectedValue * 5)")
                    .foregroundStyle(.primary)
                    .font(.title)
                    .frame(width: 40, height: 40)
                    .padding()
                    .background(Color.blue.gradient, in: Circle())
            }
    }
    
    private var numberForTimer: some View {
        ForEach(1...12, id: \.self) { number in
            numberLabel(for: number)
        }
    }

    private func numberLabel(for number: Int) -> some View {
        let isSelected = number == viewModel.selectedValue
        let font: Font = isSelected ? .system(size: 16) : .system(size: 14)
        let color: Color = isSelected ? .white : .black
        return Text("\(number * 5)")
            .font(font)
            .bold(isSelected)
            .foregroundStyle(color)
            .position(pointForNumber(number))
    }
    
    private var circularDragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let selected = numberFromLocation(value.location)
                viewModel.selectedValue = selected
                timerVM.time = selected * 5
                timerVM.selectedTime = selected * 5
                
            }
    }
    
    private func pointForNumber(_ number: Int) -> CGPoint {
        let angle = 2 * .pi * CGFloat(number - 3) / 12
        return CGPoint(
            x: centerPoint.x + radius * cos(angle),
            y: centerPoint.y + radius * sin(angle)
        )
    }
    
    private func numberFromLocation(_ location: CGPoint) -> Int {
        let angle = atan2(location.y - centerPoint.y, location.x - centerPoint.x)
        var normalizedAngle = angle + .pi / 2
        if normalizedAngle < 0 {
            normalizedAngle += 2 * .pi
        }
        
        let number = Int(round((normalizedAngle / (2 * .pi)) * 12)) + 1
        
        return number > 12 ? 1 : number
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                backCircle
                
                centerToNumberLine
                
                numberCircle
                
                numberForTimer
            }
            .frame(width: radius * 2, height: radius * 2)
            .gesture(circularDragGesture)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
        
    }
}

