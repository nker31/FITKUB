//
//  UserDataViewModel.swift
//  FITKUB
//
//  Created by Nathat Kuanthanom on 25/4/2566 BE.
//

import Foundation
class UserDataViewModel: ObservableObject{
    
    @Published var userData: UserDataModel = UserDataModel(){
        didSet{
            saveItem()
        }
    }
    let userDataKey = "userdata"
    
    init() {
        getItem()
    }
    
    func getItem(){
        guard let data = UserDefaults.standard.data(forKey: userDataKey) else{
            return
        }
        
        guard let savedItem = try? JSONDecoder().decode(UserDataModel.self, from: data) else{
            return
        }
        self.userData = savedItem
        
    }
    
    
    func saveItem(){
        if let encodedData = try? JSONEncoder().encode(userData){
            UserDefaults.standard.set(encodedData, forKey: userDataKey)
        }
    }
    
    func updatePersonalData(userFname: String, userLname: String,userWeight: Float, userHeight: Float){
        self.userData.userFname = userFname
        self.userData.userLname = userLname
        self.userData.userCurrentWeight = userWeight
        self.userData.userCurrentHeight = userHeight

        calculateBMI()
//        calculateTDEE()
//        calculateNutrition()
        saveItem()
    }
    
    func initUserPersonalData(userFname: String, userLname: String,userWeight: Float, userHeight: Float, userAge: Int, userGender: String){
        self.userData.userFname = userFname
        self.userData.userLname = userLname
        self.userData.userWeight = userWeight
        self.userData.userHeight = userHeight
        self.userData.userAge = userAge
        self.userData.userGender = userGender
        // Additional Value
        self.userData.userStartWeight = userWeight
        self.userData.userCurrentWeight = userWeight
        self.userData.userCurrentHeight = userHeight
        self.userData.userStartDate = Date()
        // After got above values then calculate BMI and TDEE from these data
        calculateBMI()
        
        // After calculate BMI then persist data
        saveItem()
    }
    
    func editUserSelectData(userGoal: String, userActivity: String, userFoodPlan: String){
        self.userData.userGoal = userGoal
        self.userData.userActivity = userActivity
        self.userData.userFoodPlan = userFoodPlan
        calculateTDEE()
        calculateNutrition()
        // save data after got it
        saveItem()
    }
    
    func updateCurrentWeight(currentWeight: Float){
        self.userData.userCurrentWeight = currentWeight
        saveItem()
    }
    
    func editUserGoal(selectedGoal: String){
        self.userData.userGoal = selectedGoal
        saveItem()
    }
    
    func editUserActivity(selectedActivity: String){
        self.userData.userActivity = selectedActivity
        saveItem()
    }
    
    func editUserFoodPlan(selectedFoodPlan: String){
        self.userData.userFoodPlan = selectedFoodPlan
        saveItem()
    }
    

    func calculateBMI(){
        let heightInMeters = self.userData.userCurrentHeight / 100.0
        let bmi = self.userData.userCurrentWeight / (heightInMeters * heightInMeters)
        let ageFactor = Float(max(0, min(self.userData.userAge - 20, 50))) / 100.0
        let adjustedBMI = bmi + (bmi * ageFactor)
        self.userData.userBMI = adjustedBMI
    }
    
    func calculateTDEE(){
        
        // Calculate BMR
        var bmr:Float = 0.0
        
        if(self.userData.userGender == "Male"){
            var elementOne = 13.7 * self.userData.userWeight
            var elementTwo = 5 * self.userData.userHeight
            var elementThree = 6.8 * Float(self.userData.userAge)
//            self.userData.userBMR = 66.0 + elementOne + elementTwo - elementThree
            bmr = 66.0 + elementOne + elementTwo - elementThree

        }
        else if(self.userData.userGender == "Female"){

            var elementOne = 9.6 * self.userData.userWeight
            var elementTwo = 1.8 * self.userData.userHeight
            var elementThree = 4.7 * Float(self.userData.userAge)
            bmr = 655.0 + elementOne + elementTwo - elementThree

        }
        
        // Calculate TDEE
        var TDEEResult:Float = 0.0
        if(self.userData.userActivity == "office"){
            TDEEResult = bmr * 1.2
        }
        else if(self.userData.userActivity == "light"){
            TDEEResult = bmr * 1.375
        }
        else if(self.userData.userActivity == "moderate"){
            TDEEResult = bmr * 1.55
        }
        else if(self.userData.userActivity == "active"){
            TDEEResult = bmr * 1.725
        }
        else if(self.userData.userActivity == "boss"){
            TDEEResult = bmr * 1.9
        }
        
        
        self.userData.userBMR = bmr
        self.userData.userTDEE = TDEEResult
        
        self.userData.isGreet.toggle()
        
        
        
    }
    
    func calculateIdealWeight(){
        var idealWeight: Float = 0.0
        idealWeight =  50 + 0.9 * (self.userData.userHeight - 152)
        self.userData.userIdealWeight = idealWeight
    }

    func calculateNutrition(){
        // Calculate
        var goalCal:Int = 0
        if(self.userData.userGoal == "gain"){
            goalCal = Int(self.userData.userTDEE) + 500
        }
        else if(self.userData.userGoal == "loss"){
            goalCal = Int(self.userData.userTDEE) - 500
        }else{
            goalCal = Int(self.userData.userTDEE)
        }
        
        //
        var protein: Int = 0
        var fat: Int = 0
        var carb: Int = 0

        if(self.userData.userFoodPlan == "moderate"){
            protein = Int((Double(goalCal) * 0.3) / 4)
            fat = Int((Double(goalCal) * 0.35) / 9)
            carb = Int((Double(goalCal) * 0.35) / 4)
        }
        else if(self.userData.userFoodPlan == "higher"){
            protein = Int((Double(goalCal) * 0.3) / 4)
            fat = Int((Double(goalCal) * 0.2) / 9)
            carb = Int((Double(goalCal) * 0.5) / 4)
        }
        else if(self.userData.userFoodPlan == "lower"){
            protein = Int((Double(goalCal) * 0.4) / 4)
            fat = Int((Double(goalCal) * 0.4) / 9)
            carb = Int((Double(goalCal) * 0.2) / 4)
        }
        self.userData.userGoalCal = goalCal
        self.userData.userGoalProtein = protein
        self.userData.userGoalFat = fat
        self.userData.userGoalCarb = carb
        
        saveItem()
    }
}
