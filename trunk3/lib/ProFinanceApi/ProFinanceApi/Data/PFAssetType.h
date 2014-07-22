//
//  PFAssetType.h
//  ProFinanceApi
//
//  Created by VitaliyK on 03.03.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//
#import "Detail/PFObject.h"

@protocol PFAssetType < NSObject >

-(NSString*)name;
-(PFLong)assetId;
-(NSString*)assetDescription;
-(PFDouble)interestRate;
-(PFDouble)minChange;

@end

@interface PFAssetType : PFObject < PFAssetType >

@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) PFLong assetId;
@property (nonatomic, strong) NSString* assetDescription;
@property (nonatomic, assign) PFDouble interestRate;
@property (nonatomic, assign) PFDouble minChange;

-(void)updateFromAssetType: (PFAssetType*) object_;

@end
