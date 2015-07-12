//
//  Calculator.h
//  Integral Calculator
//
//  Created by Ambassador on 3/1/13.
//  Copyright (c) 2013 Gen. All rights reserved.
//
#import <Foundation/Foundation.h>
typedef NSArray * locations;
typedef NSInteger location;

@interface Calculator : NSObject

+(NSString *)invNorm:(double)d;
+(NSString *)doOperation:(NSString *)op onNumber:(NSString *)num1 andNumber:(NSString *)num2;

+(NSString *)performOperations:(NSString*)labelText;
+(locations)locationsOfString:(NSString *)aString inFunction:(NSString *)func;

+(NSString *)parseFunction:(NSString *)func forLocationsOfString:(NSString *)aString displacement:(NSUInteger)disp;

+(void)handleOperation:(NSString *)op forFunction:(NSString **)func;
+(void)handleOperations:(NSString *)op1 and:(NSString *)op2 forFunction:(NSString **)func;
+(locations)locationsOfAllOperatorsExcept:(NSString *)op1 and:(NSString *)op2 inFunction:(NSString *)func;
+(locations)locationsOfAllOperatorsExcept:(NSString *)op inFunction:(NSString *)func;
+(locations)sortedArrayFromArrays:(NSArray *)arr1 and:(NSArray *)arr2;
+(location)locationOfOperatorClosestToIndex:(NSUInteger)i ofOperator:(NSString *)op inFunction:(NSString *)func before:(BOOL)b;
+(long long)factorial:(int)n;
@end