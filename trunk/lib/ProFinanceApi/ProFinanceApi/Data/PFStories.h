#import <Foundation/Foundation.h>

@protocol PFStory;

@protocol PFStories <NSObject>

-(NSArray*)stories;

-(NSUInteger)count;
-(NSUInteger)indexOfStory:( id< PFStory > )story_;

@end

@class PFStory;

@interface PFStories : NSObject< PFStories >

@property ( nonatomic, strong, readonly ) NSArray* stories;

-(void)addStory:( PFStory* )story_;
-(void)addStories:( NSArray* )stories_;

@end
