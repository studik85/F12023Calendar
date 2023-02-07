//
//  F12023CalendarApp.swift
//  F12023Calendar
//
//  Created by Andrey Studenkov on 05.02.2023.
//

import SwiftUI

@main
struct F12023CalendarApp: App {
    
    @StateObject private var vm = EventViewModel()
    
    var body: some Scene {
        WindowGroup {
            EventsView()
                .environmentObject(vm)
        }
    }
}
