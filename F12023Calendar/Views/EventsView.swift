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
        }
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
            .environmentObject(EventViewModel())
    }
}
