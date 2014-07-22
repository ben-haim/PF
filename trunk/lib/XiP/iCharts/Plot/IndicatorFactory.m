//
//  IndicatorFactory.m
//  XiP
//
//  Created by Xogee MacBook on 03/06/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import "IndicatorFactory.h"
#import "FinanceChart.h"
#import "XYChart.h"
#import "Axis.h"
#import "PropertiesStore.h"
#import "Indicators.h"
#import "LineLayer.h"
#import "InterLineLayer.h"
#import "BarLayer.h"

@implementation IndicatorFactory

- (id)init
{
    self = [super init];
    if(self == nil)
    {
        return self; 
    }
    numberFormatter = [[NSNumberFormatter alloc] init];
    
	[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[numberFormatter setDecimalSeparator:@"."];
	[numberFormatter setGeneratesDecimalNumbers:TRUE];
    [numberFormatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    return  self;
}

-(void)dealloc
{
    [numberFormatter release];
    
    [super dealloc];
}

- (BaseBoxLayer*)addMainIndicator:(NSString*)code WithProperties:(NSString*)path ForChart:(FinanceChart*)chart
{
    //PropertiesStore* properties = chart.properties;

    if([code isEqualToString:@"sma"])
    {
        [self addSimpleMovingAvg:path ForChart:chart];                                                    
    }
    else
    if([code isEqualToString:@"ema"])
    {
        [self addExpMovingAvg:path ForChart:chart];                                                      
    }
    else
    if([code isEqualToString:@"psar"])
    {
        [self addPSAR:path ForChart:chart];                                                      
    }
    else
    if([code isEqualToString:@"bb"])
    {
        [self addBB:path ForChart:chart];              
    }
    else
    if([code isEqualToString:@"bands"])
    {
       [self addBands:path ForChart:chart];
    }
    else
    if([code isEqualToString:@"env"])
    {
        [self addENV:path ForChart:chart];              
    }


    return nil;
}
- (void)addAuxIndicator:(NSString*)code WithProperties:(NSString*)path ToChart:(XYChart*) indChart
{
    if([code isEqualToString:@"mtm"])
    {
        [self addMTM:path ToChart:indChart];
    }
    else
    if([code isEqualToString:@"rsi"])
    {
        [self addRSI:path ToChart:indChart];         
    }
    else
    if([code isEqualToString:@"vol"])
    {
        [self addVOL:path ToChart:indChart];         
    }
    else
    if([code isEqualToString:@"macd"])
    {
        [self addMACD:path ToChart:indChart];         
    }
    else
    if([code isEqualToString:@"will"])
    {
        [self addWILL:path ToChart:indChart];         
    }
    else
    if([code isEqualToString:@"stoh"])
    {
        [self addSTO:path ToChart:indChart];         
    }
    else
    if([code isEqualToString:@"dmi"])
    {
        [self addDMI:path ToChart:indChart];         
    }
}


-(LineLayer*)addSimpleMovingAvg:(NSString*)path ForChart:(FinanceChart*)chart
{
    PropertiesStore* properties = chart.properties;
    NSString *rootPath = [NSString stringWithFormat:@"%@.sma", path];
    IndSMADataSource* sma = [[IndSMADataSource alloc] initWithDataSource:chart.chart_data 
                                                           AndProperties:properties
                                                                 AndPath:rootPath];
    [sma build];
    
    uint lineColor = [properties getColorParam:[NSString stringWithFormat:@"%@.sma.color",path]];
    uint lineWidth = [properties getUIntParam:[NSString stringWithFormat:@"%@.sma.width",path]];
    uint lineDash = [properties getUIntParam:[NSString stringWithFormat:@"%@.sma.dash",path]];    
    
    //localise legend number
    [numberFormatter setMinimumFractionDigits:0];
    [numberFormatter setMaximumFractionDigits:0];
    [numberFormatter setGeneratesDecimalNumbers:NO];
    NSNumber *number = [NSNumber numberWithInt:(int)sma.period];
    NSString *numberString = [numberFormatter stringFromNumber:number];
    
    NSString* legendName = [NSString stringWithFormat:@"SMA(%@)", numberString]; 
    
    LineLayer* ll =  [chart.mainChart addLineLayer:sma
                                    ForSourceField:@"indData"
                                          WithName:legendName
                                            Color1:lineColor
                                         LineWidth:lineWidth
                                          LineDash:lineDash
                                         LegendKey:legendName
                                      ShowInLegend:true
                                        forceFirst:false];
    ll.subtype = 1;
    [sma release];
    return ll;
}
-(LineLayer*)addExpMovingAvg:(NSString*)path ForChart:(FinanceChart*)chart
{
    PropertiesStore* properties = chart.properties;
    NSString *rootPath = [NSString stringWithFormat:@"%@.ema", path];
    IndEMADataSource* ema = [[IndEMADataSource alloc] initWithDataSource:chart.chart_data 
                                                           AndProperties:properties
                                                                 AndPath:rootPath];
    [ema build];
    
    //NSString* applyToFieldTitle = [properties getApplyToTitle:[NSString stringWithFormat:@"%@.ema.apply",path]];
    uint lineColor = [properties getColorParam:[NSString stringWithFormat:@"%@.ema.color",path]];
    uint lineWidth = [properties getUIntParam:[NSString stringWithFormat:@"%@.ema.width",path]];
    uint lineDash = [properties getUIntParam:[NSString stringWithFormat:@"%@.ema.dash",path]];  

    //localise legend number
    [numberFormatter setMinimumFractionDigits:0];
    [numberFormatter setMaximumFractionDigits:0];
    [numberFormatter setGeneratesDecimalNumbers:NO];
    NSNumber *number = [NSNumber numberWithInt:(int)ema.period];
    NSString *numberString = [numberFormatter stringFromNumber:number];

    NSString* legendName = [NSString stringWithFormat:@"EMA(%@)", numberString]; 
    
    LineLayer* ll =  [chart.mainChart addLineLayer:ema
                              ForSourceField:@"indData"
                                    WithName:legendName
                                      Color1:lineColor
                                   LineWidth:lineWidth 
                                    LineDash:lineDash 
                                   LegendKey:legendName
                                      ShowInLegend:true
                                        forceFirst:false];
    ll.subtype = 1;
    [ema release];
    return ll;    
}
-(DOTLayer*)addPSAR:(NSString*)path ForChart:(FinanceChart*)chart
{
    PropertiesStore* properties = chart.properties;
    NSString *rootPath = [NSString stringWithFormat:@"%@.psar", path];
    IndPSARDataSource* psar = [[IndPSARDataSource alloc] initWithDataSource:chart.chart_data 
                                                           AndProperties:properties
                                                                 AndPath:rootPath];
    [psar build];
    
    uint lineColor1 = [properties getColorParam:[NSString stringWithFormat:@"%@.psar.color1",path]];
    uint lineColor2 = [properties getColorParam:[NSString stringWithFormat:@"%@.psar.color2",path]];
    //uint lineWidth = [properties getUIntParam:[NSString stringWithFormat:@"%@.ema.width",path]];
    //uint lineDash = [properties getUIntParam:[NSString stringWithFormat:@"%@.ema.dash",path]];  
    
    //localise legend number
    [numberFormatter setMinimumFractionDigits:2];
    [numberFormatter setMaximumFractionDigits:2];
    [numberFormatter setMinimumIntegerDigits: 1];
    [numberFormatter setGeneratesDecimalNumbers:YES];
    NSNumber *number = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.02f", psar.stepPeriod]];
    NSString *numberString = [numberFormatter stringFromNumber:number];
    
    NSString* legendName = [NSString stringWithFormat:@"PSAR(%@)", numberString]; 
    
    DOTLayer* dl =  [chart.mainChart addDotLayer:psar 
                                   ForSourceField:@"sarData" 
                                         WithName:legendName 
                                           Color1:lineColor1 
                                           Color2:lineColor2 
                                        LegendKey:legendName 
                                     ShowInLegend:true 
                                       forceFirst:false];

    [psar release];
    return dl;  
    
}
-(InterLineLayer*)addBB:(NSString*)path ForChart:(FinanceChart*)chart
{       
    PropertiesStore* properties = chart.properties;
    IndBBDataSource* bb = [[IndBBDataSource alloc] initWithDataSource:chart.chart_data 
                                                        AndProperties:properties
                                                              AndPath:path];
    [bb build];
    uint fillColor = [properties getColorParam:[NSString stringWithFormat:@"%@.bb.color",path]];
    uint lineColor = [properties getColorParam:[NSString stringWithFormat:@"%@.line.color",path]];
    uint lineWidth = [properties getUIntParam:[NSString stringWithFormat:@"%@.line.width",path]];
    uint lineDash = [properties getUIntParam:[NSString stringWithFormat:@"%@.line.dash",path]];
    
    //localise legend number
    [numberFormatter setMinimumFractionDigits:0];
    [numberFormatter setMaximumFractionDigits:0];
    [numberFormatter setGeneratesDecimalNumbers:NO];
    NSNumber *number1 = [NSNumber numberWithInt:(int)bb.period];
    NSString *number1String = [numberFormatter stringFromNumber:number1];
    NSNumber *number2 = [NSNumber numberWithInt:(int)bb.deviation];
    NSString *number2String = [numberFormatter stringFromNumber:number2];
    
    NSString* bb_name = [NSString stringWithFormat:@"BB(%@, %@)", number1String, number2String]; 
    
    
    InterLineLayer* ilLayer =  [chart.mainChart addInterLineLayer:bb 
                                            ForSourceField1:@"indData1"
                                            ForSourceField2:@"indData2"
                                                   WithName:bb_name
                                                          c:lineColor
                                                  FillAlpha:0xFFFFFF55 
                                                        c12:fillColor
                                                        c21:fillColor
                                                  lineWidth:lineWidth
                                                   lineDash:lineDash                                                  legend_key:bb_name 
                                                   ToLegend:true];
    
    [bb release];
    return ilLayer;
}

-(void)addBands: (NSString*)path_ ForChart: (FinanceChart*)chart_
{
   PropertiesStore* properties_ = chart_.properties;
   IndBandsDataSource* bands_ = [ [ IndBandsDataSource alloc ] initWithDataSource: chart_.chart_data
                                                                    AndProperties: properties_
                                                                          AndPath: path_ ];
   [ bands_ build ];
   
   uint line1_color_ = [ properties_ getColorParam: [ NSString stringWithFormat: @"%@.line1.color", path_ ] ];
   uint line1_width_ = [ properties_ getUIntParam: [ NSString stringWithFormat: @"%@.line1.width", path_ ] ];
   uint line1_dash_ = [ properties_ getUIntParam: [ NSString stringWithFormat: @"%@.line1.dash", path_ ] ];
   
   uint line2_color_ = [ properties_ getColorParam: [ NSString stringWithFormat: @"%@.line2.color", path_ ] ];
   uint line2_width_ = [ properties_ getUIntParam: [ NSString stringWithFormat: @"%@.line2.width", path_ ] ];
   uint line2_dash_ = [ properties_ getUIntParam: [ NSString stringWithFormat: @"%@.line2.dash", path_ ] ];
   
   uint line3_color_ = [ properties_ getColorParam: [ NSString stringWithFormat: @"%@.line3.color", path_ ] ];
   uint line3_width_ = [ properties_ getUIntParam: [ NSString stringWithFormat: @"%@.line3.width", path_ ] ];
   uint line3_dash_ = [ properties_ getUIntParam: [ NSString stringWithFormat: @"%@.line3.dash", path_ ] ];
   
   [ numberFormatter setMinimumFractionDigits: 0];
   [ numberFormatter setMaximumFractionDigits: 0];
   [ numberFormatter setGeneratesDecimalNumbers: NO ];
   
   NSString* number1String = [numberFormatter stringFromNumber: [ NSNumber numberWithInt: (int)bands_.period ] ];
   NSString* number2String = [numberFormatter stringFromNumber: [ NSNumber numberWithInt: (int)bands_.deviation ] ];
   NSString* bands_name_ = [ NSString stringWithFormat: @"Bands(%@, %@)", number1String, number2String ];
   /*
    [ chart_.mainChart addInterLineLayer: bands_
    ForSourceField1: @"indData1"
    ForSourceField2: @"indData2"
    WithName: bands_name_
    c: 0x00000000
    FillAlpha: 0x00000000
    c12: line1_color_
    c21: line2_color_
    lineWidth: line1_width_
    lineDash: line1_dash_
    legend_key: bands_name_
    ToLegend: true ];*/
   
   [ chart_.mainChart addLineLayer: bands_
                    ForSourceField: @"indData1"
                          WithName: nil
                            Color1: line1_color_
                         LineWidth: line1_width_
                          LineDash: line1_dash_
                         LegendKey: bands_name_
                      ShowInLegend: true
                        forceFirst: false ];
   
   [ chart_.mainChart addLineLayer: bands_
                    ForSourceField: @"indData2"
                          WithName: nil
                            Color1: line2_color_
                         LineWidth: line2_width_
                          LineDash: line2_dash_
                         LegendKey: nil
                      ShowInLegend: false
                        forceFirst: false ];
   
   [ chart_.mainChart addLineLayer: bands_
                    ForSourceField: @"indData3"
                          WithName: nil
                            Color1: line3_color_
                         LineWidth: line3_width_
                          LineDash: line3_dash_
                         LegendKey: nil
                      ShowInLegend: false
                        forceFirst: false ];
   
   [ bands_ release ];
}

-(void)addENV:(NSString*)path ForChart:(FinanceChart*)chart
{
    PropertiesStore* properties = chart.properties;
    NSString *rootPath = [NSString stringWithFormat:@"%@", path];
    IndENVDataSource* env = [[IndENVDataSource alloc] initWithDataSource:chart.chart_data
                                                           AndProperties:properties
                                                                 AndPath:rootPath];
    [env build];
    
    uint line1Color = [properties getColorParam:[NSString stringWithFormat:@"%@.env.color1",path]];
    uint line2Color = [properties getColorParam:[NSString stringWithFormat:@"%@.env.color2",path]];
    uint lineWidth = [properties getUIntParam:[NSString stringWithFormat:@"%@.env.width",path]];
    uint lineDash = [properties getUIntParam:[NSString stringWithFormat:@"%@.env.dash",path]];    
    
    //localise legend number
    [numberFormatter setMinimumFractionDigits:0];
    [numberFormatter setMaximumFractionDigits:0];
    [numberFormatter setGeneratesDecimalNumbers:NO];
    NSNumber *number = [NSNumber numberWithInt:(int)env.period];
    NSString *numberString = [numberFormatter stringFromNumber:number];
    
    NSString* legendName = [NSString stringWithFormat:@"ENV(%@)", numberString]; 
    
    [chart.mainChart addInterLineLayer:env 
                                                  ForSourceField1:@"envLower"
                                                  ForSourceField2:@"envUpper"
                                                         WithName:legendName
                                                                c:0x00000000
                                                        FillAlpha:0x00000000 
                                                              c12:line2Color
                                                              c21:line1Color
                                                        lineWidth:lineWidth
                                                         lineDash:lineDash                                                  legend_key:legendName 
                                                         ToLegend:true];
    [chart.mainChart addLineLayer:env
                   ForSourceField:@"envLower"
                         WithName:nil
                           Color1:line1Color
                        LineWidth:(lineWidth == 0 ? 1 : lineWidth)
                         LineDash:lineDash
                        LegendKey:nil
                     ShowInLegend:false
                       forceFirst:false];
    
    [chart.mainChart addLineLayer:env
                   ForSourceField:@"envUpper"
                         WithName:nil
                           Color1:line2Color
                        LineWidth:(lineWidth == 0 ? 1 : lineWidth)
                         LineDash:lineDash
                        LegendKey:nil
                     ShowInLegend:false
                       forceFirst:false];
    [env release];
}

- (void)addMTM:(NSString*)path ToChart:(XYChart*)indChart
{
    PropertiesStore* properties = indChart.parentFChart.properties;
    NSString *rootPath = [NSString stringWithFormat:@"%@.mtm", path];
    IndMTMDataSource* mtm = [[IndMTMDataSource alloc] initWithDataSource:indChart.parentFChart.chart_data 
                                                           AndProperties:properties
                                                                 AndPath:rootPath];
    [mtm build];
    
    uint lineColor = [properties getColorParam:[NSString stringWithFormat:@"%@.mtm.color",path]];
    uint lineWidth = [properties getUIntParam:[NSString stringWithFormat:@"%@.mtm.width",path]];
    uint lineDash = [properties getUIntParam:[NSString stringWithFormat:@"%@.mtm.dash",path]];
    
    //localise legend number
    [numberFormatter setMinimumFractionDigits:0];
    [numberFormatter setMaximumFractionDigits:0];
    [numberFormatter setGeneratesDecimalNumbers:NO];
    NSNumber *number = [NSNumber numberWithInt:(int)mtm.period];
    NSString *numberString = [numberFormatter stringFromNumber:number];
    
    NSString* legendName = [NSString stringWithFormat:@"MTM(%@)", numberString]; 
    
    LineLayer* ll =  [indChart addLineLayer:mtm
                             ForSourceField:@"indData"
                                   WithName:legendName
                                     Color1:lineColor
                                  LineWidth:lineWidth
                                   LineDash:lineDash 
                                  LegendKey:legendName
                               ShowInLegend:true
                                 forceFirst:false];
    ll.subtype = 1;
    [mtm release];            	    
}
- (void)addRSI:(NSString*)path ToChart:(XYChart*)indChart
{
    PropertiesStore* properties = indChart.parentFChart.properties;
    NSString *rootPath = [NSString stringWithFormat:@"%@.rsi", path];
    IndRSIDataSource* rsi = [[IndRSIDataSource alloc] initWithDataSource:indChart.parentFChart.chart_data 
                                                           AndProperties:properties
                                                                 AndPath:rootPath];
    [rsi build];
    
    uint lineColor = [properties getColorParam:[NSString stringWithFormat:@"%@.rsi.color",path]];
    uint lineWidth = [properties getUIntParam:[NSString stringWithFormat:@"%@.rsi.width",path]];
    uint lineDash = [properties getUIntParam:[NSString stringWithFormat:@"%@.rsi.dash",path]];
    uint fillColor1 = [properties getColorParam:[NSString stringWithFormat:@"%@.rsi.fillcolor1",path]];
    uint fillColor2 = [properties getColorParam:[NSString stringWithFormat:@"%@.rsi.fillcolor2",path]];
    uint level = [properties getUIntParam:[NSString stringWithFormat:@"%@.rsi.level",path]];
    
    //localise legend number
    [numberFormatter setMinimumFractionDigits:0];
    [numberFormatter setMaximumFractionDigits:0];
    [numberFormatter setGeneratesDecimalNumbers:NO];
    NSNumber *number = [NSNumber numberWithInt:(int)rsi.period];
    NSString *numberString = [numberFormatter stringFromNumber:number];
    
    NSString* legendName = [NSString stringWithFormat:@"RSI(%@)", numberString]; 
    
    LineLayer* ll =  [indChart addLineLayer:rsi
                             ForSourceField:@"indData"
                                   WithName:legendName
                                     Color1:lineColor
                                  LineWidth:lineWidth
                                   LineDash:lineDash 
                                  LegendKey:legendName
                               ShowInLegend:true
                                 forceFirst:true];
    ll.subtype = 1;
    InterLineLayer* il1 = [indChart addInterLineLayer:rsi 
                                      ForSourceField1:@"level_top"
                                      ForSourceField2:@"indData"
                                             WithName:@""
                                                    c:0x00000000
                                            FillAlpha:0xFFFFFF55 
                                                  c12:fillColor1
                                                  c21:0x00000000
                                            lineWidth:lineWidth
                                             lineDash:lineDash                                                  
                                           legend_key:@"t1"
                                             ToLegend:false];
    il1.mustClip = true;
    il1.clipAbove = true;
    il1.clip_level = 100 - level;
    
    InterLineLayer* il2 = [indChart addInterLineLayer:rsi 
                                      ForSourceField1:@"level_bottom"
                                      ForSourceField2:@"indData"
                                             WithName:@""
                                                    c:0x00000000
                                            FillAlpha:0xFFFFFF55 
                                                  c12:fillColor2
                                                  c21:0x00000000
                                            lineWidth:lineWidth
                                             lineDash:lineDash                                                  
                                           legend_key:@"t1"
                                             ToLegend:false];
    il2.mustClip = true;
    il2.clipAbove = false;
    il2.clip_level = level;

    [indChart addLineLayer:rsi
            ForSourceField:@"level_top"
                  WithName:@""
                    Color1:fillColor1
                 LineWidth:1
                  LineDash:0 
                 LegendKey:legendName
              ShowInLegend:false
                forceFirst:false];  
    
    [indChart addLineLayer:rsi
            ForSourceField:@"level_bottom"
                  WithName:@""
                    Color1:fillColor2
                 LineWidth:1
                  LineDash:0 
                 LegendKey:legendName
              ShowInLegend:false
                forceFirst:false];   
    
    indChart.yAxis.lowerLimit = 0;
    indChart.yAxis.upperLimit = 100;
    [indChart.yAxis setIsAutoLower:false];
    [indChart.yAxis setIsAutoScale:false];
    [rsi release];            	    
}

- (void)addVOL:(NSString*)path ToChart:(XYChart*)indChart
{
    PropertiesStore* properties = indChart.parentFChart.properties;
    
    uint barColor = [properties getColorParam:[NSString stringWithFormat:@"%@.vol.color",path]];
    NSString* legendName = @"VOL"; 
    indChart.digits = 0;
    [indChart addBarLayer:indChart.parentFChart.chart_data 
                           ForSourceField:@"volData"
                                 WithName:legendName 
                                   Color1:barColor 
                                   Color2:barColor 
                                LegendKey:legendName
                             ShowInLegend:true];
    [indChart.yAxis setLowerLimit:0];
    [indChart.yAxis setIsAutoLower:false];
}

- (void)addMACD:(NSString*)path ToChart:(XYChart*)indChart
{
    
    PropertiesStore* properties = indChart.parentFChart.properties;
    NSString *rootPath = [NSString stringWithFormat:@"%@", path];
    IndMACDDataSource* macd = [[IndMACDDataSource alloc] initWithDataSource:indChart.parentFChart.chart_data 
                                                           AndProperties:properties
                                                                 AndPath:rootPath];
    [macd build];
    
    uint lineColor = [properties getColorParam:[NSString stringWithFormat:@"%@.sma.color",path]];
    uint lineWidth = [properties getUIntParam:[NSString stringWithFormat:@"%@.sma.width",path]];
    uint lineDash = [properties getUIntParam:[NSString stringWithFormat:@"%@.sma.dash",path]];
    
    uint barColor1 = [properties getColorParam:[NSString stringWithFormat:@"%@.macd.color2",path]];
    uint barColor2 = [properties getColorParam:[NSString stringWithFormat:@"%@.macd.color1",path]];
    
    //localise legend number
    [numberFormatter setMinimumFractionDigits:0];
    [numberFormatter setMaximumFractionDigits:0];
    [numberFormatter setGeneratesDecimalNumbers:NO];
    NSNumber *number = [NSNumber numberWithInt:(int)macd.ema1];
    NSString *numberString = [numberFormatter stringFromNumber:number];
    NSNumber *number2 = [NSNumber numberWithInt:(int)macd.ema2];
    NSString *number2String = [numberFormatter stringFromNumber:number2];
    
    NSString* legendName = [NSString stringWithFormat:@"MACD(%@, %@)", numberString, number2String]; 
    
    
    [indChart addBarLayer:macd 
           ForSourceField:@"indMACD"
                 WithName:legendName 
                   Color1:barColor1 
                   Color2:barColor2 
                LegendKey:legendName
             ShowInLegend:true];
    
    NSNumber *number3 = [NSNumber numberWithInt:(int)macd.sma_period];
    NSString *number3String = [numberFormatter stringFromNumber:number3];
    
    legendName = [NSString stringWithFormat:@"SMA(%@)", number3String]; 
    
    [indChart addLineLayer:macd
            ForSourceField:@"indSMA"
                  WithName:legendName
                    Color1:lineColor
                 LineWidth:lineWidth
                  LineDash:lineDash 
                 LegendKey:legendName
              ShowInLegend:true
                forceFirst:false]; 
    indChart.digits = 5;
    lineColor = [properties getColorParam:[NSString stringWithFormat:@"%@.div.color",path]];
    lineWidth = [properties getUIntParam:[NSString stringWithFormat:@"%@.div.width",path]];
    lineDash = [properties getUIntParam:[NSString stringWithFormat:@"%@.div.dash",path]];
    legendName = @"Div"; 
    
    [indChart addLineLayer:macd
            ForSourceField:@"indDiv"
                  WithName:legendName
                    Color1:lineColor
                 LineWidth:lineWidth
                  LineDash:lineDash 
                 LegendKey:legendName
              ShowInLegend:true
                forceFirst:false];    
    
    indChart.yAxis.showZero = true;
    [macd release];   
}


- (void)addWILL:(NSString*)path ToChart:(XYChart*)indChart
{
    PropertiesStore* properties = indChart.parentFChart.properties;
    NSString *rootPath = [NSString stringWithFormat:@"%@.will", path];
    IndWillDataSource* will = [[IndWillDataSource alloc] initWithDataSource:indChart.parentFChart.chart_data 
                                                           AndProperties:properties
                                                                 AndPath:rootPath];
    [will build];
    
    uint lineColor = [properties getColorParam:[NSString stringWithFormat:@"%@.will.color",path]];
    uint lineWidth = [properties getUIntParam:[NSString stringWithFormat:@"%@.will.width",path]];
    uint lineDash = [properties getUIntParam:[NSString stringWithFormat:@"%@.will.dash",path]];
    
    //localise legend number
    [numberFormatter setMinimumFractionDigits:0];
    [numberFormatter setMaximumFractionDigits:0];
    [numberFormatter setGeneratesDecimalNumbers:NO];
    NSNumber *number = [NSNumber numberWithInt:(int)will.period];
    NSString *numberString = [numberFormatter stringFromNumber:number];
    
    NSString* legendName = [NSString stringWithFormat:@"%%R(%@)", numberString]; 
    
    LineLayer* ll =  [indChart addLineLayer:will
                             ForSourceField:@"indData"
                                   WithName:legendName
                                     Color1:lineColor
                                  LineWidth:lineWidth
                                   LineDash:lineDash 
                                  LegendKey:legendName
                               ShowInLegend:true
                                 forceFirst:false];
    ll.subtype = 1;
    [will release];            	    
}

- (void)addSTO:(NSString*)path ToChart:(XYChart*)indChart
{
    PropertiesStore* properties = indChart.parentFChart.properties;
    NSString *rootPath = [NSString stringWithFormat:@"%@", path];
    IndStohDataSource* stoh = [[IndStohDataSource alloc] initWithDataSource:indChart.parentFChart.chart_data 
                                                           AndProperties:properties
                                                                 AndPath:rootPath];
    [stoh build];
    
    uint lineColor = [properties getColorParam:[NSString stringWithFormat:@"%@.perc_k.color",path]];
    uint lineWidth = [properties getUIntParam:[NSString stringWithFormat:@"%@.perc_k.width",path]];
    uint lineDash = [properties getUIntParam:[NSString stringWithFormat:@"%@.perc_k.dash",path]];
    
    //localise legend number
    [numberFormatter setMinimumFractionDigits:0];
    [numberFormatter setMaximumFractionDigits:0];
    [numberFormatter setGeneratesDecimalNumbers:NO];
    NSNumber *number = [NSNumber numberWithInt:(int)stoh.k_period];
    NSString *numberString = [numberFormatter stringFromNumber:number];
    NSNumber *number2 = [NSNumber numberWithInt:(int)stoh.smoothing];
    NSString *number2String = [numberFormatter stringFromNumber:number2];
    
    NSString* legendName = [NSString stringWithFormat:@"STO %%K(%@, %@)", numberString, number2String]; 
    
    [indChart addLineLayer:stoh
                             ForSourceField:@"dataK"
                                   WithName:legendName
                                     Color1:lineColor
                                  LineWidth:lineWidth
                                   LineDash:lineDash 
                                  LegendKey:legendName
                               ShowInLegend:true
                                 forceFirst:false];
    lineColor = [properties getColorParam:[NSString stringWithFormat:@"%@.perc_d.color",path]];
    lineWidth = [properties getUIntParam:[NSString stringWithFormat:@"%@.perc_d.width",path]];
    lineDash = [properties getUIntParam:[NSString stringWithFormat:@"%@.perc_d.dash",path]];
    
    NSNumber *number3 = [NSNumber numberWithInt:(int)stoh.d_period];
    NSString *number3tring = [numberFormatter stringFromNumber:number3];
    
    NSString* legendName2 = [NSString stringWithFormat:@"STO %%D(%@)", number3tring]; 
    
    [indChart addLineLayer:stoh
                             ForSourceField:@"dataD"
                                   WithName:legendName2
                                     Color1:lineColor
                                  LineWidth:lineWidth
                                   LineDash:lineDash 
                                  LegendKey:legendName2
                               ShowInLegend:true
                                 forceFirst:false];
    [stoh release];            	    
}

- (void)addDMI:(NSString*)path ToChart:(XYChart*)indChart
{
    PropertiesStore* properties = indChart.parentFChart.properties;
    NSString *rootPath = [NSString stringWithFormat:@"%@", path];
    IndDMIDataSource* dmi = [[IndDMIDataSource alloc] initWithDataSource:indChart.parentFChart.chart_data 
                                                              AndProperties:properties
                                                                    AndPath:rootPath];
    [dmi build];
    
    uint lineColor = [properties getColorParam:[NSString stringWithFormat:@"%@.adx.color",path]];
    uint lineWidth = [properties getUIntParam:[NSString stringWithFormat:@"%@.adx.width",path]];
    uint lineDash = [properties getUIntParam:[NSString stringWithFormat:@"%@.adx.dash",path]];
    
    //localise legend number
    [numberFormatter setMinimumFractionDigits:0];
    [numberFormatter setMaximumFractionDigits:0];
    [numberFormatter setGeneratesDecimalNumbers:NO];
    NSNumber *number = [NSNumber numberWithInt:(int)dmi.period];
    NSString *numberString = [numberFormatter stringFromNumber:number];
    
    NSString* legendName = [NSString stringWithFormat:@"ADX(%@)", numberString]; 
    
    [indChart addLineLayer:dmi
            ForSourceField:@"adxData"
                  WithName:legendName
                    Color1:lineColor
                 LineWidth:lineWidth
                  LineDash:lineDash 
                 LegendKey:legendName
              ShowInLegend:true
                forceFirst:false];
    
    lineColor = [properties getColorParam:[NSString stringWithFormat:@"%@.di_plus.color",path]];
    lineWidth = [properties getUIntParam:[NSString stringWithFormat:@"%@.di_plus.width",path]];
    lineDash = [properties getUIntParam:[NSString stringWithFormat:@"%@.di_plus.dash",path]];
    
    NSString* legendName2 = [NSString stringWithFormat:@"DI+(%@)", numberString]; 
    
    [indChart addLineLayer:dmi
            ForSourceField:@"diPlusData"
                  WithName:legendName2
                    Color1:lineColor
                 LineWidth:lineWidth
                  LineDash:lineDash 
                 LegendKey:legendName2
              ShowInLegend:true
                forceFirst:false];
    
    lineColor = [properties getColorParam:[NSString stringWithFormat:@"%@.di_min.color",path]];
    lineWidth = [properties getUIntParam:[NSString stringWithFormat:@"%@.di_min.width",path]];
    lineDash = [properties getUIntParam:[NSString stringWithFormat:@"%@.di_min.dash",path]];
    NSString* legendName3 = [NSString stringWithFormat:@"DI-(%@)", numberString]; 
    
    [indChart addLineLayer:dmi
            ForSourceField:@"diMinusData"
                  WithName:legendName3
                    Color1:lineColor
                 LineWidth:lineWidth
                  LineDash:lineDash 
                 LegendKey:legendName3
              ShowInLegend:true
                forceFirst:false];
    [dmi release];            	    
}
@end
