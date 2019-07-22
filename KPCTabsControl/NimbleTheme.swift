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
    
    fileprivate static var sharedBorderColor: NSColor { if #available(OSX 10.14, *) {
        return NSColor.separatorColor
    } else {
        return NSColor.lightGray
        } }
    fileprivate static var sharedBackgroundColor: NSColor { return NSColor.windowBackgroundColor }
    
    fileprivate struct DefaultTabButtonTheme: KPCTabsControl.TabButtonTheme {
        var backgroundColor: NSColor { return NimbleTheme.sharedBackgroundColor }
        var borderColor: NSColor { return NimbleTheme.sharedBorderColor }
        var titleColor: NSColor { return NSColor.textColor }
        var titleFont: NSFont { return NSFont.systemFont(ofSize: 12) }
    }
    
    fileprivate struct SelectedTabButtonTheme: KPCTabsControl.TabButtonTheme {
        let base: DefaultTabButtonTheme
        
        var backgroundColor: NSColor {
            if #available(OSX 10.13, *) {
                return NSColor.init(named: "SelectedBackgroundColor", bundle: Bundle.init(for: TabsControl.self)) ?? NSColor.white
            } else {
                return NSColor.white
            }
            
        }
        var borderColor: NSColor { return NimbleTheme.sharedBorderColor }
        var titleColor: NSColor { return NSColor.selectedTextColor  }
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
