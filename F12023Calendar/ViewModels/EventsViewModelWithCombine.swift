//
//  EventsDataServices.swift
//  F12023Calendar
//
//  Created by Andrey Studenkov on 05.02.2023.
//

import Foundation
import Combine
import SwiftUI
import MapKit

class EventsViewModelWithCombine: ObservableObject {
    
    
    @Published var raceEvents : ScheduleOfRaces?
    @Published var racingWeeknd: [Race] = []
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        getRacesData()
        self.racingWeeknd = raceEvents?.mrData.raceTable.races ?? []
        print(racingWeeknd)
    }
    
    func getRacesData() {
        
        guard let url = URL(string: "https://ergast.com/api/f1/2023.json") else { return }
        
        // Combine discussion:
        /*
        // 1. Create the Publisher
        // 2. Subscribe the Publisher on background thread
        // 3. Recive on main thread
        // 4. tryMap (check that the data is good)
        // 5. Decode
        // 6. Sink (put the event into our app)
        // 7. Store (cancel subscription if needed)
         */
        
        URLSession.shared.dataTaskPublisher(for: url)
            //.subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type: ScheduleOfRaces.self, decoder: JSONDecoder())
            .sink { (complition) in
            } receiveValue: {[weak self](returnedEvents) in
                self?.raceEvents = returnedEvents
                self?.racingWeeknd = returnedEvents.mrData.raceTable.races
            }
            .store(in: &cancellables)
        
        func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
            guard let response = output.response as? HTTPURLResponse,
                  response.statusCode >= 200 && response.statusCode < 300 else {
                throw URLError(.badServerResponse)
            }
            
            return output.data
        }
        
    }
    
    
}
