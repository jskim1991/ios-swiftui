//
//  ContentView.swift
//  color-mixer-app
//
//  Created by jay on 8/29/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ColorMixerApp()
    }
}

#Preview {
    ContentView()
}


struct ColorMixerApp: View {
    @State private var red: Double = 0
    @State private var green: Double = 0
    @State private var blue: Double = 0
    @FocusState private var focusedChannel: String?
    
    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())

            VStack(spacing: 20) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: red / 255, green: green / 255, blue: blue / 255))
                        .frame(height: 250)
                    Text("Color Preview")
                        .foregroundStyle(.white)
                        .bold()
                        .shadow(radius: 5)
                }

                VStack(spacing: 20) {
                    ColorSlider(value: $red, text: "Red", color: Color.red, focus: $focusedChannel)
                    ColorSlider(value: $green, text: "Green", color: Color.green, focus: $focusedChannel)
                    ColorSlider(value: $blue, text: "Blue", color: Color.blue, focus: $focusedChannel)
                }.padding()
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .simultaneousGesture(
            TapGesture().onEnded { focusedChannel = nil }
        )
    }
}

enum ColorChannel {
    static let range = 0.0...255.0

    static func clamped(_ input: Double) -> Double {
        min(max(input.rounded(), range.lowerBound), range.upperBound)
    }
}

struct ColorSlider: View {
    @Binding var value: Double
    let text: String
    let color: Color
    @FocusState.Binding var focus: String?

    var body: some View {
        HStack {
            Text(text).frame(width: 50, alignment: Alignment.leading)
                .foregroundStyle(color)
            Slider(value: $value, in: ColorChannel.range, step: 1)
            TextField(text, value: $value, format: .number.precision(.fractionLength(0)))
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.trailing)
                .frame(width: 60)
                .accessibilityIdentifier("\(text)Field")
                .focused($focus, equals: text)
                .onChange(of: focus) { _, current in
                    if current != text { value = ColorChannel.clamped(value) }
                }
        }
    }
}
