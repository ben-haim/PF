#import "PFColumn.h"

#import <UIKit/UIKit.h>

@class PFConcreteGridCell;

typedef void (^PFDoneCellBlock)( PFConcreteGridCell* cell_, id context_ );

@interface PFConcreteColumn : PFColumn

+(id)columnWithTitle:( NSString* )title_
           cellClass:( Class )class_;

+(id)columnWithTitle:( NSString* )title_
         secondTitle:( NSString* )bottom_title_
           cellClass:( Class )class_;

+(id)columnWithTitle:( NSString* )title_
           cellClass:( Class )class_
       doneCellBlock:( PFDoneCellBlock )done_block_;

+(id)columnWithTitle:( NSString* )title_
         secondTitle:( NSString* )bottom_title_
           cellClass:( Class )class_
       doneCellBlock:( PFDoneCellBlock )done_block_;

@end
