//
//  StartView.swift
//  FITKUB
//
//  Created by Nathat Kuanthanom on 30/4/2566 BE.
//

import SwiftUI

struct StartView: View {
    // Environment Object
    @StateObject var user: UserDataViewModel = UserDataViewModel()
    @StateObject var hk: HealthKitViewModel = HealthKitViewModel()
    @StateObject var fd: FoodDiaryViewModel = FoodDiaryViewModel()
    
    @State var isGreet: Bool = false
    @State var isAuthorized : Bool = false
    var body: some View {
        ZStack{

            if(!isGreet){
                GreetingView(isGreet: $isGreet)
            
            }
            else if(!hk.isAuthorized){
                VStack {
                    Text("Please Authorize Health!")
                        .font(.title3)

                    Button {
                        hk.healthRequest()
                    } label: {
                        Text("Authorize HealthKit")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .frame(width: 320, height: 55)
                    .background(Color(.orange))
                    .cornerRadius(10)
                }
                .onAppear(perform: changeView)
            }
            else{
                TabView{
                    HomeView().tabItem{
                        Label("Home", systemImage: "house")
                    }
                    FoodDiaryView().tabItem{
                        Label("Food", systemImage: "fork.knife")

                    }
                    ProfileView().tabItem{
                        Label("Profile", systemImage: "person")
                    }
                }
            }
        }.onAppear{
            if(user.userData.isGreet){
                withAnimation{
                    isGreet = true
                }
                
            }
            if(hk.isAuthorized){
                withAnimation{
                    isAuthorized = true
                }
            }
        }

        
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            StartView()
        }.environmentObject(UserDataViewModel())
            .environmentObject(FoodDiaryViewModel())
            .environmentObject(HealthKitViewModel())

    }
}

extension StartView{
    
    func changeView(){
        if (user.userData.isGreet){
            isGreet = true
        }
        if (hk.isAuthorized){
            isAuthorized = true
        }
    }
}
