//
//  ColorTheme.swift
//  soundwich
//
//  Created by Tommy Chheng on 10/20/15.
//  Copyright © 2015 Tommy Chheng. All rights reserved.
//


class ColorTheme {
    /*
    Track 1 - Red:                  #EA321A,    rgb(234, 50, 26)
    Track 2 - Magenta:              #D81F93,    rgb(216, 31, 147)
    Track 3 - Violet:               #C333FF,    rgb(195, 51, 255)
    Track 4 - Indigo:               #9E91FF,    rgb(158, 145, 255)
    Track 5 - Ocean:                #40BED2,    rgb(64 , 190, 210)
    Track 6 - Parakeet:             #05D667,    rgb(5 G,214, 103)
    Track 7 - Unrippened Banana:    #B1DB1F,    rgb(177, 219, 31)
    Track 8 - Dreamsicle:           #F8AB18,    rgb(248, 171, 24)
    */
    
    // Colors assigned to each channel
    static let colorRectPalette : [ [CGFloat] ] = [
        [ 234, 50, 26 ],
        [ 216, 31, 147 ],
        [ 195, 51, 255 ],
        [ 158, 145, 255 ],
        [ 64, 190, 210 ],
        [ 5, 214, 103 ],
        [ 177, 219, 31 ],
        [ 248, 171, 24 ]
    ]
    
    static let colorHandlePalette: [ [CGFloat] ] = [
        [ 239, 121, 63],
        [ 243, 133, 154],
        [ 237, 153, 255],
        [ 229, 216, 255],
        [ 173, 229, 212],
        [ 115, 239, 113],
        [ 232, 241, 36],
        [ 253, 222, 33]
    ]
    
}