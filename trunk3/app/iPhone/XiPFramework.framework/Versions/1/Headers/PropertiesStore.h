
#import <Foundation/Foundation.h>

@interface PropertiesStore : NSObject 
{
    NSDictionary *settings;
    NSMutableDictionary *cache;
}
-(id)initWithString:(NSString*)settings_str;
-(NSString*)getJSONString;
-(id)getParam:(NSString*)_paramName;
-(NSArray*)getArray:(NSString*)_paramName;
-(NSDictionary*)getDict:(NSString*)_paramName;
-(uint)getColorParam:(NSString*)paramName;
-(bool)getBoolParam:(NSString*)paramName;
-(uint)getUIntParam:(NSString*)paramName;
-(double)getDblParam:(NSString*)paramName;
-(NSString*)getApplyToParam:(NSString*)paramName;
-(NSString*)getApplyToTitle:(NSString*)paramName;

-(void)ClearCache;
-(void)setParam:(NSString*)paramName WithValue:(NSString*)value;
-(void)setParamValue:(NSString*)paramName 
              inPath:(NSString*)path 
           WithValue:(NSString*)value;
-(void)setArray:(NSString*)paramName inPath:(NSString*)path WithArray:(NSArray*)value;
-(void)setDict:(NSString*)paramName 
        inPath:(NSString*)path 
     WithDict:(NSMutableDictionary*)value;
-(void)cloneDict:(PropertiesStore*)src
        FromPath:(NSString*)path 
       AtNewPath:(NSString*)new_path 
      AndNewName:(NSString*)new_name;

@property (nonatomic, retain) NSDictionary *settings;
@property (nonatomic, retain) NSMutableDictionary *cache;
@end
