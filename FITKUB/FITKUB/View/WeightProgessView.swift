//
//  WeightProgessView.swift
//  FITKUB
//
//  Created by Nathat Kuanthanom on 14/4/2566 BE.
//

import SwiftUI
import Charts
import CoreData

struct GraphE: Identifiable{
    let id: String
    let weight: Float
    let date: Date
}

struct WeightProgessView: View {
    
    // Graph Array
    @State var graphArray:[GraphE] = []

    // Core Data
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: WeightDiary.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \WeightDiary.weightAddedDate, ascending: true)])
    var weights: FetchedResults<WeightDiary>

    
    @FetchRequest(entity: FoodDiary.entity(), sortDescriptors: [])
    var foodDiarys: FetchedResults<FoodDiary>
    
    //Environment obj
    @EnvironmentObject var user: UserDataViewModel
    //
    @State var expectedWeight: Float = 0.0
    
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
            VStack(alignment: .center){
                GroupBox("Progession"){
                    Chart{
                        if(user.userData.userIdealWeight > 0){
                            RuleMark(
                                y: .value("Goal", user.userData.userIdealWeight)
                            ).foregroundStyle(Color.mint)
                                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                                .annotation(alignment: .trailing){
                                    Text("Ideal Weight")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .offset(x: 20,y: -10)
                                }
                        }

                        //  Display Graph from WeightDiary Entity
                        ForEach(weights){ item in
                            BarMark(
                                x: .value("Day", dateFormatterTwo.string(from: item.weightAddedDate ?? Date())),
                                y: .value("Weight", item.weightCurrent),
                                width: 20
                            )
                            .foregroundStyle(.green)
                            
                            
                        }
                        

                        
                    }.frame(width: 340, height: 200)
                    .chartYScale(domain: 0...100)
                    // Weight Progress
                    HStack {
                        VStack{
                            Text("Current Weight")
                                .font(.system(size: 16))
                            Text("\(user.userData.userCurrentWeight, specifier: "%.2f")")
                                .font(.system(size: 18))
                                .fontWeight(.semibold)
                        }
                        Spacer().frame(width: 25)
                        VStack{
                            Text("Estimated Weight")
                                .font(.system(size: 16))
                            Text("\(expectedWeight, specifier: "%.2f")")
                                .font(.system(size: 18))
                                .fontWeight(.semibold)
                        }
                    }
                }
                .padding(15)
                

                
                
                
                
                Text("Lastest Weight")
                    .fontWeight(.bold)
                    .padding(.leading, 15)
                
                //  Display value from WeightDiary Entity
                VStack(){
                    List{
                        ForEach(weights){ item in
                            HStack{
                                Text("\(item.weightCurrent, specifier: "%.2f") kg")
                                Spacer()
                                Text("\(dateFormatter.string(from: item.weightAddedDate ?? Date()))")
                                
                            }
                        }
                        .onDelete(perform: deleteItems)

                    }.listStyle(.inset)
                        .frame(maxWidth: 380, maxHeight: 800)
                }
                    
                
            }
            
            .frame(maxWidth: .infinity, maxHeight:.infinity)
            .onAppear{
                calculateExpectedWeight()
                showOnlyFive()
            }

        }.navigationTitle("Weight Diary")
            .navigationBarItems(trailing: NavigationLink("Add", destination: AddWeightView()))

        
    }
}

extension WeightProgessView{
    
    func showOnlyFive(){
        graphArray = []
        let request: NSFetchRequest<WeightDiary> = WeightDiary.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \WeightDiary.weightAddedDate, ascending: false)]
        request.fetchLimit = 5
        do {
            let results = try viewContext.fetch(request)
            // results is an array of WeightDiary objects, containing the last five records sorted by weightAddedDate in descending order
            // You can now use the results array in your code
            
            for weight in results {
                graphArray.append(GraphE(id: UUID().uuidString,weight: weight.weightCurrent, date: weight.weightAddedDate ?? Date()))
            }
            graphArray.reverse()
        } catch {
            print("Error fetching weights: \(error)")
        }
        
    }
    
    func calculateExpectedWeight(){
        var overCal:Float = 0
        // gain
        if(user.userData.userGoal == "gain"){
            for fd in foodDiarys{
                overCal = overCal + ((fd.foodDiaryTotalCal - fd.foodDiaryBurendCal) - fd.foodDiaryGoalCal + 500)
            }
        }
        else if(user.userData.userGoal == "loss"){
            for fd in foodDiarys{
                overCal = overCal + ((fd.foodDiaryTotalCal - fd.foodDiaryBurendCal) - fd.foodDiaryGoalCal - 500)
            }
        }
        else{
            for fd in foodDiarys{
                overCal = overCal + ((fd.foodDiaryTotalCal - fd.foodDiaryBurendCal) - fd.foodDiaryGoalCal)
            }
        }
        var weightGained: Float = overCal/7700
        expectedWeight = user.userData.userStartWeight + weightGained
        
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
            guard let index = offsets.first else{return}
            let removeWeight = weights[index]
            let removeValWeight = weights[index].weightCurrent
            viewContext.delete(removeWeight)
            saveItem()

            if(removeValWeight == user.userData.userCurrentWeight){
                if(weights.isEmpty){
                    var startWeight = user.userData.userStartWeight
                    user.userData.userCurrentWeight = startWeight
                }
                else{
                    user.userData.userCurrentWeight = weights.last?.weightCurrent ?? 0.0
                }
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
}

struct WeightProgessView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            WeightProgessView()
        }.environmentObject(UserDataViewModel())
    }
}
