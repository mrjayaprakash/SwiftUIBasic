//
//  RunButtonStyle.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 07/07/25.
//

import SwiftUI

struct RunButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .frame(height: 44)
//            .padding(.horizontal, 16)
            .padding([.leading,.trailing], 16)
            .background(Color.black)
            .cornerRadius(10)
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}
