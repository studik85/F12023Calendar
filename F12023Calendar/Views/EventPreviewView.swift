//
//  EventPreviewView.swift
//  F12023Calendar
//
//  Created by Andrey Studenkov on 08.02.2023.
//

import SwiftUI

struct EventPreviewView: View {
    
//    @EnvironmentObject var vm: EventViewModel
    
    let event: Race
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            VStack(alignment: .leading, spacing: 16.0) {
                imageSection
                titleSection

             
            }
            VStack(spacing: 7){
               
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

//struct EventPreviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventPreviewView()
//            .environmentObject(EventViewModel())
//    }
//}

extension EventPreviewView {
    
    private var imageSection: some View {
        ZStack {
            if let imageName = event.circuit.location.locality {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
            }
        }
        .padding(6)
        .background(Color.white)
        .cornerRadius(10)
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(event.raceName)
                .font(.title2)
                .fontWeight(.bold)
            Text(event.circuit.circuitName)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var moreAboutButton: some View {
        Button {
            
        } label: {
            Text("More About")
                .font(.headline)
                .frame(width: 125, height: 30)
        }
        .buttonStyle(.borderedProminent)
    }
    
    private var nextButton: some View {
        Button {
            
        } label: {
            Text("Next")
                .font(.headline)
                .frame(width: 125, height: 30)
        }
        .buttonStyle(.bordered)
    }
}
