//
//  SurvicateDestination.swift
//  SurvicateDestination
//
//  Created by Cody Garvin on 9/13/21.
//

import Foundation
import Segment
import Survicate

public class SurvicateDestination: DestinationPlugin {
    public let timeline = Timeline()
    public let type = PluginType.destination

    public let key = "Survicate"
    public var analytics: Analytics? = nil
    
    private var SurvicateSettings: SurvicateSettings?
        
    public init() { }

    public func update(settings: Settings, type: UpdateType) {
        guard type == .initial else { return }
        
        guard let tempSettings: SurvicateSettings = settings.integrationSettings(forPlugin: self) else { return }
        SurvicateSettings = tempSettings
        
        try? SurvicateSdk.shared.setWorkspaceKey(tempSettings.workspaceKey)
        SurvicateSdk.shared.initialize()
    }
    
    public func identify(event: IdentifyEvent) -> IdentifyEvent? {       
        if let userId = event.userId {
            SurvicateSdk.shared.setUserTrait(withName: "userId", value: userId)
        }

        if let traits = event.traits?.dictionaryValue {
            traits.forEach { key, value in
                guard let value = value as? String else { return }
                
                SurvicateSdk.shared.setUserTrait(withName: key, value: value)
            }
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

private struct SurvicateSettings: Codable {
    let workspaceKey: String
}
