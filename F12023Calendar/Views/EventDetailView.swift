//
//  EventDetailView.swift
//  F12023Calendar
//
//  Created by Andrey Studenkov on 08.02.2023.
//

import SwiftUI
import MapKit

struct EventDetailView: View {
    @EnvironmentObject private var vm: EventViewModel
    @EnvironmentObject private var lnManager: LocalNotificationManager
    let event: Race
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 5){
                imageSection
                    .shadow(color: Color.black.opacity(0.3) , radius: 20, x: 0, y: 10)
                VStack(alignment: .leading, spacing: 5) {
                    raceSection
                    Divider()
                    firstPracticeSection
                    Divider()
                    if event.thirdPractice?.date != nil {
                        secondPracticeSection
                        Divider()
                        thirdPracticeSection
                        Divider()
                        qualificationSection
                        Divider()
                    } else {
                        qualificationSection
                        Divider()
                        secondPracticeSection
                        Divider()
                        sprintSection
                        Divider()
                    }
                    if let url = URL(string: event.circuit.url) {
                        Link("Wiki", destination: url)
                            .font(.headline)
                            .tint(.blue)
                    }
                    mapLayer
                }
            }
            .frame(maxWidth: .infinity , alignment: .leading)
            .padding()
        }
        
        .ignoresSafeArea()
        .background(.ultraThinMaterial)
        .overlay(backButton, alignment: .topTrailing)
        
    }
    
}

extension EventDetailView {
    private var imageSection: some View {
        Image(event.circuit.circuitName)
            .resizable()
            .scaledToFit()
            .padding(.top, 25)
        //                    .frame(width: UIScreen.main.bounds.width)
        //                    .clipped()
    }
    
    private var raceSection: some View {
        
        VStack(alignment: .leading, spacing: 5) {
            Text(event.raceName)
                .font(.title)
                .fontWeight(.semibold)
            Text("Race")
                .font(.title2)
                .fontWeight(.semibold)
            Text(vm.convertUTCDateToLocalDate(date: event.date, time: event.time))
                .font(.headline)
                .fontWeight(.semibold)
        }
    }
    
    private var notificationSection: some View {
        VStack {
            List{
                ForEach(lnManager.pendingRequests, id: \.identifier) { request in
                    
                    VStack(alignment: .leading) {
                        Text(request.content.title)
                        HStack {
                            Text(request.content.body)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                    }
                    .listRowBackground(Color.clear)
                    .swipeActions {
                        Button("Delete", role: .destructive) {
                            lnManager.removeRequest(withIdentifier: request.identifier)
                        }
                    }
                    
                }
            }
            .listStyle(.plain)
        }
    }
    
    private var firstPracticeSection: some View {
        VStack(alignment: .leading, spacing: 5){
            Text("First Practice")
                .font(.title2)
                .fontWeight(.semibold)
            Text(vm.convertUTCDateToLocalDate(date: event.firstPractice.date, time: event.firstPractice.time))
                .font(.headline)
                .fontWeight(.semibold)
        }
    }
    
    private var secondPracticeSection: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Second Practice")
                .font(.title2)
                .fontWeight(.semibold)
            Text(vm.convertUTCDateToLocalDate(date: event.secondPractice.date, time: event.secondPractice.time))
                .font(.headline)
                .fontWeight(.semibold)
        }
    }
    
    private var thirdPracticeSection: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Third Practice")
                .font(.title2)
                .fontWeight(.semibold)
            Text(vm.convertUTCDateToLocalDate(date: event.thirdPractice?.date ?? "no date", time: event.thirdPractice?.time ?? "no time"))
                .font(.headline)
                .fontWeight(.semibold)
        }
    }
    
    private var qualificationSection: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Qualifying")
                .font(.title2)
                .fontWeight(.semibold)
            Text(vm.convertUTCDateToLocalDate(date: event.qualifying.date, time: event.qualifying.time))
                .font(.headline)
                .fontWeight(.semibold)
        }
    }
    
    private var sprintSection: some View {
        VStack (alignment: .leading, spacing: 5){
            Text("Sprint")
            Text(vm.convertUTCDateToLocalDate(date: event.sprint?.date ?? "no date", time: event.sprint?.time ?? "no time"))
        }
    }
    
    private var mapLayer: some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(
            latitude: Double(event.circuit.location.lat) ?? 0.0000,
            longitude: Double(event.circuit.location.long) ?? 0.0000),
                                                           span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))),
            annotationItems: [event]) { event in
            MapAnnotation(coordinate:
                            CLLocationCoordinate2D(
                                latitude: Double(event.circuit.location.lat) ?? 0.0000,
                                longitude: Double(event.circuit.location.long) ?? 0.0000)) {
                                    EventMapAnnotationView()
                                        .shadow(radius: 10)
                                }
            
        }
            .allowsHitTesting(false)
            .aspectRatio(1, contentMode: .fit)
            .cornerRadius(30)
    }
    
    private var backButton: some View {
        Button {
            vm.sheetEvents = nil
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
                .padding(16)
                .foregroundColor(.primary)
                .background(.thickMaterial)
                .cornerRadius(10)
                .shadow(radius: 4)
                .padding()
        }
        
    }
    
}
