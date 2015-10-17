//
//  SoundBiteView.swift
//  SoundEditor
//
//  Created by David Sklar on 9/25/15.
//  Copyright © 2015 David Sklar. All rights reserved.
//

import UIKit

class SoundBiteView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var handleClippingLeft: UIView!
    @IBOutlet weak var leftConstraintForHandleClippingLeft: NSLayoutConstraint!
    
    @IBOutlet weak var handleClippingRight: UIView!
    @IBOutlet weak var leftConstraintForHandleClippingRight: NSLayoutConstraint!
    
    @IBOutlet weak var backgroundForLeftClippedout: UIView!
    @IBOutlet weak var widthConstraintForLeftClippedoutBackground: NSLayoutConstraint!
    
    @IBOutlet weak var backgroundForRightClippedout: UIView!
    @IBOutlet weak var widthConstraintForRightClippedoutBackground: NSLayoutConstraint!
    
    
    var name = "Clip"
    var channelIndex : Int?
    var timespec : Timespec?
    var imageForClippedOutPatterning : UIImage?
    
    @IBOutlet weak var label_Name: UILabel!
    
    
    @IBOutlet weak var nameEditorTextField: UITextField!
    
    @IBAction func handleEditingOfNameDidEnd(sender: AnyObject) {
    }
    
    
    

    func startEditingProcess() {
        nameEditorTextField.text = label_Name.text
        nameEditorTextField.hidden = false
        
    }

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    init(frame: CGRect, colorRectRGB: [CGFloat], colorHandleRGB: [CGFloat], _imageForClippedOutPatterning: UIImage) {
        super.init(frame: frame)
        self.imageForClippedOutPatterning = _imageForClippedOutPatterning
        initSubviews()
        contentView.backgroundColor = UIColor(
            red: colorRectRGB[0]/255,
            green: colorRectRGB[1]/255,
            blue: colorRectRGB[2]/255, alpha: 1.0)
        let bgcolorHandle = UIColor(
            red: colorHandleRGB[0]/255,
            green: colorHandleRGB[1]/255,
            blue: colorHandleRGB[2]/255, alpha: 1.0)
        handleClippingLeft.backgroundColor = bgcolorHandle
        handleClippingRight.backgroundColor = bgcolorHandle
    }
    
    
    func initSubviews() {
        let nib = UINib(nibName: "SoundBite", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        // Position the right-side clipping handle as its initial "x"
        // is based on the width of the soundbite's frame
        leftConstraintForHandleClippingRight.constant = bounds.width - handleClippingRight.bounds.width
        
        backgroundForLeftClippedout.backgroundColor = UIColor(patternImage: imageForClippedOutPatterning!)
        backgroundForRightClippedout.backgroundColor = UIColor(patternImage: imageForClippedOutPatterning!)
        
        handleClippingLeft.layer.borderWidth = 1.5
        handleClippingLeft.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3).CGColor
        
        handleClippingRight.layer.borderWidth = handleClippingLeft.layer.borderWidth
        handleClippingRight.layer.borderColor = handleClippingLeft.layer.borderColor
    }
    
    
    func positionOfLeftClip() -> CGFloat {
        // this is normalized so the position being reported is the LEFT edge of the LEFT clipping handle
        return leftConstraintForHandleClippingLeft.constant
    }
    
    func positionOfRightClip() -> CGFloat {
        // this is normalized so the position being reported is the RIGHT edge of the RIGHT clipping handle
        return leftConstraintForHandleClippingRight.constant + handleClippingRight.bounds.width
    }

    
    
    func moveClippingHandle(whichHandle: UIView, deltaX: CGFloat, relative: Bool) -> Bool {
        let handleWidth = whichHandle.bounds.width
        var curX = CGFloat(0)
        var minX = CGFloat(-99999)
        var maxX = CGFloat(self.frame.width)
        var newX = CGFloat(0)
        var newBgWidth = CGFloat(0)
        
        var whichConstraint : NSLayoutConstraint?
        var whichConstraintForBG : NSLayoutConstraint?
        
        if (whichHandle == handleClippingLeft) {
            whichConstraint = leftConstraintForHandleClippingLeft
            whichConstraintForBG = widthConstraintForLeftClippedoutBackground
            if (relative) {
                curX = leftConstraintForHandleClippingLeft.constant
                minX = CGFloat(0)
                maxX = leftConstraintForHandleClippingRight.constant - handleWidth
            }
            newX = min(max(curX+deltaX, minX), maxX)
            newBgWidth = newX
        } else {
            whichConstraint = leftConstraintForHandleClippingRight
            whichConstraintForBG = widthConstraintForRightClippedoutBackground
            if (relative) {
                curX = leftConstraintForHandleClippingRight.constant
                minX = leftConstraintForHandleClippingLeft.constant + handleWidth
                maxX = self.bounds.width - handleWidth
            }
            newX = min(max(curX+deltaX, minX), maxX)
            newBgWidth = maxX - newX
        }
        
        if (newX != curX) {
            whichConstraint!.constant = newX
            whichConstraintForBG!.constant = newBgWidth
            return true
	       }else{
            return false
        }
    }
    
}
