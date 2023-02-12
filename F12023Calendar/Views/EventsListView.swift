//
//  EventsListView.swift
//  F12023Calendar
//
//  Created by Andrey Studenkov on 08.02.2023.
//

import SwiftUI

struct EventsListView: View {
    
    @EnvironmentObject private var vm: EventViewModel
    
    var body: some View {
        List {
            ForEach(vm.allEvents) { event in
                Button {
                    vm.showNextEvent(raceLocation: event)
                } label: {
                    listRowView(event: event)
                }
                .padding(.vertical, 4)
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(PlainListStyle())
    }
}

struct EventsListView_Previews: PreviewProvider {
    static var previews: some View {
        EventsListView()
            .environmentObject(EventViewModel())
    }
}


extension EventsListView {
    
    private func listRowView(event: Race) -> some View {
        HStack {
            Image(event.circuit.location.country)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 35)
                .cornerRadius(5)
            VStack (alignment: .leading) {
                Text("ROUND \(event.round)")
                    .fontWeight(.bold)
                Text(event.raceName.uppercased())
                    .font(.headline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
}
