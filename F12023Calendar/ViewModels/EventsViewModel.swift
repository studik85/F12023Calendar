//
//  EventsViewModel.swift
//  F12023Calendar
//
//  Created by Andrey Studenkov on 07.02.2023.
//  Download JSON from API in Swift w/ URLSession and escaping closures

import Foundation

class EventViewModel: ObservableObject {
    
    @Published var scheduleOfRaces: ScheduleOfRaces?
    @Published var allEvents: [Race] = []
    
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
}
