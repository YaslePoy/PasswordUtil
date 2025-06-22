//
//  ContentView.swift
//  PasswordUtil
//
//  Created by Михаил Митрованов on 21.06.2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State public var useLetters = false
    @State public var useNumbers = false
    @State public var useSpecial = false
    @State public var len = 8.0
    @State private var count = 10.0
    @State private var isEditing = false
    @State private var passwords : [Password] = []
    @State private var specials = "!@#$%&*()+{}[]"
    @State private var editSpecials = false
    private var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    var body: some View {
        
        NavigationSplitView{

            List{
                Section("Параметры генерации"){
                    Toggle(isOn: $useLetters.animation()){
                        Text("Использовать буквы")
                    }
                    Toggle(isOn: $useNumbers.animation()){
                        Text("Использовать цифры")
                    }
                    Toggle(isOn: $useSpecial.animation()){
                        Text("Использовать спец. символы")
                    }.onTapGesture {
                        withAnimation{
                            editSpecials = !editSpecials
                        }
                    }
                    
                    if editSpecials{
                    
                        TextField(text: $specials.animation(), prompt: Text("Специальные символы")){
                                
                            }
                        Button(role: .destructive){withAnimation{ specials = "!@#$%&*()+{}[]" }} label: {Text("Сбросить")}
                            
                        
                        
                    }
                    VStack{
                        HStack{
                            Text("Длина пароля")
                            Text("\(Int(len))")
                                .bold()
                        }
                        Slider(value: $len, in: 1...20, step: 1)
                    }
                    VStack{
                        HStack{
                            Text("Количество паролей")
                            Text("\(Int(count))")
                                .bold()
                        }
                        Slider(value: $count, in: 1...20, step: 1)
                    }
                    if useLetters || useNumbers || (useSpecial && specials.count != 0){
                        Button{
                            generateAll()
                        } label :
                        {Label("Сгенерировать", systemImage: "plus")}
                    }
                    
                }
                
                Section{
                    
                    ForEach(passwords){ pass in
                        NavigationLink{
                            PassworkPractice(password: pass.text)
                        } label: {
                            Text(pass.text).fontDesign(.monospaced).bold()
                        }
                    }
                    
                    
                }
            }
        } detail: {
            Text("Выберите пароль для практики")
        }

    }
    
    private func generateAll(){
        passwords.removeAll()
        for i in 0...Int(count - 1){
            withAnimation{
                passwords.append(Password(id: i + 1, text: generatePass()))
            }
        }
    }
    
    private func generatePass() -> String {
        var totalPass : [Character] = []
        for _ in 0...Int(len-1){
            var candidates : [Character] = []
            
            if useLetters{
                candidates.append(alphabet.shuffled().first!)
            }
            if useNumbers{
                candidates.append("1234567890".shuffled().first!)
            }
            if useSpecial{
                
                candidates.append(specials.shuffled().first ?? " ")
            }
            totalPass.append(candidates.shuffled().first!)
        }
        return String(totalPass)
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
