//
//  EventsViewModel.swift
//  F12023Calendar
//
//  Created by Andrey Studenkov on 07.02.2023.
//  Download JSON from API in Swift w/ URLSession and escaping closures

import Foundation

class EventViewModel: ObservableObject {
    
    @Published var scheduleOfRaces: ScheduleOfRaces?
    
    init() {
        getScheduleOfRaces()
    }
    
    func getScheduleOfRaces() {
        
        guard let url = URL(string: "https://ergast.com/api/f1/2023.json") else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("No Data")
                return
            }
            
            guard error == nil else {
                print("Error: \(String(describing: error))")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("Invalid response.")
                return
            }
            
            guard response.statusCode >= 200 && response.statusCode < 300 else {
                print("Status code should be 2xx, but is \(response.statusCode)")
                return
            }
            
            print("Successfully dowmloaded data!")
            print(data)
            let jsonString = String(data: data, encoding: .utf8)
            print(jsonString)
            
            guard let racesSchedule = try? JSONDecoder().decode(ScheduleOfRaces.self, from: data) else {return}
            DispatchQueue.main.async { [weak self] in
                self?.scheduleOfRaces = racesSchedule
            }
            
        }
        .resume()
    }
}
