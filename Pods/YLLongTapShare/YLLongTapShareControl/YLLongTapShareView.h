//
//  YLLongTapShareView.h
//  YLLongTapShareControlDemo
//
//  Created by Yong Li on 7/22/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLShareView.h"

@interface YLLongTapShareView : UIView

@property (nonatomic, weak) id<YLLongTapShareDelegate> delegate;

- (void)addShareItem:(YLShareItem*)item;

@end

