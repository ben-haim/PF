
#import <UIKit/UIKit.h>

@class CMColourBlockView;
@class PropertiesStore;

@interface PropertySection : NSObject 
{
    NSString* name;
    NSArray* props;
}
@property (nonatomic, retain)	NSString* name;
@property (nonatomic, retain)	NSArray* props;
@end

@interface EditPropertiesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView*       settingsTableView;
    PropertiesStore*            properties;
    IBOutlet UIBarButtonItem*   lblTitle;
    NSMutableArray*             tableLayout;
    NSString*                   notify_msg;
    NSString*                   title;
    IBOutlet UIBarButtonItem *btnDone;
}
-(void)ShowProperties:(PropertiesStore*)store 
            WithTitle:(NSString*)__title              
              ForPath:(NSString*)path 
           WithNotify:(NSString*)_notify_msg;

- (IBAction)btnDonePressed:(id)sender;

@property (nonatomic, retain)	NSMutableArray		*tableLayout;
@property (nonatomic, retain)	PropertiesStore*    properties;
@property (nonatomic, retain)	UIBarButtonItem*    lblTitle;
@property (nonatomic, retain)	UIBarButtonItem*    btnDone;
@end
