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
    var errorCountdown = CountdownEntry(date: Date.distantPast, interval: "-1", name: "error", isReverse: false)
    
    func placeholder(in context: Context) -> CountdownEntry {
        CountdownEntry(date: Date(), interval: "12d", name: "Birthday", isReverse: false)
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
                let dateString = userDefaults.value(forKey: "countdown_date") as? String ?? "null"
                let dateName = userDefaults.value(forKey: "countdown_name") as? String ?? ""
                
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                formatter.timeZone = TimeZone.current
                print(String(dateString.prefix(19)))
                let date = formatter.date(from: String(dateString.prefix(19)))
                
                guard let date = date else {return completion(errorCountdown)}
                
                var isReverse = false
                if date < .now {isReverse = true}
                
                let datecom = DateComponentsFormatter()
                datecom.allowedUnits = [.day, .hour, .minute]
                datecom.unitsStyle = .abbreviated
                var interval = datecom.string(from: .now, to: date) ?? "..."
                let diff = isReverse ?
                    Calendar.current.dateComponents([.day, .hour, .minute], from: date, to: .now) :
                    Calendar.current.dateComponents([.day, .hour, .minute], from: .now, to: date)
                
                if let day = diff.day, let hour = diff.hour, let minute = diff.minute {
                    interval = "\(day)d \(hour)h \(minute)m"
                }
                
                print("received dateString: ", dateString)
                print("received date: ", date)
                print("received interval: ", interval)
                
                entry = CountdownEntry(date: date, interval: interval, name: dateName, isReverse: isReverse)
            }
        }
        
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
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
    let interval: String
    let name: String
    let isReverse: Bool
}

struct SmallInfoText : View {
    let text: String
    
    var body : some View {
        Text(text).font(.system(size: 8))
    }
}

struct CountdownEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family

    var body: some View {
        
        switch (family) {
        case .systemSmall, .systemMedium:
            VStack {
                entry.isReverse ?
                SmallInfoText(text: "Since") :
                SmallInfoText(text: "To:")
                Text(entry.name)
                Text(entry.date, style: .date)
                
                SmallInfoText(text: "Interval")
                Text(entry.interval).font(.title)
            }
        case .systemLarge, .systemExtraLarge:
            VStack {
                Text(entry.name)
                Text(entry.date, style: .date)
                
                SmallInfoText(text: "Interval")
                Text(entry.interval).font(.title)
            }
        case .accessoryCircular:
            Text(entry.interval)
        default:
            EmptyView()
                
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
        .supportedFamilies([
            .systemSmall, .systemMedium, .accessoryCircular
        ])
    }
}

//#Preview(as: .systemSmall) {
//    Countdown()
//} timeline: {
//    CountdownEntry(date: .now, interval: "NA", name: "first")
//    CountdownEntry(date: .now, interval: "NA2", name: "second")
//}
