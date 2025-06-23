//
//  DailyPasswords.swift
//  DailyPasswords
//
//  Created by Михаил Митрованов on 22.06.2025.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    private func generatePass(len: Int, useLetters: Bool, useNumbers: Bool, useSpecial: Bool) -> String {
        
        let specials = "!@#$%&*()+{}[]"
        let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
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
    
    func placeholder(in context: Context) -> DailyPasswordSet {
        DailyPasswordSet()
    }

    func getSnapshot(in context: Context, completion: @escaping (DailyPasswordSet) -> ()) {
        let entry = DailyPasswordSet()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        
        
        var entries : [DailyPasswordSet] = []
//                for i in 0...1{
//                    var e = DailyPasswordSet(date: Date(timeIntervalSinceNow:  Double(i) * 5.0))
//                    e.pin = i.description + "~"
//                    e.longPass = String(Int.random(in: 0...1000))
//                    entries.append(e)
//                }
        
        print(Date.now)
        var passSet = DailyPasswordSet(date: Date())
        
        passSet.pin = generatePass(len: 4, useLetters: false, useNumbers: true, useSpecial: false)
        passSet.longPin = generatePass(len: 6, useLetters: false, useNumbers: true, useSpecial: false)
        passSet.pass = generatePass(len: 8, useLetters: true, useNumbers: true, useSpecial: true)
        passSet.longPass = generatePass(len: 12, useLetters: true, useNumbers: true, useSpecial: true)

        let now = Date().timeIntervalSince1970

        entries.append(passSet)
        let tz = Calendar.current.timeZone
        let tzNow = Int(now) + tz.secondsFromGMT()
        let day = tzNow / 86400
        let tommorow = Double((day + 1) * 86400 + 5 - tz.secondsFromGMT())
        let date = Date(timeIntervalSince1970: tommorow)
        print("End at \(date)")
        passSet = DailyPasswordSet(date: date)
        passSet.pin = "Гене"
        passSet.longPin = "рируем"
        passSet.pass = "новые"
        passSet.longPass = "комбинации"
        entries.append(passSet)
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct DailyPasswordSet: TimelineEntry {
    var date: Date = Date()
    public var pin: String = "1234"
    public var longPin: String = "098765"
    public var pass: String = "AbC123{!"
    public var longPass: String = "w4!X5@y6(Z7*"
    
    init(date: Date){
        self.date = date
    }
    
    init() {
    }
}

struct DailyPasswordsEntryView : View {
    
    var entry: Provider.Entry

    var body: some View {

        VStack {
            Text("Пароли дня").font(.title2)
            Text(entry.pin).bold().fontDesign(.monospaced)
            Text(entry.longPin).bold().fontDesign(.monospaced)
            Text(entry.pass).bold().fontDesign(.monospaced)
            Text(entry.longPass).bold().fontDesign(.monospaced).font(.subheadline)
        
        }
    }
    
}

struct DailyPasswords: Widget {
    let kind: String = "DailyPasswords"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                DailyPasswordsEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                DailyPasswordsEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Пароли дня")
        .description("Подсказка для смены пароля, если какой-то пронравился").supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    DailyPasswords()
} timeline: {
    DailyPasswordSet()
}
