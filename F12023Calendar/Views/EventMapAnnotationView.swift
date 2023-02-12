//
//  EventMapAnnotation.swift
//  F12023Calendar
//
//  Created by Andrey Studenkov on 08.02.2023.
//

import SwiftUI

struct EventMapAnnotationView: View {
    let accentColor = Color("AccentColor")
    var body: some View {
        
        VStack(spacing: 0){
            Image(systemName: "flag.checkered.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .font(.headline)
                .foregroundColor(.white)
                .padding(6)
                .background(accentColor)
                .clipShape(Circle())
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(accentColor)
                .frame(width: 10, height: 10)
                .rotationEffect(Angle(degrees: 180))
                .offset(y: -3)
                .padding(.bottom, 40)
        }
    }
}

struct EventMapAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        EventMapAnnotationView()
    }
}
