#import <Foundation/Foundation.h>

@protocol PFStory;

@interface PFStoryHTMLFormatter : NSObject

-(NSString*)toHTMLStory:( id< PFStory > )story_;

@end
