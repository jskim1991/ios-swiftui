//
//  TimerViewModel.swift
//  background-timer
//
//  Created by jay on 9/9/26.
//

import SwiftUI
import UserNotifications
import Combine

@Observable
final class TimerViewModel: NSObject, UNUserNotificationCenterDelegate {
    var time: Int = 0
    var selectedTime: Int = 0
    var buttonAnimation = false
    
    var timerViewOffset: CGFloat = UIScreen.main.bounds.height
    var timerHeightChange: CGFloat = 0
    var leftTime: Date!
    
    func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    func resetView() {
        withAnimation {
            time = 0
            selectedTime = 0
            timerHeightChange = 0
            timerViewOffset = UIScreen.main.bounds.height
            buttonAnimation = false
            leftTime = nil
        }
    }
    
    func performNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Time is up!"
        content.body = "Your time is up!"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(time), repeats: false)
        let request = UNNotificationRequest(identifier: "TIMER", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.banner, .sound])
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        resetView()
        completionHandler()
    }
    
        
}
