#import <Foundation/Foundation.h>

typedef void (^PFPFDowJonesDoneBlock)( NSArray* news_, NSString* alert_context_, NSError* error_ );

@interface PFDowJonesReader : NSObject

+(id)readerWithPublicToken:( NSString* )token_;

-(void)disconnect;

-(void)readNewsWithAlertContext:( NSString* )context_
                      doneBlock:( PFPFDowJonesDoneBlock )block_;

@end
