//
//  ScheduleOfRacesForASeason.swift
//  F12023Calendar
//
//  Created by Andrey Studenkov on 05.02.2023.
//

import Foundation

// MARK: - ScheduleOfRaces
struct ScheduleOfRaces: Codable {
    
    let mrData: MRData
    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

// MARK: - MRData
struct MRData: Codable {
    
    let raceTable: RaceTable
    enum CodingKeys: String, CodingKey {
        case raceTable = "RaceTable"
    }
}

// MARK: - RaceTable
struct RaceTable: Codable {
    
    let races: [Race]
    enum CodingKeys: String, CodingKey {
        case races = "Races"
    }
}

// MARK: - Race
struct Race: Codable, Identifiable, Equatable {
    
    
    let id = UUID().uuidString
    let season, round: String
    let url: String
    let raceName: String
    let circuit: Circuit
    let date, time: String
    let firstPractice, secondPractice: NotRaceEvent
    let thirdPractice: NotRaceEvent?
    let qualifying: NotRaceEvent
    let sprint: NotRaceEvent?

    enum CodingKeys: String, CodingKey {
        case season, round, url, raceName
        case circuit = "Circuit"
        case date, time
        case firstPractice = "FirstPractice"
        case secondPractice = "SecondPractice"
        case thirdPractice = "ThirdPractice"
        case qualifying = "Qualifying"
        case sprint = "Sprint"
    }
    
    static func == (lhs: Race, rhs: Race) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Circuit
struct Circuit: Codable {
    let circuitID: String
    let url: String
    let circuitName: String
    let location: Location

    enum CodingKeys: String, CodingKey {
        case circuitID = "circuitId"
        case url, circuitName
        case location = "Location"
    }
}

// MARK: - Location
struct Location: Codable {
    let lat, long: String
    let locality, country: String
    
}

// MARK: - FirstPractice
struct NotRaceEvent: Codable {
    let date, time: String
}
