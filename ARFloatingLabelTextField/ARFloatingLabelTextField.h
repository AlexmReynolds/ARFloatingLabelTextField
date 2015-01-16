//
//  CYCFloatingLabelTextField.h
//  Househappy
//
//  Created by Alex Reynolds on 12/19/14.
//  Copyright (c) 2014 House Happy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, ARLabelAnimationStyle) {
    CYCLabelAnimationStyleNone = 0,
    CYCLabelAnimationStyleFade = 1 << 0,
    CYCLabelAnimationStyleMove  = 1 << 1,
};


@interface ARFloatingLabelTextField : UITextField

@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic) UIEdgeInsets insets;

@property (nonatomic) CGFloat labelScale;
@property (nonatomic) ARLabelAnimationStyle animationStyle;


@end
