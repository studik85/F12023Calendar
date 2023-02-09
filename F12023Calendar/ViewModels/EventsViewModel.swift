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
    @Published var eventLocation: Race? {
        didSet {
            updateMapRegion(location: eventLocation!)
        }
    }
    
    // Текущий регион на карте
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    // Показать список гонок
    @Published var showEventList: Bool = false
    
    @Published var sheetEvents: Race? = nil
    
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
                    self?.eventLocation = racesSchedule.mrData.raceTable.races.first!
                    self?.updateMapRegion(location: racesSchedule.mrData.raceTable.races.first!)
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
    
    private func updateMapRegion (location: Race) {
        withAnimation(.easeInOut) {
            mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Double(eventLocation?.circuit.location.lat ?? "") ?? 0.0000, longitude: Double(eventLocation?.circuit.location.long ?? "") ?? 0.0000), span: mapSpan)
        }
    }
    
    func toggleEventsList() {
        withAnimation(.easeInOut) {
            showEventList.toggle()
        }
    }
    
    func showNextEvent(raceLocation: Race) {
        withAnimation(.easeInOut) {
            eventLocation = raceLocation
            showEventList = false
        }
    }
    
    func nextButtonPressed() {
        // get the current index
        guard let currentIndex = allEvents.firstIndex(where: { $0 == eventLocation }) else {return}
        
        let nextIndex = currentIndex + 1
        guard allEvents.indices.contains(nextIndex) else {
            guard let firstLocation = allEvents.first else {return}
            showNextEvent(raceLocation: firstLocation)
            return
            
        }
        
        // Next
        let nextEvent = allEvents[nextIndex]
        showNextEvent(raceLocation: nextEvent)
    }
    
    func prevButtonPressed() {
        // get the current index
        guard let currentIndex = allEvents.firstIndex(where: { $0 == eventLocation }) else {return}
        
        let nextIndex = currentIndex - 1
        guard allEvents.indices.contains(nextIndex) else {
            guard let firstLocation = allEvents.first else {return}
            showNextEvent(raceLocation: firstLocation)
            return
            
        }
        
        // Next
        let nextEvent = allEvents[nextIndex]
        showNextEvent(raceLocation: nextEvent)
    }
    
    func convertUTCDateToLocalDate(date: String, time: String) -> String {
        let stringDate: String = date + "T" + time
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let newDate = formatter.date(from: stringDate)
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let localDateStr = formatter.string(from: newDate!)
        return localDateStr
    }
    
}
