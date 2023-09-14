//
//  PersonalDataView.swift
//  FITKUB
//
//  Created by Nathat Kuanthanom on 30/4/2566 BE.
//

import SwiftUI

struct PersonalDataView: View {
    
    // Core Data
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: WeightDiary.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \WeightDiary.weightAddedDate, ascending: false)])
    var weights: FetchedResults<WeightDiary>
    
    // Environment Obj
    @EnvironmentObject var user: UserDataViewModel
    
    // Alert variable
    @State var alertTitle: String = ""
    @State private var showAlert: Bool = false

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
    
    // Date Formatter
    let date: Date
    let dateFormatter: DateFormatter
    let dateFormatterTwo: DateFormatter
    init() {
        
        // init core data

        
        // init date formatter
        date = Date()
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        dateFormatterTwo = DateFormatter()
        dateFormatterTwo.dateFormat = "EEE, dd MMM"
        
    }
    
    var body: some View {
        ZStack{
            VStack{
                //                WelcomeToFITKUBTitle()
                SelectPlanTitle(title: "Edit your personal data")
                ScrollView{
                    
                    VStack(alignment: .leading){
                        
                        
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
                        
                        
                        
                    }
                    
                }
                .frame(width: 345)
                
                // Button
                Button(action: {

                    if(checkTextFieldPassed()){
                        user.updatePersonalData(userFname: inputFirstName,
                                                userLname: inputLastName,
                                                userWeight: Float(inputWeight) ?? 0.0,
                                                userHeight: Float(inputHeight) ?? 0.0)
                        updateWeightToDB()
                    }
                    
                }
                ){
                    Text("Save Change")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                }

                
            }
            .frame(maxHeight: 650)

            
            
            
            
        }
        .frame(maxWidth:400, maxHeight: 1100)
        .onAppear(perform: getPersonalData)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                
                Button{
                    dismissKeyboard()
                } label:{
                    Image(systemName: "keyboard.chevron.compact.down")
                }

                
                
            }
            
        }
        .alert(isPresented: $showAlert, content: getAlert)
    }
}

extension PersonalDataView{
    func checkOnThisDayItem() -> Bool{
        for weightElement in weights{
            // if found duplicated item return true
            if (dateFormatter.string(from: weightElement.weightAddedDate ?? Date()) == dateFormatter.string(from: Date() )){
                
                return true
            }
        }
        
        // if not return false
        return false
        
    }
    
    // Core Data Function
    
    func updateWeightToDB(){
        // if found weight on this day then update value
        if(checkOnThisDayItem()){
            for weightElement in weights{
                // update value
                if (dateFormatter.string(from: weightElement.weightAddedDate ?? Date()) == dateFormatter.string(from: Date() )){
                    weightElement.weightCurrent = Float(inputWeight) ?? 0.0
                    user.userData.userCurrentWeight = Float(inputWeight) ?? 0.0
                }
            }
        }else{
            // create new record
            var newWeight = WeightDiary(context: viewContext)
            newWeight.weightCurrent = Float(inputWeight) ?? 0.0
            newWeight.weightAddedDate = Date()
            user.userData.userCurrentWeight = Float(inputWeight) ?? 0.0
        }
        saveItem()
        
    }
    
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
  
    // this function get value from UserDataViewModel
    func getPersonalData(){
        inputFirstName = user.userData.userFname
        inputLastName = user.userData.userLname
        inputWeight = String(user.userData.userCurrentWeight)
        inputHeight = String(user.userData.userHeight)
        
    }
    
    // View Function
    
    // Check TextField for handle the error
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
    
    func dismissKeyboard() {
          UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.endEditing(true) // 4
        }
    
    func getAlert() -> Alert{
        Alert(title: Text(alertTitle))
    }
    
}


struct PersonalDataView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            PersonalDataView()
        }.environmentObject(UserDataViewModel())
        
    }
}
