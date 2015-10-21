//
//  View_Timeline.swift
//  SoundEditor
//
//  Created by David Sklar on 9/26/15.
//  Copyright © 2015 David Sklar. All rights reserved.
//

import UIKit


protocol MessagesFromTimelineDelegate {
    func soundbiteTimespecDidChange(name:String, newSpec:Soundbite)
    func soundbiteDeleteRequested(name:String)
    func soundbiteDuplicateRequested(name:String)
    func userMovedScrubber(newPositionInSeconds:Float, interactionHasEnded:Bool)
}


enum TimelineError: ErrorType {
    case SoundbiteNameInUse
    case SoundbiteNameNotFound
}




class TimelineView: UIView, UIGestureRecognizerDelegate {
    
    @IBOutlet var contentView: UIView!

    
    @IBOutlet weak var scrubber: UIView!
    @IBOutlet weak var scrubberHandle: UIView!
    
    @IBOutlet weak var constraintScrubberX: NSLayoutConstraint!
    
    
    // The user should register a delegate callback func to receive
    // messages from the instance of this view:
    var delegate: MessagesFromTimelineDelegate?
    
    // Fixed characteristics
    let channelCount = 8
    let channelPadding : Float = 2
    let timelineWidthInSec = 8 //seconds
    let heightReservedScrubberHandle : CGFloat = 10


    // Derived from the fixed characteristics and the geometry
    var secWidthInPx : Float = 0   //width of a second's worth of duration's representation, in pixels
    var channelHeight : Float = 0  //pixels
    
    // Database of soundbites in this timeline
    var dictSoundbites = [String: SoundBiteView]()
    
    var scrubberLocation : Float = 0   // in seconds
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    
    override func layoutSubviews() {
        // Calculate derived values based on the incoming geometry
        secWidthInPx = Float(bounds.width / CGFloat(timelineWidthInSec))
        channelHeight = Float(Int(bounds.height-heightReservedScrubberHandle) / channelCount)
        
        super.layoutSubviews()
        
        constraintScrubberX.constant = CGFloat(secWidthInPx * scrubberLocation)
        
        for sbv in dictSoundbites.values {
            if let spec = sbv.soundbite {
                let frameRect = CGRectMake(
                    CGFloat(spec.start * secWidthInPx),
                    CGFloat(((Float(spec.channel)*channelHeight)+channelPadding)),
                    CGFloat(spec.duration()*secWidthInPx),
                    CGFloat(channelHeight-2*channelPadding))
                sbv.frame = frameRect
                sbv.moveClippingHandle(sbv.handleClippingLeft,
                    deltaX: CGFloat(spec.clipStart * secWidthInPx), relative:false)
                sbv.moveClippingHandle(sbv.handleClippingRight,
                    deltaX: CGFloat(spec.clipEnd * secWidthInPx) - sbv.handleClippingRight.bounds.width, relative:false)
            }
        }
        
        contentView.bringSubviewToFront(scrubber)
        contentView.bringSubviewToFront(scrubberHandle)
    }
    
    
    
    // Public API for populating this timeline with visual representations of "soundbite" objects in
    // the data model.
    
    func registerDelegate(delegate: MessagesFromTimelineDelegate) {
        self.delegate = delegate    
    }
    
    func createSoundbiteView(spec:Soundbite) throws {
        
        let name = spec.url
        let channelIndex = spec.channel
        
        if let _ = dictSoundbites[name] {
            throw TimelineError.SoundbiteNameInUse
        }
        
        let frameRect = CGRectMake(
            CGFloat(spec.start * secWidthInPx),
            CGFloat(((Float(channelIndex)*channelHeight)+channelPadding)),
            CGFloat(spec.duration()*secWidthInPx),
            CGFloat(channelHeight-2*channelPadding))
        
        
        let sbv = SoundBiteView(frame: frameRect, colorRectRGB: ColorTheme.colorRectPalette[channelIndex], colorHandleRGB: ColorTheme.colorHandlePalette[channelIndex], _imageForClippedOutPatterning: self.clippedoutPatternImage!)
        sbv.soundbite = spec
        sbv.channelIndex = channelIndex
        sbv.label_Name.text = "III"
        dictSoundbites[name] = sbv
        contentView.addSubview(sbv)
        bringSubviewToFront(scrubber)
        bringSubviewToFront(scrubberHandle)
        
        // Gesture recognizer: drag the soundbite as a whole
        let gestureRecogPan = UIPanGestureRecognizer()
        gestureRecogPan.addTarget(self, action: "handleSoundbiteDrag:")
        sbv.addGestureRecognizer(gestureRecogPan)
        
        // Gesture recognizer: drag the soundbite clipping handles (L and R)
        let gestureRecogPanHandleLeft = UIPanGestureRecognizer()
        let gestureRecogPanHandleRight = UIPanGestureRecognizer()
        setUpHandleMovementSupport(gestureRecogPanHandleLeft, handle: sbv.handleClippingLeft)
        setUpHandleMovementSupport(gestureRecogPanHandleRight, handle: sbv.handleClippingRight)
        
        // Gesture: long-press on soundbite to bring up menu
        let grHold = UILongPressGestureRecognizer()
        grHold.addTarget(self, action: "handleSoundbiteLongPress:")
        sbv.addGestureRecognizer(grHold)
        
        sbv.userInteractionEnabled = true
        
        contentView.bringSubviewToFront(scrubber)
        contentView.bringSubviewToFront(scrubberHandle)
    }
    
    
    
    func deleteSoundbite(name:String) throws {
        if let soundbite = dictSoundbites[name] {
            soundbite.removeFromSuperview()
            dictSoundbites.removeValueForKey(name)
        } else {
            throw TimelineError.SoundbiteNameNotFound
        }
    }
    
    
    // TODO: Animate this!
    func moveScrubberHairline(timeInSeconds: Float) {
        scrubberLocation = timeInSeconds
        constraintScrubberX.constant = CGFloat(secWidthInPx * timeInSeconds)
    }
    
    
    
    func initSubviews() {
        // Instantiate from XIB file
        let nib = UINib(nibName: "Timeline", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
        
        contentView.frame = bounds
        addSubview(contentView)
        
        // Gesture recognizer: drag the soundbite as a whole
        let gestureRecogPan = UIPanGestureRecognizer()
        gestureRecogPan.addTarget(self, action: "handleScrubberDrag:")
        scrubberHandle.addGestureRecognizer(gestureRecogPan)
        scrubberHandle.userInteractionEnabled = true
        
        self.setNeedsDisplay()
        
        scrubberHandle.backgroundColor = UIColor(patternImage: UIImage(named: "Scrubber")!)
    }
    

    
    func handleScrubberDrag(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(self)
        let newX = min(Float(self.bounds.width - 2),
            Float(constraintScrubberX.constant+translation.x))
        constraintScrubberX.constant = CGFloat(newX)
        sender.setTranslation(CGPointZero, inView: self)
        if let delegate = delegate {
            delegate.userMovedScrubber(newX / secWidthInPx,
                interactionHasEnded: (sender.state == .Ended))
        }
    }

    
    // This is non-nil only when a drag is in process:
    var curFrameOrigin : CGPoint?
    var maxAllowedNegativeTranslation : CGFloat?
    var maxAllowedPositiveTranslation : CGFloat?
    
    func handleSoundbiteDrag(sender: UIPanGestureRecognizer) {
        if let sbite = sender.view as? SoundBiteView {
            if curFrameOrigin == nil {
                // This is the start of a drag operation
                self.curFrameOrigin = sbite.frame.origin
                // Determine the limits to the user's ability to drag this left/right
                maxAllowedNegativeTranslation = -1.0 * (curFrameOrigin!.x + sbite.handleClippingLeft.frame.origin.x)
                maxAllowedPositiveTranslation = self.frame.width - (curFrameOrigin!.x + sbite.frame.width)
                    + (sbite.backgroundForRightClippedout.bounds.width/* - sbite.handleClippingRight.bounds.width*/)
            }
            let translation = sender.translationInView(self)
            let currentOrig = curFrameOrigin!
            sbite.frame.origin = CGPointMake(
                currentOrig.x + min(max(translation.x, maxAllowedNegativeTranslation!), maxAllowedPositiveTranslation!),
                currentOrig.y)
            if (sender.state == .Ended) {
                curFrameOrigin = nil
                sender.setTranslation(CGPointZero, inView: self)
                self.reportTimespecChange(sbite)
            }
        }
    }

    
    func handleSoundbiteClipHandleDrag(sender: UIPanGestureRecognizer) {
        if let handle = sender.view {
            if let sb = handle.superview!.superview as? SoundBiteView {
                let translation = sender.translationInView(handle.superview)
                if (sb.moveClippingHandle(handle, deltaX: translation.x, relative: true)) {
                    sender.setTranslation(CGPointZero, inView: handle.superview!)
                }
                if (sender.state == .Ended) {
                    self.reportTimespecChange(sb)
                }
            }
        }
    }


    
    func reportTimespecChange(sbv: SoundBiteView) {
        let sb = sbv.soundbite!
        sb.start = Float(sbv.frame.origin.x) / secWidthInPx
        sb.end = Float(sbv.frame.origin.x + sbv.frame.width) / secWidthInPx
        sb.clipStart = Float(sbv.positionOfLeftClip()) / secWidthInPx
        sb.clipEnd = Float(sbv.positionOfRightClip()) / secWidthInPx
        if let delegate = delegate {
            delegate.soundbiteTimespecDidChange(sb.url, newSpec: sb)
        }
    }
    
    
    func setUpHandleMovementSupport(gest: UIPanGestureRecognizer, handle: UIView) {
        gest.addTarget(self, action: "handleSoundbiteClipHandleDrag:")
        handle.addGestureRecognizer(gest)
        handle.userInteractionEnabled = true
    }
    
    
    
    var sbiteContextOfPopupMenu : SoundBiteView?
    
    func handleSoundbiteLongPress(sender: UILongPressGestureRecognizer) {
        if (sender.state == .Began) {
            if let sbite = sender.view as? SoundBiteView {
                sbiteContextOfPopupMenu = sbite
                KxMenu.showMenuInView(self, fromRect: sbite.frame, menuItems: [
                    // KxMenuItem("Rename", image: nil, target: self, action: "pushMenuItem:"),
                    KxMenuItem("Duplicate", image: nil, target: self, action: "pushMenuItem:"),
                    KxMenuItem("Delete", image: nil, target: self, action: "pushMenuItem:")])
            }
        }
    }
    
    
    func pushMenuItem(sender: KxMenuItem) {
        let commandChosen = sender.title
        switch commandChosen {
        case "Delete":
            if let delegate = delegate {
                delegate.soundbiteDeleteRequested(sbiteContextOfPopupMenu!.soundbite!.url)
            }
        case "Duplicate":
            if let delegate = delegate {
                delegate.soundbiteDuplicateRequested(sbiteContextOfPopupMenu!.soundbite!.url)
            }
        default:
            return
        }
    }
    
    
    



    // Internal methods
    
    var clippedoutPatternImage : UIImage?
    
    override func drawRect(rect: CGRect) {

        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineWidth(context, 5)

        self.clipsToBounds = true
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        let componentsWhite : [CGFloat] = [1.0, 1.0, 1.0, 0.2]
        let componentsDarkGrey : [CGFloat] = [0.1, 0.1, 0.1, 1.0]

        var color = CGColorCreate(colorSpace, componentsDarkGrey)
        CGContextSetFillColorWithColor(context, color)
        CGContextFillRect(context, rect)
        
        color = CGColorCreate(colorSpace, componentsWhite)
        CGContextSetStrokeColorWithColor(context, color)
        
        for i in 0...channelCount {
            let yCoord = (Float(i) * channelHeight)
            CGContextMoveToPoint(context, 0, CGFloat(yCoord))
            CGContextAddLineToPoint(context, 30000, CGFloat(yCoord))
            CGContextStrokePath(context)
        }
        
        // We now want to create an off-screen-image pattern for repeating to use as the background for clipped-out areas of soundbites.
        let diagBandWidth = Double(1.5)
        let spacingFactor = Double(2)

        let patternSize = 30
        let drawSize = CGSize(width: patternSize, height: patternSize)
        
        UIGraphicsBeginImageContextWithOptions(drawSize, false, 0.0)
        let patContext = UIGraphicsGetCurrentContext()

        let x : CGFloat = 0.2
        let componentsTransluc : [CGFloat] = [x, x, x, 0.5]
        CGContextSetStrokeColorWithColor(patContext, CGColorCreate(colorSpace, componentsTransluc))
        
        CGContextSetLineWidth(patContext, CGFloat(diagBandWidth))
        for _i in -18...18 {
            let i = Double(_i)
            CGContextMoveToPoint(patContext, -50, CGFloat(-50 + i*spacingFactor*diagBandWidth))
            CGContextAddLineToPoint(patContext, 300, CGFloat(300 + i*spacingFactor*diagBandWidth))
            CGContextStrokePath(patContext)
        }
        self.clippedoutPatternImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    

}
