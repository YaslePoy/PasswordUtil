//
//  PassworkPractice.swift
//  PasswordUtil
//
//  Created by Михаил Митрованов on 21.06.2025.
//

import SwiftUI

struct PassworkPractice: View {
    init(password: String) {
        self.password = password
        passView = password
    }
    @State private var passVisibility = true
    @State private var visiblePass = ""
    @State private var securePass = ""
    public var password: String
    @State private var isGood = false
    @State private var isBad = false
    @State private var isHarder = false
    @State private var passView : String
    var body: some View {
        VStack{
            Text(passView).font(.title2).bold().fontDesign(.monospaced)
            Button{
                passVisibility = !passVisibility
                if passVisibility{
                    passView = password
                }else{
                    passView = String(repeating: "*", count: password.count)
                }
            }label: {Label("Видимость", systemImage: (passVisibility ? "eye" : "eye.slash"))}
            List {
                Toggle(isOn: $isHarder.animation()){
                    Text("Усложнение")
                }
                if isHarder{
                    SecureField(text: $securePass, prompt: Text("А теперь если не видно")) {
                    }.textContentType(.nickname).disableAutocorrection(true)
                    
                }else{
                    TextField(text: $visiblePass, prompt: Text("Потренируйтесь в вводе пароля")) {
                    }.textContentType(.nickname).disableAutocorrection(true)
                }
                
                
                Button{
                    withAnimation{
                        
                        if (password == visiblePass || password == securePass){
                            isGood = true
                            isBad = false
                        }else{
                            isGood = false
                            isBad = true
                        }
                        visiblePass = ""
                        securePass = ""
                    }
                } label: {
                    Text("Проверка")
                }
                Button{
                    withAnimation{
                        visiblePass = ""
                        securePass = ""
                        isBad = false
                        isGood = false
                    }
                } label: {
                    Label("Очистить", systemImage: "eraser")
                }
                Button{
#if os(iOS)
                    UIPasteboard.general.string = password
#else
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(password, forType: .string)
#endif

                } label: {
                    Label("Скопировать", systemImage: "clipboard")
                }
                if isGood{
                    Label("Все верно", systemImage: "checkmark.circle").listRowBackground(Color.green).accentColor(Color.white)
                }
                if isBad{
                    Label("Несовпадение", systemImage: "xmark.circle").listRowBackground(Color.red).accentColor(Color.white)
                }
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
.navigationTitle("Тренировка пароля")
        
    }
}

#Preview {
    PassworkPractice(password: "j5z1#JFY3-K)xR-_V-S_")
}
