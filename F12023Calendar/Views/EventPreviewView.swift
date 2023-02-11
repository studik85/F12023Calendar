//
//  EventPreviewView.swift
//  F12023Calendar
//
//  Created by Andrey Studenkov on 08.02.2023.
//

import SwiftUI

struct EventPreviewView: View {
    
    @EnvironmentObject var vm: EventViewModel
    @EnvironmentObject var lnManager: LocalNotificationManager
    
    let event: Race
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                imageSection
                titleSection
                
                
            }
            VStack(spacing: 7){
                reminderButton
                moreAboutButton
                nextButton
                
                
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
                .offset(y:65)
        )
        .cornerRadius(10)
    }
}

extension EventPreviewView {
    
    private var imageSection: some View {
        ZStack {
            if let imageName = event.circuit.location.locality {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .cornerRadius(10)
            }
        }
        
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial))
        .cornerRadius(10)
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("ROUND \(event.round)")
                .fontWeight(.heavy)
            Text(event.raceName)
                .font(.subheadline)
                .fontWeight(.bold)
            Text(event.circuit.circuitName)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var moreAboutButton: some View {
        Button {
            vm.sheetEvents = event
        } label: {
            Text("More About")
                .font(.headline)
                .frame(width: 125, height: 30)
        }
        .buttonStyle(.borderedProminent)
    }
    
    private var nextButton: some View {
        Button {
            vm.nextButtonPressed()
        } label: {
            Text("Next Race")
                .font(.headline)
                .frame(width: 125, height: 30)
        }
        .buttonStyle(.bordered)
    }
    
    private var reminderButton: some View {
        Button {
            if lnManager.isGranted {
                 Task{
                    guard let date = vm.convertUTCDateToLocalDate(date: event.date, time: event.time) else {return}
                    let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                    let localNotification = LocalNotification(identifier: UUID().uuidString, title: event.raceName, body: event.circuit.circuitName, dateComponents: dateComponents, repeats: false)
                    await lnManager.schedule(localNotification: localNotification)
                }
            } else {
                lnManager.openSettings()
            }
            
        } label: {
           
            Text(lnManager.isGranted ? "Add \(Image(systemName: "bell.and.waves.left.and.right"))" : "Enable \(Image(systemName: "bell.and.waves.left.and.right"))")
                    .font(.headline)
                    .frame(width: 125, height: 30)
        }
        .buttonStyle(.borderedProminent)
        
    }
    
}
