//
//  TDEEModel.swift
//  FITKUB
//
//  Created by Nathat Kuanthanom on 5/4/2566 BE.
//

import Foundation

class TDEEModel: ObservableObject{
    var age: Int
    var weight: Float
    var height: Float
    var gender: String
    var activity: String
    var bmr: Float = 0
    var bmi: Float = 0
    var TDEE: Int

    
    init(){
        self.age = 0
        self.weight = 0
        self.height = 0
        self.gender = "Male"
        self.activity = "Sedantary"
        self.TDEE = 2220
        
    }
    
    func modifyVal(age: Int, weight: Float, height: Float, gender: String, activity: String){
        self.age = age
        self.weight = weight
        self.height = height
        self.gender = gender
        self.activity = activity
        calculateBMI()
        calculateTDEE()

    }
    
    func calculateBMI(){
        let heightInMeters = self.height / 100.0
        let bmi = self.weight / (heightInMeters * heightInMeters)
        let ageFactor = Float(max(0, min(self.age - 20, 50))) / 100.0
        let adjustedBMI = bmi + (bmi * ageFactor)
        self.bmi = adjustedBMI
    }
    
    func calculateTDEE(){
//        var ageCal = self.age
//        var weightCal = self.weight
//        var heightCal = self.height
        var gender = self.gender
        var activity = self.activity
        var bmrResult:Float = 0.0
        var TDEEResult:Float = 0.0
        if(gender == "Male"){
//            bmrResult = 66.0 + (13.7 * weightCal) + (5 * heightCal) - (6.8 * ageCal)
            var elementOne = 13.7 * self.weight
            var elementTwo = 5 * self.height
            var elementThree = 6.8 * Float(self.age)
            bmrResult = 66.0 + elementOne + elementTwo - elementThree
//            self.TDEE = 5000
            
        }
        else if(gender == "Female"){
//            bmrResult = (655 + (9.6 * weightCal)) + ((1.8 * heightCal) - (4.7 * ageCal))
            var elementOne = 9.6 * self.weight
            var elementTwo = 1.8 * self.height
            var elementThree = 4.7 * Float(self.age)
            bmrResult = 655.0 + elementOne + elementTwo - elementThree
//            self.TDEE = 4000
        }
        
        if(activity == "Sedantary"){
            TDEEResult = bmrResult * 1.2
        }
        else if(activity == "Light Exercise (1-2 days/week)"){
            TDEEResult = bmrResult * 1.375
        }
        else if(activity == "Moderate Exercise (3-5 days/week)"){
            TDEEResult = bmrResult * 1.55
        }
        else if(activity == "Active Exercise (6-7 days/week)"){
            TDEEResult = bmrResult * 1.725
        }
        else if(activity == "Superman (14 days/week)"){
            TDEEResult = bmrResult * 1.9
        }
        
        self.TDEE = Int(TDEEResult)
        
        

    }
    
    func getTDEE() -> [Int] {
        
        return [self.TDEE, self.TDEE - 500, self.TDEE + 500]
    }

}
