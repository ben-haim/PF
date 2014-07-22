//
//  HitTestResult.h
//  XiP
//
//  Created by Xogee MacBook on 14/06/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TAObject;
@class TAAnchor;
@interface HitTestResult : NSObject 
{
    TAObject* o;
    TAAnchor* a;
    uint _ht_res;    
    float distance;
}
- (id)initWithRes:(uint)res;

@property (assign) TAObject* o;
@property (assign) TAAnchor* a;
@property (assign) uint _ht_res;
@property (assign) float distance;
@end
