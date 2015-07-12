//
//  ViewController.m
//  Calculator App
//
//  Created by Ambassador on 3/2/13.
//  Copyright (c) 2013 Gen. All rights reserved.
//

#import "ViewController.h"
#import "Calculator.h"
@interface ViewController ()
-(IBAction)enterButtonPressed:(id)sender;
-(IBAction)appendText:(id)sender;
-(IBAction)backspace:(id)sender;
-(IBAction)clear:(id)sender;
-(IBAction)invNorm:(id)sender;
@end

@implementation ViewController
@synthesize label,button,clearButton,backspaceButton;


-(void)enterButtonPressed:(id)sender{
    NSLog(@"Enter Button Pressed");
    NSString * labText;
    
    //If there's nothing in the label, set text to the last answer.
    if([(labText = [label text]) isEqualToString:@""]){
        [label setText:ans];
        return;
    }
    
    //Perform operations on the label text.
    labText = [Calculator performOperations:labText];
    
    
    //Chop off the excess 0's.
    while([labText hasSuffix:@"0"]){
        labText = [labText substringToIndex:[labText length] - 1];
    }
    
    //If there's a . at the end, take it out.
    NSUInteger len;
    if([[labText substringFromIndex:(len=[labText length])-1] isEqualToString:@"."])
        labText = [labText substringToIndex:len-1];
    
    //Set the label to the result.
    [label setText:(ans = labText)];
    
    //This value is now the result.
    isResult = YES;
}

-(void)appendText:(id)sender{
    //If it was just cleared, append the necessary text
    if(isCleared){
        isCleared = NO;
        isResult = NO;
        [label setText:[((UIButton *)sender) currentTitle]];
        return;
    }
    
    NSString * title;
    
    //If it's the result,
    if(isResult){
        isResult = NO;
        
        //If it's a number, add a * before it.
        [label setText:(ans = [[label text] stringByAppendingString:[self isDigit:(title=[((UIButton *) sender) currentTitle])] ? [@"*" stringByAppendingString:title] : [title isEqualToString:@"ans"] ? [@"*" stringByAppendingString:ans] : title])];
        return;
    }
    
    [label setText:[[label text] stringByAppendingString:(![ (title=[((UIButton *)sender) currentTitle]) isEqualToString:@"ans"]) ? title : ans]];
    NSLog(@"Appended text");
}

-(void)backspace:(id)sender{
    isResult = NO;
    NSString * labText;
    NSUInteger len;
    if((len = [(labText = [label text]) length]) == 0) //If nothing to backspace
        return;
    if([self hasTrigAtEnd:labText]){  //If it's a trig function
        [label setText:[labText substringFromIndex:len-3]];
    }
    else{//If it's not a special case
        [label setText:[labText substringToIndex:len-1]];
    }
    NSLog(@"Backspaced");
}

-(BOOL)hasTrigAtEnd:(NSString *)labText{
    NSUInteger len;
    if((len = [labText length]) < 3){
        return NO;
    }
    
    NSString * sub = [labText substringFromIndex:len-3];
    for(NSString * trig in trigFuncs){
        if([sub isEqualToString:trig]){
            return YES;
        }
    }
    return NO;
}
-(void)clear:(id)sender{
    NSLog(@"Cleared");
    [label setText:@"0.0000"];
    isResult = YES;
    isCleared = YES;
    
}

-(void)invNorm:(id)sender{
    NSLog(@"InvNorm");
    [label setText:[Calculator invNorm:[[label text] doubleValue]]];
}

-(BOOL)isDigit:(NSString *)s{
    NSArray * nums = [[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", nil];
    
    for(int i = 0; i < 10; i++){
        if([s isEqualToString:[nums objectAtIndex:i]]) return YES;
    }
    
    return NO;
}
- (void)viewDidLoad{
    NSLog(@"View did load");
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    isResult = YES;
    ans = @"0";
    
    trigFuncs = [[NSArray alloc] initWithObjects:@"sin",@"cos",@"tan",@"sec",@"csc",@"cot", nil];
}


/*- (void)didReceiveMemoryWarning{
 [super didReceiveMemoryWarning];
 // Dispose of any resources that can be recreated.
 }*/

@end
