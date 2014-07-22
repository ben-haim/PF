//
//  SplitterLayer.m
//  XiP
//
//  Created by Xogee MacBook on 06/06/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import "SplitterLayer.h"
#import "FinanceChart.h"
#import "XYChart.h"
#import "PropertiesStore.h"

@implementation ChartSplitterHittest
@synthesize iChart, y, address, state;

@end

@implementation SplitterLayer
@synthesize parentFChart, iChartClicks;

-(id)initWithParentChart:(FinanceChart*)_parentChart
{
    self  = [super init];
    if(self == nil)
        return self;
    self.parentFChart       = _parentChart;
    iChartClicks            = [[NSMutableArray alloc] init];
    
    scale = 1.0;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        scale = [UIScreen mainScreen].scale;

    return self;
}


- (void)drawInContext:(CGContextRef)ctx 
               InRect:(CGRect)rect
               AndDPI:(double)pen_1px
{
    if([parentFChart.addIndCharts count]==0)
        return;
    CGRect r = rect;

    //r.origin.y = r.origin.y + parentFChart.mainChart.chart_rect.size.height;
    int c = 0;
    for (XYChart* addChart in parentFChart.addIndCharts) 
    {
        CGContextSetFillColorWithColor(ctx, [HEXCOLOR([parentFChart.properties getColorParam:@"style.chart_general.chart_margin_color"]) CGColor]);
        CGContextSetStrokeColorWithColor(ctx, [HEXCOLOR([parentFChart.properties getColorParam:@"style.chart_general.chart_frame_color"]) CGColor]);
        
        float gripRadius = CHART_SPLITTER_GRIP_RADIUS;
        r = addChart.chart_rect;
        
        double circle_left = roundf(r.origin.x + (r.size.width - [Utils getYAxisWidth] - gripRadius)/2.0);
        double circle_top = roundf(r.origin.y - gripRadius + (CHART_PADDING_TOP_BOTTOM/2.0));
        CGRect ellipse_rect = CGRectMake(circle_left, 
                                         circle_top, 
                                         gripRadius*2, gripRadius*2);
        CGContextAddEllipseInRect(ctx, ellipse_rect);
        CGContextFillPath(ctx);
		CGContextSetShouldAntialias(ctx, true);
        CGContextAddEllipseInRect(ctx, ellipse_rect);
        CGContextStrokePath(ctx);
        
        CGContextSetFillColorWithColor(ctx, [HEXCOLOR([parentFChart.properties getColorParam:@"style.chart_general.chart_frame_color"]) CGColor]);
        CGContextMoveToPoint(ctx, circle_left + gripRadius,         circle_top + gripRadius/3.0);
        CGContextAddLineToPoint(ctx, circle_left + gripRadius*(1 + 1/3.0),  circle_top + gripRadius*2/3.0);
        CGContextAddLineToPoint(ctx, circle_left + gripRadius*(1 - 1/3.0),  circle_top + gripRadius*2/3.0);
        CGContextFillPath(ctx);
        
        CGContextSetFillColorWithColor(ctx, [HEXCOLOR([parentFChart.properties getColorParam:@"style.chart_general.chart_frame_color"]) CGColor]);
        CGContextMoveToPoint(ctx, circle_left + gripRadius,         circle_top + gripRadius + gripRadius*2/3.0);
        CGContextAddLineToPoint(ctx, circle_left + gripRadius*(1 + 1/3.0),  circle_top + gripRadius + gripRadius*1/3.0);
        CGContextAddLineToPoint(ctx, circle_left + gripRadius*(1 - 1/3.0),  circle_top + gripRadius + gripRadius*1/3.0);
        CGContextFillPath(ctx);
        
        
		CGContextSetShouldAntialias(ctx, false);
   
        //r.size.height = truncf((rect.size.height - CHART_XAXIS_HEIGHT) * addChart.percentHeight);
        //r.origin.y = r.origin.y + r.size.height;
        
        c++;
    }    
    
    for (ChartSplitterHittest* ht in iChartClicks) 
    {
        if(ht.iChart==-1)
            continue;
        
        CGRect divider_rect = CGRectMake(r.origin.x, ht.y, r.size.width, CHART_PADDING_TOP_BOTTOM);
        
        CGContextSaveGState(ctx);        
        CGContextSetBlendMode(ctx, kCGBlendModeDifference);  
        CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
        CGContextFillRect(ctx, divider_rect);
        
        CGContextRestoreGState(ctx);
    }
}

//+++denis
-(BOOL)splitterModeFromTouches: (NSSet*)touches_
{
   if( parentFChart.addIndCharts.count == 0 )
      return NO;
   
   for (XYChart* addChart in parentFChart.addIndCharts)
   {
      CGRect r = addChart.chart_rect;
      float gripRadius = CHART_SPLITTER_GRIP_RADIUS * scale;
      
      CGRect ellipse_rect = CGRectMake(r.origin.x,
                                       r.origin.y - gripRadius * 2 + (CHART_PADDING_TOP_BOTTOM / 2.0),
                                       addChart.chart_rect.size.width, gripRadius * 4);
      
      
      if(CGRectContainsPoint(ellipse_rect, [ touches_.anyObject locationInView: self.parentFChart ]))
      {
         [ parentFChart setCursorMode: CHART_MODE_SPLITTER ];
         return YES;
      }
   }
   return NO;
}

- (void)touchesBegan:(NSSet*)points
{
    if([parentFChart.addIndCharts count]==0)
        return;

    for (UITouch* touch in points) 
    {
        CGPoint pt = [touch locationInView:self.parentFChart];

        
        int iChart = -1;
        double y = NAN;
        int c = 0;
        for (XYChart* addChart in parentFChart.addIndCharts) 
        {
            CGRect r = addChart.chart_rect;
            float gripRadius = CHART_SPLITTER_GRIP_RADIUS*scale;
            CGRect ellipse_rect = CGRectMake(r.origin.x + (r.size.width - [Utils getYAxisWidth] - gripRadius*2)/2.0,
                                             r.origin.y - gripRadius*2 + (CHART_PADDING_TOP_BOTTOM/2.0),
                                             gripRadius*4, gripRadius*4);
            if(CGRectContainsPoint(ellipse_rect, pt))
            {
                iChart = c;
                y = r.origin.y;
                break;
            }
            c++;
        }    

        
        if(iChart>=0)
        {
            bool alreadyExists = false;
            for (ChartSplitterHittest* ht2 in iChartClicks) 
            {
                if(ht2.iChart == iChart)
                {
                    alreadyExists = true;
                    break;
                }
                c++;
            }
            if(!alreadyExists)
            {
                ChartSplitterHittest *ht = [[ChartSplitterHittest alloc] init];
                ht.iChart = iChart;
                ht.y = y;
                ht.address = (__bridge void*)touch;
                ht.state = 0;
                [iChartClicks addObject:ht];
            }
        }
        //+++denis touch on empty space
        else
        {
           [ iChartClicks removeAllObjects ];
           [ parentFChart setCursorMode: CHART_MODE_NONE ];
        }
    }
    
    [self.parentFChart draw];
}

- (void)touchesMoved:(NSSet*)points
{
    if([parentFChart.addIndCharts count]==0)
        return;
    
    float minGap = 2*(CHART_SPLITTER_GRIP_RADIUS + CHART_PADDING_TOP_BOTTOM);
    for (UITouch* touch in points) 
    {
        CGPoint pt = [touch locationInView:self.parentFChart];
        
        int c = 0;
        int iFound = -1;
        ChartSplitterHittest* ht;
        double prevY = NAN;
        for (ht in iChartClicks) 
        {
            if(ht.address == (__bridge void*)touch)
            {
                prevY = ht.y;
                ht.y = pt.y;
                ht.state = 1;
                iFound = c;
                break;
            }
            c++;
        }
        if(iFound>=0 && ht.iChart>=0)
        {
            XYChart *ownerChart = (parentFChart.addIndCharts)[ht.iChart];
            CGRect r = ownerChart.chart_rect;
            
            if(ht.y<r.origin.y)//moved up
            {
                //check not to intersect with any chartclick above                
                for (ChartSplitterHittest* ht2 in iChartClicks) 
                {
                    if(ht2.address == ht.address) //us
                        continue;
                    if(ht2.iChart==-1) //empty
                        continue;
                    if(ht2.iChart>=ht.iChart) //it's a below chart so we don't care
                        continue;
                    //we've got one active splitter above us, so we make sure to get too close to it
                    
                    //NSLog(@"up ht2.y=%f, ht.y=%f", ht2.y, ht.y);

                    if((ht.y-ht2.y)<minGap)
                    {
                        //we are too close
                        ht.y = prevY;
                        break;
                    }
                }
                
                //check not to intersect with any chart splitter above
                //we will not take those that are being dragged and have been checked above
                for(int i=0; i<ht.iChart; i++)
                {
                    XYChart* aboveChart = (parentFChart.addIndCharts)[i];
                    
                    //check if it is being dragged
//                    bool isDragged = false;
//                    for (ChartSplitterHittest* ht2 in iChartClicks) 
//                    {
//                        if(ht2.iChart==i) //it is being dragged
//                        {
//                            isDragged = true;
//                            break;
//                        }
//                    }
                    //if(isDragged)
                    //    continue;
                    
                    //we've got one chart above us, so we make sure to get too close to it                    
                    if((ht.y-aboveChart.chart_rect.origin.y)<minGap)
                    {
                        //we are too close
                        ht.y = prevY;
                        break;
                    }                    
                }
                
                
                if(ht.iChart == 0)//the bottom chart
                {
                    if(ht.y - parentFChart.mainChart.chart_rect.origin.y<minGap)
                    {
                        //we are too close
                        ht.y = prevY;
                        break;
                    }                    
                    
                }
            }//moved up
            else
            {
                //check not to intersect with any chartclick below                
                for (ChartSplitterHittest* ht2 in iChartClicks) 
                {
                    if(ht2.address == ht.address) //us
                        continue;
                    if(ht2.iChart==-1) //empty
                        continue;
                    if(ht2.iChart<=ht.iChart) //it's a above chart so we don't care
                        continue;
                    //we've got one active splitter above us, so we make sure to get too close to it
                    NSLog(@"down ht2.y=%f, ht.y=%f", ht2.y, ht.y);
                    if((ht2.y-ht.y)<minGap)
                    {
                        //we are too close
                        ht.y = prevY;
                        break;
                    }
                }
                
                //check not to intersect with any chart splitter below
                //we will not take those that are being dragged and have been checked above
                for(int i=ht.iChart+1; i<[parentFChart.addIndCharts count]; i++)
                {
                    XYChart* belowChart = (parentFChart.addIndCharts)[i];
                    
                    //check if it is being dragged
//                    bool isDragged = false;
//                    for (ChartSplitterHittest* ht2 in iChartClicks) 
//                    {
//                        if(ht2.iChart==i) //it is being dragged
//                        {
//                            isDragged = true;
//                            break;
//                        }
//                    }
                    //if(isDragged)
                    //    continue;
                    
                    //we've got one chart above us, so we make sure to get too close to it
                    if((belowChart.chart_rect.origin.y - ht.y)<minGap)
                    {
                        //we are too close
                        ht.y = prevY;
                        break;
                    }                    
                }
                if(ht.iChart == [parentFChart.addIndCharts count]-1)//the bottom chart
                {
                    XYChart* chart = (parentFChart.addIndCharts)[ht.iChart];
                    if(chart.chart_rect.origin.y + chart.chart_rect.size.height - ht.y<minGap)
                    {
                        //we are too close
                        ht.y = prevY;
                        break;
                    }                    

                }
            }//moved down
            
        }//if touch was registered for a spliiter
    }//iterate touches
    [self.parentFChart draw];
}

- (void)touchesEnded:(NSSet*)points
{
    NSMutableArray *newHeights = [[NSMutableArray alloc] init];

    for (UITouch* touch in points) 
    {
        int c = 0;
        int iFound = -1;
        ChartSplitterHittest* ht;
        for (ht in iChartClicks) 
        {
            if(ht.address == (__bridge void*)touch)
            {
                iFound = c;
                break;
            }
            c++;
        }
        if(iFound>=0 && ht.iChart>=0)
        {
            //fix the corresponding splitter
            XYChart *ownerChart = (parentFChart.addIndCharts)[ht.iChart];
            CGRect r = ownerChart.chart_rect;
            
            
            [newHeights removeAllObjects];
            if(ht.y<r.origin.y)//moved up
            {
                double deltaY = fabs(r.origin.y - ht.y); 
                double OwnerChartRatio = 1 + deltaY/r.size.height;
                if (ht.iChart>0)
                {
                    XYChart* prevChart = (parentFChart.addIndCharts)[ht.iChart-1];
                    double prevChartRatio = 1 - deltaY/prevChart.chart_rect.size.height;
                        
                    for(int i=0; i<ht.iChart-1; i++)
                    {
                        XYChart* aboveChart = (parentFChart.addIndCharts)[i];
                        [newHeights addObject:@(aboveChart.percentHeight)];
                    }  
                    prevChart.percentHeight*=prevChartRatio;
                    [newHeights addObject:@(prevChart.percentHeight)];
                }
                ownerChart.percentHeight*=OwnerChartRatio;
                [newHeights addObject:@(ownerChart.percentHeight)];  
                        
                for(int i=ht.iChart+1; i< [parentFChart.addIndCharts count];i++)
                {
                    XYChart* belowChart = (parentFChart.addIndCharts)[i];
                    [newHeights addObject:@(belowChart.percentHeight)];
                }  
            }
            else //moved down
            {
                double deltaY = fabs(r.origin.y - ht.y);                 
                double OwnerChartRatio = 1 - deltaY/r.size.height;

                if (ht.iChart>0)
                {
                    XYChart* prevChart = (parentFChart.addIndCharts)[ht.iChart-1];
                    double prevChartRatio = 1 + deltaY/prevChart.chart_rect.size.height;
                    
                    for(int i=0; i<ht.iChart-1; i++)
                    {
                        XYChart* aboveChart = (parentFChart.addIndCharts)[i];
                        [newHeights addObject:@(aboveChart.percentHeight)];
                    }  
                    prevChart.percentHeight*=prevChartRatio;
                    [newHeights addObject:@(prevChart.percentHeight)];
                }
                ownerChart.percentHeight*=OwnerChartRatio;
                [newHeights addObject:@(ownerChart.percentHeight)];  
                
                for(int i=ht.iChart+1; i< [parentFChart.addIndCharts count];i++)
                {
                    XYChart* belowChart = (parentFChart.addIndCharts)[i];
                    [newHeights addObject:@(belowChart.percentHeight)];
                }  
            }
            [iChartClicks removeObjectAtIndex:iFound];//remove the hittest info
            [parentFChart.properties setArray:@"panel_heights" inPath:@"view" WithArray:newHeights];
            
            double summHeight = 0;
            for (NSNumber* height in newHeights) 
            {
                summHeight+=[height doubleValue];
            }
            
            [parentFChart.mainChart setPercentHeight:1-summHeight];
            
        }//was a valid touch
        
    }//iterate over touches
    
    parentFChart.dataChanged = true;
    [self.parentFChart draw];
}

- (void)touchesCanceled:(NSSet*)points
{
    
    for (UITouch* touch in points) 
    {
        int c = 0;
        int iFound = -1;
        for (ChartSplitterHittest* ht in iChartClicks) 
        {
            if(ht.address == (__bridge void*)touch)
            {
                iFound = c;
                break;
            }
            c++;
        }
        if(iFound>=0)
        {
            //just remove the hittest info
            [iChartClicks removeObjectAtIndex:iFound];
        }
    }
    [self.parentFChart draw];
}





@end
