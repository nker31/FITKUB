//
//  BMICalView.swift
//  FITKUB
//
//  Created by Nathat Kuanthanom on 1/4/2566 BE.
//

import SwiftUI

struct BMICalView: View {
    @EnvironmentObject var tdee: TDEEModel
    @State var weight: String = "80.0"
    @State var age: String = "20"
    @State var height: String = "180.0"
    @State var gender: String = ""
    @State var showModal = false
    @State var BMI: Float = 0
    @State var imgBMI = ""
    
    // Alert
    @State var alertTitle: String = ""
    @State  var showAlert: Bool = false
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading, spacing: 22){
                // Gender Selection Part
                HStack{
                    Button(action: {
                        gender = "male"
                    }, label: {
                        Image("male_icon")
                            .resizable()
                            .frame(width: 40, height: 40)
                        Text("Male")
                    }).frame(width: 160, height: 100)
                        .background((Color(red: 1, green: 1, blue: 1)))
                        .cornerRadius(10)
                        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
                    
                    Spacer().frame(width: 22)
                    
                    Button(action: {
                        gender = "female"
                    }, label: {
                        Image("female_icon")
                            .resizable()
                            .frame(width: 28, height: 40)
                            .foregroundColor(.pink)
                        Text("Female")
                            .foregroundColor(.pink)
                    })
                    .frame(width: 160, height: 100)
                    .background((Color(red: 1, green: 1, blue: 1)))
                    .cornerRadius(10)
                    .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
                    
                }
                
                // Row 2
                
                HStack{
                    // Column 0
                    VStack{
                        TitleBMICal(title: "Weight (kg)")
                        TextField("Enter your name", text: $weight)
                            .keyboardType(.decimalPad)
                            .font(.system(size: 40))
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .frame(width: 90,height: 45)
                        Rectangle()
                            .frame(width: 75, height: 1)
                            .offset(y:-5)
                    }.frame(width: 160, height: 140)
                        .background((Color(red: 1, green: 1, blue: 1)))
                        .cornerRadius(10)
                        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
                    
                    Spacer().frame(width: 22)
                    // Column 1
                    VStack{
                        TitleBMICal(title: "Age")
                        HStack(spacing: 1){
                            Button {
                                subAge()
                            } label: {
                                Text("-")
                            }.frame(width: 30, height: 30)
                                .foregroundColor(.black)
                                .background(Color(red: 0.914, green: 0.98, blue: 0.89))
                                .cornerRadius(10)
                            VStack{
                                TextField("", text: $age)
                                    .font(.system(size: 40))
                                    .fontWeight(.semibold)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 80,height: 45)
                                    .keyboardType(.numberPad)
                                Rectangle()
                                    .frame(width: 55, height: 1)
                                    .offset(y:-5)
                            }
                            Button {
                                addAge()
                            } label: {
                                Text("+")
                            }.frame(width: 30, height: 30)
                                .foregroundColor(.black)
                                .background(Color(red: 0.914, green: 0.98, blue: 0.89))
                                .cornerRadius(10)
                            
                        }
                        
                        
                        
                    }.frame(width: 160, height: 140)
                        .background((Color(red: 1, green: 1, blue: 1)))
                        .cornerRadius(10)
                        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
                }
                
                // Row 3
                // Height Box
                VStack{
                    TitleBMICal(title: "Height (cm)")
                    //                Text("\(height , specifier: "%.1f")")
                    //                    .font(.system(size: 40))
                    //                    .fontWeight(.semibold)
                    //                    .multilineTextAlignment(.center)
                    //                    .frame(width: 150,height: 45)
                    TextField("", text: $height)
                        .keyboardType(.decimalPad)
                        .font(.system(size: 40))
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .frame(width: 150,height: 45)
                        .keyboardType(.numberPad)
                    Rectangle()
                        .frame(width: 90, height: 1)
                        .offset(y:-5)
                    
                    
                }.frame(width: 340, height: 140)
                    .background((Color(red: 1, green: 1, blue: 1)))
                    .cornerRadius(10)
                    .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
                
                // Row 4
                Button(action: {
                    if(checkEmptyTextField()){
                        self.showModal = true
                    }
                    
                    
                }
                ){
                    Text("Calculate")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                }
                .frame(width: 340, height: 56)
                .foregroundColor(.white)
                .background(Color(red: 0.024, green: 0.843, blue: 0.522))
                .cornerRadius(10)
                
                .sheet(isPresented: $showModal){
                    ModalBMIView(bmiValue: calculateBMI(weight: Float(weight)!,height: Float(height)!,
                                                        age: Int(age)!), img: imgBMI)
                }
                Spacer().frame(height: 50)
                
            }
            .frame(maxWidth: 400,maxHeight: 1100)
            
        }
        .alert(isPresented: $showAlert, content: getAlert)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                
                Button{
                    dismissKeyboard()
                } label:{
                    Image(systemName: "keyboard.chevron.compact.down")
//                        .foregroundColor(Color("GreenFitkub"))
                    
                }

                
                
            }
            
        }
        .navigationTitle("BMI Calculator")
        //        .background(.red)
        .background(Color(red: 0.98, green: 0.98, blue: 0.98))
        //        .frame(maxWidth: .infinity
        //               ,maxHeight: .infinity)
    }
    
    func getAlert() -> Alert{
        Alert(title: Text(alertTitle))
    }
    
    func dismissKeyboard() {
          UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.endEditing(true) // 4
        }
    
    func checkEmptyTextField() -> Bool{
        if(weight.isEmpty){
            alertTitle = "Please enter your weight"
            showAlert.toggle()
            return false
        }else if(height.isEmpty){
            alertTitle = "Please enter your height"
            showAlert.toggle()
            return false
        }else if(age.isEmpty){
            alertTitle = "Please enter your age"
            showAlert.toggle()
            return false
        }
        return true
    }
    
    func calculateBMI(weight: Float, height: Float, age: Int) -> Float{
        let heightInMeters = height / 100.0
        let bmi = weight / (heightInMeters * heightInMeters)
        let ageFactor = Float(max(0, min(age - 20, 50))) / 100.0
        let adjustedBMI = bmi + (bmi * ageFactor)
        
        return adjustedBMI
        
    }
    func addAge(){
        var ageValue = Int(age)!
        ageValue += 1
        age = String(ageValue)
    }
    func subAge(){
        var ageValue = Int(age)!
        ageValue -= 1
        age = String(ageValue)
    }
}

struct BMICalView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            BMICalView()
        }
        
    }
}


struct TitleBMICal: View {
    var title: String
    var body: some View {
        Text("\(title)")
            .font(.system(size: 20))
            .fontWeight(.semibold)
    }
}

struct ModalBMIView: View {
    @Environment(\.presentationMode) var presentationMode
    var bmiValue: Float
    var img: String
    @State var imgState: String = ""
    @State var title:String = ""
    @State var caption: String = ""
    var body: some View {
        
        VStack {
            Image("\(imgState)")
                .resizable()
                .frame(width: 300,height: 190)
                .onAppear{
                    if (bmiValue < 18.5) {
                        imgState = "thin"
                        title = "น้ำหนักน้อยกว่าปกติ"
                        caption = "คนที่มีดัชนีมวลกายต่ำกว่า 18.5 หรือมีน้ำหนักน้อยกว่าปกติสำหรับส่วนสูง"
                    }
                    else if(bmiValue >= 18.5 && bmiValue <= 25.0){
                        imgState = "normal"
                        title = "ปกติ"
                        caption = "คนที่มีดัชนีมวลกายอยู่ในช่วง 18.5-24.9"
                    }
                    else if(bmiValue > 25.0 && bmiValue <= 30.0){
                        imgState = "overweight"
                        title = "ท้วม"
                        caption = "คนที่มีดัชนีมวลกายอยู่ในช่วง 25.0-29.9"
                    }
                    else if(bmiValue > 30.0 && bmiValue <= 35.0){
                        imgState = "obese I"
                        title = "โรคอ้วนระดับ 1"
                        caption = "คนที่มีดัชนีมวลกายอยู่ในช่วง 30.0-34.9"
                    }
                    else if(bmiValue > 35.0 && bmiValue <= 40.0){
                        imgState = "obese II"
                        title = "โรคอ้วนระดับ 2"
                        caption = "คนที่มีดัชนีมวลกายอยู่ในช่วง 35.0-39.9"
                    }
                    else if(bmiValue > 40.0){
                        imgState = "obese III"
                        title = "โรคอ้วนระดับ 3"
                        caption = "คนที่มีดัชนีมวลกายอยู่ในช่วง 40.0 ขึ้นไป"
                    }
                }
            Text("\(title)")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            Text("BMI ของคุณคือ \(bmiValue, specifier: "%.1f")")
                .font(.title3)
//                .padding()
            Text("\(caption)")
                .frame(maxWidth: 340)
                .font(.body)
                .padding()

            
//            Button("เสร็จสิ้น") {
//                self.presentationMode.wrappedValue.dismiss()
//            }
//            .padding()
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                
                Text("Done")
                    .foregroundColor(Color(red: 0.024, green: 0.843, blue: 0.522))
            }
            )
        }
    }
}
