//
//  TALayer.m
//  XiP
//
//  Created by Xogee MacBook on 14/06/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import "TALayer.h"
#import "Utils.h"
#import "FinanceChart.h"
#import "XYChart.h"
#import "Axis.h"
#import "PlotArea.h"
#import "PropertiesStore.h"
#import "Objects/TALine.h"
#import "Objects/TARay.h"
#import "Objects/TASegment.h"
#import "Objects/TAChannel.h"
#import "Objects/TAHLine.h"
#import "Objects/TAVLine.h"
#import "Objects/TAFibonacci.h"
#import "Objects/TAFibArcs.h"
#import "Objects/TAFibFan.h"

@implementation ChartTATouchInfo
@synthesize lastHitTest, ptMouseDown, address;

- (id)init
{
    self = [super init];
    if(self == nil)
        return self;
    self.lastHitTest        = nil;   
    return self;
}

- (void)dealloc
{	
    if(lastHitTest!=nil)
        [lastHitTest release];
	[super dealloc];    
}
@end

@implementation TALayer
@synthesize objects, ta_touches, parentChart, ta_anchor_img, ta_anchor_img_off;

- (id)initWithParentChart:(XYChart*)_parentChart
{
    self = [super init];
    if(self == nil)
        return self;
    self.parentChart        = _parentChart;
    self.objects            = [[[NSMutableArray alloc] init] autorelease];   
    self.ta_touches         = [[[NSMutableArray alloc] init] autorelease]; 
    self.ta_anchor_img      = [UIImage imageNamed:@"ta_grip.png"];
    self.ta_anchor_img_off  = [UIImage imageNamed:@"ta_grip_del.png"];
    return self;
}

- (void)dealloc
{	
    [objects release];
    [ta_touches release];
    [ta_anchor_img release];
	[super dealloc];    
}

-(void)Clear
{
    [objects removeAllObjects];    
//    [objects release];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [self setObjects:tempArray];
    [tempArray release];
//    self.objects = [[NSMutableArray alloc] init]; 		
}
-(void)AddObject:(TAObject*)o
{
    [objects addObject:o];
}

- (void)drawInContext:(CGContextRef)ctx 
               InRect:(CGRect)rect
               AndDPI:(double)pen_1px
        AndCursorMode:(uint)cursorMode 
{
    if(parentChart.plotArea.plot_rect.size.width==0 || 
       parentChart.plotArea.plot_rect.size.height ==0 || 
       parentChart != parentChart.parentFChart.mainChart)
        return; 
    CGContextSaveGState( ctx );
    CGContextClipToRect(ctx, rect);
    TAObject* oSelected = nil;
    CGContextSetShouldAntialias(ctx, true);
    for(TAObject* o in objects)
    {        
        if(![o isVisibleWithin:parentChart.parentFChart.startIndex 
                           And:parentChart.parentFChart.startIndex + parentChart.parentFChart.duration])
            continue;
        if(o.isSelected && oSelected==nil)
        {
            oSelected = o;
            continue;
        }
        [o drawInContext:ctx InRect:rect AndDPI:pen_1px AndCursorMode:cursorMode];
    }			
    if(oSelected!=nil)
        [oSelected drawInContext:ctx InRect:rect AndDPI:pen_1px AndCursorMode:cursorMode];

    // Undo the clipping fun
    CGContextRestoreGState( ctx );

}
-(HitTestResult*)hitTest:(CGPoint)p AndThreshold:(double)threshold
{
    HitTestResult* htResult = [[[HitTestResult alloc] initWithRes:CHART_HT_NONE] autorelease];
    double minDistance = HUGE_VAL;
    for(TAObject* o in objects)
    {
        o.isSelected = false;
        if(![o isVisibleWithin:parentChart.parentFChart.startIndex 
                           And:parentChart.parentFChart.startIndex + parentChart.parentFChart.duration])
            continue;
        HitTestResult* currHT = [o HitTest:p AndThreshold:threshold]; 
        if(currHT._ht_res != CHART_HT_NONE && currHT.distance<minDistance) 
        {
            minDistance = currHT.distance;
            htResult = currHT;
        }
    }
    return htResult;//autoreleased earlier
}

- (void)HandleDrag:(NSSet *)touches
{    
    for (UITouch* touch in touches) 
    {
        CGPoint pt = [touch locationInView:self.parentChart.parentFChart];
    
        ChartTATouchInfo* ht;
        bool isFound = false;
        for (ht in ta_touches) 
        {
            if(ht.address == (void*)touch)
            {
                isFound = true;
                break;
            }
        }
        
        if(isFound && ht.lastHitTest._ht_res != CHART_HT_NONE)
        {
            pt.y = MAX(pt.y, parentChart.plotArea.plot_rect.origin.y + ht.lastHitTest.a.AnchorSize/2);
            pt.y = MIN(pt.y, parentChart.plotArea.plot_rect.origin.y + parentChart.plotArea.plot_rect.size.height - ht.lastHitTest.a.AnchorSize/2);
            if(ht.lastHitTest._ht_res == CHART_HT_ANCHOR) 
            {
                ht.lastHitTest.a.y_value = MIN([parentChart.yAxis coorToValue:pt.y], [parentChart.yAxis coorToValue:parentChart.plotArea.plot_rect.origin.y]);
                ht.lastHitTest.a.x_index = [parentChart.parentFChart.xAxis getXDataIndex:pt.x];
                
                if(ht.lastHitTest.a.x_index<parentChart.startIndex)
                    ht.lastHitTest.a.x_index = parentChart.startIndex;
                if(ht.lastHitTest.a.x_index>=parentChart.startIndex + parentChart.parentFChart.duration)
                    ht.lastHitTest.a.x_index = parentChart.startIndex + parentChart.parentFChart.duration-1;	
                ht.lastHitTest.a.isSelected = true;
                //if(event.localY-lastHitTest.a.AnchorSize/2<parentChart.plotArea.y)// || event.localY-2>parentChart.plotArea.y + parentChart.plotArea.areaHeight)
                    //event.localY<parentChart.plotArea.y + lastHitTest.a.AnchorSize/2;
            }
            else
            if(ht.lastHitTest._ht_res == CHART_HT_OBJECT)
            {   
                ht.lastHitTest.o.isSelected = true;
                for(TAAnchor* a in ht.lastHitTest.o.anchors)
                {
                    a.y_value =  a.y_val_orig_drag - 
                                 (
                                    [parentChart.yAxis coorToValue:ht.ptMouseDown.y] - 
                                    [parentChart.yAxis coorToValue:pt.y]
                                 );
                    a.x_index = a.x_index_orig_drag - 
                                 (
                                    [parentChart.parentFChart.xAxis getXDataIndex:ht.ptMouseDown.x] - 
                                    [parentChart.parentFChart.xAxis getXDataIndex:pt.x]
                                 );	
                }
            }
        }
    }
}

- (void)HandleDrawStartAt:(CGPoint)pt WithTouch:(UITouch*)touch WithXIndex:(int)x_index AndYValue:(double)y_value
{    
    PropertiesStore* style = self.parentChart.parentFChart.properties;
    uint draw_color = [style getColorParam:@"style.draw.color"];
    uint draw_lwidth = [style getUIntParam:@"style.draw.width"];
    uint draw_ldash = [style getUIntParam:@"style.draw.dash"];
    uint drawMode = parentChart.parentFChart.drawSubtype;   
    HitTestResult *lastHitTest = nil;
    //pt.y-=30.0;
    switch(drawMode)
    {			
        case CHART_DRAW_LINE:
        {
            TALine* oLine = [[TALine alloc] initWithParentChart:parentChart 
                                                          AndX1:x_index 
                                                          AndX2:x_index 
                                                          AndY1:y_value  
                                                          AndY2:y_value  
                                                       AndColor:draw_color 
                                                   AndLineWidth:draw_lwidth 
                                                    AndLineDash:draw_ldash];
            [objects addObject:oLine];             
            
            lastHitTest = [[HitTestResult alloc] initWithRes:CHART_HT_ANCHOR];
            lastHitTest.a = [oLine.anchors objectAtIndex:1]; 
            [oLine release];
        }
        break;
        case CHART_DRAW_CHANNEL:
        {
            TAChannel* oChannel = [[TAChannel alloc] initWithParentChart:parentChart
                                                                   AndX1:x_index
                                                                   AndX2:x_index
                                                                   AndX3:x_index
                                                                   AndY1:y_value
                                                                   AndY2:y_value
                                                                   AndY3:y_value+[parentChart.yAxis getValueOfPixel]*30
                                                                AndColor:draw_color
                                                            AndLineWidth:draw_lwidth
                                                             AndLineDash:draw_ldash];
            [objects addObject:oChannel];             
            
            lastHitTest = [[HitTestResult alloc] initWithRes:CHART_HT_ANCHOR];
            lastHitTest.a = [oChannel.anchors objectAtIndex:1];
            [oChannel release];
        }
        break;
        case CHART_DRAW_RAY:	
        {     
            TARay* oRay = [[TARay alloc] initWithParentChart:parentChart
                                                       AndX1:x_index
                                                       AndX2:x_index
                                                       AndY1:y_value
                                                       AndY2:y_value
                                                    AndColor:draw_color 
                                                AndLineWidth:draw_lwidth 
                                                 AndLineDash:draw_ldash];
            [objects addObject:oRay];             
            
            lastHitTest = [[HitTestResult alloc] initWithRes:CHART_HT_ANCHOR];
            lastHitTest.a = [oRay.anchors objectAtIndex:1]; 
            [oRay release];
        }
        break;
        case CHART_DRAW_SEGMENT:
        {
            TASegment* oSeg = [[TASegment alloc] initWithParentChart:parentChart
                                                               AndX1:x_index
                                                               AndX2:x_index
                                                               AndY1:y_value
                                                               AndY2:y_value  
                                                            AndColor:draw_color 
                                                        AndLineWidth:draw_lwidth 
                                                         AndLineDash:draw_ldash];
            [objects addObject:oSeg];             
            
            lastHitTest = [[HitTestResult alloc] initWithRes:CHART_HT_ANCHOR];
            lastHitTest.a = [oSeg.anchors objectAtIndex:1]; 
            [oSeg release];
        }
        break;
        case CHART_DRAW_FIB_RETR:
        {
            TAFibonacci* oFib = [[TAFibonacci alloc] initWithParentChart:parentChart 
                                                                   AndX1:x_index
                                                                   AndX2:x_index 
                                                                   AndY1:y_value
                                                                   AndY2:y_value  
                                                                AndColor:draw_color 
                                                            AndLineWidth:draw_lwidth 
                                                             AndLineDash:draw_ldash];
            [objects addObject:oFib];             
            
            lastHitTest = [[HitTestResult alloc] initWithRes:CHART_HT_ANCHOR];
            lastHitTest.a = [oFib.anchors objectAtIndex:1];       
            [oFib release];
        }
        break;            
        case CHART_DRAW_FIB_CIRC:	
        {
            TAFibArcs* oFibArcs = [[TAFibArcs alloc] initWithParentChart:parentChart 
                                                                   AndX1:x_index
                                                                   AndX2:x_index 
                                                                   AndY1:y_value
                                                                   AndY2:y_value  
                                                                AndColor:draw_color 
                                                            AndLineWidth:draw_lwidth 
                                                             AndLineDash:draw_ldash];
            [objects addObject:oFibArcs];             
            
            lastHitTest = [[HitTestResult alloc] initWithRes:CHART_HT_ANCHOR];
            lastHitTest.a = [oFibArcs.anchors objectAtIndex:1]; 
            [oFibArcs release];
        }
        break;           
        case CHART_DRAW_FIB_FAN:	
        {
            TAFibFan* oFibFan = [[TAFibFan alloc] initWithParentChart:parentChart 
                                                                   AndX1:x_index
                                                                   AndX2:x_index 
                                                                   AndY1:y_value
                                                                   AndY2:y_value  
                                                                AndColor:draw_color 
                                                            AndLineWidth:draw_lwidth 
                                                             AndLineDash:draw_ldash];
            [objects addObject:oFibFan];             
            
            lastHitTest = [[HitTestResult alloc] initWithRes:CHART_HT_ANCHOR];
            lastHitTest.a = [oFibFan.anchors objectAtIndex:1]; 
            [oFibFan release];
        }
        break;            
        case CHART_DRAW_HLINE:	
        {
            TAHLine* oHLine = [[TAHLine alloc] initWithParentChart:parentChart 
                                                                AndX1:x_index
                                                                AndY1:y_value 
                                                             AndColor:draw_color 
                                                         AndLineWidth:draw_lwidth 
                                                          AndLineDash:draw_ldash];
            [objects addObject:oHLine];             
            
            lastHitTest = [[HitTestResult alloc] initWithRes:CHART_HT_ANCHOR];
            lastHitTest.a = [oHLine.anchors objectAtIndex:0]; 
            [oHLine release];
        }  
        break;          
        case CHART_DRAW_VLINE:	
        {
            TAVLine* oVLine = [[TAVLine alloc] initWithParentChart:parentChart 
                                                                AndX1:x_index
                                                                AndY1:y_value 
                                                             AndColor:draw_color 
                                                         AndLineWidth:draw_lwidth 
                                                          AndLineDash:draw_ldash];
            [objects addObject:oVLine];             
            
            lastHitTest = [[HitTestResult alloc] initWithRes:CHART_HT_ANCHOR];
            lastHitTest.a = [oVLine.anchors objectAtIndex:0]; 
            [oVLine release];
        }
        break; 
    }
    if(lastHitTest==nil)
        return;
    ChartTATouchInfo* touch_info = [[ChartTATouchInfo alloc] init];
    [touch_info setLastHitTest:lastHitTest];
    [touch_info setPtMouseDown:pt];
    touch_info.address = (void*)touch;
    [ta_touches addObject:touch_info];
    [lastHitTest release];
    [touch_info release];
}

//+++denis
-(BOOL)resizeModeFromTouches: (NSSet*)touches_
{
   if( parentChart != parentChart.parentFChart.mainChart )
      return NO;
   
   HitTestResult* last_hit_test_ = [ self hitTest: [ touches_.anyObject locationInView: self.parentChart.parentFChart ] AndThreshold: CHART_TA_THRESHOLD ];
   
   if ( last_hit_test_._ht_res == CHART_HT_OBJECT || last_hit_test_._ht_res == CHART_HT_ANCHOR )
   {
      [ parentChart.parentFChart setCursorMode: CHART_MODE_RESIZE ];
      [ self touchesBegan: touches_ ];
      
      return YES;
   }
   
   return NO;
}

- (void)touchesBegan:(NSSet*)touches
{
    if(parentChart != parentChart.parentFChart.mainChart)
        return; 
    for (UITouch* touch in touches) 
    {
        CGPoint pt = [touch locationInView:self.parentChart.parentFChart];
        int x_index = [parentChart.parentFChart.xAxis getXDataIndex:pt.x];
        //double y_value = [parentChart.yAxis coorToValue:pt.y];
        
        uint cursorMode = parentChart.parentFChart.cursorMode;        
        if(cursorMode==CHART_MODE_DRAW)
        {
            double y_value = [parentChart.yAxis coorToValue:pt.y];
            [self HandleDrawStartAt:pt WithTouch:touch WithXIndex:x_index AndYValue:y_value];
            [parentChart.parentFChart setCursorMode:CHART_MODE_RESIZE];
        }
        else
        {
            HitTestResult *lastHitTest = [self hitTest:pt AndThreshold:CHART_TA_THRESHOLD];

            bool alreadyExists = false;
            for (ChartTATouchInfo* t in ta_touches) 
            {
                if(t.lastHitTest._ht_res == lastHitTest._ht_res &&
                   t.lastHitTest.o == lastHitTest.o &&
                   t.lastHitTest.a == lastHitTest.a &&
                   t.lastHitTest._ht_res!= CHART_HT_NONE)
                {
                    t.address = (void*)touch;//+++denis not clickable zone fix
                    alreadyExists = true;
                    break;
                }
            }
            ChartTATouchInfo *new_touch = nil;
            if(!alreadyExists)
            {
                new_touch = [[ChartTATouchInfo alloc] init];
                [new_touch setLastHitTest:lastHitTest];
                [new_touch setPtMouseDown:pt];
                new_touch.address = (void*)touch;
                [ta_touches addObject:new_touch];
                [new_touch release];
                
                if(lastHitTest._ht_res == CHART_HT_OBJECT)
                    lastHitTest.o.isSelected = true;
                else
                if(lastHitTest._ht_res == CHART_HT_ANCHOR)
                {
                    lastHitTest.a.isSelected = true;
                    lastHitTest.a.y_value = MIN([parentChart.yAxis coorToValue:pt.y], parentChart.yAxis.upperLimit);
                }
                //+++denis touch on empty space
                else
                {
                   [ ta_touches removeAllObjects ];
                   [ parentChart.parentFChart setCursorMode: CHART_MODE_NONE ];
                }
            }
            else
            {
               // [lastHitTest release];
                continue;
            }
            if(cursorMode==CHART_MODE_RESIZE)
            {                
                if(lastHitTest._ht_res == CHART_HT_OBJECT)
                {
                    for(TAAnchor* a in lastHitTest.o.anchors)
                    {
                        a.x_index_orig_drag = a.x_index;
                        a.y_val_orig_drag = a.y_value;
                    }
                }
            }
            else
            if(cursorMode==CHART_MODE_DELETE)
            {
                //
            }            
        } //switch cursor mode
    }//loop the touches
    [parentChart.parentFChart draw];
}

- (void)touchesMoved:(NSSet*)touches
{
    if(parentChart != parentChart.parentFChart.mainChart)
        return;
    if(parentChart.parentFChart.cursorMode != CHART_MODE_DELETE)
        [self HandleDrag:touches];
    [parentChart.parentFChart draw];
}
- (void)touchesEnded:(NSSet*)touches
{
    if(parentChart != parentChart.parentFChart.mainChart)
        return;
    for (UITouch* touch in touches) 
    {
        int c = 0;
        int iFound = -1;
        ChartTATouchInfo* ht;
        for (ht in ta_touches) 
        {
            if(ht.address == (void*)touch)
            {
                iFound = c;
                break;
            }
            c++;
        }
        if(iFound<0)
            continue;
        
        if(parentChart.parentFChart.cursorMode == CHART_MODE_DELETE)
        {
            if(ht.lastHitTest!=nil && ht.lastHitTest._ht_res != CHART_HT_NONE)
            {
                TAObject* o = nil;
                if(ht.lastHitTest._ht_res == CHART_HT_ANCHOR)
                {
                    o = ht.lastHitTest.a.parentObject;
                }
                else
                if(ht.lastHitTest._ht_res == CHART_HT_OBJECT)
                    o = ht.lastHitTest.o;
                [objects removeObject:o];
            }    
        }        
        //remove the hittest info
        [ta_touches removeObjectAtIndex:iFound];
    }    
    [parentChart.parentFChart SaveDrawings:parentChart With:[self GetDrawings]];
    
    //clear selection
    for(TAObject* o in objects)
        o.isSelected = false;
    
    [parentChart.parentFChart draw];
}

-(NSArray*)GetDrawings 
{
    NSMutableArray* drawings = [[NSMutableArray alloc] init];
    int c = 0;
    for (TAObject* o in objects) 
    {
        NSMutableDictionary *o_props = [[NSMutableDictionary alloc] init];
        //save static properties
        [o_props setValue:[NSString stringWithFormat:@"%@",[o class]] forKey:@"type"];
        [o_props setValue:[NSString stringWithFormat:@"%u",o.linewidth] forKey:@"linewidth"];
        [o_props setValue:[NSString stringWithFormat:@"%u",o.linedash] forKey:@"linedash"];
        [o_props setValue:[NSString stringWithFormat:@"%u",o.color] forKey:@"color"];
        
        //save anchors
        NSMutableArray *o_anchors = [[NSMutableArray alloc] init];
        for (TAAnchor* a in o.anchors) 
        {
            //create a dict with the current anchor properties
            NSMutableDictionary* a_props = [[NSMutableDictionary alloc] init];
            
            [a_props setValue:[NSString stringWithFormat:@"%f",[a x_time]] forKey:@"x_time"];
            [a_props setValue:[NSString stringWithFormat:@"%f",a.y_value] forKey:@"y_value"];            
            
            [o_anchors addObject:a_props];
            [a_props release];
        }        
        [o_props setValue:o_anchors forKey:@"anchors"];
        [o_anchors release];
        
        //push to the list
        [drawings addObject:o_props];
        [o_props release];

        if(c++>50)//we don't want to save too much
            break;
    }
    return [drawings autorelease];
}
-(void)SetDrawings:(NSArray*)_objects
{
    [objects removeAllObjects];

    for(NSMutableDictionary* od in _objects)
    {
        NSString *type = [od objectForKey:@"type"];
        uint draw_color = (uint)[[od objectForKey:@"color"] longLongValue];
        uint draw_lwidth = (uint)[[od objectForKey:@"linewidth"] longLongValue];
        uint draw_ldash = (uint)[[od objectForKey:@"linedash"] longLongValue];
        NSArray *anchors = [od objectForKey:@"anchors"];
        int max_anc = (int)[anchors count]-1;
        
        NSDictionary *a1 = [anchors objectAtIndex:MIN(0, max_anc)];
        NSDictionary *a2 = [anchors objectAtIndex:MIN(1, max_anc)];
        NSDictionary *a3 = [anchors objectAtIndex:MIN(2, max_anc)];
        
        NSLog(@"a1 %@", a1);
        NSLog(@"a2 %@", a2);
        
        double a1_index = [parentChart getTimeValueIndex:[[a1 objectForKey:@"x_time"] doubleValue]];
        double a2_index = [parentChart getTimeValueIndex:[[a2 objectForKey:@"x_time"] doubleValue]];
        double a3_index = [parentChart getTimeValueIndex:[[a3 objectForKey:@"x_time"] doubleValue]];
        
        double y1_value = [[a1 objectForKey:@"y_value"] doubleValue];
        double y2_value = [[a2 objectForKey:@"y_value"] doubleValue];
        double y3_value = [[a3 objectForKey:@"y_value"] doubleValue];
        
        if(a1_index==-1 || a2_index==-1 || a3_index==-1)
            continue;
        
        TAObject* res = nil;
        if([type isEqualToString:@"TALine"])
        {
            res = [[TALine alloc] initWithParentChart:parentChart 
                                                AndX1:a1_index
                                                AndX2:a2_index 
                                                AndY1:y1_value  
                                                AndY2:y2_value  
                                             AndColor:draw_color 
                                         AndLineWidth:draw_lwidth 
                                          AndLineDash:draw_ldash];
        }
        else
        if([type isEqualToString:@"TAChannel"])
        {
            res = [[TAChannel alloc] initWithParentChart:parentChart
                                                   AndX1:a1_index
                                                   AndX2:a2_index
                                                   AndX3:a3_index
                                                   AndY1:y1_value
                                                   AndY2:y2_value
                                                   AndY3:y3_value
                                                AndColor:draw_color
                                            AndLineWidth:draw_lwidth
                                             AndLineDash:draw_ldash];        
        }
        else
        if([type isEqualToString:@"TARay"])
        {
            res = [[TARay alloc] initWithParentChart:parentChart
                                               AndX1:a1_index
                                               AndX2:a2_index
                                               AndY1:y1_value
                                               AndY2:y2_value
                                            AndColor:draw_color 
                                        AndLineWidth:draw_lwidth 
                                         AndLineDash:draw_ldash];        
        }
        else
        if([type isEqualToString:@"TASegment"])
        {
            res = [[TASegment alloc] initWithParentChart:parentChart
                                                   AndX1:a1_index
                                                   AndX2:a2_index 
                                                   AndY1:y1_value
                                                   AndY2:y2_value
                                                AndColor:draw_color 
                                            AndLineWidth:draw_lwidth 
                                             AndLineDash:draw_ldash];        
        }
        else
        if([type isEqualToString:@"TAFibonacci"])
        {
            res = [[TAFibonacci alloc] initWithParentChart:parentChart 
                                                     AndX1:a1_index
                                                     AndX2:a2_index 
                                                     AndY1:y1_value
                                                     AndY2:y2_value  
                                                  AndColor:draw_color 
                                              AndLineWidth:draw_lwidth 
                                               AndLineDash:draw_ldash];

        }
        else
        if([type isEqualToString:@"TAFibArcs"])
        {
            res = [[TAFibArcs alloc] initWithParentChart:parentChart 
                                                   AndX1:a1_index
                                                   AndX2:a2_index 
                                                   AndY1:y1_value
                                                   AndY2:y2_value  
                                                AndColor:draw_color 
                                            AndLineWidth:draw_lwidth 
                                             AndLineDash:draw_ldash];       
        }
        else
        if([type isEqualToString:@"TAFibFan"])
        {
            res = [[TAFibFan alloc] initWithParentChart:parentChart 
                                                  AndX1:a1_index
                                                  AndX2:a2_index 
                                                  AndY1:y1_value
                                                  AndY2:y2_value  
                                               AndColor:draw_color 
                                           AndLineWidth:draw_lwidth 
                                            AndLineDash:draw_ldash];     
        }
        else
        if([type isEqualToString:@"TAHLine"])
        {
            res = [[TAHLine alloc] initWithParentChart:parentChart 
                                                  AndX1:a1_index
                                                  AndY1:y1_value 
                                               AndColor:draw_color 
                                           AndLineWidth:draw_lwidth 
                                            AndLineDash:draw_ldash];     
        }
        else
        if([type isEqualToString:@"TAVLine"])
        {
            res = [[TAVLine alloc] initWithParentChart:parentChart 
                                                 AndX1:a1_index
                                                 AndY1:y1_value 
                                              AndColor:draw_color 
                                          AndLineWidth:draw_lwidth 
                                           AndLineDash:draw_ldash];     
        }
        
        if(res!=nil)
        {
            [objects addObject:res];
            [res release];
        }
    }
    
}
@end
