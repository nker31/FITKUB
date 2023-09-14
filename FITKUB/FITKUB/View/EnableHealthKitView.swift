//
//  EnableHealthKitView.swift
//  FITKUB
//
//  Created by Nathat Kuanthanom on 29/4/2566 BE.
//

import SwiftUI

struct EnableHealthKitView: View {
    @EnvironmentObject var hk: HealthKitViewModel
    @Binding var isAuthorized : Bool
    var body: some View {
        VStack {
            Text("Please Authorize Health!")
                .font(.title3)
            
            Button {
                hk.healthRequest()
                isAuthorized = true
            } label: {
                Text("Authorize HealthKit")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .frame(width: 320, height: 55)
            .background(Color(.orange))
            .cornerRadius(10)
        }
    }
}

struct EnableHealthKitView_Previews: PreviewProvider {
    static var previews: some View {
        EnableHealthKitView(isAuthorized: .constant(true))
    }
}
