//
//  EventPreviewView.swift
//  F12023Calendar
//
//  Created by Andrey Studenkov on 08.02.2023.
//

import SwiftUI

struct EventPreviewView: View {
    
    @EnvironmentObject var vm: EventViewModel
    
    let event: Race
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                imageSection
                titleSection
                
                
            }
            VStack(spacing: 7){
                
                moreAboutButton
                nextButton
                prevButton
                
                
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
    
    private var prevButton: some View {
        Button {
            vm.prevButtonPressed()
        } label: {
            Text("Previous Race")
                .font(.headline)
                .frame(width: 125, height: 30)
        }
        .buttonStyle(.bordered)
    }
}
