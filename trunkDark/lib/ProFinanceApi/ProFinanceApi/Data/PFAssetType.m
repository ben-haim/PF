//
//  PFAssetType.m
//  ProFinanceApi
//
//  Created by VitaliyK on 03.03.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//
#import "PFAssetType.h"

#import "PFMessage.h"
#import "PFField.h"
#import "PFMetaObject.h"

@implementation PFAssetType

@synthesize assetId;
@synthesize assetDescription;
@synthesize interestRate;
@synthesize minChange;
@synthesize name;

+(PFMetaObject*)metaObject
{
    return [ PFMetaObject metaObjectWithFields:
            @[[ PFMetaObjectField fieldWithId: PFFieldId name: @"assetId" ],
             [ PFMetaObjectField fieldWithId: PFFieldName name: @"name" ],
             [ PFMetaObjectField fieldWithId: PFFieldDescription name: @"assetDescription" ],
             [ PFMetaObjectField fieldWithId: PFFieldInterest name: @"interestRate" ],
             [ PFMetaObjectField fieldWithId: PFFieldMinChange name: @"minChange" ]] ];
}

-(void)updateFromAssetType: (PFAssetType*) object_
{
    self.assetId = object_.assetId;
    self.assetDescription = object_.assetDescription;
    self.interestRate = object_.interestRate;
    self.minChange = object_.minChange;
    self.name = object_.name;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"assetId=%lld name=%@ assetDescription=%@ interestRate=%f minChange=%f",
            assetId,
            name,
            assetDescription,
            interestRate,
            minChange];
}

@end
