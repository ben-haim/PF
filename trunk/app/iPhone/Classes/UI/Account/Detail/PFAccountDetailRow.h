#import <UIKit/UIKit.h>

@class PFAccountDetailCell;

@protocol PFAccount;

typedef void (^PFAccountDetailCellInitializer)( PFAccountDetailCell* cell_, id< PFAccount > account_ );

@interface PFAccountDetailRow : NSObject

@property ( nonatomic, strong ) NSString* title;
@property ( nonatomic, copy ) PFAccountDetailCellInitializer initializer;

+(id)rowWithTitle:( NSString* )title_
      initializer:( PFAccountDetailCellInitializer )initializer_;

-(void)initializeCell:( PFAccountDetailCell* )cell_
              account:( id< PFAccount > )account_;

@end
