//
//  SafariTheme.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 27/08/16.
//  Licensed under the MIT License (see LICENSE file)
//

import AppKit

public struct NimbleTheme: Theme {
    
    public init() { }
    
    public let tabButtonTheme: TabButtonTheme = DefaultTabButtonTheme()
    public let selectedTabButtonTheme: TabButtonTheme = SelectedTabButtonTheme(base: DefaultTabButtonTheme())
    public let unselectableTabButtonTheme: TabButtonTheme = UnselectableTabButtonTheme(base: DefaultTabButtonTheme())
    public let tabsControlTheme: TabsControlTheme = DefaultTabsControlTheme()
  fileprivate static var sharedBorderColor: NSColor { return getColorFromAsset("BorderColor", defualt: NSColor.separatorColor)}
  
    fileprivate static var sharedBackgroundColor: NSColor { return getColorFromAsset("BackgroundColor", defualt: NSColor.windowBackgroundColor) }
    
    fileprivate struct DefaultTabButtonTheme: KPCTabsControl.TabButtonTheme {
        var backgroundColor: NSColor { return NimbleTheme.sharedBackgroundColor }
        var borderColor: NSColor { return NimbleTheme.sharedBorderColor }
        var titleColor: NSColor { return getColorFromAsset("TextColor", defualt: NSColor.selectedTextColor) }
        var titleFont: NSFont { return NSFont.systemFont(ofSize: 12) }
    }
    
    fileprivate struct SelectedTabButtonTheme: KPCTabsControl.TabButtonTheme {
        let base: DefaultTabButtonTheme
        
        var backgroundColor: NSColor { return getColorFromAsset("SelectedBackgroundColor", defualt: NSColor.white)}
        var borderColor: NSColor { return NimbleTheme.sharedBorderColor }
        var titleColor: NSColor { return getColorFromAsset("SelectedTextColor", defualt: NSColor.selectedTextColor)  }
        var titleFont: NSFont { return NSFont.systemFont(ofSize: 12) }
    }
    
    fileprivate struct UnselectableTabButtonTheme: KPCTabsControl.TabButtonTheme {
        let base: DefaultTabButtonTheme
        
        var backgroundColor: NSColor { return base.backgroundColor }
        var borderColor: NSColor { return base.borderColor }
        var titleColor: NSColor { return base.titleColor }
        var titleFont: NSFont { return base.titleFont }
    }
    
    fileprivate struct DefaultTabsControlTheme: KPCTabsControl.TabsControlTheme {
        var backgroundColor: NSColor { return NimbleTheme.sharedBackgroundColor }
        var borderColor: NSColor { return NimbleTheme.sharedBorderColor }
    }
}

fileprivate func getColorFromAsset(_ name: String, defualt: NSColor) -> NSColor {
   return NSColor.init(named: name, bundle: Bundle.init(for: TabsControl.self)) ?? defualt
}
