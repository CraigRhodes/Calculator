//
//  Calculator_AppTests.m
//  Calculator AppTests
//
//  Created by Ambassador on 3/2/13.
//  Copyright (c) 2013 Gen. All rights reserved.
//

#import "Calculator_AppTests.h"
#import "Calculator.h"
#import "Constants.h"

@implementation Calculator_AppTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

#pragma mark - Calculator Tests
// IMPORTANT TEST - This tests the core functionality of the calculator.
- (void)testPerformOperations{
    
    XCTAssertEqual([[Calculator performOperations:@"10"] intValue], 10, @"");
    
    //Test the basic operations individually
    XCTAssertEqual([[Calculator performOperations:@"6+4"] intValue], 10, @"");
	
    str = [NSString stringWithFormat:@"%d%@%d",6,m,4]; //Note that m is a way of keeping subtraction separate from minus.
    XCTAssertEqual([[Calculator performOperations:str] intValue], 2, @"");
    
    XCTAssertEqualWithAccuracy([[Calculator performOperations:@"10*4"] doubleValue], 40.0, 0.0000000000001, @"");
    XCTAssertEqualWithAccuracy([[Calculator performOperations:@"10/4"] doubleValue], 2.5, 0.0000000000001, @"");
    
    //Test multiple of similar operations
    str = [NSString stringWithFormat:@"5+3%@2",m];
    XCTAssertEqual([[Calculator performOperations:str] intValue], 6, @"");
    
    //Test parentheses
    XCTAssertEqual([[Calculator performOperations:@"(6+4)"] intValue], 10, @"");
    str = [NSString stringWithFormat:@"5+(6%@4)",m];
    XCTAssertEqual([[Calculator performOperations:str] intValue], 7, @"");
    str = [NSString stringWithFormat:@"5+(6%@4)/(2+3)",m];
    XCTAssertEqual([[Calculator performOperations:str] doubleValue], 5.4, @"");
    
    //Test large expressions
    str = [NSString stringWithFormat:@"((5+2)/(2%@3+8)*8+9/2)/3.2",m];
    XCTAssertEqual([[Calculator performOperations:str] doubleValue], 3.90625, @"");
    str = [NSString stringWithFormat:@"((9^3)*7)^2/(265%@8)*(4*(2%@1*4))",m,m];
    XCTAssertEqualWithAccuracy([[Calculator performOperations:str] doubleValue], -810602.614786, 0.000001, @"");
    str = [NSString stringWithFormat:@"((9^3)*2*7)^1/(265%@2)*(4*7*(2%@1*4))",m,m];
    XCTAssertEqualWithAccuracy([[Calculator performOperations:str] doubleValue], -2173.14068441, 0.000001, @"");
     
     
    
}

- (void)testInvNorm{
    //Test different values of invNorm
    XCTAssertEqualWithAccuracy([[Calculator invNorm:0.1] doubleValue], -1.281551567, 0.000001,@"");
    XCTAssertEqualWithAccuracy([[Calculator invNorm:0.2] doubleValue], -0.8416212335, 0.000001,@"");
    XCTAssertEqualWithAccuracy([[Calculator invNorm:0.3] doubleValue], -0.5244005101, 0.000001,@"");
    XCTAssertEqualWithAccuracy([[Calculator invNorm:0.4] doubleValue], -0.2533471011, 0.000001,@"");
    XCTAssertEqualWithAccuracy([[Calculator invNorm:0.5] doubleValue], 0.000000, 0.000001,@"");
    XCTAssertEqualWithAccuracy([[Calculator invNorm:0.6] doubleValue], 0.2533471011, 0.000001,@"");
    XCTAssertEqualWithAccuracy([[Calculator invNorm:0.7] doubleValue], 0.5244005101, 0.000001,@"");
    XCTAssertEqualWithAccuracy([[Calculator invNorm:0.8] doubleValue], 0.8416212335, 0.000001,@"");
    XCTAssertEqualWithAccuracy([[Calculator invNorm:0.9] doubleValue], 1.281551567, 0.000001,@"");
}

- (void)testDoOperationOnNumberAndNumber{
    //Test on basic operations
    XCTAssertEqual([[Calculator doOperation:@"+" onNumber:@"57" andNumber:@"44"] intValue], 101);
    XCTAssertEqual([[Calculator doOperation:m onNumber:@"34" andNumber:@"11"] intValue], 23);
    XCTAssertEqual([[Calculator doOperation:@"*" onNumber:@"22" andNumber:@"3"] intValue], 66);
    XCTAssertEqual([[Calculator doOperation:@"/" onNumber:@"60" andNumber:@"4"] intValue], 15);
    XCTAssertEqual([[Calculator doOperation:@"^" onNumber:@"10" andNumber:@"3"] intValue], 1000);
    
    //Test divide by zero
    XCTAssertEqual([[Calculator doOperation:@"/" onNumber:@"5" andNumber:@"0"] intValue],0, @"");
}

- (void)testLocationsOfStringInFunction
{
    //Test random function
    NSArray * arr = [[NSArray alloc] initWithObjects:@"5", @"7", nil];
    XCTAssertEqualObjects([Calculator locationsOfString:@"/" inFunction:@"5+3-2/5/7"], arr);
    
    //Test when all are locations
    arr = [[NSArray alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", nil];
    XCTAssertEqualObjects([Calculator locationsOfString:@"-" inFunction:@"------"], arr);
    
    //Test when none are locations
    XCTAssertNil([Calculator locationsOfString:@"+" inFunction:@""]);
}

-(void)testParseFunctionForLocationsOfStringDisplacement{
    
}

-(void)testHandleOperationForFunction{
    
}
-(void)testHandleOperationsAndForFunction{
    
}
-(void)testLocationsOfAllOperatorsExceptAndInFunction{
    
}
-(void)testLocationsOfAllOperatorsExceptInFunction{
    
}
-(void)testSortedArrayFromArraysAnd{
    
}
-(void)testLocationOfOperatorClosestToIndexOfOperatorInFunctionBefore{
   // STAssertEqualObjects([Calculator locationOfOperatorClosestToIndex:0 ofOperator:@"+" inFunction:@"-" before:YES], 0, nil);
}
-(void)testFactorial{
    XCTAssertEqual((int)[Calculator factorial:5], 120);
}

@end