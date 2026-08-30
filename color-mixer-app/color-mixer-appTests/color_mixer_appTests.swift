//
//  color_mixer_appTests.swift
//  color-mixer-appTests
//
//  Created by jay on 8/29/26.
//

import Testing
@testable import color_mixer_app

struct ColorSliderClampTests {

    @Test func keepsInteriorValue() {
        #expect(ColorChannel.clamped(128) == 128)
    }

    @Test func clampsAboveMax() {
        #expect(ColorChannel.clamped(999) == 255)
    }

    @Test func clampsBelowMin() {
        #expect(ColorChannel.clamped(-40) == 0)
    }

    @Test(arguments: [0.0, 255.0])
    func keepsBoundary(boundary: Double) {
        #expect(ColorChannel.clamped(boundary) == boundary)
    }

    @Test func roundsFractionDown() {
        #expect(ColorChannel.clamped(127.4) == 127)
    }

    @Test func roundsFractionUp() {
        #expect(ColorChannel.clamped(127.6) == 128)
    }

    @Test func roundsBeforeClampingAtUpperBound() {
        #expect(ColorChannel.clamped(255.6) == 255)
    }
}
