//
//  SurvicateDestination.swift
//  SurvicateDestination
//
//  Created by Cody Garvin on 9/13/21.
//

// NOTE: You can see this plugin in use in the DestinationsExample application.
//
// This plugin is NOT SUPPORTED by Segment.  It is here merely as an example,
// and for your convenience should you find it useful.
//

// MIT License
//
// Copyright (c) 2021 Segment
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import Segment
import Survicate

/**
 An implementation of the Example Analytics device mode destination as a plugin.
 */
 
//@objc(SEGSurvicateDestination)
//public class ObjCSegmentMixpanel: NSObject, ObjCDestination, ObjCDestinationShim {
//    public func instance() -> DestinationPlugin { return SurvicateDestination() }
//}

public class SurvicateDestination: DestinationPlugin {
    public let timeline = Timeline()
    public let type = PluginType.destination
    // TODO: Fill this out with your settings key that matches your destination in the Segment App
    public let key = "Survicate"
    public var analytics: Analytics? = nil
    
    private var SurvicateSettings: SurvicateSettings?
        
    public init() { }

    public func update(settings: Settings, type: UpdateType) {
        // Skip if you have a singleton and don't want to keep updating via settings.
        guard type == .initial else { return }
        
        // Grab the settings and assign them for potential later usage.
        // Note: Since integrationSettings is generic, strongly type the variable.
        guard let tempSettings: SurvicateSettings = settings.integrationSettings(forPlugin: self) else { return }
        SurvicateSettings = tempSettings
        
        try? SurvicateSdk.shared.setWorkspaceKey(tempSettings.workspaceKey)
        SurvicateSdk.shared.initialize()
    }
    
    public func identify(event: IdentifyEvent) -> IdentifyEvent? {
        if let traits = event.traits?.dictionaryValue {
            traits.forEach { key, value in
                guard let value = value as? String else { return }
                
                SurvicateSdk.shared.setUserTrait(withName: key, value: value)
            }
        }
        
        if let userId = event.userId {
            SurvicateSdk.shared.setUserTrait(withName: "userId", value: userId)
        }
        
        return event
    }
    
    public func track(event: TrackEvent) -> TrackEvent? {
        
        SurvicateSdk.shared.invokeEvent(name: event.event)
        
        return event
    }
    
    public func screen(event: ScreenEvent) -> ScreenEvent? {
        guard let screenName = event.name else { return event }
        
        SurvicateSdk.shared.enterScreen(value: screenName)
        
        return event
    }
    
    public func reset() {
        SurvicateSdk.shared.reset()
    }
}

// Example of versioning for your plugin
extension SurvicateDestination: VersionedPlugin {
    public static func version() -> String {
        return __destination_version
    }
}

// Example of what settings may look like.
private struct SurvicateSettings: Codable {
    let workspaceKey: String
}
