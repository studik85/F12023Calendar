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
    //    @State var mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 26.0325, longitude: 50.5106), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $vm.mapRegion)
                .ignoresSafeArea()
            VStack(spacing: 0){
                header
                    .padding()
                Spacer()
                
                ZStack{
                    ForEach(vm.allEvents) { event in
                        if vm.eventLocation == event {
                            EventPreviewView(event: event)
                                .shadow(color: Color.black.opacity(0.3), radius: 20)
                                .padding()
                                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                        }
                        
                    }
                }
            }
        }
    }
}


struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
            .environmentObject(EventViewModel())
    }
}


extension EventsView {
    
    private var header: some View {
        
        VStack {
            Button (action: vm.toggleEventsList) {
                Text("\(vm.eventLocation?.circuit.location.country ?? ""), \(vm.eventLocation?.circuit.location.locality ?? "")" )
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .overlay(alignment: .leading) {
                        Image(systemName: "arrow.down")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding()
                            .rotationEffect(Angle(degrees: vm.showEventList ? 180 : 0))
                    }
            }
                
                
                if vm.showEventList {
                    EventsListView()
                }
            
        }
        .background(.ultraThinMaterial)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 15)
    }
}
