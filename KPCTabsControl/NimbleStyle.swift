//
//  SafariStyle.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 27/08/16.
//  Licensed under the MIT License (see LICENSE file)
//

import AppKit

public struct NimbleStyle: ThemedStyle {
    public let theme: Theme
    public let tabButtonWidth: TabWidth
    public let tabsControlRecommendedHeight: CGFloat = 24.0
    
    public init(theme: Theme = NimbleTheme(), tabButtonWidth: TabWidth = .flexible(min: 70, max: 250)) {
        self.theme = theme
        self.tabButtonWidth = tabButtonWidth
    }
    
    
}

