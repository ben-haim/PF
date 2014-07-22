#import "../PFTypes.h"

#import "Detail/PFObject.h"

#import <Foundation/Foundation.h>

@protocol PFStoryDetails< NSObject >

-(NSArray*)contentLines;

@end

typedef void (^PFStoryDetailsDoneBlock)( id< PFStoryDetails > details_, NSError* error_ );

@protocol PFStory <NSObject>

-(PFInteger)storyId;
-(PFInteger)routeId;
-(NSString*)source;
-(NSString*)header;
-(NSURL*)url;
-(NSDate*)date;

-(id< PFStoryDetails >)details;

-(void)detailsWithDoneBlock:( PFStoryDetailsDoneBlock )done_block_;

@end

@interface PFStory : PFObject< PFStory >

@property ( nonatomic, assign ) PFInteger storyId;
@property ( nonatomic, assign ) PFInteger routeId;
@property ( nonatomic, strong ) NSString* source;
@property ( nonatomic, strong ) NSString* header;
@property ( nonatomic, strong ) NSURL* url;
@property ( nonatomic, strong ) NSDate* date;

@end
