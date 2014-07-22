#import "../../Data/Detail/PFObject.h"

#import <Foundation/Foundation.h>

@interface PFQuoteFile : PFObject

@property ( nonatomic, strong ) NSString* name;
@property ( nonatomic, strong ) NSString* signature;
@property ( nonatomic, assign, getter=isCompressed ) BOOL compressed;
@property ( nonatomic, strong, readonly ) NSArray* quotes;
@property ( nonatomic, strong, readonly ) NSData* data;

-(BOOL)assignData:( NSData* )data_
            error:( NSError** )error_;

@end
