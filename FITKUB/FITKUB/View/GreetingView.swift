//
//  GreetingView.swift
//  FITKUB
//
//  Created by Nathat Kuanthanom on 30/4/2566 BE.
//

import SwiftUI

struct GreetingView: View {
    
    // Environment Obj
    @EnvironmentObject var user: UserDataViewModel
    
    // Core Data
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: WeightDiary.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \WeightDiary.weightAddedDate, ascending: true)])
    var weights: FetchedResults<WeightDiary>
    
    // Greeting from startView
    @Binding var isGreet: Bool
    
    // Select Target Variable
    @State var isMaintenanceSelected = false
    @State var isGainSelected = false
    @State var isLossSelected = false
    // Select Activity Variable
    @State var isOfficeSelected = false
    @State var isLightSelected = false
    @State var isModerateSelected = false
    @State var isActiveSelected = false
    @State var isBossSelected = false
    // Select Meal Plan Variable
    @State var isModerateCarbSelected = false
    @State var isHigherCarbSelected = false
    @State var isLowerCarbSelected = false
    // Personal Data Variable
        //Value from textfields
    @State var inputFirstName = ""
    @State var inputLastName = ""
    @State var inputWeight = ""
    @State var inputHeight = ""
    
        // For Date Picker
    @State var inputSelectedDOB = Date()
    @State var inputAge = 0
    
        // For Gender Picker
    @State var inputSelectedGender = "Male"
    let gender = ["Male","Female"]
    
    // Alert variable
    @State var alertTitle: String = ""
    @State private var showAlert: Bool = false
    
    
    var body: some View {
        ZStack{
            VStack{
                WelcomeToFITKUBTitle()
                ScrollView{
                    
                    VStack(spacing: 40){
                        // Select Goal
                        VStack(spacing: 23){
                            SelectPlanTitle(title: "What is your goal ?")
    //                        Text(selected)
                            PlanRowComponent(title: "Maintenance your weight", iconName: "maintenance",isSelected: isMaintenanceSelected)
                                .onTapGesture {
                                    isMaintenanceSelected = true
                                    isGainSelected = false
                                    isLossSelected = false
    //                                selected = "maintenance"
                                }
                            PlanRowComponent(title: "Gain your weight", iconName: "gain",isSelected: isGainSelected)
                                .onTapGesture {
                                    isMaintenanceSelected = false
                                    isGainSelected = true
                                    isLossSelected = false
    //                                selected = "gain"
                                }
                            PlanRowComponent(title: "Loss your weight", iconName: "loss", isSelected: isLossSelected)
                                .onTapGesture {
                                    isMaintenanceSelected = false
                                    isGainSelected = false
                                    isLossSelected = true
    //                                selected = "loss"
                                }
                        }
                        .frame(width: 345)
                        
                        // Select Activity
                        VStack(spacing: 23){
                            SelectPlanTitle(title: "How about your activity")
                            // Office Worker
                            ActivityRowComponent(title: "Office Worker", iconName: "officeworker", des: "no exercise", isSelected: isOfficeSelected)
                                .onTapGesture {
                                    isOfficeSelected = true
                                    isLightSelected = false
                                    isModerateSelected = false
                                    isActiveSelected = false
                                    isBossSelected = false
                                }
                            // Light Exercise
                            ActivityRowComponent(title: "Light Exercise", iconName: "lightexercise", des: "1 - 2 days / week", isSelected: isLightSelected)
                                .onTapGesture {
                                    isOfficeSelected = false
                                    isLightSelected = true
                                    isModerateSelected = false
                                    isActiveSelected = false
                                    isBossSelected = false
                                }
                            // Moderate Exercise
                            ActivityRowComponent(title: "Moderate Exercise", iconName: "moderateexercise", des: "3 - 5 days / week", isSelected: isModerateSelected)
                                .onTapGesture {
                                    isOfficeSelected = false
                                    isLightSelected = false
                                    isModerateSelected = true
                                    isActiveSelected = false
                                    isBossSelected = false
                                }
                            // Active Exercise
                            ActivityRowComponent(title: "Active Exercise", iconName: "activeexercise", des: "6 - 7 days / week",isSelected: isActiveSelected)
                                .onTapGesture {
                                    isOfficeSelected = false
                                    isLightSelected = false
                                    isModerateSelected = false
                                    isActiveSelected = true
                                    isBossSelected = false
                                }
                            // Boss
                            ActivityRowComponent(title: "Boss of The Gym", iconName: "bossofthegym", des: "14 days / week", isSelected: isBossSelected)
                                .onTapGesture {
                                    isOfficeSelected = false
                                    isLightSelected = false
                                    isModerateSelected = false
                                    isActiveSelected = false
                                    isBossSelected = true
                                }
                        }
                        .frame(width: 345)
                        
                        // Select Food Plan
                        
                        VStack(spacing: 23){
                            SelectPlanTitle(title: "Select your food plan")
                            PlanRowComponent(title: "Moderate carbohydrate", iconName: "modcarb", isSelected: isModerateCarbSelected)
                                .onTapGesture {
                                    isModerateCarbSelected = true
                                    isHigherCarbSelected = false
                                    isLowerCarbSelected = false
                                }
                            PlanRowComponent(title: "Higher carbohydrate", iconName: "highcarb", isSelected: isHigherCarbSelected)
                                .onTapGesture {
                                    isModerateCarbSelected = false
                                    isHigherCarbSelected = true
                                    isLowerCarbSelected = false
                                }
                            PlanRowComponent(title: "Lower carbohydrate", iconName: "lowcarb", isSelected: isLowerCarbSelected)
                                .onTapGesture {
                                    isModerateCarbSelected = false
                                    isHigherCarbSelected = false
                                    isLowerCarbSelected = true
                                }
                        }
                        .frame(width: 345)
                        
                        // Enter Personal Data
                        VStack(alignment: .leading){
                            SelectPlanTitle(title: "Enter your personal data")
                            
                            Group{
                                // First name
                                InputTitle(title: "firstname")
                                TextField("Enter your firstname", text: $inputFirstName)
                                Rectangle()
                                    .frame(width: 340, height: 1)
                                    .opacity(0.4)
                                
                                
                                // Last name
                                InputTitle(title: "lastname")
                                TextField("Enter your lastname", text: $inputLastName)
                                Rectangle()
                                    .frame(width: 340, height: 1)
                                    .opacity(0.4)
                            }
                            
                            
                            Group{
                                // Weight
                                InputTitle(title: "weight")
                                TextField("Enter your weight", text: $inputWeight)
                                Rectangle()
                                    .frame(width: 340, height: 1)
                                    .opacity(0.4)
                                
                                // Height
                                InputTitle(title: "Height")
                                TextField("Enter your height", text: $inputHeight)
                                Rectangle()
                                    .frame(width: 340, height: 1)
                                    .opacity(0.4)
                            }.keyboardType(.decimalPad)
                            
                            
                            Group{
                                // Gender
                                InputTitle(title: "Gender")
                                HStack{
                                    Text("Enter your gender")
                                        .font(.subheadline)
                                        .fontWeight(.light)
                                    Spacer()
                                    Picker("Gender", selection: $inputSelectedGender) {
                                        ForEach(gender, id: \.self) {
                                            Text($0)
                                        }
                                    }.tint(.black)

                                }

                                // Birthdate
                                InputTitle(title: "Birthdate")
                                DatePicker("Enter your birthdate",
                                           selection: $inputSelectedDOB,
                                           in: ...Date(),
                                           displayedComponents: [.date])
                                .font(.subheadline)
                                .fontWeight(.light)
                                
                                
                                                        }
                            
                        }.frame(width: 345)
                        
                        Button(action: {
                            // Handle Non select goal choice
                            if(checkSelectedChoice()){
                                // Assign goal to user
                                if(isMaintenanceSelected){
                                    user.editUserGoal(selectedGoal: "maintenance")
                                }
                                else if(isGainSelected){
                                    user.editUserGoal(selectedGoal: "gain")
                                }
                                else if(isLossSelected){
                                    user.editUserGoal(selectedGoal: "loss")
                                }
                                // Assign activity to user
                                if(isOfficeSelected){
                                    user.editUserActivity(selectedActivity: "office")
                                }
                                else if(isLightSelected){
                                    user.editUserActivity(selectedActivity: "light")
                                }
                                else if(isModerateSelected){
                                    user.editUserActivity(selectedActivity: "moderate")
                                }
                                else if(isActiveSelected){
                                    user.editUserActivity(selectedActivity: "active")
                                }
                                else if(isBossSelected){
                                    user.editUserActivity(selectedActivity: "boss")
                                }
                                // Assign food plan to user
                                if(isModerateCarbSelected){
                                    user.editUserFoodPlan(selectedFoodPlan: "moderate")
                                }
                                else if(isHigherCarbSelected){
                                    user.editUserFoodPlan(selectedFoodPlan: "higher")
                                }
                                else if(isLowerCarbSelected){
                                    user.editUserFoodPlan(selectedFoodPlan: "lower")
                                }
                                
                                getAge()
                                
                                user.initUserPersonalData(userFname: inputFirstName,
                                                          userLname: inputLastName,
                                                          userWeight: Float(inputWeight) ?? 0.0,
                                                          userHeight: Float(inputHeight) ?? 0.0,
                                                          userAge: inputAge,
                                                          userGender: inputSelectedGender)
                                user.calculateTDEE()
                                user.calculateNutrition()
                                // create new record
                                let newWeight = WeightDiary(context: viewContext)
                                newWeight.weightCurrent = Float(inputWeight) ?? 0.0
                                newWeight.weightAddedDate = Date()
                                saveItem()
                                isGreet = true
                                user.userData.isGreet = true

                            }
                            
                        }
                        ){
                            Text("Continue")
                                .font(.system(size: 20))
                                .fontWeight(.semibold)
                        }
                        .frame(width: 340, height: 56)
                        .foregroundColor(.white)
                        .background(Color(red: 0.024, green: 0.843, blue: 0.522))
                        .cornerRadius(10)

                    }.alert(isPresented: $showAlert, content: getAlert)
                }.scrollIndicators(.hidden)

                
                
                
                
                
                
            }
            .frame(maxWidth:400, maxHeight: 1100)

        }.toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                Button{
                    dismissKeyboard()
                } label:{
                    Image(systemName: "keyboard.chevron.compact.down")
                }
            }
            
        }
        .background(Color(red: 0.98, green: 0.98, blue: 0.98))
    }
}

extension GreetingView{
    
    
    func dismissKeyboard() {
          UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.endEditing(true) // 4
        }
    
    func getAge(){
        let now = Date()
        let calendar = Calendar.current
        // Find the distance between DOB to today
        let ageComponents = calendar.dateComponents([.year], from: inputSelectedDOB, to: now)
        // Get only year value
        let age = ageComponents.year!
        inputAge = age
    }
    
    func getAlert() -> Alert{
        Alert(title: Text(alertTitle))
    }
    
    func checkTextFieldPassed() -> Bool{
        if(inputFirstName.isEmpty){
            alertTitle = "Please enter your firstname"
            showAlert.toggle()
            return false
        }else if(inputLastName.isEmpty){
            alertTitle = "Please enter your lastname"
            showAlert.toggle()
            return false
        }else if(inputWeight.isEmpty){
            alertTitle = "Please enter your weight"
            showAlert.toggle()
            return false
        }else if(inputHeight.isEmpty){
            alertTitle = "Please enter your height"
            showAlert.toggle()
            return false
        }
        alertTitle = "Saved Successfully"
        showAlert.toggle()
        return true
        
    }
    func checkSelectedChoice() -> Bool{
        if(!(isGainSelected || isMaintenanceSelected || isLossSelected)){
            alertTitle = "Please select your goal"
            showAlert.toggle()
            return false
        }
        else if(!(isOfficeSelected || isLightSelected || isModerateSelected || isActiveSelected || isBossSelected)){
            alertTitle = "Please select your activity"
            showAlert.toggle()
            return false
        }
        else if(!(isModerateCarbSelected || isHigherCarbSelected || isLowerCarbSelected)){
            alertTitle = "Please select your food plan"
            showAlert.toggle()
            return false
        }
        else if(inputFirstName.isEmpty){
            alertTitle = "Please enter your firstname"
            showAlert.toggle()
            return false
        }else if(inputLastName.isEmpty){
            alertTitle = "Please enter your lastname"
            showAlert.toggle()
            return false
        }else if(inputWeight.isEmpty){
            alertTitle = "Please enter your weight"
            showAlert.toggle()
            return false
        }else if(inputHeight.isEmpty){
            alertTitle = "Please enter your height"
            showAlert.toggle()
            return false
        }
        alertTitle = "Succesfully"
        showAlert.toggle()
        return true

    }
    // Core Data
    
    private func saveItem(){
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    
}

struct GreetingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            GreetingView(isGreet: .constant(true))
        }.environmentObject(UserDataViewModel())

        
    }
}

// Customize Struct
struct WelcomeToFITKUBTitle: View {
    var body: some View {
        VStack{
            Text("Welcome to FITKUB")
                .font(Font.system(size:24))
                .fontWeight(.semibold)
        }.frame(width: 340, alignment: .leading)
//            .background(.red)
            .padding(.vertical, 24)
    }
}

struct SelectPlanTitle: View {
    var title: String
    var body: some View {
        VStack{
            Text(title)
        }.frame(width: 340, alignment: .leading)
            .font(Font.system(size:20))
            .fontWeight(.semibold)
    }
}

struct PlanRowComponent: View {
    var title: String
    var iconName: String
    var isSelected: Bool
    var body: some View {
        HStack{
            Image(iconName)
                .resizable()
                .frame(width: 30, height: 30)
                .padding(.leading, 44)
                .foregroundColor(Color(isSelected ? "White": "Black"))
            
            
            Text(title)
                .fontWeight(.medium)
                .padding(.leading, 15)
                .foregroundColor(Color(isSelected ? "White": "Black"))
        }.frame(width: 340, height: 80, alignment: .leading)
            .background(Color(red: isSelected ? 0.024 : 1, green: isSelected ? 0.843 : 1, blue: isSelected ? 0.522 : 1))
            .cornerRadius(10)
            .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

struct ActivityRowComponent: View {
    var title: String
    var iconName: String
    var des: String
    var isSelected: Bool
    var body: some View {
        HStack{
            Image(iconName)
                .resizable()
                .frame(width: 30, height: 30)
                .padding(.leading, 44)
                .foregroundColor(Color(isSelected ? "White": "Black"))
            
            VStack(alignment: .leading){
                Text(title)
                    .fontWeight(.medium)
                    .foregroundColor(Color(isSelected ? "White": "Black"))
                Text(des)
                    .font(Font.system(size:13))
                    .fontWeight(.light)
                    .foregroundColor(Color(isSelected ? "White": "Black"))
            }.padding(.leading, 15)
            
        }.frame(width: 340, height: 80, alignment: .leading)
            .background(Color(red: isSelected ? 0.024 : 1, green: isSelected ? 0.843 : 1, blue: isSelected ? 0.522 : 1))
            .cornerRadius(10)
            .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}


struct InputTitle: View {
    var title:String
    var body: some View {
        Text("\(title.uppercased())")
            .font(.subheadline)
            .fontWeight(.light)
            .padding(.vertical,5)
    }
}
