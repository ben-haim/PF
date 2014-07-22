#import <UIKit/UIKit.h>

@protocol PFNewsViewControllerDelegate;

@interface PFNewsViewController : UITableViewController

@property ( nonatomic, weak ) id< PFNewsViewControllerDelegate > delegate;

+(BOOL)isAvailable;

@end

@protocol PFStory;

@protocol PFNewsViewControllerDelegate <NSObject>

-(void)newsViewController:( PFNewsViewController* )controller_
           didSelectStory:( id< PFStory > )story_;

@end
