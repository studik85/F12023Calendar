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
    let event: Race
    
    var body: some View {
        ScrollView{
            VStack{
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
                        Link("See More on Wiki", destination: url)
                            .font(.headline)
                            .tint(.blue)
                    }
                    mapLayer
                }
                
                .frame(maxWidth: .infinity , alignment: .leading)
                .padding()
            }
        }
        
        .ignoresSafeArea()
        .background(.ultraThinMaterial)
        .overlay(backButton, alignment: .topLeading)
        
    }
    
}

extension EventDetailView {
    private var imageSection: some View {
        Image(event.circuit.circuitName)
            .resizable()
            .scaledToFit()
            .padding(.top, 25)
        //            .frame(width: UIScreen.main.bounds.width)
        //            .clipped()
    }
    
    private var raceSection: some View {
        
            VStack(alignment: .leading, spacing: 8) {
                Text(event.raceName)
                    .font(.headline)
                    .fontWeight(.semibold)
                Text("Race")
                Text(vm.convertUTCDateToLocalDate(date: event.date, time: event.time))
            }
        
    }
    
    
    private var firstPracticeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("First Practice Session")
            Text(vm.convertUTCDateToLocalDate(date: event.firstPractice.date, time: event.firstPractice.time))
            
            
        }
    }
    
    private var secondPracticeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Second Practice Session")
            Text(vm.convertUTCDateToLocalDate(date: event.secondPractice.date, time: event.secondPractice.time))
            
            
            
        }
    }
    
    private var thirdPracticeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Third Practice Session")
            Text(vm.convertUTCDateToLocalDate(date: event.thirdPractice?.date ?? "no date", time: event.thirdPractice?.time ?? "no time"))
        }
    }
    
    private var qualificationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Qualifying")
            Text(vm.convertUTCDateToLocalDate(date: event.qualifying.date, time: event.qualifying.time))
  
            
            
        }
    }
    
    private var sprintSection: some View {
        VStack(alignment: .leading, spacing: 8) {
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
    
    private var notificationButton: some View {
        Button {
           
        } label: {
            HStack {
                Text("Turn")
                Image(systemName: "bell.and.waves.left.and.right")
            }
        }
        .buttonStyle(.borderedProminent)
    }
}
