
#import "PropertiesStore.h"
#import "JSON.h"


@implementation PropertiesStore
@synthesize settings, cache;

-(id)initWithString:(NSString*)settings_str
{
    self = [super init];
    if(self==nil)
        return self;
    //NSDictionary *results = [settings_str JSONValue];
    SBJsonParser* parser = [[SBJsonParser alloc] init];
    NSDictionary *results = (NSDictionary *)[parser objectWithString:settings_str];
    [self setSettings:results];
    cache = [[NSMutableDictionary alloc] init];
    return self;
}

-(NSString*)getJSONString
{
    SBJSON *json = [[SBJSON alloc] init];
    NSError * error = nil;//[[NSError alloc] init];
    NSString *res = [json stringWithObject:settings error:&error];
    //NSLog(@"%@", error);
    return res; 
}
-(void)cloneDict:(PropertiesStore*)src
        FromPath:(NSString*)path
       AtNewPath:(NSString*)new_path
      AndNewName:(NSString*)new_name
{
    NSDictionary* elem = [src getDict:path];
    //convert ot string
    SBJSON *json = [[SBJSON alloc] init];
    NSError * error = nil;//[[NSError alloc] init];
    NSString *dict2string = [json stringWithObject:elem error:&error];
    
    
    
    SBJsonParser* parser = [[SBJsonParser alloc] init];
    NSDictionary *string2dict = (NSDictionary *)[parser objectWithString:dict2string];
    [self setDict:new_name inPath:new_path WithDict:[NSMutableDictionary dictionaryWithDictionary:string2dict]];

}
-(void)ClearCache
{
    [cache removeAllObjects];
}
-(NSDictionary*)getParam:(NSString*)_paramName
{
    if([_paramName length]==0)
        return settings;
    id result = settings;
    NSArray *path_components = [_paramName componentsSeparatedByString:@"."];
    
    for (NSString* fold in path_components) 
    {
        result = result[fold];
    }
    return result;
}
-(NSArray*)getArray:(NSString*)_paramName
{
    return (NSArray*)[self getParam:_paramName];    
}
-(NSDictionary*)getDict:(NSString*)_paramName
{
    return (NSDictionary*)[self getParam:_paramName];
}

-(uint)getUIntParam:(NSString*)paramName
{
    NSDictionary* result = [self getDict:paramName];
    return (uint)[result[@"value"] intValue];
}

-(double)getDblParam:(NSString*)paramName
{
    NSDictionary* result = [self getDict:paramName];
    return (double)[result[@"value"] doubleValue];
}

-(NSString*)getApplyToParam:(NSString*)paramName
{
    uint apply_to_field_id = [self getUIntParam:paramName];

    switch (apply_to_field_id) 
    {
        case 0:
            return @"closeData";
        case 1:
            return @"openData";
        case 2:
            return @"highData";
        case 3:
            return @"lowData";
        case 4:
            return @"hl2Data";
        case 5:
            return @"hlc3Data";
        case 6:
            return @"hlcc4Data";            
        default:
            return @"closeData";
    }
}
-(NSString*)getApplyToTitle:(NSString*)paramName
{
    uint apply_to_field_id = [self getUIntParam:paramName];
    
    switch (apply_to_field_id) 
    {
        case 0:
            return @"Close";
        case 1:
            return @"Open";
        case 2:
            return @"High";
        case 3:
            return @"Low";
        case 4:
            return @"HL/2";
        case 5:
            return @"HLC/3";
        case 6:
            return @"HLCC/4";            
        default:
            return @"Close";
    }
}

-(uint)getColorParam:(NSString*)paramName
{
    id val = cache[paramName]; 
    if(val==nil)
    {
        NSDictionary* result = [self getDict:paramName];
        NSString* str_val = result[@"value"];
        uint outVal;
        NSScanner* scanner = [NSScanner scannerWithString:str_val];
        [scanner scanHexInt:&outVal];
        val = @(outVal);
        [cache setValue:val forKey:paramName];
        return outVal;  
    }
    else
        return (uint)[val intValue];    
}

-(bool)getBoolParam:(NSString*)paramName
{
    NSDictionary* result = [self getDict:paramName];
    return ((uint)[result[@"value"] intValue])>0;
}

-(void)setParam:(NSString*)paramName WithValue:(NSString*)value
{
    //NSDictionary* result = [self getDict:paramName];
    //[result setValue:value forKey:@"value"];
    
    [self setParamValue:@"value" inPath:paramName WithValue:value];
}

-(void)setParamValue:(NSString*)paramName 
        inPath:(NSString*)path 
      WithValue:(NSString*)value
{
    NSDictionary* result = [self getDict:path];
    [result setValue:value forKey:paramName];
}

-(void)setArray:(NSString*)paramName inPath:(NSString*)path WithArray:(NSArray*)value
{
    NSDictionary* result = [self getDict:path];
    [result setValue:value forKey:paramName];
}
-(void)setDict:(NSString*)paramName 
        inPath:(NSString*)path 
     WithDict:(NSDictionary*)value
{
    NSDictionary* result = [self getDict:path];
    [result setValue:value forKey:paramName];
}
@end
