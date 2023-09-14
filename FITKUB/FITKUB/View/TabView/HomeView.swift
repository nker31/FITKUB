//
//  HomeView.swift
//  FITKUB
//
//  Created by Nathat Kuanthanom on 1/4/2566 BE.
//

import SwiftUI

struct HomeView: View {
    // Core Data
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Food.entity(), sortDescriptors: [])
    var foods: FetchedResults<Food>
    
    @FetchRequest(entity: StepDiary.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \StepDiary.stepDate, ascending: true)])
    var steps: FetchedResults<StepDiary>
    
    // Environment Obj
    @EnvironmentObject var user: UserDataViewModel
    @EnvironmentObject var hk: HealthKitViewModel
    @EnvironmentObject var fd: FoodDiaryViewModel
    
    // Date Formatter
    let date: Date
    let dateFormatter: DateFormatter
    let dateFormatterTwo: DateFormatter
    init() {
        date = Date()
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        dateFormatterTwo = DateFormatter()
        dateFormatterTwo.dateFormat = "EEE, dd MMM"
    
    }

    
    //
    @State var countedStep = 1000
    @State var stepGoal = 5000
    @State var estBurnedCal:Float = 0.0
    @State var calGoal = 2600
    @State var eatenCal = 0
    // Nutrition Widget
    @State var todayEatenCal = 0
    @State var todayProtein = 0
    @State var todayFat = 0
    @State var todayCarb = 0
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading, spacing: 20){
                HStack(spacing:20){
                    
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                    Text("Hello, \(user.userData.userFname)")
                        .font(.system(size: 24))
                        .fontWeight(.semibold)
                    
                }.padding(.top,20)
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            // code to be executed after 5 seconds
                            calculateNutrtition()
                            if(hk.isAuthorized){
                                
                                hk.readStepsTakenToday()
                                UpdateStep()
                                
                            }
                        }
                        
                    }
                ScrollView{

                    VStack(alignment: .leading, spacing: 20){
                        // Step Widget
                        WidgetTitle(title: "Step Remaining")
                        RemainStepWidget(countedStep: Int(hk.userStepCount) ?? 0,
                                         stepGoal: user.userData.userGoalStep,
                                         estBurnedCal: Int((Float(hk.userStepCount) ?? 0.0) * 0.04),
                                         progress: (Double(hk.userStepCount) ?? 0.0 )/Double(user.userData.userGoalStep)).onTapGesture {
                            UpdateStep()
                        }
                        
                        // Calories Widget
                        WidgetTitle(title: "Calories Remaining")
                        NavigationLink(
                            destination: FoodDiaryView(),
                            label: {
                                RemainCalWidget(calGoal: user.userData.userGoalCal,
                                                eatenCal: todayEatenCal,
                                                progress: Double(todayEatenCal)/Double(user.userData.userGoalCal),
                                                protein: todayProtein,
                                                carb: todayCarb,
                                                fat: todayFat)

                            }
                        )

                        
                    }.frame(width: 350)
                    

        
                }
//                Spacer()
            }
            .frame(maxWidth:400)
        }
        .background(Color(red: 0.98, green: 0.98, blue: 0.98))
//        .background(.green)
        
    }
    
}

extension HomeView{
    
    
    func calculateEstCal(){
        var step = Float(hk.userStepCount) ?? 0.0
        estBurnedCal = step * 0.04

    }
    func UpdateStep(){
        var isNotExist = true
        calculateEstCal()
        if(steps.isEmpty){
            let newStepValue = StepDiary(context: viewContext)
            newStepValue.stepDate = Date()
            newStepValue.stepBurned = estBurnedCal
            newStepValue.stepTotal = hk.userStepCount
            saveItem()
        }
        else if(estBurnedCal <= steps[0].stepBurned){
            
        }
        else{
            for item in steps{
                if(dateFormatter.string(from: item.stepDate ?? Date()) == dateFormatter.string(from: Date() )){
                    isNotExist = false
                    item.stepTotal = hk.userStepCount
                    item.stepBurned = estBurnedCal
                }
                
            }
            if(isNotExist){
                let newStepValue = StepDiary(context: viewContext)
                newStepValue.stepDate = Date()
                newStepValue.stepBurned = estBurnedCal
                newStepValue.stepTotal = hk.userStepCount
            }
            
            saveItem()
        }
        
        
    }
    
    func calculateNutrtition(){
        todayEatenCal = 0
        todayProtein = 0
        todayFat = 0
        todayCarb = 0
        for food in foods{
            if(dateFormatter.string(from: food.addedDate ?? Date()) == dateFormatter.string(from: Date())){
                todayEatenCal += Int(food.foodCal ?? "0") ?? 0
                todayProtein += Int(food.foodProtein)
                todayFat += Int(food.foodFat)
                todayCarb += Int(food.foodCarb )
                
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
            guard let index = offsets.first else{return}
            let removeStep = steps[index]
            viewContext.delete(removeStep)
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            HomeView()
        }.environmentObject(UserDataViewModel())
            .environmentObject(FoodDiaryViewModel())
            .environmentObject(HealthKitViewModel())
    }
}

struct RemainStepWidget: View {
    
    // Argument Variable
    var countedStep: Int
    var stepGoal: Int
    var estBurnedCal: Int
    var progress: Double
    
    
    
    var body: some View {
        HStack(spacing: 30){
            ZStack {
                Circle()
                    .stroke(
                        Color.orange.opacity(0.5),
                        lineWidth: 15
                    ).frame(width: 130, height: 130)
                Circle()
                    // 2
                    .trim(from: 0, to: progress)
                    .stroke(
                        Color.orange,
                        style: StrokeStyle(
                            lineWidth: 15,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut, value: progress)
                    .frame(width: 130, height: 130)
                VStack{
                    Text("\(stepGoal - countedStep)")
                        .font(.system(size: 28))
                        .fontWeight(.bold)
                    Text("steps")
                        .font(.system(size: 14))
                        .fontWeight(.regular)
                }
            }
            
            VStack(alignment: .leading, spacing: 20){
                
                
                HStack{
                    Image(systemName: "target")
                        .resizable()
                        .frame(width: 30, height: 30)
                    VStack(alignment: .leading){
                        Text("Your Goal")
                            .font(.system(size: 14))
                        Text("\(stepGoal) steps")
                            .font(.system(size: 16))
                            .fontWeight(.bold)
                    }
                }
                
                HStack{
                    Image(systemName: "flame.fill")
                        .resizable()
                        .foregroundColor(.orange)
                        .frame(width: 30, height: 30)
                    VStack(alignment: .leading){
                        Text("Est. Burned")
                            .font(.system(size: 14))
                        Text("\(estBurnedCal) kcal")
                            .font(.system(size: 16))
                            .fontWeight(.bold)
                    }
                }
                
            }
        }
        .frame(width: 342, height: 180)
        .background(Color(red: 1, green: 1, blue: 1))
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

struct RemainCalWidget: View {
    @EnvironmentObject var user: UserDataViewModel
    // @State
    @State var isOver = false
    
    //
    var calGoal: Int
    var eatenCal: Int
    var progress: Double
    
    // Nutrition progress bar
    var protein: Int
    var carb: Int
    var fat: Int
    var body: some View {
        VStack {
            HStack(spacing: 30){
                ZStack {
                    
                    if((calGoal - eatenCal) < 0){
                        // Backgroud Circle
                        Circle()
                            .stroke(
                                Color.green.opacity(0.5),
                                lineWidth: 15
                            ).frame(width: 130, height: 130)
                        // Front Circle
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(
                                Color.pink,
                                style: StrokeStyle(
                                    lineWidth: 15,
                                    lineCap: .round
                                )
                            )
                            .rotationEffect(.degrees(-90))
                            .animation(.easeOut, value: progress)
                            .frame(width: 130, height: 130)
                    }else{
                        // Backgroud Circle
                        Circle()
                            .stroke(
                                Color.green.opacity(0.5),
                                lineWidth: 15
                            ).frame(width: 130, height: 130)
                        // Front Circle
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(
                                Color.green,
                                style: StrokeStyle(
                                    lineWidth: 15,
                                    lineCap: .round
                                )
                            )
                            .rotationEffect(.degrees(-90))
                            .animation(.easeOut, value: progress)
                            .frame(width: 130, height: 130)
                    }
                    // Display Remaining Calories
                    VStack{
                        if((calGoal - eatenCal) < 0){
                            Text("0")
                                .font(.system(size: 28))
                                .fontWeight(.bold)
                        }else{
                            Text("\(calGoal - eatenCal)")
                                .font(.system(size: 28))
                                .fontWeight(.bold)
                        }
                        
                        Text("kcal")
                            .font(.system(size: 14))
                            .fontWeight(.regular)
                    }
                }
                // Display Calories Stat
                VStack(alignment: .leading, spacing: 20){
                    HStack{
                        Image(systemName: "target")
                            .resizable()
                            .frame(width: 30, height: 30)
                        VStack(alignment: .leading){
                            Text("Today Goal")
                                .font(.system(size: 14))
                            Text("\(calGoal) kcal")
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                        }
                    }
                    
                    HStack{
                        Image(systemName: "fork.knife.circle")
                            .resizable()
                            .foregroundColor(.black)
                            .frame(width: 30, height: 30)
                        VStack(alignment: .leading){
                            Text("Eaten")
                                .font(.system(size: 14))
                            Text("\(eatenCal) kcal")
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                        }
                    }
                    
                }
                
            }.padding(.top,10)
            
            // Nutrition Bar
            HStack(spacing: 30){
                HorizontalProgressBar(nutritionTitle: "carb",currentNutri: carb, totalNutrition: user.userData.userGoalCarb)
//                Spacer()
                HorizontalProgressBar(nutritionTitle: "protein",currentNutri: protein, totalNutrition: user.userData.userGoalProtein)
//                Spacer()
                HorizontalProgressBar(nutritionTitle: "fat",currentNutri: fat, totalNutrition: user.userData.userGoalFat)
            }.frame(width: 342, height: 27)
//                .background(.red)
                .padding(.top,10)
        }.frame(width: 342, height: 220)
            .foregroundColor(.black)
            .background(Color(red: 1, green: 1, blue: 1))
            .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)

    }
    

}

struct WidgetTitle: View {
    var title:String
    var body: some View {
        Text(title)
            .font(.system(size: 20))
            .fontWeight(.bold)
    }
}

struct CircularProgressView: View {
    // 1
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.pink.opacity(0.5),
                    lineWidth: 15
                ).frame(width: 130, height: 130)
            Circle()
                // 2
                .trim(from: 0, to: progress)
                .stroke(
                    Color.pink,
                    style: StrokeStyle(
                        lineWidth: 15,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
                .frame(width: 130, height: 130)
            VStack{
                Text("2130")
                    .font(.system(size: 28))
                    .fontWeight(.bold)
                Text("steps")
                    .font(.system(size: 14))
                    .fontWeight(.regular)
            }
        }
    }
}

struct HorizontalProgressBar: View {
    var nutritionTitle: String
    var currentNutri: Int
    var totalNutrition: Int
    
    var body: some View {
        VStack(spacing:2) {
            
            Text("\(nutritionTitle)")
                .font(.system(size: 14))
                .fontWeight(.regular)

            ProgressView(value: Double(currentNutri) / Double(totalNutrition))
                .accentColor(.green)
                .frame(width: 75,height: 6)
            
        }
    }
}

