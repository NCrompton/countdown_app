//
//  Countdown.swift
//  Countdown
//
//  Created by Mason Tsui on 23/6/2024.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    var _counter = 0
    
    func placeholder(in context: Context) -> CountdownEntry {
        CountdownEntry(date: Date(), emoji: "😀", counter: 0, interval: "NA")
    }

    func getSnapshot(in context: Context, completion: @escaping (CountdownEntry) -> ()) {
        var entry: CountdownEntry = placeholder(in: context)
        
        if context.isPreview {
//            entry = placeholder(in: context)
        } else {
//            let userDefaults = UserDefaults(suiteName: Bundle.main.infoDictionary?["DEVELOPMENT_TEAM"] as? String)
            let userDefaults = UserDefaults(suiteName: "group.masonzen.countdown")
            if let userDefaults = userDefaults {
                let formatter = DateFormatter()
                let dateString = userDefaults.value(forKey: "countdown_date") as? String
                
                formatter.dateFormat = "yyyy-MM-dd hh:mm:ss.000"
                formatter.timeZone = TimeZone(secondsFromGMT: 0)
                var date = formatter.date(from: dateString ?? "")
                
                let datecom = DateComponentsFormatter()
                datecom.allowedUnits = [.day, .hour, .minute]
                datecom.unitsStyle = .abbreviated
                let interval = datecom.string(from: .now, to: date ?? .now)
                print("int: ", interval ?? "NA")
                
//                let interval = userDefaults.value(forKey: "countdown_interval") as? String
                
                print("the number is", date ?? "null")
                print(interval ?? "NA")
                let counter = userDefaults.value(forKey: "countdown_counter") as? Int
                entry = CountdownEntry(date: date ?? .now, emoji: "non", counter: counter ?? 0, interval: interval ?? "0d 0h 0m")
            }
        }
        
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        var entries: [CountdownEntry] = []
//
//        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = CountdownEntry(date: entryDate, emoji: "😀", counter: 5)
//            entries.append(entry)
//        }
//
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
        print("updating widget")
        getSnapshot(in: context) { (entry) in
       // atEnd policy tells widgetkit to request a new entry after the date has passed
               let timeline = Timeline(entries: [entry], policy: .atEnd)
                         completion(timeline)
        }
    }
}

struct CountdownEntry: TimelineEntry {
    let date: Date
    let emoji: String
    let counter: Int
    let interval: String
}

struct CountdownEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .date)

//            Text("Emoji:")
//            Text(entry.emoji)
            
//            Text("Counter")
//            Text("\(entry.counter)")
            
            Text("Interval")
            Text(entry.interval)
        }
    }
}

struct Countdown: Widget {
    let kind: String = "com.masonzen.calendar.Countdown"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                CountdownEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                CountdownEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Countdown Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    Countdown()
} timeline: {
    CountdownEntry(date: .now, emoji: "😀", counter: 2, interval: "NA")
    CountdownEntry(date: .now, emoji: "🤩", counter: 3, interval: "NA2")
}
