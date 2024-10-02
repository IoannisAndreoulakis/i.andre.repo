//
//  ContentView.swift
//  SimpleAPNProject
//
//  Created by Ioannis Andreoulakis on 20/9/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var notificationManager = NotificationManager()
    var body: some View{
        VStack{
            Button("Request Notification"){
                Task{
                    await notificationManager.request()
                }
            }
            .buttonStyle(.bordered)
            .disabled(notificationManager.hasPermission)
            .task {
                await notificationManager.getAuthStatus()
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
