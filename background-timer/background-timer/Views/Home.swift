//
//  Home.swift
//  background-timer
//
//  Created by jay on 9/9/26.
//

import SwiftUI
import Combine

struct Home: View {
    
    @Environment(TimerViewModel.self) var viewModel
    @State private var progress: CGFloat = 1.0
    
    private var startButton: some View {
        Button(action: startTimer) {
            Circle()
                .fill(Color.blue.gradient)
                .frame(width: 80, height: 80)
                .overlay {
                    Text("Start")
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                }
        }
        .disabled(viewModel.time == 0)
        .opacity(viewModel.time == 0 ? 0.6 : 1.0)
        .padding(.bottom, 35)
    }
    
    private func startTimer() {
        withAnimation(Animation.easeInOut(duration: 0.65)) {
            viewModel.buttonAnimation.toggle()
        }
        withAnimation(Animation.easeIn.delay(0.6)) {
            viewModel.timerViewOffset = 0
        }
        viewModel.performNotification()
    }
    
    @ViewBuilder
    func timerSlidingView(_ geo: GeometryProxy) -> some View {
        
        Rectangle()
            .fill(Color.blue.gradient)
            .overlay {
                Text("\(viewModel.formatTime(seconds: viewModel.selectedTime))")
                    .font(.system(size: 55, weight: .heavy))
                    .foregroundStyle(.white)
                    .countdownStyle($progress)
                    .onChange(of: viewModel.selectedTime) { _, newValue in
                        progress = CGFloat(newValue) / CGFloat(viewModel.time)
                    }
            }
            .frame(height: geo.size.height - viewModel.timerHeightChange)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
            .offset(y: viewModel.timerViewOffset)
    }
    
    private func timerProgress(_ geo: GeometryProxy) {
        if viewModel.time > 0 && viewModel.selectedTime > 0 && viewModel.buttonAnimation == true {
            viewModel.selectedTime -= 1
            let progressHeight = geo.size.height / CGFloat(viewModel.time)
            let diff = viewModel.time - viewModel.selectedTime
            
            withAnimation(.bouncy) {
                viewModel.timerHeightChange = CGFloat(diff) * progressHeight
            }
            if viewModel.selectedTime == 0 {
                viewModel.resetView()
            }
        }
    }
    
    private func publishNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
            
        UNUserNotificationCenter.current().delegate = viewModel
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack {
                    VStack {
                        CircularPickerView()
                            .environment(viewModel)
                            .frame(height: geo.size.height * 0.8)
                        
                        startButton
                    }
                    
                    timerSlidingView(geo)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.8))
                .ignoresSafeArea()
                .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                    timerProgress(geo)
                }
            }
            .onAppear {
                publishNotification()
            }
            .navigationTitle("Background Timer")
        }
    }
}
