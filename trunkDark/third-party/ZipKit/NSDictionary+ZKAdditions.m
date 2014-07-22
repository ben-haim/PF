//
//  NSDictionary+ZKAdditions.m
//  ZipKit
//
//  Created by Karl Moskowski on 01/04/09.
//

#import "NSDictionary+ZKAdditions.h"

NSString* const ZKTotalFileSize = @"ZKTotalFileSize";
NSString* const ZKItemCount = @"ZKItemCount";

@implementation NSDictionary (ZKAdditions)

+ (NSDictionary *) zk_totalSizeAndCountDictionaryWithSize:(unsigned long long) size andItemCount:(unsigned long long) count {
	return @{ZKTotalFileSize: @(size),
			ZKItemCount: @(count)};
}

- (unsigned long long) zk_totalFileSize {
	return [self[ZKTotalFileSize] unsignedLongLongValue];
}

- (unsigned long long) zk_itemCount {
	return [self[ZKItemCount] unsignedLongLongValue];
}

@end