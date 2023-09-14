//
//  TDEECalView.swift
//  FITKUB
//
//  Created by Nathat Kuanthanom on 1/4/2566 BE.
//

import SwiftUI

struct TDEECalView: View {

    @EnvironmentObject var tdee: TDEEModel
    // Variable For TextFields
    @State private var userWeight: String = ""
    @State private var userAge: String = ""
    @State private var userHeight: String = ""
    @State private var userBodyFat: String = ""
 
    @State private var selectedTheme = "Sedantary"
    @State private var selectedGender = "Male"

    
    // Alert
    @State var alertTitle: String = ""
    @State private var showAlert: Bool = false

    
    let gender = ["Male","Female"]
    let activity = ["Sedantary", "Light Exercise (1-2 days/week)", "Moderate Exercise (3-5 days/week)","Active Exercise (6-7 days/week)","Superman (14 days/week)"]
    
    var body: some View {
        ZStack{
            VStack{
//                Text("BMI \(tdee.bmi)")
//                Text("Age \(tdee.age) \(tdee.weight) \(tdee.height) \(tdee.gender)" )
                
                Form{
                    Section(header: Text("Personal Information")){
                        Group{
                            
                            TextField("Age", text: $userAge)
                                .keyboardType(.numberPad)
                            
                            Group{
                                TextField("Weight (kg)", text: $userWeight)
                                TextField("Height (cm)", text: $userHeight)
                            }.keyboardType(.decimalPad)
                        }
//                        TextField("Body Fat %", text: $userBodyFat)
                        Picker("Gender", selection: $selectedGender) {
                            ForEach(gender, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        Picker("Activity", selection: $selectedTheme) {
                            ForEach(activity, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(.green)
                        
                        
                    }
                    
                    
                    
                }
                .navigationTitle("TDEE Calculator")
                
                    .toolbar{
                        ToolbarItem(placement: .navigationBarTrailing){
                            
                            //                            Button {
                            //                                calculateTDEE()
                            //                                self.showModal = true
                            //                                tdee.modifyVal(age: Int(userAge) ?? 0, weight: Float(userWeight) ?? 0.0, height: Float(userHeight) ?? 0.0, gender: selectedGender, activity: selectedTheme)
                            //                                tdee.calculateBMI()
                            //                            } label: {
                            //                                Text("Calculate")
                            //                            }
                            //                            .sheet(isPresented: $showModal){
                            //
                            //                            }
                            
                            
                            NavigationLink(
                                destination: TDEEResultView(userTDEE: .constant(1.0)),
                                label: {
                                    Text("Calculate")
                                        .foregroundColor(.green)

                                }
                            )
                            .simultaneousGesture(TapGesture().onEnded{
                                if(checkTDEEText()){
                                    tdee.modifyVal(age: Int(userAge) ?? 0, weight: Float(userWeight) ?? 0.0, height: Float(userHeight) ?? 0.0, gender: selectedGender, activity: selectedTheme)
                                }
                                
  
                            }
                            )
                            .disabled(!checkTDEEText())


                            
                            
                        }
                        
                    }
                
                
            }
        }.alert(isPresented: $showAlert, content: getAlert)
    }
}

extension TDEECalView{

    private func checkTDEEText() -> Bool{
        if(userAge.isEmpty){
            alertTitle = "Please enter your age"
            showAlert.toggle()
            return false
        }else if(userWeight.isEmpty){
            alertTitle = "Please enter your weight"
            showAlert.toggle()
            return false
        }else if(userHeight.isEmpty){
            alertTitle = "Please enter your height"
            showAlert.toggle()
            return false
        }
        return true
    }
    
    func getAlert() -> Alert{
        Alert(title: Text(alertTitle))
    }
    
}

struct TDEECalView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            TDEECalView()
        }.environmentObject(TDEEModel())

    }
}

struct ModalTDEEView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var bmiValue: Float
    var body: some View {
        VStack {
            Text("")
        }
    }
}
