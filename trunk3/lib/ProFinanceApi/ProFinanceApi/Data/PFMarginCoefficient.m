//
//  PFMarginCoefficient.m
//  ProFinanceApi
//
//  Created by VitaliyK on 14.04.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//
#import "PFMetaObject.h"
#import "PFField.h"

#import "PFMarginCoefficient.h"

@implementation PFMarginCoefficient

@synthesize expDay;
@synthesize expMonth;
@synthesize expYear;
@synthesize initMarginCallSize;
@synthesize holdMarginCallSize;
@synthesize initMarginCallSizeShort;
@synthesize holdMarginCallSizeShort;
@synthesize initMarginCallSizeOvernight;
@synthesize holdMarginCallSizeOvernight;
@synthesize initMarginCallSizeOvernightShort;
@synthesize holdMarginCallSizeOvernightShort;

+(PFMetaObject*)metaObject
{
    return [ PFMetaObject metaObjectWithFields:
            [ NSArray arrayWithObjects:
             [ PFMetaObjectField fieldWithId: PFFieldExpDay name: @"expDay" ],
             [ PFMetaObjectField fieldWithId: PFFieldExpMonth name: @"expMonth" ],
             [ PFMetaObjectField fieldWithId: PFFieldExpYear name: @"expYear" ],
             [ PFMetaObjectField fieldWithId: PFFieldInitMarginSize name: @"initMarginCallSize" ],
             [ PFMetaObjectField fieldWithId: PFFieldHoldMarginSize name: @"holdMarginCallSize" ],
             [ PFMetaObjectField fieldWithId: PFFieldInitMarginSizeShort name: @"initMarginCallSizeShort" ],
             [ PFMetaObjectField fieldWithId: PFFieldHoldMarginSizeShort name: @"holdMarginCallSizeShort" ],
             [ PFMetaObjectField fieldWithId: PFFieldInitMarginSizeOvernight name: @"initMarginCallSizeOvernight" ],
             [ PFMetaObjectField fieldWithId: PFFieldHoldMarginSizeOvernight name: @"holdMarginCallSizeOvernight" ],
             [ PFMetaObjectField fieldWithId: PFFieldInitMarginSizeOvernightShort name: @"initMarginCallSizeOvernightShort" ],
             [ PFMetaObjectField fieldWithId: PFFieldHoldMarginSizeOvernightShort name: @"holdMarginCallSizeOvernightShort" ],
             nil ] ];
}

@end
