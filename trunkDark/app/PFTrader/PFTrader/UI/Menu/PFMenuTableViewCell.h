#import <UIKit/UIKit.h>

@interface PFMenuTableViewCell : UITableViewCell < UITableViewDelegate, UITableViewDataSource >

@property ( nonatomic, strong ) NSArray* menuItems;
@property ( nonatomic, weak ) UIViewController* menuController;

-(id)initWithFrame:( CGRect )frame_ reuseIdentifier:( NSString* )reuse_identifier_;

@end
