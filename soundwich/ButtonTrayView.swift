//
//  ButtonTrayView.swift
//  soundwich
//
//  Created by Matt Hayes on 10/19/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//

import UIKit

class ButtonTrayView: UIView {

    var recordButton = UIButton()
    var recordButtonImage = UIImage(named: "Record Button")

    override func didMoveToSuperview() {
        backgroundColor = UIColor(white: 44.0/255.0, alpha: 1.0)
        print("\n", frame, "\n")

        recordButton.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        recordButton.setImage(
            recordButtonImage,
            forState: UIControlState.Normal
        )

        addSubview(recordButton)
    }

//    override func drawRect(rect: CGRect) {
//    }

}
