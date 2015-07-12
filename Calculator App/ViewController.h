//
//  ViewController.h
//  Calculator App
//
//  Created by Ambassador on 3/2/13.
//  Copyright (c) 2013 Gen. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(unsigned char, buttonID){
    numb, //Number
    leftP, //Left Paren - (
    rightP, //Right Paren - )
    op, //Operator
    func //Function
};

@interface ViewController : UIViewController{
    IBOutletCollection(UIButton) NSArray * numberBtns;
    IBOutletCollection(UIButton) NSArray * operatorBtns;
    BOOL isResult,isCleared;
    NSString * ans;
    NSArray * trigFuncs;
    NSArray * components;
    unsigned char lastSeen;
}



@property(weak, nonatomic) IBOutlet UIButton* backspaceButton;
@property(weak, nonatomic) IBOutlet UIButton* button;
@property(weak, nonatomic) IBOutlet UIButton* clearButton;
@property(weak, nonatomic) IBOutlet UIButton* normButton;
@property(weak, nonatomic) IBOutlet UITextView* label;

@end
