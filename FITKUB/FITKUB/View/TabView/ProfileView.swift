//
//  ProfileView.swift
//  FITKUB
//
//  Created by Nathat Kuanthanom on 1/4/2566 BE.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var user: UserDataViewModel
    

    var body: some View {
        ZStack{
            VStack{
                // Profile Cover
                VStack(alignment: .center){

                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .foregroundColor(.white)
                                                    
                    Text("\(user.userData.userFname) \(user.userData.userLname)")
                        .font(.system(size: 24))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
//                    .frame(width: 420, height: 180)
                .frame(maxWidth: .infinity,maxHeight: 180)
//                .padding(.bottom)
                .background(Color(red: 0.024, green: 0.843, blue: 0.522) )
                
                //
                ScrollView(.vertical){
                    VStack(spacing: 20){
                        
                        // Personal Data BMI/ Weight/ Height
                        HStack(spacing:30){
                            personalFloatDataElement(title: "BMI", value: user.userData.userBMI)
                            Rectangle().frame(width: 1,height: 42).opacity(0.3)
                            personalFloatDataElement(title: "Weight", value: user.userData.userCurrentWeight)
                            Rectangle().frame(width: 1,height: 42).opacity(0.3)
                            personalFloatDataElement(title: "Height", value: user.userData.userCurrentHeight)
                        }.frame(width: 342, height: 80, alignment: .center)
                            .background(Color(red: 1, green: 1, blue: 1))
                            .cornerRadius(15)
                            .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
                            .padding(.top,20)
                        
                        // Weight Progression
                        NavigationLink(
                            destination: WeightProgessView(),
                            label: {
                                VStack(spacing: 10){
                                    weightRow(label: "Start Weight", value: "\(user.userData.userStartWeight)")
                                    weightRow(label: "Weight Difference", value: "\(user.userData.userCurrentWeight - user.userData.userStartWeight)")
                                    weightRow(label: "Ideal Weight", value: "\(user.userData.userIdealWeight)")
                                    
                                }.frame(width: 342, height: 120)
                                    .background(Color(red: 1, green: 1, blue: 1))
                                    .cornerRadius(15)
                                    .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
                                    
                            }
                        )


                        // Personal Detail
                        NavigationLink(
                            destination: PersonalDataView(),
                            label: {
                                MenuRow(menuName: "Personal Detail")
                                    
                            }
                        )
                        
                        
                        NavigationLink(
                            destination: TDEECalView(),
                            label: {
                                MenuRow(menuName: "TDEE Calculator")

                            }
                        )

                        
                        //BMI Calculator
                        NavigationLink(
                            destination: BMICalView(),
                            label: {
                                MenuRow(menuName: "BMI Calculator")
                                    
                            }
                        )
                    }.frame(maxWidth: .infinity)

                    
                    
                }
                //                .background(.red)

                
                Spacer()
            }
            .onAppear(perform: user.calculateIdealWeight)

        }
        .background(Color(red: 0.98, green: 0.98, blue: 0.98))
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            ProfileView()
        }
        .environmentObject(UserDataViewModel())
    }
}


struct weightRow: View {
    var label: String
    var value: String
    var body: some View {
        HStack{
            Text("\(label)")
                .font(.system(size: 18))
                .fontWeight(.regular)
                .foregroundColor(.black)
            Spacer()
            if(value == "0"){
                
                Text("N/A")

                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            }
            else if((Float(value) ?? 0) < 1){
                Text("\(Float(value) ?? 0.0 * -1 , specifier: "%.1f") kg")

                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            }
            else{
                Text("\(value) kg")
                    
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            }
            
                
        }.padding(.horizontal,40)
        
    }
}

struct personalDataElement: View {
    var title: String
    var value: String
    var body: some View {
        VStack{
            Text("\(title)")
                .font(.system(size: 18))
                .fontWeight(.regular)
            Text("\(value)")
                .font(.system(size: 18))
                .fontWeight(.semibold)
        }
    }
}

struct personalFloatDataElement: View {
    var title: String
    var value: Float
    var body: some View {
        VStack{
            Text("\(title)")
                .font(.system(size: 18))
                .fontWeight(.regular)
            Text("\(value, specifier: "%.1f")")
                .font(.system(size: 18))
                .fontWeight(.semibold)
        }
    }
}



struct MenuRow: View {
    var menuName: String
    var body: some View {
        HStack(){
            Text("\(menuName)")
            Spacer()
            Image("arrow_forward")
        }.padding(.horizontal,40)
            .foregroundColor(.black)
            .frame(width: 342, height: 45)
            .background(Color(red: 1, green: 1, blue: 1))
            .cornerRadius(15)
            .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}
