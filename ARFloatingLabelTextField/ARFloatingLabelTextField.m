//
//  CYCFloatingLabelTextField.m
//  Househappy
//
//  Created by Alex Reynolds on 12/19/14.
//  Copyright (c) 2014 House Happy. All rights reserved.
//

#import "ARFloatingLabelTextField.h"

@interface ARFloatingLabelTextField ()
@property (nonatomic, strong) CATextLayer *textLayer;
@property (nonatomic, strong) NSLayoutConstraint *labelBottom;
@end


static CGFloat kAnimationTime = 0.4;
static CGFloat kDefaultScale = 0.6;
static UIEdgeInsets kDefaulInsets;
static UIColor *kDefaultPlaceholderColor;

@implementation ARFloatingLabelTextField{
    BOOL _labelIsUp;
    BOOL _isAnimating;
}

+ (void)initialize
{
    kDefaulInsets = UIEdgeInsetsMake(4, 4, 4, 4);
    kDefaultPlaceholderColor = [UIColor lightGrayColor];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initialSetup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initialSetup];
    }
    return self;
}

- (void)initialSetup
{
    self.labelScale = kDefaultScale;
    self.insets = kDefaulInsets;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    self.placeholderColor = kDefaultPlaceholderColor;
    [[self layer] addSublayer:self.textLayer];
    
    if(self.text.length){
        _labelIsUp = YES;
        self.textLayer.transform = [self labelPositionTransform];
    }
    if(self.placeholder){
        self.placeholder = self.placeholder;
        [super setPlaceholder:nil];

    }
    [self registerForNotifications];

}

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangeText)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didEndEditing)
                                                 name:UITextFieldTextDidEndEditingNotification
                                               object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBeginEditing)
                                                 name:UITextFieldTextDidBeginEditingNotification
                                               object:self];
}

#pragma mark - Getters

- (CATextLayer *)textLayer
{
    if(_textLayer == nil){
        CATextLayer *textLayer = [CATextLayer layer];
        [textLayer setString:@"Hello World"];
        [textLayer setForegroundColor:self.placeholderColor.CGColor];
        [textLayer setFontSize:self.font.pointSize];
        CGFontRef font = CGFontCreateWithFontName((CFStringRef)self.font.fontName);
        textLayer.font = font;
        CGFontRelease(font);
        textLayer.shouldRasterize = NO;
        textLayer.anchorPoint = CGPointMake(0, 0.5);
        textLayer.contentsScale = [[UIScreen mainScreen] scale];
        
        [textLayer setFrame:[self baseFrameForTextLayer]];
        _textLayer = textLayer;
    }
    return _textLayer;
}

#pragma mark - Setters

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self.textLayer setFontSize:self.font.pointSize];
    
    CGFontRef fontRed = CGFontCreateWithFontName((CFStringRef)self.font.fontName);
    self.textLayer.font = fontRed;
    CGFontRelease(fontRed);
}

- (void)setPlaceholder:(NSString *)placeholder
{
    self.textLayer.string = placeholder;
}

- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    if(_labelIsUp && self.isFirstResponder)
        self.textLayer.foregroundColor = tintColor.CGColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    if(!self.isFirstResponder)
        self.textLayer.foregroundColor = _placeholderColor.CGColor;
}

- (void)setLabelScale:(CGFloat)labelScale
{
    _labelScale = labelScale;
    [self invalidateIntrinsicContentSize];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Text Change Notifications
- (void)didChangeText
{
    if(self.text.length && !_labelIsUp){
        _labelIsUp = YES;
        [self animateTextLayerUp];
    }
}

- (void)didBeginEditing
{
    if(self.text.length && _labelIsUp){
        [self animateTextLayerChangeColor:self.tintColor];
    }
}

- (void)didEndEditing
{
    if(self.text.length && _labelIsUp){
        [self animateTextLayerChangeColor:self.placeholderColor];
    }else if(self.text.length == 0 && _labelIsUp) {
        _labelIsUp = NO;
        [self animateTextLayerDown];
    }
}

#pragma mark - Helpers

- (CGRect)baseFrameForTextLayer
{
    CGFloat offset = [self sizeOfText:@"one line" forFont:self.font].height;

    return CGRectMake(self.insets.left, self.bounds.size.height - offset - self.insets.bottom, self.bounds.size.width, offset);
}

- (CGSize)sizeOfText:(NSString*)text forFont:(UIFont*)font{
    CGFloat hotizontalPadding = 127;
    NSString *stringToMeasure = text ?: @"foobar";
    CGFloat desiredWidth = [UIScreen mainScreen].bounds.size.width - hotizontalPadding;
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:stringToMeasure attributes:@{NSFontAttributeName: font}];
    
    UILabel *label = [[UILabel alloc] init];
    
    label.attributedText = attributedText;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [label sizeThatFits:CGSizeMake(desiredWidth, CGFLOAT_MAX)];
    
    font = nil;
    attributedText = nil;
    
    return size;
}

- (BOOL)textLayerNeedsLayoutForLabelPosition
{
    CGRect labelFrame = [self baseFrameForTextLayer];
    return _labelIsUp && (!CATransform3DEqualToTransform(self.textLayer.transform, [self labelPositionTransform]) || !CGRectEqualToRect(labelFrame, self.textLayer.frame));
}

- (BOOL)textLayerNeedsLayoutForPlaceholderPosition
{
    CGRect labelFrame = [self baseFrameForTextLayer];
    return !_labelIsUp && (!CATransform3DEqualToTransform(self.textLayer.transform, [self placeHolderPositionTransform]) || !CGRectEqualToRect(labelFrame, self.textLayer.frame));
}

#pragma mark - Method Overrides

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize textSize = [self sizeOfText:self.text forFont:self.font];
    CGSize placeholderSize = [self sizeOfText:self.placeholder forFont:self.font];
    
    CGFloat width = MAX(textSize.width, placeholderSize.width);
    CGFloat height = MAX(textSize.height, placeholderSize.height) * (1 + self.labelScale);
    
    return CGSizeMake(width, height);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect labelFrame = [self baseFrameForTextLayer];
    if(!_isAnimating){
        if([self textLayerNeedsLayoutForLabelPosition]){
            self.textLayer.transform = [self placeHolderPositionTransform];
            [self.textLayer setFrame:labelFrame];
            self.textLayer.transform = [self labelPositionTransform];
        }else if([self textLayerNeedsLayoutForPlaceholderPosition]){
            self.textLayer.transform = [self placeHolderPositionTransform];
            [self.textLayer setFrame:labelFrame];
        }
    }
}

- (CGSize)intrinsicContentSize
{
    CGSize textSize = [self sizeOfText:self.text forFont:self.font];
    CGSize placeholderSize = [self sizeOfText:self.placeholder forFont:self.font];
    
    CGFloat width = MAX(textSize.width, placeholderSize.width) + self.insets.left + self.insets.right;
    CGFloat height = MAX(textSize.height, placeholderSize.height) * (1 + self.labelScale) + self.insets.top + self.insets.bottom;
    
    return CGSizeMake(width, height);
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return  UIEdgeInsetsInsetRect(bounds, self.insets);

}
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return  UIEdgeInsetsInsetRect(bounds, self.insets);
}


#pragma mark - Animation Methods

- (CATransform3D)placeHolderPositionTransform
{
    return CATransform3DIdentity;
}

- (CATransform3D)labelPositionTransform
{
    CGFloat heightOfTextfield = [self sizeOfText:@"one line" forFont:self.font].height;
    CATransform3D translate = CATransform3DTranslate(CATransform3DIdentity, 0, - (heightOfTextfield + 4), 0);
    CATransform3D scale = CATransform3DScale(CATransform3DIdentity, self.labelScale, self.labelScale, 1);
    return CATransform3DConcat(translate, scale);
}

-(void)animateTextLayerUp {
    NSArray *scaleValues = @[[NSValue valueWithCATransform3D:[self placeHolderPositionTransform]],
                            [NSValue valueWithCATransform3D:[self labelPositionTransform]]];
    
    [self animateTextTransformValuesArray:scaleValues];
    [self animateTextLayerChangeColor:self.tintColor];
}

-(void)animateTextLayerDown {
    NSArray *scaleValues = @[[NSValue valueWithCATransform3D:[self labelPositionTransform]],
                            [NSValue valueWithCATransform3D:[self placeHolderPositionTransform]]];
    
    [self animateTextTransformValuesArray:scaleValues];
    [self animateTextLayerChangeColor:self.placeholderColor];

}

- (void)animateTextTransformValuesArray:(NSArray*)array
{
    _isAnimating = YES;
    [self.textLayer removeAllAnimations];
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{

        self->_isAnimating = NO;
        self.textLayer.transform = [[array lastObject] CATransform3DValue];
        [self.textLayer removeAllAnimations];


    }];
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation
                                           animationWithKeyPath:@"transform"];
    [scaleAnimation setValues:array];
    scaleAnimation.duration = kAnimationTime;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.timingFunction = [CAMediaTimingFunction
                                     functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.textLayer addAnimation:scaleAnimation forKey:@"animateScale"];
    
    [CATransaction commit];
}

-(void)animateTextLayerChangeColor:(UIColor *)color {
    [UIView animateWithDuration:kAnimationTime animations:^{
        self.textLayer.foregroundColor = color.CGColor;
    }];
}

@end
