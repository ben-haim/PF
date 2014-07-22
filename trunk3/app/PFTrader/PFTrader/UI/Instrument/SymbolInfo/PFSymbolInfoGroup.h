#import <Foundation/Foundation.h>

typedef enum
{
   PFSymbolInfoGroupTypeGeneral = 0
   , PFSymbolInfoGroupTypeTrading = 1
   , PFSymbolInfoGroupTypeMargin = 2
   , PFSymbolInfoGroupTypeFees = 3
   , PFSymbolInfoGroupTypeSession = 4
}PFSymbolInfoGroupType;

@protocol PFSymbolInfoGroup < NSObject >

-(PFSymbolInfoGroupType)groupType;
-(NSArray*)infoRows;

@end

@protocol PFSymbol;

@interface PFSymbolInfoGroup : NSObject < PFSymbolInfoGroup >

@property ( nonatomic, assign, readonly ) PFSymbolInfoGroupType groupType;
@property ( nonatomic, strong, readonly ) NSArray* infoRows;

+(NSArray*)groupsForSymbol:( id< PFSymbol > )symbol_;

@end
