//
//  Calculator.m
//  Integral Calculator
//
//  Created by Ambassador on 3/1/13.
//  Copyright (c) 2013 Gen. All rights reserved.
//

#import "Calculator.h"

@implementation Calculator

+(NSString *)performOperations:(NSString *)func{
    NSUInteger parLoc;
	
    //HANDLES THE PARENTHESES RECURSIVELY
    while((parLoc = [func rangeOfString:@"(" options:NSBackwardsSearch].location) != NSNotFound){
        NSRange parenRange = NSMakeRange(parLoc + 1, [[func substringFromIndex:parLoc + 1] rangeOfString:@")"].location);
        
        func = [func stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@%@%@",@"(",[func substringWithRange:parenRange],@")"] withString:[Calculator performOperations:[func substringWithRange:parenRange]]];
        
    }
    
    //HANDLE OPERATIONS
    [Calculator handleOperation:@"^" forFunction:&func];
    
    [Calculator handleOperations:@"*" and:@"/" forFunction:&func];
    
    [Calculator handleOperations:@"+" and:@"﹣" forFunction:&func];
    
    return func;
}


//Handles 2 operations simultaneously
+(void)handleOperations:(NSString *)op1 and:(NSString *)op2 forFunction:(NSString **)func{
    
    NSString * beforeNumString;
    NSString * afterNumString;
    location op1Loc, op2Loc;
    
    
    while ((op1Loc = [*func rangeOfString:op1].location) != NSNotFound | (op2Loc = [*func rangeOfString:op2].location) != NSNotFound){
        if(op1Loc == NSNotFound){
            [Calculator handleOperation:op2 forFunction:func];
            return;
        }
        if(op2Loc == NSNotFound){
            [Calculator handleOperation:op1 forFunction:func];
            return;
        }
      
        //Find out which one comes first
        if(op1Loc < op2Loc){
            beforeNumString = [Calculator substringFrom:[Calculator locationOfOperatorClosestToIndex:op1Loc ofOperator:op1 inFunction:*func before:YES]+1 to:op1Loc ofString:*func];
            afterNumString = [Calculator substringFrom:op1Loc+1  to:[Calculator locationOfOperatorClosestToIndex:op1Loc ofOperator:op1 inFunction:*func before:NO] ofString:*func];
            *func = [*func stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@%@%@",beforeNumString,op1,afterNumString] withString:[NSString stringWithFormat:@"%@",[Calculator doOperation:op1 onNumber:beforeNumString andNumber:afterNumString]]];
        }
        else{
            beforeNumString = [Calculator substringFrom:[Calculator locationOfOperatorClosestToIndex:op2Loc ofOperator:op2 inFunction:*func before:YES]+1 to:op2Loc ofString:*func];
            afterNumString = [Calculator substringFrom:op2Loc+1  to:[Calculator locationOfOperatorClosestToIndex:op2Loc ofOperator:op2 inFunction:*func before:NO] ofString:*func];
            *func = [*func stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@%@%@",beforeNumString,op2,afterNumString] withString:[NSString stringWithFormat:@"%@",[Calculator doOperation:op2 onNumber:beforeNumString andNumber:afterNumString]]];
        }
    }
}


//Functional
+(NSString *)substringFrom:(NSUInteger)index to:(NSUInteger)endIndex ofString:(NSString *)string{
    return [string substringWithRange:NSMakeRange(index, endIndex-index)];
}

//Functional most likely
+(location)locationOfOperatorClosestToIndex:(NSUInteger)i ofOperator: (NSString *)op inFunction:(NSString *)func before:(BOOL)b{
    
    NSArray * arr = [Calculator sortedArrayFromArrays:[Calculator locationsOfAllOperatorsExcept:op inFunction:func] and:[Calculator locationsOfString:op inFunction:func]];
    NSMutableArray * mutArr = [arr mutableCopy];
    [mutArr removeObject:[NSString stringWithFormat:@"%lu",(NSUInteger)i]];
    arr = (NSArray *) mutArr;
    NSUInteger loc = -1;
    
    //Look for locations before index
    if(b){
        //If no other operators or no operators before
        if([arr count] == 0 || [[arr objectAtIndex:0] intValue] > i)
            return loc;
        
        //Go through locations returning the first location that comes before the operator's location
        for(NSString * s in arr){
            if([s intValue] > i)
                return loc;
            loc = [s intValue];
        }
        return loc;
        
    }
    
    //After
    //If no other operators or no operators after
    if([arr count] == 0 || i > [[arr objectAtIndex:[arr count]-1] intValue])
        return [func length];
    
    //Go through locations returning the first Location that comes after the operator's location
    for(NSString * s in arr){
        if(i < (loc = [s intValue]))
            return loc;
    }
    
    return [func length];
    
}

//Functional
+(NSString *)doOperation:(NSString *)op onNumber:(NSString *)num1 andNumber:(NSString *)num2{
    double result = 0;
    if([op isEqualToString:@"^"]){
        result = pow([num1 doubleValue],[num2 doubleValue]);
    }
    else if([op isEqualToString:@"*"]){
        result = [num1 doubleValue]*[num2 doubleValue];
    }
    else if([op isEqualToString:@"/"]){
        result = [num1 doubleValue]/[num2 doubleValue];
    }
    else if([op isEqualToString:@"+"]){
        result = [num1 doubleValue]+[num2 doubleValue];
    }
    else if([op isEqualToString:@"﹣"]){
        result = [num1 doubleValue]-[num2 doubleValue];
    }
    
    return [NSString stringWithFormat:@"%.12f",result];
}

//Functional
+(void)handleOperation:(NSString *)op forFunction:(NSString **)func{
    
    NSString * beforeNumString;
    NSString * afterNumString;
    location opLoc;
    
    
    //While there's still an operator
    while ((opLoc = [*func rangeOfString:op].location) != NSNotFound){
        beforeNumString = [Calculator substringFrom:[Calculator locationOfOperatorClosestToIndex:opLoc ofOperator:op inFunction:*func before:YES]+1 to:opLoc ofString:*func];
        afterNumString = [Calculator substringFrom:opLoc+1  to:[Calculator locationOfOperatorClosestToIndex:opLoc ofOperator:op inFunction:*func before:NO] ofString:*func];
        *func = [*func stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@%@%@",beforeNumString,op,afterNumString] withString:[NSString stringWithFormat:@"%@",[Calculator doOperation:op onNumber:beforeNumString andNumber:afterNumString]]];
    }
    
}

//Functional
+(locations)sortedArrayFromArrays:(NSArray *)arr1 and:(NSArray *)arr2{
    
    arr1 = [arr1 arrayByAddingObjectsFromArray:arr2];
    arr1 = [arr1 sortedArrayUsingComparator:^NSComparisonResult(NSString * obj1, NSString * obj2) {
        NSUInteger val1 = [obj1 intValue];
        NSUInteger val2 = [obj2 intValue];
        if(val1 < val2)
            return NSOrderedAscending;
        if(val1 > val2)
            return NSOrderedDescending;
        return NSOrderedAscending;
    }];
    
    return arr1;
}

//Functional
+(locations)locationsOfAllOperatorsExcept:(NSString *)op inFunction:(NSString *)func{
    locations locArray = [[NSArray alloc] init];
    NSArray * opArray = [[NSArray alloc] initWithObjects:@"^",@"*",@"/",@"+",@"﹣",nil];
    
    for(NSString * s in opArray){
        if(![op isEqualToString:s]){
            locArray = [locArray arrayByAddingObjectsFromArray:[Calculator locationsOfString:s inFunction:func]];
        }
    }
    
    locArray = [locArray sortedArrayUsingComparator:^NSComparisonResult(NSString * obj1, NSString * obj2) {
        NSUInteger val1 = [obj1 intValue];
        NSUInteger val2 = [obj2 intValue];
        if(val1 < val2)
            return NSOrderedAscending;
        if(val1 > val2)
            return NSOrderedDescending;
        return NSOrderedAscending;
    }];
    return locArray;
}

//Functional
+(locations)locationsOfAllOperatorsExcept:(NSString *)op1 and:(NSString *)op2 inFunction:(NSString *)func{
    locations locArray = [[NSArray alloc] init];
    NSArray * opArray = [[NSArray alloc] initWithObjects:@"^",@"*",@"/",@"+",@"-",nil];
    
    for(NSString * s in opArray){
        if(![op1 isEqualToString:s] && ![op2 isEqualToString:s]){
            locArray = [locArray arrayByAddingObjectsFromArray:[Calculator locationsOfString:s inFunction:func]];
        }
    }
    
    locArray = [locArray sortedArrayUsingComparator:^NSComparisonResult(NSString * obj1, NSString * obj2) {
        NSUInteger val1 = [obj1 intValue];
        NSUInteger val2 = [obj2 intValue];
        if(val1 < val2)
            return NSOrderedAscending;
        if(val1 > val2)
            return NSOrderedDescending;
        return NSOrderedAscending;
    }];
    
    return locArray;
    
}


//FUNCTIONAL
+(locations)locationsOfString:(NSString *)aString inFunction:(NSString *)func{
    if([func rangeOfString:aString].location == NSNotFound)
        return nil;
    NSString * someString = [Calculator parseFunction:func forLocationsOfString:aString displacement:0];
    
    return [[someString substringToIndex:[someString length]-1] componentsSeparatedByString:@"/"];
}

//FUNCTIONAL
//Returns the locations of parens as a String
+(NSString *)parseFunction:(NSString *)func forLocationsOfString:(NSString *)aString displacement:(NSUInteger)disp{
    
    NSUInteger stringLoc = [func rangeOfString:aString].location;
    if(stringLoc == NSNotFound)
        return @"";
	
    NSString * num = [[NSString alloc] initWithFormat:@"%lu/",disp+stringLoc];
    
    return [num stringByAppendingString:[NSString stringWithFormat:@"%@",[Calculator parseFunction:[func substringFromIndex:stringLoc+1] forLocationsOfString:aString displacement:disp+stringLoc+1]]];
}






/////////////////////////////////////////////////////
//--------------------NEW SECTION--------------------
/////////////////////////////////////////////////////

+(long long)factorial:(int)n{
    if(n == 0)
        return 1;
    return n*[Calculator factorial:n-1];
}

+(NSString *)invNorm:(double)d{
    double P_LOW  = 0.02425;
    double P_HIGH = 1.0 - P_LOW;
    
    // Coefficients in rational approximations.
    double ICDF_A[] =
    { -3.969683028665376e+01,  2.209460984245205e+02,
        -2.759285104469687e+02,  1.383577518672690e+02,
        -3.066479806614716e+01,  2.506628277459239e+00 };
    
    double ICDF_B[] =
    { -5.447609879822406e+01,  1.615858368580409e+02,
        -1.556989798598866e+02,  6.680131188771972e+01,
        -1.328068155288572e+01 };
    
    double ICDF_C[] =
    { -7.784894002430293e-03, -3.223964580411365e-01,
        -2.400758277161838e+00, -2.549732539343734e+00,
        4.374664141464968e+00,  2.938163982698783e+00 };
    
    double ICDF_D[] =
    { 7.784695709041462e-03,  3.224671290700398e-01,
        2.445134137142996e+00,  3.754408661907416e+00 };
    
    
    // Define break-points.
    // variable for result
    double z = 0;
    
    if(d == 0) return [NSString stringWithFormat:@"%d",10^100];
    else if(d == 1) return [NSString stringWithFormat:@"%d",10^-100];
    else if(isnan(d) || d < 0 || d > 1) z = NAN;
    
    // Rational approximation for lower region:
    else if( d < P_LOW )
    {
        double q  = sqrt(-2*log(d));
        z = (((((ICDF_C[0]*q+ICDF_C[1])*q+ICDF_C[2])*q+ICDF_C[3])*q+ICDF_C[4])*q+ICDF_C[5]) / ((((ICDF_D[0]*q+ICDF_D[1])*q+ICDF_D[2])*q+ICDF_D[3])*q+1);
    }
    
    // Rational approximation for upper region:
    else if ( P_HIGH < d )
    {
        double q  = sqrt(-2*log(1-d));
        z = -(((((ICDF_C[0]*q+ICDF_C[1])*q+ICDF_C[2])*q+ICDF_C[3])*q+ICDF_C[4])*q+ICDF_C[5]) / ((((ICDF_D[0]*q+ICDF_D[1])*q+ICDF_D[2])*q+ICDF_D[3])*q+1);
    }
    // Rational approximation for central region:
    else
    {
        double q = d - 0.5;
        double r = q * q;
        z = (((((ICDF_A[0]*r+ICDF_A[1])*r+ICDF_A[2])*r+ICDF_A[3])*r+ICDF_A[4])*r+ICDF_A[5])*q / (((((ICDF_B[0]*r+ICDF_B[1])*r+ICDF_B[2])*r+ICDF_B[3])*r+ICDF_B[4])*r+1);
    }
    
    if( d > 0 && d < 1)
    {
        double e = 0.5 * erfc(-z/sqrt(2.0)) - d;
        double u = e * sqrt(2.0*3.1415926535897932384626433832795028841971)*exp((z*z)/2.0);
        z = z - u/(1.0 + z*u/2.0);
    }
    
    
    return [NSString stringWithFormat:@"%f",z];
}

/*
+(NSString*)powerRule:(NSString*)func{
    double coeff = [[func substringToIndex:[func rangeOfString:@"x"].location] doubleValue];
    double power = [[func substringFromIndex:[func rangeOfString:@"^"].location + 1] doubleValue];
    
    NSString* powerRuleString = [NSString stringWithFormat:@"%.3fx^%.2f",coeff*power,power-1];
    return powerRuleString;
} */

@end
