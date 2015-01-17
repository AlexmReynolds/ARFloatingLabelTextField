//
//  CYCFloatingLabelTextField.h
//  Househappy
//
//  Created by Alex Reynolds on 12/19/14.
//  Copyright (c) 2014 House Happy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARFloatingLabelTextField : UITextField

/*!
 Color to use when place holder text is used.
 
 @note when the text field @c isFirstResponder the @c tintColor is used.
 */
@property (nonatomic, strong) UIColor *placeholderColor;

/*!
 Edge insets to use on the text field.
 
 @note Default is @code UIEdgeInsetsMake(4, 4, 4, 4); @endcode
 */
@property (nonatomic) UIEdgeInsets insets;

/*!
 Scale to use when animating placeholder text into its floating position.
 
 @note This begins to break down at larger numbers.
 */
@property (nonatomic) CGFloat labelScale;

@end
