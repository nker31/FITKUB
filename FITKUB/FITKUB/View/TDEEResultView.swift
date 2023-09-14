//
//  TDEEResultView.swift
//  FITKUB
//
//  Created by Nathat Kuanthanom on 4/4/2566 BE.
//

import SwiftUI

struct TDEEResultView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var tdee: TDEEModel
    @Binding var userTDEE: Float
    @State var planList = ["Cutting", "Maintenance", "Bulking" ]
    @State var selectedPlan = "Maintenance"
    @State var tdeeDisplay = 0

    var body: some View {
        ZStack{
            VStack(alignment: .leading, spacing: 20){
                // Select Plan Picker
                Picker("selectedPlan", selection: $selectedPlan) {
                    ForEach(planList, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(maxWidth: 340)
                .onAppear(perform: changePlan)
                .onChange(of: selectedPlan){ newValue in
                    changePlan()
                }
//
                
                // Output Box
                VStack{
                    if(selectedPlan == "Maintenance"){
                        Text("\(tdee.TDEE)")
                            .font(.system(size: 36))
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                    }else if (selectedPlan == "Cutting"){
                        Text("\(tdeeDisplay)")
                            .font(.system(size: 36))
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                    }else if (selectedPlan == "Bulking"){
                        Text("\(tdeeDisplay)")
                            .font(.system(size: 36))
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                    }else{
                        
                    }
                    Text("calories / day")
                        .font(.subheadline)
                }.frame(maxWidth: 340, maxHeight: 130)
                    .background((Color(red: 1, green: 1, blue: 1)))
                    .cornerRadius(10)
                    .shadow(color: Color.gray.opacity(0.2),
                            radius: 5, x: 0, y: 2)
                
                // Moderate Carb Box
                VStack(alignment: .leading){
                    TitleBMICal(title: "Moderate Carb")
                    HStack(spacing:50){
                        NutritionComponent(nutritionVal: "\( Int((Float(tdeeDisplay) * 0.3) / 4) )", nutrition: "Protein (g)")
                        NutritionComponent(nutritionVal: "\( Int((Float(tdeeDisplay) * 0.35) / 9) )", nutrition: "Fat (g)" )
                        NutritionComponent(nutritionVal: "\( Int((Float(tdeeDisplay) * 0.35) / 4) )", nutrition: "Carbs (g)" )
                         
                        
                    }.frame(maxWidth: 340, maxHeight: 100)
                        .background((Color(red: 1, green: 1, blue: 1)))
                        .cornerRadius(10)
                        .shadow(color: Color.gray.opacity(0.2),
                                radius: 5, x: 0, y: 2)
                }
                
                // Lower Carb box
                VStack(alignment: .leading){
                    TitleBMICal(title: "Lower Carb")
                    HStack(spacing:50){
                        NutritionComponent(nutritionVal: "\( Int((Float(tdeeDisplay) * 0.4) / 4) )", nutrition: "Protein (g)" )
                        NutritionComponent(nutritionVal: "\( Int((Float(tdeeDisplay) * 0.4) / 9) )", nutrition: "Fat (g)" )
                        NutritionComponent(nutritionVal: "\( Int((Float(tdeeDisplay) * 0.2) / 4) )", nutrition: "Carbs (g)" )
                         
                        
                    }.frame(maxWidth: 340, maxHeight: 100)
                        .background((Color(red: 1, green: 1, blue: 1)))
                        .cornerRadius(10)
                        .shadow(color: Color.gray.opacity(0.2),
                                radius: 5, x: 0, y: 2)
                }
                // High Carbs box
                VStack(alignment: .leading){
                    TitleBMICal(title: "High Carb")
                    HStack(spacing:50){
                        NutritionComponent(nutritionVal: "\( Int((Float(tdeeDisplay) * 0.3) / 4) )", nutrition: "Protein (g)" )
                        NutritionComponent(nutritionVal: "\( Int((Float(tdeeDisplay) * 0.2) / 9) )", nutrition: "Fat (g)" )
                        NutritionComponent(nutritionVal: "\( Int((Float(tdeeDisplay) * 0.5) / 4) )", nutrition: "Carbs (g)" )
                         
                        
                    }.frame(maxWidth: 340, maxHeight: 100)
                        .background((Color(red: 1, green: 1, blue: 1)))
                        .cornerRadius(10)
                        .shadow(color: Color.gray.opacity(0.2),
                                radius: 5, x: 0, y: 2)
                }
                Spacer()
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            
            
        }
        //        .background(.green)
        .background(Color(red: 0.98, green: 0.98, blue: 0.98))
        .navigationTitle("Your result")
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){

                Button{
                    presentationMode.wrappedValue.dismiss()
                    presentationMode.wrappedValue.dismiss()
                }label: {
                    Text("Done")
                        .foregroundColor(.green)
                }
//                NavigationLink(
//                    destination: ProfileView(),
//                    label: {
//                        Text("Done")
//                            .foregroundColor(.green)
//
//                    }
//                )
                
                
            }
        }
    }

}
extension TDEEResultView{

    private func changePlan(){
        if(selectedPlan == "Cutting"){
            tdeeDisplay = tdee.TDEE - 500
        }else if (selectedPlan == "Maintenance"){
            tdeeDisplay = tdee.TDEE
        }else if (selectedPlan == "Bulking"){
            tdeeDisplay = tdee.TDEE + 500
        }
    }
}

struct TDEEResultView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            TDEEResultView(userTDEE: .constant(1.0))
        }.environmentObject(TDEEModel())

    }
}

struct NutritionComponent: View {
    var nutritionVal: String
    var nutrition: String
    var body: some View {
        VStack{
            Text("\(nutritionVal)")
                .font(.system(size: 30))
                .fontWeight(.regular)
                .multilineTextAlignment(.center)
            Text("\(nutrition)")
                .font(.subheadline)
        }
    }
}
