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
                
                VStack(alignment: .leading, spacing: 16) {
                    tittleSection
                    Divider()
                    detailSection
                    Divider()
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
            .frame(width: UIScreen.main.bounds.width)
            .clipped()
    }
    
    private var tittleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(event.raceName)
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text(event.date)
                .font(.title2)
            Text(event.time)
                .font(.title2)
        }
    }
    
    private var detailSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(event.firstPractice.date)
            Text(event.firstPractice.time)
            if let url = URL(string: event.url) {
                Link("See More on Wiki", destination: url)
                    .font(.headline)
                    .tint(.blue)
            }
            
        }
    }
    
    private var mapLayer: some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(
            latitude: Double(event.circuit.location.lat) ?? 0.0000,
            longitude: Double(event.circuit.location.long) ?? 0.0000),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))),
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
