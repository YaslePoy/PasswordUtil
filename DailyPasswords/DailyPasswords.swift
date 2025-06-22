//
//  DailyPasswords.swift
//  DailyPasswords
//
//  Created by Михаил Митрованов on 22.06.2025.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct DailyPasswordsEntryView : View {

    
    
    private func generatePass(len: Int, useLetters: Bool, useNumbers: Bool, useSpecial: Bool) -> String {
        
        let specials = "!@#$%&*()+{}[]"
        var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
        
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
    
    var entry: Provider.Entry

    var body: some View {

        VStack {
            Text("Пароли дня").font(.title2)
            Text(generatePass(len: 4, useLetters: false, useNumbers: true, useSpecial: false)).bold().fontDesign(.monospaced)
            Text(generatePass(len: 6, useLetters: false, useNumbers: true, useSpecial: false)).bold().fontDesign(.monospaced)
            Text(generatePass(len: 8, useLetters: true, useNumbers: true, useSpecial: true)).bold().fontDesign(.monospaced)
            Text(generatePass(len: 12, useLetters: true, useNumbers: true, useSpecial: true)).bold().fontDesign(.monospaced).font(.subheadline)
        
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
        .description("Подсказка для смены пароля, если какой-то пронравился")
    }
}

#Preview(as: .systemSmall) {
    DailyPasswords()
} timeline: {
    SimpleEntry(date: .now)
    SimpleEntry(date: .now)
}
