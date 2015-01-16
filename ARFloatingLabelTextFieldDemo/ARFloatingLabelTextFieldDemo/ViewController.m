//
//  ViewController.m
//  ARFloatingLabelTextFieldDemo
//
//  Created by Alex Reynolds on 1/14/15.
//  Copyright (c) 2015 Alex Reynolds. All rights reserved.
//

#import "ViewController.h"
#import "ARFloatingLabelTextField.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *placeholderText;
@property (weak, nonatomic) IBOutlet UITextField *tintRed;
@property (weak, nonatomic) IBOutlet UITextField *tintGreen;
@property (weak, nonatomic) IBOutlet UITextField *tintBlue;
@property (weak, nonatomic) IBOutlet ARFloatingLabelTextField *demoField;
@property (weak, nonatomic) IBOutlet UITextField *placeholderGreen;
@property (weak, nonatomic) IBOutlet UITextField *placeholderRed;

@property (weak, nonatomic) IBOutlet UITextField *placeholderBlue;
@property (weak, nonatomic) IBOutlet UITextField *labelScale;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.demoField.placeholder = self.placeholderText.text;
    self.demoField.insets = UIEdgeInsetsMake(10, 10, 10, 10);
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)updatePressed:(id)sender {
    self.demoField.placeholder = self.placeholderText.text;
    
    CGFloat red = [self.tintRed.text floatValue];
    CGFloat green = [self.tintGreen.text floatValue];
    CGFloat blue = [self.tintBlue.text floatValue];
    
    UIColor *tint = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
    self.demoField.tintColor = tint;
    
    
    CGFloat pRed = [self.placeholderRed.text floatValue];
    CGFloat pGreen = [self.placeholderGreen.text floatValue];
    CGFloat pBlue = [self.placeholderBlue.text floatValue];
    
    UIColor *placeholderColor = [UIColor colorWithRed:pRed/255.0 green:pGreen/255.0 blue:pBlue/255.0 alpha:1.0];
    self.demoField.placeholderColor = placeholderColor;
    if(self.demoField.labelScale != [self.labelScale.text doubleValue]){
        self.demoField.labelScale = [self.labelScale.text doubleValue];
        self.demoField.text = nil;
        [self.demoField resignFirstResponder];
    }
}

@end
