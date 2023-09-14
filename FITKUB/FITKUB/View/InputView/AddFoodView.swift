//
//  AddFoodView.swift
//  FITKUB
//
//  Created by Nathat Kuanthanom on 1/4/2566 BE.
//

import SwiftUI

struct AddFoodView: View {
    // Presentation Mode
    @Environment(\.presentationMode) var presentationMode
    
    // Core Data
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Food.entity(), sortDescriptors: [])
    var foods: FetchedResults<Food>
    
    // Date from Food Diary View
    @Binding var displayedDate: Date
    
    // Input Variable
    @State var foodName = ""
    @State var totalCal  = ""
    @State var totalProtein  = ""
    @State var totalCarb  = ""
    @State var totalFat = ""
    
    // Alert Variable
    @State var showAlert: Bool = false
    @State var alertTitle: String = ""

    
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading){
                Form{
                    Section(header: Text("Food Information")){
                        TextField("Food name", text: $foodName)
                        TextField("Total Cal (g)", text: $totalCal)
                            .keyboardType(.decimalPad)
                        
                    }
                    Section(header: Text("Nutritional Information (Optional)")){
                        TextField("Total Protein (g)", text: $totalProtein)
                        TextField("Total Carb (g)", text: $totalCarb)
                        TextField("Total Fats (g)", text: $totalFat)
                    }.keyboardType(.decimalPad)
                    
                }.navigationTitle("Add Food")
                    .toolbar{
                        ToolbarItem(placement: .navigationBarTrailing){
                            Button{
                                if(checkText()){
                                    addFood()
                                }
                            }label: {
                                Text("Add")
                                    .foregroundColor(.green)
                            }
                            
                        }
                    }
                
//
//                Button {
//
//                        } label: {
//                            Text("Add Food")
//                        }.frame(width: 342, height: 42)
//                    .foregroundColor(.black)
//                    .background(Color(red: 0.914, green: 0.98, blue: 0.89))
//                    .cornerRadius(10)
                
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 0.98, green: 0.98, blue: 0.98))
                .alert(isPresented: $showAlert, content: getAlert)
                
            
            
        }
    }

    
}
extension AddFoodView{
    
    private func addFood() {
        withAnimation {
            let newFood = Food(context: viewContext)
            newFood.foodName = foodName
            newFood.foodCal = totalCal
            newFood.addedDate = displayedDate
            newFood.foodProtein = Float(totalProtein) ?? 0.0
            newFood.foodFat = Float(totalFat) ?? 0.0
            newFood.foodCarb = Float(totalCarb) ?? 0.0
            saveItem()
            foodName = ""
            totalCal = ""
            presentationMode.wrappedValue.dismiss()
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
    
    func checkText() -> Bool{
        if(foodName.count < 3 || foodName.isEmpty){
            alertTitle = "Food name should have at least 3 character"
            showAlert.toggle()
            return false
        }
        else if(Int(totalCal) ?? 0 <= 0){
            alertTitle = "Total Cal can not be 0 or negative value"
            showAlert.toggle()
            return false
        }

        return true

        
    }
    
    func getAlert() -> Alert{
        Alert(title: Text(alertTitle))
    }
}

struct AddFoodView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            AddFoodView(displayedDate: .constant(Date()))
        }
        
    }
}

struct LabelTextField: View {
    var label: String
    var body: some View {
        Text("\(label)")
        Spacer()
    }
}
