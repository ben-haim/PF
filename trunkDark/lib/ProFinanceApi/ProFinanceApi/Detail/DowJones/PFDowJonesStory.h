#import "../../Data/PFStory.h"

@interface PFDowJonesStoryDetails : NSObject< PFStoryDetails >

@property ( nonatomic, strong ) NSArray* contentLines;

@end

@class ADSession;

@interface PFDowJonesStory : PFStory

@property ( nonatomic, strong ) NSURL* detailsUrl;
@property ( nonatomic, strong ) PFDowJonesStoryDetails* details;
@property ( nonatomic, strong ) ADSession* asyncSession;

@end
