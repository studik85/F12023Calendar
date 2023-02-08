//
//  EventsViewModel.swift
//  F12023Calendar
//
//  Created by Andrey Studenkov on 07.02.2023.
//  Download JSON from API in Swift w/ URLSession and escaping closures

import Foundation
import SwiftUI
import MapKit

class EventViewModel: ObservableObject {
    
    @Published var scheduleOfRaces: ScheduleOfRaces?
    @Published var allEvents: [Race] = []
    @Published var eventLocation: Location? {
        didSet {
            updateMapRegion(location: eventLocation!)
        }
    }
    
    // Текущий регион на карте
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    // Показать список гонок
    @Published var showEventList: Bool = false
    
    init() {
        getScheduleOfRaces()
       
    }
    
    func getScheduleOfRaces() {
        
        guard let url = URL(string: "https://ergast.com/api/f1/2023.json") else {return}
        
        downloadData(fromURL: url) { (returnedData) in
            if let data = returnedData {
                guard let racesSchedule = try? JSONDecoder().decode(ScheduleOfRaces.self, from: data) else {return}
                DispatchQueue.main.async { [weak self] in
                    self?.scheduleOfRaces = racesSchedule
                    self?.allEvents = racesSchedule.mrData.raceTable.races
                    self?.eventLocation = racesSchedule.mrData.raceTable.races.first!.circuit.location
                    self?.updateMapRegion(location: racesSchedule.mrData.raceTable.races.first!.circuit.location)
                }
                
            } else {
                print("No data returned.")
            }
        }

    }
    
    func downloadData(fromURL url: URL, complitionHandler: @escaping (_ data: Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let data = data,
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {
                print("Error Downloading Data.")
                complitionHandler(nil)
                return
            }
            complitionHandler(data)

            
            
        }
        .resume()
    }
    
    private func updateMapRegion (location: Location) {
        withAnimation(.easeInOut) {
            mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Double(eventLocation?.lat ?? "") ?? 0.0000, longitude: Double(eventLocation?.long ?? "") ?? 0.0000), span: mapSpan)
        }
    }
    
    func toggleEventsList() {
        withAnimation(.easeInOut) {
            showEventList.toggle()
        }
    }
    
    func showNextEvent(location: Location) {
        withAnimation(.easeInOut) {
    eventLocation = location
            showEventList = false
        }
    }
    
}
