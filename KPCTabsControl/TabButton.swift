//
//  TabButton.swift
//  KPCTabsControl
//
//  Created by Cédric Foellmi on 06/07/16.
//  Licensed under the MIT License (see LICENSE file)
//

import AppKit

open class TabButton: NSButton {

    fileprivate var iconView: NSImageView?
    fileprivate var alternativeTitleIconView: NSImageView?
    fileprivate var trackingArea: NSTrackingArea?
    fileprivate var closeButton: NSButton?
    
    fileprivate var tabButtonCell: TabButtonCell? {
        get { return self.cell as? TabButtonCell }
    }

    open var item: AnyObject? {
        get { return self.cell?.representedObject as AnyObject? }
        set { self.cell?.representedObject = newValue }
    }

    open var style: Style! {
        didSet {
            self.tabButtonCell?.style = self.style
            let path = Bundle(for: TabButton.self).pathForImageResource("tab_close_icon")!
            let img = NSImage(contentsOfFile: path)?.imageWithTint((style as! ThemedStyle).theme.closeButtonColor)
            closeButton?.image = img
            closeButton?.imageScaling = .scaleProportionallyDown
        }
    }

    /// The button is aware of its last known index in the tab bar.
    var index: Int? = nil

    open var buttonPosition: TabPosition! {
        get { return tabButtonCell?.buttonPosition }
        set { self.tabButtonCell?.buttonPosition = newValue }
    }
    
    open var closeButtonSize: CGFloat {
        return closeButton?.frame.width ?? 0
    }

    open var representedObject: AnyObject? {
        get { return self.tabButtonCell?.representedObject as AnyObject? }
        set { self.tabButtonCell?.representedObject = newValue }
    }

    open var editable: Bool {
        get { return self.tabButtonCell?.isEditable ?? false }
        set { self.tabButtonCell?.isEditable = newValue }
    }

    open var icon: NSImage? = nil {
        didSet {
            if self.icon != nil && self.iconView == nil {
                self.iconView = NSImageView(frame: NSZeroRect)
                self.iconView?.imageFrameStyle = .none
                self.addSubview(self.iconView!)
            }
            else if (self.icon == nil && self.iconView != nil) {
                self.iconView?.removeFromSuperview()
                self.iconView = nil
            }
            self.iconView?.image = self.icon
            self.needsDisplay = true
        }
    }
    
    open var alternativeTitleIcon: NSImage? = nil {
        didSet {
            self.tabButtonCell?.hasTitleAlternativeIcon = (self.alternativeTitleIcon != nil)
            
            if self.alternativeTitleIcon != nil && self.alternativeTitleIconView == nil {
                self.alternativeTitleIconView = NSImageView(frame: NSZeroRect)
                self.alternativeTitleIconView?.imageFrameStyle = .none
                self.addSubview(self.alternativeTitleIconView!)
            }
            else if self.alternativeTitleIcon == nil && self.alternativeTitleIconView != nil {
                self.alternativeTitleIconView?.removeFromSuperview()
                self.alternativeTitleIconView = nil
            }
            self.alternativeTitleIconView?.image = self.alternativeTitleIcon
            self.needsDisplay = true
        }
    }
    
    open var closeTabCallBack : ((AnyObject?, AnyObject?) -> Void)? = {_, _ in }
    
    // MARK: - Init

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.cell = TabButtonCell(textCell: "")
        
    }
    
    convenience init(frame frameRect: NSRect, closeCallBack:((AnyObject? ,AnyObject?) -> Void)?) {
        self.init(frame: frameRect)
        self.cell = TabButtonCell(textCell: "")
        createCloseButton(closeCallBack: closeCallBack)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(index: Int, item: AnyObject, target: AnyObject?, action:Selector, style: Style) {
        super.init(frame: NSZeroRect)

        self.index = index
        self.style = style

        let tabCell = TabButtonCell(textCell: "")
        
        tabCell.representedObject = item
        tabCell.imagePosition = .noImage
        
        tabCell.target = target
        tabCell.action = action
        tabCell.style = style
        
        tabCell.sendAction(on: NSEvent.EventTypeMask(rawValue: UInt64(Int(NSEvent.EventTypeMask.leftMouseDown.rawValue))))
        self.cell = tabCell
    }
    
    convenience init(index: Int, item: AnyObject, target: AnyObject?, action:Selector, style: Style, closeCallBack: ((AnyObject?, AnyObject?) -> Void)?) {
        self.init(index: index, item:  item, target:  target, action:  action, style: style)
        createCloseButton(closeCallBack: closeCallBack)
        
    }
    
    override open func copy() -> Any {
        let copy = TabButton(frame: self.frame, closeCallBack: self.closeTabCallBack)
        copy.cell = self.cell?.copy() as? NSCell
        copy.icon = self.icon
        copy.style = self.style
        copy.alternativeTitleIcon = self.alternativeTitleIcon
        copy.state = self.state
        copy.index = self.index
        copy.closeTabCallBack = self.closeTabCallBack
        return copy
    }
        
    open override var menu: NSMenu? {
        get { return self.cell?.menu }
        set {
            self.cell?.menu = newValue
            self.updateTrackingAreas()
        }
    }
    
    // MARK: - Drawing

    open override func updateTrackingAreas() {
        if let ta = self.trackingArea {
            self.removeTrackingArea(ta)
        }
        
        let item: AnyObject? = self.cell?.representedObject as AnyObject?
        
        let userInfo: [String: AnyObject]? = (item != nil) ? ["item": item!] : nil
        self.trackingArea = NSTrackingArea(rect: self.bounds,
                                           options: [NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.activeInActiveApp, NSTrackingArea.Options.inVisibleRect],
                                           owner: self, userInfo: userInfo)
        
        self.addTrackingArea(self.trackingArea!)
        
        if let w = self.window, let e = NSApp.currentEvent {
            let mouseLocation = w.mouseLocationOutsideOfEventStream
            let convertedMouseLocation = self.convert(mouseLocation, from: nil)
        
            if NSPointInRect(convertedMouseLocation, self.bounds) {
                self.mouseEntered(with: e)
            }
            else {
                self.mouseExited(with: e)
            }
        }
        
        super.updateTrackingAreas()
    }
    
    open override func mouseEntered(with theEvent: NSEvent) {
        super.mouseEntered(with: theEvent)
        self.needsDisplay = true
    }
    
    open override func mouseExited(with theEvent: NSEvent) {
        super.mouseExited(with: theEvent)
        self.needsDisplay = true
    }

    open override func mouseDown(with theEvent: NSEvent) {
        super.mouseDown(with: theEvent)
        if self.isEnabled == false {
            NSSound.beep()
        }
    }

    open override func resetCursorRects() {
        self.addCursorRect(self.bounds, cursor: NSCursor.arrow)
    }
    
    open override func draw(_ dirtyRect: NSRect) {

        guard let tabButtonCell = self.tabButtonCell
            else { assertionFailure("TabButtonCell expected in drawRect(_:)"); return }
        let path = Bundle(for: TabButton.self).pathForImageResource("tab_close_icon")!
        let img = NSImage(contentsOfFile: path)?.imageWithTint((style as! ThemedStyle).theme.closeButtonColor)
        closeButton?.image = img
        closeButton?.imageScaling = .scaleProportionallyDown
        let iconFrames = self.style.iconFrames(tabRect: self.frame)
        self.iconView?.frame = iconFrames.iconFrame
        self.alternativeTitleIconView?.frame = iconFrames.alternativeTitleIconFrame

        let scale: CGFloat = (self.layer != nil) ? self.layer!.contentsScale : 1.0

        if self.icon?.size.width > (iconFrames.iconFrame).height*scale {
            let smallIcon = NSImage(size: iconFrames.iconFrame.size)
            smallIcon.addRepresentation(NSBitmapImageRep(data: self.icon!.tiffRepresentation!)!)
            self.iconView?.image = smallIcon
        }

        if self.alternativeTitleIcon?.size.width > (iconFrames.alternativeTitleIconFrame).height*scale {
            let smallIcon = NSImage(size: iconFrames.alternativeTitleIconFrame.size)
            smallIcon.addRepresentation(NSBitmapImageRep(data: self.alternativeTitleIcon!.tiffRepresentation!)!)
            self.alternativeTitleIconView?.image = smallIcon
        }

        let hasRoom = tabButtonCell.hasRoomToDrawFullTitle(inRect: self.bounds)
        self.alternativeTitleIconView?.isHidden = hasRoom
        self.toolTip = (hasRoom == true) ? nil : self.title

        super.draw(dirtyRect)
    }

    
    // MARK: - Editing
    
    internal func edit(fieldEditor: NSText, delegate: NSTextDelegate) {
        self.tabButtonCell?.edit(fieldEditor: fieldEditor, inView: self, delegate: delegate)
    }
    
    internal func finishEditing(fieldEditor: NSText, newValue: String) {
        self.tabButtonCell?.finishEditing(fieldEditor: fieldEditor, newValue: newValue)
    }
    
    //MARK: Closing
    
    @objc fileprivate func closeButtonPressed(){
        closeTabCallBack!(self, item)
    }
    
    func createCloseButton(closeCallBack : ((AnyObject?, AnyObject?) -> Void)?) {
        guard let callBack = closeCallBack else {
            return
        }
        self.closeButton = NSButton()
        self.closeButton!.cell = CloseButtonCell()
        self.closeButton?.isBordered = false
        self.addSubview(closeButton!)
        closeButton?.translatesAutoresizingMaskIntoConstraints = false
        closeButton?.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        closeButton?.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        closeButton?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        closeButton?.heightAnchor.constraint(equalTo: closeButton!.widthAnchor, multiplier: 1).isActive = true
        closeButton?.target = self
        closeTabCallBack = callBack
        closeButton?.action = #selector(closeButtonPressed)
    }
}


class CloseButtonCell: NSButtonCell {
  
  override var backgroundColor: NSColor? {
    get { return .clear }
    set {}
  }
  
  override func drawImage(_ image: NSImage, withFrame frame: NSRect, in controlView: NSView) {
    super.drawImage(image, withFrame: frame.insetBy(dx: 5, dy: 5), in: controlView)
  }
  
}
