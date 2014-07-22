#import "../PFTypes.h"

#import "PFField.h"

#import <Foundation/Foundation.h>

@class PFDataScanner;

@interface PFField (PFDataScanner)

+(id)fieldWithId:( PFShort )field_id_
         scanner:( PFDataScanner* )scanner_;

@end
