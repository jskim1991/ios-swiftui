//
//  ContentView.swift
//  notification-demo
//
//  Created by jay on 9/8/26.
//

import SwiftUI

struct ContentView: View {
    @State private var systemNotification = SystemNotificationExample()
    
    var body: some View {
        let layout = systemNotification.orientation == .portrait ? AnyLayout(VStackLayout()) : AnyLayout(HStackLayout())
        
        NavigationStack {
            layout {
                ReceiverView()
                SenderView()

            }.onChange(of: systemNotification.orientation) { oldValue, newValue in
                print(oldValue, " -> ", newValue)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

struct SenderView: View {
    var body: some View {
        ZStack {
            Color.orange.opacity(0.2)
            Button("Send Notification") {
                let center = NotificationCenter.default
                let name = Notification.Name("JAlert")
                
                let course = Course(name: UUID().uuidString, author: UUID().uuidString)
                let additionalInfo = ["Course": course]
                
                center.post(
                    name: name,
                    object: nil,
                    userInfo: additionalInfo
                )
            }
        }
    }
}

struct ReceiverView: View {
    @State private var counter: Int = 0
    @State private var additionalInfo: String = ""
    
    var body: some View {
        ZStack {
            Color.blue.opacity(0.2)
            
            VStack {
                Text("Received \(counter) notifications")
                if !additionalInfo.isEmpty {
                    Text(additionalInfo)
                }
            }
        }
        .onAppear {
            Task(priority: .background) {
                await receiveNotifications()
            }
        }
    }
    
    private func receiveNotifications() async {
        let center = NotificationCenter.default
        let name = Notification.Name("JAlert")
        
        for await notification in center.notifications(named: name) {
            if let userInfo = notification.userInfo,
               let moreInfo = userInfo["Course"] as? Course {
                await MainActor.run {
                    additionalInfo = "\(moreInfo.name) by \(moreInfo.author)"
                }
            }
            
            await MainActor.run {
                counter += 1
            }
        }
    }
}

struct Course: Codable {
    var name: String
    var author: String
}

enum Orientation {
    case portrait
    case landscape
}

@Observable
final class SystemNotificationExample {
    let center = NotificationCenter.default
    var orientation = Orientation.portrait
    
    init() {
        Task(priority: .background) {
            await subscribeToOrientationChangeNotifications()
        }
    }
    
    @MainActor
    func subscribeToOrientationChangeNotifications() async {
        let name = UIDevice.orientationDidChangeNotification
        for await notification in center.notifications(named: name) {
            if let device = notification.object as? UIDevice {
                
                print(device.orientation)
                if device.orientation.isPortrait {
                    orientation = .portrait
                } else if device.orientation.isLandscape {
                    orientation = .landscape
                }
            }
        }
    }
}

extension Notification: @unchecked Sendable {
    
}
