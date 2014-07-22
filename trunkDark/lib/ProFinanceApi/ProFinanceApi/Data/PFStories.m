#import "PFStories.h"

#import "PFStory.h"

@interface PFStories ()

@property ( nonatomic, strong ) NSArray* stories;

@end

@implementation PFStories

@synthesize stories;

-(void)addStory:( PFStory* )story_
{
   [ self addStories: @[story_] ];
}

-(void)addStories:( NSArray* )stories_
{
   NSArray* all_stories_ = [ stories_ arrayByAddingObjectsFromArray: self.stories ];
   self.stories = [ all_stories_ sortedArrayUsingComparator: ^( id story1_, id story2_ )
   {
      return [ [ story2_ date ] compare: [ story1_ date ] ];
   } ];
}

-(NSUInteger)count
{
   return [ self.stories count ];
}

-(NSUInteger)indexOfStory:( id< PFStory > )story_
{
   return [ self.stories indexOfObject: story_ ];
}

@end
