//
//  PFMarginCoefficient.h
//  ProFinanceApi
//
//  Created by VitaliyK on 14.04.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//
#import "../PFTypes.h"
#import "Detail/PFObject.h"
#import <Foundation/Foundation.h>

@protocol PFMarginCoefficient <NSObject>

-(PFByte)expDay;
-(PFByte)expMonth;
-(PFShort)expYear;
-(PFDouble)initMarginCallSize;
-(PFDouble)holdMarginCallSize;
-(PFDouble)initMarginCallSizeShort;
-(PFDouble)holdMarginCallSizeShort;
-(PFDouble)initMarginCallSizeOvernight;
-(PFDouble)holdMarginCallSizeOvernight;
-(PFDouble)initMarginCallSizeOvernightShort;
-(PFDouble)holdMarginCallSizeOvernightShort;

@end

@interface PFMarginCoefficient : PFObject< PFMarginCoefficient >

@property (nonatomic, assign) PFByte expDay;
@property (nonatomic, assign) PFByte expMonth;
@property (nonatomic, assign) PFShort expYear;
@property (nonatomic, assign) PFDouble initMarginCallSize;
@property (nonatomic, assign) PFDouble holdMarginCallSize;
@property (nonatomic, assign) PFDouble initMarginCallSizeShort;
@property (nonatomic, assign) PFDouble holdMarginCallSizeShort;
@property (nonatomic, assign) PFDouble initMarginCallSizeOvernight;
@property (nonatomic, assign) PFDouble holdMarginCallSizeOvernight;
@property (nonatomic, assign) PFDouble initMarginCallSizeOvernightShort;
@property (nonatomic, assign) PFDouble holdMarginCallSizeOvernightShort;

@end
