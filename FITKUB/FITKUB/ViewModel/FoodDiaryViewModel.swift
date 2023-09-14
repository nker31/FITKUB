//
//  FoodDiaryViewModel.swift
//  FITKUB
//
//  Created by Nathat Kuanthanom on 30/4/2566 BE.
//

import Foundation
import SwiftUI

class FoodDiaryViewModel: ObservableObject{
    // Core Data
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Food.entity(), sortDescriptors: [])
    var foods: FetchedResults<Food>
    
    // Date Formatter
    let date: Date
    let dateFormatter: DateFormatter
    
    
    init() {
        date = Date()
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        //            dateFormatter.timeStyle = .short
        
    }
    
    //
    @Published var foodData: FoodDiaryModel = FoodDiaryModel()
  
    func calculateThisDayData(){
        var totalCal = 0
        var totalProtein = 0
        var totalCarb = 0
        var totalFat = 0
        
        for foodItem in foods{
            
            if(self.dateFormatter.string(from: foodItem.addedDate ?? Date()) == self.dateFormatter.string(from: Date())){
                totalCal += Int(foodItem.foodCal ?? "0") ?? 0
                totalProtein += Int(foodItem.foodProtein ?? 0.0) ?? 0
                totalFat += Int(foodItem.foodFat ?? 0.0) ?? 0
                totalCarb += Int(foodItem.foodCarb ?? 0.0) ?? 0
            }
            
        }
        
        // set data
        self.foodData.thisDayEatenCal = totalCal
        self.foodData.thisDayEatenProtein = totalProtein
        self.foodData.thisDayEatenCarb = totalCarb
        self.foodData.thisDayEatenFat = totalFat
        
    }
}
