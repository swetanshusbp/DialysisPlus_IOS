//
//  DialysisPlusWidgetLiveActivity.swift
//  DialysisPlusWidget
//
//  Created by Abilasha  on 23/03/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct DialysisPlusWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct DialysisPlusWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DialysisPlusWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension DialysisPlusWidgetAttributes {
    fileprivate static var preview: DialysisPlusWidgetAttributes {
        DialysisPlusWidgetAttributes(name: "World")
    }
}

extension DialysisPlusWidgetAttributes.ContentState {
    fileprivate static var smiley: DialysisPlusWidgetAttributes.ContentState {
        DialysisPlusWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: DialysisPlusWidgetAttributes.ContentState {
         DialysisPlusWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: DialysisPlusWidgetAttributes.preview) {
   DialysisPlusWidgetLiveActivity()
} contentStates: {
    DialysisPlusWidgetAttributes.ContentState.smiley
    DialysisPlusWidgetAttributes.ContentState.starEyes
}
