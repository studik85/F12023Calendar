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
            Image(systemName: "flag.checkered.2.crossed")
            //                        .resizable()
            //                        .scaledToFill()
                .frame(width: 45, height: 45)
                .cornerRadius(10)
            VStack (alignment: .leading) {
                Text(event.raceName)
                    .font(.headline)
                Text(event.date)
                    .font(.subheadline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
}
