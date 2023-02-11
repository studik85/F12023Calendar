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
    @EnvironmentObject var lnManager: LocalNotificationManager
    @Environment(\.scenePhase) var scenePhase
    let maxWidthForIpad: CGFloat = 700
    
    
    var body: some View {
            ZStack{
                mapLayer
                    .ignoresSafeArea()
                VStack(spacing: 0){
                    header
                        .padding()
                        .frame(maxWidth: maxWidthForIpad)
                    Spacer()
                    eventPreviewStack
                }
            }
            .sheet(item: $vm.sheetEvents, onDismiss: nil) { event in
                EventDetailView(event: event)
            }
            .task {
                try? await lnManager.requestAuthorization()
            }
            .onChange(of: scenePhase) { newValue in
                if newValue == .active {
                    Task {
                       await lnManager.getCurrentSettings()
                        await lnManager.getPendingRequests()
                    }
                    
                }
            }
        }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
            .environmentObject(EventViewModel())
            .environmentObject(LocalNotificationManager())
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
                            .fontWeight(.heavy)
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
    
    private var mapLayer: some View {
        Map(coordinateRegion: $vm.mapRegion,
            annotationItems: vm.allEvents,
            annotationContent: { event in
            MapAnnotation(
                coordinate:
                    CLLocationCoordinate2D(latitude: Double(event.circuit.location.lat) ?? 0.0000,
                                           longitude: Double(event.circuit.location.long) ?? 0.0000)) {
                EventMapAnnotationView()
                    .scaleEffect(vm.eventLocation == event ? 1 : 0.7)
                    .shadow(radius: 10)
                    .onTapGesture {
                        vm.showNextEvent(raceLocation: event)
                    }
            }
        })
    }
    
    private var eventPreviewStack: some View {
        ZStack{
            ForEach(vm.allEvents) { event in
                if vm.eventLocation == event {
                    EventPreviewView(event: event)
                        .shadow(color: Color.black.opacity(0.3), radius: 20)
                        .padding()
                        .frame(maxWidth: maxWidthForIpad)
                        .frame(maxWidth: .infinity)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                }                
            }
        }
    }
}
