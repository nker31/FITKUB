//
//  FITKUBApp.swift
//  FITKUB
//
//  Created by Nathat Kuanthanom on 29/4/2566 BE.
//

import SwiftUI

@main
struct FITKUBApp: App {
    // Core Data
    let persistenceController = PersistenceController.shared
    
    // Environment Object
    @StateObject var tdee: TDEEModel = TDEEModel()
    @StateObject var user: UserDataViewModel = UserDataViewModel()
    @StateObject var hk: HealthKitViewModel = HealthKitViewModel()
    @StateObject var fd: FoodDiaryViewModel = FoodDiaryViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack{
                StartView()
                
            }.background(Color(red: 0.98, green: 0.98, blue: 0.98))
                .environmentObject(tdee)
                .environmentObject(user)
                .environmentObject(hk)
                .environmentObject(fd)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                

        }
    }
    
}
