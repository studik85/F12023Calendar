//
//  EventsView.swift
//  F12023Calendar
//
//  Created by Andrey Studenkov on 05.02.2023.
//

import SwiftUI
import MapKit


struct EventsView: View {
    
    @EnvironmentObject private var vm: EventViewModel
    
    var body: some View {
        VStack {
            Text(vm.scheduleOfRaces?.mrData.raceTable.races.first?.raceName ?? "")
        }
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
            .environmentObject(EventViewModel())
    }
}
