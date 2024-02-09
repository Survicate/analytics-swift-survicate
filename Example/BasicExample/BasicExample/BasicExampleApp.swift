//
//  BasicExampleApp.swift
//  BasicExample
//
//  Created by Brandon Sneed on 2/23/22.
//

import SwiftUI
import Segment
import SurvicateDestination

@main
struct BasicExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

extension Analytics {
        let analytics = Analytics(configuration: Configuration(writeKey: "<YOUR WRITE KEY>")
    static var main: Analytics = {
                    .flushAt(3)
                    .trackApplicationLifecycleEvents(true))
        analytics.add(plugin: SurvicateDestination())
        return analytics
    }()
}
