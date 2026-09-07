//
//  ContentView.swift
//  snow-fall-animation
//
//  Created by jay on 9/7/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        SnowFallAnimationView()
    }
}

#Preview {
    ContentView()
}

struct Snowflake: Identifiable {
    let id = UUID()
    var x: Double
    var y: Double
    var scale: Double
    var speed: Double
}

struct SnowFallAnimationView: View {
    @State private var snowflakes: [Snowflake] = []
    @State private var timer: Timer?
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue, .indigo]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            Canvas {
                context,
                size in
                for snowflake in snowflakes {
                    context.draw(
                        Text("❄️")
                            .font(.system(size: 10 * snowflake.scale)),
                        at: CGPoint(x: snowflake.x * size.width, y: snowflake.y * size.height)
                    )
                }
                
            }.ignoresSafeArea()
            
            Text("Snowflakes")
                .font(.custom("Noteworthy", size: 70))
                .foregroundStyle(.white)
        }
        .onAppear() {
            startSnowFall()
        }
        .onDisappear() {
            timer?.invalidate()
        }
    }
    
    func startSnowFall() {
        for _ in 0..<50 {
            snowflakes.append(
                Snowflake(
                    x: Double.random(in: 0...1),
                    y: Double.random(in: -0.2...0),
                    scale: Double.random(in: 0.5...1.5),
                    speed: Double.random(in: 0.001...0.003)
                )
            )
        }
        
        timer = Timer.scheduledTimer(
            withTimeInterval: 0.016,
            repeats: true,
            block: { _ in
                for i in snowflakes.indices {
                    snowflakes[i].y += snowflakes[i].speed
                    
                    if (snowflakes[i].y > 1.2) {
                        snowflakes[i].y = -0.2
                        snowflakes[i].x = Double.random(in: 0...1)
                    }
                }
            }
        )
    }
}
