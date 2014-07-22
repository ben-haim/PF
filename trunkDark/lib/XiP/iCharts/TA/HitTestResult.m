//
//  HitTestResult.m
//  XiP
//
//  Created by Xogee MacBook on 14/06/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import "HitTestResult.h"


@implementation HitTestResult
@synthesize o, a, _ht_res, distance;


- (id)initWithRes:(uint)res
{
    self = [super init];
    if(self ==  nil)
        return self;
    
    self._ht_res = res;
    self.distance = HUGE_VAL;
    return self;
}

- (void)dealloc
{	
	[super dealloc];    
}
 
@end
