//
//  AddWeightView.swift
//  FITKUB
//
//  Created by Nathat Kuanthanom on 30/4/2566 BE.
//

import SwiftUI

struct AddWeightView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // Core Data Variables
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: WeightDiary.entity(), sortDescriptors: [])
    var weights: FetchedResults<WeightDiary> // Variables which is used for reference entity
    
    // Environment Obj
    @EnvironmentObject var user: UserDataViewModel
    
    // TextField Value Variables
    @State var inputWeight = ""
    @State var inputDate = Date()
    
    // Alert Variables
    @State var alertTitle: String = ""
    @State var showAlert: Bool = false
    
    // Date Formatter Variables
    let date: Date
    let dateFormatter: DateFormatter
    init() {
        date = Date()
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
    }


    var body: some View {
        ZStack{
            VStack(alignment: .leading){
                Form{
                    Section(header: Text("Weight Information")){
                        TextField("current weight", text: $inputWeight)
                            .keyboardType(.decimalPad)
                        DatePicker("Date", selection: $inputDate, in: ...Date.now, displayedComponents: [.date])
                    }
                    
                }.navigationTitle("Add Weight")
                    .toolbar{
                        ToolbarItem(placement: .navigationBarTrailing){
                            Button{
                                AddWeight()
                            }label: {
                                Text("Add")
                            }
                            
                        }
                    }
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .alert(isPresented: $showAlert, content: getAlert)
                
            
            
        }
    }
}

extension AddWeightView{
    func AddWeight(){
        withAnimation{
            if(checkEmptyValue()){
                alertTitle = "Please enter your weight"
                showAlert.toggle()
            }
            // if found duplicate item alert user
            else if(checkDuplicatedItem()){
                alertTitle = "You've already added your weight for this day!!!"
                showAlert.toggle()
            }
            // if not found duplicate item then add item
            else{
                // create new record
                let newWeight = WeightDiary(context: viewContext)
                newWeight.weightCurrent = Float(inputWeight) ?? 0.0
                newWeight.weightAddedDate = inputDate
                
                // save change
                saveItem()
                if(dateFormatter.string(from: Date()) == dateFormatter.string(from: inputDate )){
                    // save changed for UserDataViewModel
                    user.updateCurrentWeight(currentWeight: Float(inputWeight) ?? 0.0)
                }

                inputWeight = ""
                presentationMode.wrappedValue.dismiss()
            }
            
        }
        
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
    
    func checkEmptyValue() -> Bool{
        if(inputWeight.isEmpty){
            
            return true
        }
        else{
            return false
        }
    }
    
    func checkDuplicatedItem() -> Bool{
        for weightElement in weights{
            // if found duplicated item return true
            if (dateFormatter.string(from: weightElement.weightAddedDate ?? Date()) == dateFormatter.string(from: inputDate )){
                
                return true
            }
        }
        
        // if not return false
        return false
        
    }
    
    func getAlert() -> Alert{
        Alert(title: Text(alertTitle))
        
    }
}

struct AddWeightView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationStack{
            AddWeightView()
        }
    }
}

