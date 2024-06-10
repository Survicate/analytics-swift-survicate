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
            SurvicateSdk.shared.setUserTrait(withName: "user_id", value: userId)
        }

        if let dictionary = event.traits?.dictionaryValue {
            let traits: [UserTrait] = dictionary.compactMap { key, value in
                switch value {
                case let value as String:
                    return UserTrait(withName: key, value: value)
                case let value as Bool:
                    return UserTrait(withName: key, value: value)
                case let value as Double:
                    return UserTrait(withName: key, value: value)
                default:
                    return nil
                }
            }

            SurvicateSdk.shared.setUserTraits(traits: traits)
        }
        return event
    }
    
    public func track(event: TrackEvent) -> TrackEvent? {
        guard let dictionary = event.properties?.dictionaryValue else {
            SurvicateSdk.shared.invokeEvent(name: event.event)
            return event
        }
        
        var properties = [String: String]();
        for (key, value) in dictionary {
            if let property = value as? String {
                properties[key] = property
            }
        }
        
        SurvicateSdk.shared.invokeEvent(name: event.event, with: properties)
        
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
