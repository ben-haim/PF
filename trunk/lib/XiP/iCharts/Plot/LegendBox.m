

#import "LegendBox.h"
#import "Utils.h"
#import "FinanceChart.h"
#import "XYChart.h"
#import "PropertiesStore.h"


@implementation LegendBox
@synthesize parentChart, legendKeys, legend_rect;

- (id)initWithParentChart:(XYChart*)_parentChart
{
    self = [super init];
    if(self == nil)
        return self;
    
    legendKeys = [[NSMutableArray alloc] init];
    parentChart = _parentChart;
    return self;
}

-(void)dealloc
{	
    [legendKeys release];
	[super dealloc];    
}

- (void)drawInContext:(CGContextRef)ctx 
               InRect:(CGRect)rect 
         mustFillRect:(bool)fillRect
               AndDPI:(double)pen_1px
                
{
    PropertiesStore* style = self.parentChart.parentFChart.properties;
	CGColorRef textColor = [HEXCOLOR([style getColorParam:@"style.chart_general.chart_font_color"]) CGColor];
	CGColorRef axisColor = [HEXCOLOR([style getColorParam:@"style.chart_general.chart_frame_color"]) CGColor];
	CGColorRef bgColor = [HEXCOLOR([style getColorParam:@"style.chart_general.chart_margin_color"]) CGColor];
	CGColorRef bgTextColor = [HEXCOLOR([style getColorParam:@"style.chart_general.chart_font_color"]) CGColor];
    legend_rect = rect;
    //if(!this.parentChart.parentFChart.settings["showLegend"])
    //    return;
    
    
    
    int iLegend = 0;
    float lastY = rect.origin.y;
    if(legend_rect.size.height<27)
        return;
    UIFont* font = [UIFont systemFontOfSize:[Utils getFontSize]];
	CGAffineTransform myTextTransform = CGAffineTransformMake(1, 0, 0, -1, 0, 0);
	CGContextSetTextMatrix(ctx, myTextTransform); 
	CGContextSetStrokeColorWithColor(ctx, textColor);     
	CGContextSetFillColorWithColor(ctx, textColor); 
	CGContextSelectFont(ctx, [font.fontName UTF8String], [Utils getFontSize], kCGEncodingMacRoman);
	CGContextSetLineWidth(ctx, pen_1px);
    
    
    for (LegendKey *key in legendKeys) 
    {  
        NSString* legendText = key.text;
        
		float textPosX = rect.origin.x + CHART_PADDING_TOP_BOTTOM;
		float textPosY = lastY;// + _y + CHART_AXIS_TICK_LEN*pen_1px;
        
        CGSize legentSize = [legendText sizeWithFont:font];
        float textPixelLength = legentSize.width + CHART_PADDING_TOP_BOTTOM + CHART_PADDING_TOP_BOTTOM;
        
        bool drawEllipsize = false;
        if (textPixelLength > rect.size.width - CHART_PADDING_TOP_BOTTOM - CHART_PADDING_TOP_BOTTOM)
        {
            drawEllipsize = true;
            NSString *ellipsize = @"...";
            CGSize ellipsizeSize = [ellipsize sizeWithFont:font];
            textPixelLength = rect.size.width - CHART_PADDING_TOP_BOTTOM - CHART_LEGEND_MARK_SIZE;// - ellipsizeSize.width;
            
            
            NSString *legendTemp = legendText;
            CGSize tempLegendSize = [legendTemp sizeWithFont:font];
            while (tempLegendSize.width > textPixelLength - ellipsizeSize.width) 
            {
                int legendEndIndex = (int)[legendTemp length] - 2;
                if (legendEndIndex > 0)
                {
                    legendTemp = [legendTemp substringToIndex:legendEndIndex];
                    tempLegendSize = [legendTemp sizeWithFont:font];
                }
                else
                {
                    break;
                }
            }
            legendText = [NSString stringWithFormat:@"%@%@", legendTemp, ellipsize];
        }
        
        //fill text bg
        CGContextSetLineWidth(ctx, 1*pen_1px);
        if(fillRect)
        {
            CGRect textRect = CGRectMake(rect.origin.x, 
                                         textPosY, 
                                         textPixelLength + CHART_LEGEND_MARK_SIZE + CHART_PADDING_TOP_BOTTOM, 
                                         font.lineHeight);
            CGContextSetFillColorWithColor(ctx, bgColor); 
            CGContextFillRect(ctx, textRect);
            CGContextSetStrokeColorWithColor(ctx, bgTextColor); 
            CGContextStrokeRect(ctx, textRect);
        }
        
        //draw color square
        CGRect markRect = CGRectMake(textPosX, 
                                     textPosY + (font.lineHeight - CHART_LEGEND_MARK_SIZE)/2, 
                                     CHART_LEGEND_MARK_SIZE, 
                                     CHART_LEGEND_MARK_SIZE);
        if(key.color1== key.color2)
        {   
            CGContextSetFillColorWithColor(ctx, HEXCOLOR(key.color1).CGColor); 
            CGContextFillRect(ctx, markRect);
            CGContextSetStrokeColorWithColor(ctx, axisColor); 
            CGContextStrokeRect(ctx, markRect);
        }
        else
        {
            CGContextSetFillColorWithColor(ctx, HEXCOLOR(key.color1).CGColor); 
            CGContextMoveToPoint(ctx,    markRect.origin.x,                         markRect.origin.y);
            CGContextAddLineToPoint(ctx, markRect.origin.x + markRect.size.width,   markRect.origin.y);
            CGContextAddLineToPoint(ctx, markRect.origin.x,                         markRect.origin.y + markRect.size.height);
            CGContextAddLineToPoint(ctx, markRect.origin.x,                         markRect.origin.y);
            CGContextFillPath(ctx);
            
            if (pen_1px == 1)
            {
                CGContextMoveToPoint(ctx,    markRect.origin.x + 2,                         markRect.origin.y + markRect.size.height);
                CGContextAddLineToPoint(ctx, markRect.origin.x + 1 + markRect.size.width,   markRect.origin.y + 1);
                CGContextAddLineToPoint(ctx, markRect.origin.x + 1 + markRect.size.width,   markRect.origin.y + markRect.size.height);
                CGContextAddLineToPoint(ctx, markRect.origin.x + 2,                         markRect.origin.y + markRect.size.height);
            }            
            else
            {
                CGContextMoveToPoint(ctx,    markRect.origin.x,                         markRect.origin.y + markRect.size.height);
                CGContextAddLineToPoint(ctx, markRect.origin.x + markRect.size.width,   markRect.origin.y);
                CGContextAddLineToPoint(ctx, markRect.origin.x + markRect.size.width,   markRect.origin.y + markRect.size.height);
                CGContextAddLineToPoint(ctx, markRect.origin.x + 1,                         markRect.origin.y + markRect.size.height);
            }
            CGContextSetFillColorWithColor(ctx, HEXCOLOR(key.color2).CGColor); 
            CGContextFillPath(ctx);
            
            CGContextSetStrokeColorWithColor(ctx, axisColor); 
            CGContextStrokeRect(ctx, markRect);
            
        }
        textPosX+=(CHART_LEGEND_MARK_SIZE + CHART_PADDING_TOP_BOTTOM);
        
        //draw string      
        CGContextSetFillColorWithColor(ctx, fillRect?bgTextColor:textColor); 
        CGContextSetTextDrawingMode(ctx, kCGTextFill); 
        CGContextSetShouldAntialias(ctx, true);
        [legendText drawInRect:CGRectMake(textPosX, textPosY, textPixelLength, [Utils getFontSize]) withFont:font];
//[legentText drawInRect:CGRectMake((int) textPosX, (int) textPosY, (int) textPixelLength, (int) [Utils getFontSize]) withFont:font];
//        [legentText drawAtPoint:CGPointMake(textPosX, textPosY) withFont:font];
        CGContextSetShouldAntialias(ctx, false);
        
        
        iLegend++; 
        lastY+=font.lineHeight;
    }
    /*  if(totalHeight<=0 || totalWidth<=27)
     {
     trace("width recalc"); 
     while (iLegend < legendKeys.length) 
     {
     var legendText:flash.text.TextField = legendKeys[iLegend].edt; 
     legendText.autoSize = flash.text.TextFieldAutoSize.LEFT;  
     legendText.wordWrap = false;
     legendText.htmlText = 	(legendKeys[iLegend].text!=null)?						
     "<textformat tabstops='[" + tabstops + "]'>" + legendKeys[iLegend].text + "</textformat>":
     ""; 
     
     if (legendKeys[iLegend].key != "")		  		  
     totalHeight += Math.max(rowHeight, legendText.textHeight+4);  
     totalWidth = Math.max(totalWidth, legendText.textWidth+27);  
     iLegend++; 
     }
     }
     totalHeight=Math.min(totalHeight, this.parentChart.plotArea.areaHeight - this.x);
     
     // 
     if(totalHeight<0 || totalHeight<0)
     return; 
     var bd:Raster = new Raster(this.x+totalWidth, this.y+totalHeight, true, 0x00FFFFFF);
     
     bd.fillRect(new Rectangle(this.x, this.y, totalWidth, totalHeight), 0xD8FFFFFF & this.parentChart.parentFChart.settings["legendColor"]);
     bd.drawRect(new Rectangle(this.x, this.y, totalWidth-1, totalHeight-1), this.parentChart.parentFChart.settings["axisColor"]);   
     
     
     totalHeight = 0;
     iLegend = 0;  
     //
     
     while (iLegend < legendKeys.length )    
     {   
     if (legendKeys[iLegend].key != "") 
     {					
     legendText = legendKeys[iLegend].edt; 	
     
     legendKeys[iLegend].maxWidth = legendText.textWidth + legendText.textHeight * 3;  
     
     
     if(legendKeys[iLegend].color== legendKeys[iLegend].color2)
     {
     bd.fillRect(new Rectangle(	this.x+4, 
     this.y+totalHeight + (rowHeight - iconSize)/2, 
     iconSize, 
     iconSize), 
     legendKeys[iLegend].color);
     }
     else
     {
     bd.mountain(this.x+3, this.y+totalHeight + (rowHeight - iconSize)/2+iconSize,  
     this.x+3+iconSize, this.y+totalHeight + (rowHeight - iconSize)/2,
     legendKeys[iLegend].color,
     this.y+totalHeight + (rowHeight - iconSize)/2);
     bd.mountain(this.x+3, this.y+totalHeight + (rowHeight - iconSize)/2+iconSize,
     this.x+3+iconSize, this.y+totalHeight + (rowHeight - iconSize)/2,
     legendKeys[iLegend].color2,
     this.y+totalHeight + (rowHeight - iconSize)/2+iconSize);
     
     }
     
     
     //bd.drawRect(new Rectangle(this.x+4, 
     //								this.y+totalHeight + (rowHeight - iconSize)/2, 
     //								iconSize, 
     //								iconSize), 
     //								0xFF000000);
     
     //legendText.text = this.parentChart.parentFChart.fps.toFixed(2);
     legendText.defaultTextFormat= new flash.text.TextFormat(font, fontSize, this.parentChart.parentFChart.settings["legendTextColor"]);
     //legendText.htmlText = (legendKeys[iLegend].text!=null)?legendKeys[iLegend].text:"";  
     legendText.htmlText = 	(legendKeys[iLegend].text!=null)?						
     "<textformat tabstops='[" + tabstops + "]'>" + legendKeys[iLegend].text + "</textformat>":  
     "";
     legendText.wordWrap = false;  
     legendText.x = 0+(rowHeight - iconSize) + iconSize;
     legendText.y = totalHeight ;//+ legendText.textHeight; 
     legendText.height = Math.max(rowHeight, legendText.textHeight+4);
     totalHeight = totalHeight + Math.max(rowHeight, legendText.textHeight+4);
     
     
     
     var bd2:BitmapData = new flash.display.BitmapData(legendText.textWidth+4, legendText.textHeight+4, true, 0);
     var r:Rectangle = new flash.geom.Rectangle(0, 0, bd.width, bd.height);
     var p:Point = new flash.geom.Point(this.x + legendText.x, this.y + legendText.y);
     bd2.draw(legendText);
     bd.copyPixels(bd2, r, p, null, null, true);
     
     //this.parentChart.canvas.draw(legendText, new Matrix(1,0,0,1, this.x + legendText.x, this.y + legendText.y));
     }
     iLegend++;
     }
     if(this.parentChart.canvas_cursors==null)  
     return;
     this.parentChart.canvas_cursors.draw(bd, null, null, "layer");
     */
}

- (void)setKey:(NSString*)_legendKeyString color1:(uint)_legendColor color2:(uint)_legendColor2 forceFirst:(bool)insertFirst
{
    LegendKey* leg = [[LegendKey alloc] initWithKey:_legendKeyString color1:_legendColor color2:_legendColor2];
    if(insertFirst)
        [legendKeys insertObject:leg atIndex:0];
    else
        [legendKeys addObject:leg];   
    [leg release];
}  

- (void)setText:(NSString*)_text ForKey:(NSString*)_key
{
    for (LegendKey *key in legendKeys) 
    {
        if(![key.key isEqualToString:_key])
            continue;
        key.text = _text;
        
    }
    //draw();
}

@end
