#import <UIKit/UIKit.h>

@interface PFGridCell : UIView

@property ( nonatomic, strong, readonly ) NSString* reuseIdentifier;

@property ( nonatomic, strong ) IBOutlet UIView* contentView;

@property ( nonatomic, strong ) IBOutlet UIView* backgroundView;

-(id)initWithReuseIdentifier:( NSString* )reuse_identifier_;

-(void)prepareForEnqueue;
-(void)prepareForDequeue;

-(void)update;

@end
