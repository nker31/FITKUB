//
//  UserDataModel.swift
//  FITKUB
//
//  Created by Nathat Kuanthanom on 13/4/2566 BE.
//

import Foundation

struct UserDataModel: Codable{
    
    // User Personal Data
    var userFname:String = ""
    var userLname: String = ""
    var userWeight: Float = 0.0
    var userHeight: Float = 0.0
    var userAge: Int = 0
    var userGender: String = ""
    var userStartDate: Date = Date()
    
    // Editable Variable
    var userStartWeight: Float = 0.0
    var userCurrentWeight: Float = 0.0
    var userCurrentHeight: Float = 0.0
    
    // Selected data from user
    var userGoal: String = ""
    var userActivity: String = ""
    var userFoodPlan: String = ""
   
    // Calculated index: Value of these variable calculated from above data
    var userBMI: Float = 0.0
    var userBMR: Float = 0.0
    var userTDEE: Float = 0.0
    var userIdealWeight:Float = 0.0
    
    // Nutrition Plan
    var userGoalCal: Int = 0
    var userGoalProtein: Int = 0
    var userGoalFat: Int = 0
    var userGoalCarb: Int = 0
    
    // Step Goal
    var userGoalStep: Int = 10000
    
    // Greeting 
    var isGreet: Bool = false
}
