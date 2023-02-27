import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> FlutterEntry {
        FlutterEntry(date: Date(), widgetData: WidgetData(text: "Flutter iOS widget!"))
    }

    func getSnapshot(in context: Context, completion: @escaping (FlutterEntry) -> ()) {
        let entry = FlutterEntry(date: Date(), widgetData: WidgetData(text: "Flutter iOS widget!"))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let sharedDefaults = UserDefaults.init(suiteName: "group.flutterioswidget")
        let flutterData = try? JSONDecoder().decode(WidgetData.self, from: (sharedDefaults?
            .string(forKey: "widgetData")?.data(using: .utf8)) ?? Data())

        let entryDate = Calendar.current.date(byAdding: .hour, value: 24, to: Date())!
        let entry = FlutterEntry(date: entryDate, widgetData: flutterData)

        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct WidgetData: Decodable, Hashable {
    let text: String
}

struct FlutterEntry: TimelineEntry {
    let date: Date
    let widgetData: WidgetData?
}

struct FlutterIOSWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        Text(entry.widgetData?.text ?? "Tap to set message.")
    }
}

struct FlutterIOSWidget: Widget {
    let kind: String = "FlutterIOSWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            FlutterIOSWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Flutter iOS Widget")
        .description("This is an example Flutter iOS widget.")
    }
}
