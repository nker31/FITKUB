//
//  FoodDiaryView.swift
//  FITKUB
//
//  Created by Nathat Kuanthanom on 1/4/2566 BE.
//

import SwiftUI
import CoreData

struct FoodDiaryView: View {
    // Core Data
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Food.entity(), sortDescriptors: [])
    var foods: FetchedResults<Food>
    
    @FetchRequest(entity: StepDiary.entity(), sortDescriptors: [])
    var steps: FetchedResults<StepDiary>
    
    @FetchRequest(entity: FoodDiary.entity(), sortDescriptors: [])
    var foodDiarys: FetchedResults<FoodDiary>
    
    // User Data Object
    @EnvironmentObject var user: UserDataViewModel
    @EnvironmentObject var fd: FoodDiaryViewModel
    @State var displayedDate = Date()
    
    //
    @State var todayBurnedCal = 0

    //
    @State var todayCal = 0
    @State var todayProtein = 0
    @State var todayFat = 0
    @State var todayCarb = 0
    //
    let date: Date
    let dateFormatter: DateFormatter
    
    
    init() {
        date = Date()
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        //            dateFormatter.timeStyle = .short
        
    }
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading, spacing: 20){

                // Date Picker
                DatePicker("Let's pick a date", selection: $displayedDate)
                    .datePickerStyle(CustomDatePickerStyle(displayedDate: $displayedDate)).frame(height: 20)
                // Calories Remaining Widget
                
                WidgetTitle(title: "Today Stats")
                
                VStack(spacing:5){
                    titleInWidget(title: "Calories Remaining")
                    HStack(spacing:7){
                        statText(title: "cal goal", value: user.userData.userGoalCal)
                        Text("-")
                            .font(.system(size:13))
                            .fontWeight(.semibold)
                        statText(title: "today food", value: todayCal)
                        Text("+")
                            .font(.system(size:13))
                            .fontWeight(.semibold)
                        statText(title: "burned", value: todayBurnedCal)
                        Text("=")
                            .font(.system(size:13))
                            .fontWeight(.semibold)
                        statText(title: "remaining", value: (user.userData.userGoalCal - todayCal + todayBurnedCal))
                    }
                    
                }.frame(width: 340, height: 90)
                    .background(Color(red: 1, green: 1, blue: 1))
                
                    .cornerRadius(15)
                    .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
                // Calories Remaining Widget
                
                //Nutrition Widget
                VStack(spacing:5){
                    titleInWidget(title: "Nutrition")
                    HStack(spacing: 40){
                        statNutrition(title: "Carbs", currantNutri: todayCarb, needNutri: user.userData.userGoalCarb)
                        statNutrition(title: "Protein", currantNutri: todayProtein, needNutri: user.userData.userGoalProtein)
                        statNutrition(title: "Fat", currantNutri: todayFat, needNutri: user.userData.userGoalFat)
                    }
                }.frame(width: 340, height: 90)
                    .background(Color(red: 1, green: 1, blue: 1))
                    .cornerRadius(15)
                    .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
                //Ended Nutrition Widget
                
                //Today food title and add food button
                HStack{
                    WidgetTitle(title: "Today Food")
                    Spacer()
                    NavigationLink(
                        destination: AddFoodView(displayedDate: $displayedDate),
                        label: {
                            Text("Add")
                                .frame(width: 55, height: 30)
                                .background(.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            
                        }
                    )
                }.frame(width: 340)
                

                VStack{
                    List{
                        ForEach(foods) { food in
                            if(dateFormatter.string(from: food.addedDate ?? Date()) == dateFormatter.string(from: displayedDate )){
                                HStack{
                                    Text("\(food.foodName ?? "noo" )")
                                    Spacer()
                                    Text("\(food.foodCal ?? "0") kcal")

                                }
                            }
                            
                        }
                        .onDelete(perform: deleteItems)
                        
                    }.listStyle(.plain)
                    
                }.frame(width: 340, height: 230)
                    .background(Color(red: 1, green: 1, blue: 1))
                    .cornerRadius(15)
                    .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
                
                Spacer()
            }.onAppear{
                calculateNutrtition()
                calculateBurnedCal()
                updateFood()
                
            }
            .onChange(of: displayedDate){ newValue in
                calculateNutrtition()
                calculateBurnedCal()
                updateFood()
            }
            
                .frame(maxWidth:400, maxHeight: 1100)
                .padding(.top, 20)
//                .ignoresSafeArea()
        }
        .background(Color(red: 0.98, green: 0.98, blue: 0.98))

    }
}

extension FoodDiaryView{
    func updateFood(){
        var isNotExist = true
        if(foodDiarys.isEmpty){
            calculateNutrtition()
            calculateBurnedCal()
            let newFoodDiaryValue = FoodDiary(context: viewContext)
            newFoodDiaryValue.foodDiaryDate = displayedDate
            newFoodDiaryValue.foodDiaryTotalCal = Float(todayCal)
            newFoodDiaryValue.foodDiaryTotalProtein = Float(todayProtein)
            newFoodDiaryValue.foodDiaryTotalCarb = Float(todayCarb)
            newFoodDiaryValue.foodDiaryTotalFat = Float(todayFat)
            newFoodDiaryValue.foodDiaryGoalCal = Float(user.userData.userGoalCal)
            newFoodDiaryValue.foodDiaryBurendCal = Float(todayBurnedCal)
            newFoodDiaryValue.foodDiaryRemainCal = Float(user.userData.userGoalCal - todayCal + todayBurnedCal)
            saveItem()
        }else{
            
            for fd in foodDiarys{
                if(dateFormatter.string(from: fd.foodDiaryDate ?? Date()) == dateFormatter.string(from: displayedDate )){
                    isNotExist = false
                    calculateNutrtition()
                    calculateBurnedCal()
                    fd.foodDiaryTotalCal = Float(todayCal)
                    fd.foodDiaryTotalProtein = Float(todayProtein)
                    fd.foodDiaryTotalCarb = Float(todayCarb)
                    fd.foodDiaryTotalFat = Float(todayFat)
                    fd.foodDiaryGoalCal = Float(user.userData.userGoalCal)
                    fd.foodDiaryBurendCal = Float(todayBurnedCal)
                    fd.foodDiaryRemainCal = Float(user.userData.userGoalCal - todayCal + todayBurnedCal)
                    
                }
            }
            if(isNotExist){
                calculateNutrtition()
                calculateBurnedCal()
                let newFoodDiaryValue = FoodDiary(context: viewContext)
                newFoodDiaryValue.foodDiaryDate = displayedDate
                newFoodDiaryValue.foodDiaryTotalCal = Float(todayCal)
                newFoodDiaryValue.foodDiaryTotalProtein = Float(todayProtein)
                newFoodDiaryValue.foodDiaryTotalCarb = Float(todayCarb)
                newFoodDiaryValue.foodDiaryTotalFat = Float(todayFat)
                newFoodDiaryValue.foodDiaryGoalCal = Float(user.userData.userGoalCal)
                newFoodDiaryValue.foodDiaryBurendCal = Float(todayBurnedCal)
                newFoodDiaryValue.foodDiaryRemainCal = Float(user.userData.userGoalCal - todayCal + todayBurnedCal)
                
            }
            saveItem()
        }
    }
    
    private func deletefd(offsets: IndexSet) {
        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
            guard let index = offsets.first else{return}
            let removeFD = foodDiarys[index]
            viewContext.delete(removeFD)
            saveItem()
            
        }
    }
    func calculateBurnedCal(){
        var found = false
        for step in steps{
            if(dateFormatter.string(from: step.stepDate ?? Date()) == dateFormatter.string(from: displayedDate)){
                todayBurnedCal = Int(step.stepBurned)
                found = true
            }
        }
        if(!found){
            todayBurnedCal = 0
        }
    }
    func calculateNutrtition(){
        todayCal = 0
        todayProtein = 0
        todayFat = 0
        todayCarb = 0
        for food in foods{
            if(dateFormatter.string(from: food.addedDate ?? Date()) == dateFormatter.string(from: displayedDate)){
                todayCal += Int(food.foodCal ?? "0") ?? 0
                todayProtein += Int(food.foodProtein ?? 0.0) ?? 0
                todayFat += Int(food.foodFat ?? 0.0) ?? 0
                todayCarb += Int(food.foodCarb ?? 0.0) ?? 0
                
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
            guard let index = offsets.first else{return}
            let removeFood = foods[index]
            viewContext.delete(removeFood)
            saveItem()
            
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

}

struct FoodDiaryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            FoodDiaryView()
                .environmentObject(UserDataViewModel())
                .environmentObject(FoodDiaryViewModel())
        }
    }
}


struct statText: View {
    var title: String
    var value: Int
    var body: some View {
        VStack{
            Text("\(value)")
                .font(.system(size:16))
                .fontWeight(.semibold)
            Text("\(title)")
                .font(.system(size:13))
                .fontWeight(.semibold)
        }
    }
}

struct statNutrition: View {
    var title: String
    var currantNutri: Int
    var needNutri: Int
    var body: some View {
        VStack{
            Text("\(currantNutri)/\(needNutri) ")
                .font(.system(size:16))
                .fontWeight(.semibold)
            Text("\(title)")
                .font(.system(size:13))
                .fontWeight(.semibold)
        }
    }
}

struct statResultText: View {
    var title: String
    var value: Int
    var body: some View {
        VStack{
            Text("\(value)")
                .font(.system(size:16))
                .fontWeight(.bold)
            Text("\(title)")
                .font(.system(size:13))
                .fontWeight(.semibold)
        }
    }
}

struct titleInWidget: View {
    var title: String
    var body: some View {
        Text("\(title)")
            .font(.system(size:15))
            .fontWeight(.semibold)
            .frame(width: 300,alignment: .leading)
    }
}

struct recFoodBox: View {
    var body: some View {
        Rectangle()
            .frame(width: 160,height: 140)
            .foregroundColor(Color(red: 1, green: 1, blue: 1))
            .cornerRadius(15)
            .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
        
        
    }
}

struct CustomDatePickerStyle: DatePickerStyle {
    
    @Binding var displayedDate: Date
    
    @State var currentDate = Date()
    
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            
            HStack {
                
                Button {
                    displayedDate = Calendar.current.date(byAdding: .day, value: -1, to: displayedDate)!
                } label: {
                    dateChangeButton(imgName: "arrow_backward")
                }
                Text(displayedDate.formatted(date: .abbreviated, time: .omitted))
                
                Button {
                    displayedDate = Calendar.current.date(byAdding: .day, value: 1, to: displayedDate)!
                } label: {
                    dateChangeButton(imgName: "arrow_forward")
                }
            }.frame(width: 340, height: 20)
        }
    }
}

struct dateChangeButton: View {
    var imgName: String
    var body: some View {
        Image("\(imgName)")
            .foregroundColor(.green)
            .font(.title)
            .padding()
            .frame(height: 20)

    }
}

struct TodayFoodComponent: View {
    var body: some View {
        HStack{
            Text("Chicken Masala")
            Spacer()
            Text("500 kcal")
        }.padding(.vertical, 8)
    }
}
