//
//  EventsDataServices.swift
//  F12023Calendar
//
//  Created by Andrey Studenkov on 05.02.2023.
//

import Foundation

import Combine

class EventsDataServices: ObservableObject {
    
    @Published var raceEvents : ScheduleOfRacesForASeason?
    var cancellables = Set<AnyCancellable>()
    
    init() {
        getRacesData()
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
            .decode(type: ScheduleOfRacesForASeason.self, decoder: JSONDecoder())
            .sink { (complition) in
            } receiveValue: {[weak self](returnedEvents) in
                self?.raceEvents = returnedEvents
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
