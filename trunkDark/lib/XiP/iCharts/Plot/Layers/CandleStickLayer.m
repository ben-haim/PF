
#import "CandleStickLayer.h"
#import "CursorLayer.h"
#import "LegendBox.h"
#import "../XYChart.h"
#import "../FinanceChart.h"
#import "../Axis.h"
#import "PropertiesStore.h"
#import "Utils.h"
#import "../../DataStores/BaseDataStore.h"

enum
{
   barTypeDown,
   barTypeUp,
   barTypeNull
};

@implementation CandleStickLayer
@synthesize color_up, color_down, color_up_border, color_down_border, color_null_border;

- (id)initWithDataStore:(BaseDataStore*)_DataStore ParentChart:(XYChart*)_parentChart
{
   self = [super initWithDataStore:_DataStore ParentChart:_parentChart];
   if(self == nil)
      return self;

   self = [super initWithDataStore:_DataStore ParentChart:_parentChart SrcField:@"hloc" LayerName:@"CandleStick"];
   if(self == nil)
      return self;
   PropertiesStore* style = _parentChart.parentFChart.properties;
   [self setColor_up:HEXCOLOR([style getColorParam:@"style.candles.candle_up"])];
   [self setColor_down:HEXCOLOR([style getColorParam:@"style.candles.candle_down"])];
   [self setColor_up_border:HEXCOLOR([style getColorParam:@"style.candles.candle_up_border"])];
   [self setColor_down_border:HEXCOLOR([style getColorParam:@"style.candles.candle_down_border"])];
   [self setColor_null_border:HEXCOLOR([style getColorParam:@"style.chart_general.chart_font_color"])];

   return self;
}

-(void)dealloc
{
   [color_up release];
   [color_down release];
   [color_down_border release];
   [color_up_border release];
   [super dealloc];
}

- (void)drawInContext:(CGContextRef)ctx
               InRect:(CGRect)rect
               AndDPI:(double)pen_1px
{
   layer_rect = rect;
   int i = parentChart.endIndex;
   float chart_grid_right_cellsize = [Utils getChartGridRightCellSize: parentChart.parentFChart.frame];
   double bar_width_full = fabs((rect.size.width - chart_grid_right_cellsize) / parentChart.parentFChart.duration);
   int bar_width = bar_width_full;

   if (bar_width_full > 3)
      bar_width = bar_width_full * 0.85;

   CGContextSetLineWidth(ctx, pen_1px/*1.0*/);

   if ((bar_width / 2) > (CHART_GRID_CELLSIZE - 5))
      bar_width = (CHART_GRID_CELLSIZE - 5) * 2;

   //if(bar_width%2==0)
   //    bar_width--;
   //    double last_x = rect.origin.x + rect.size.width - chart_grid_right_cellsize;

   double* openData    = [[parentChart.DataStore GetVector:@"openData"] getData];
   double* closeData   = [[parentChart.DataStore GetVector:@"closeData"] getData];
   double* highData    = [[parentChart.DataStore GetVector:@"highData"] getData];
   double* lowData     = [[parentChart.DataStore GetVector:@"lowData"] getData];

   double open, close, high, low, y_close, y_open, y_high, y_low, last_x_new;
   CGColorRef cs_border_color;
   CGColorRef cs_color;
   CGRect r, r_bar;

   for (int draw_not_bars_=0; draw_not_bars_<2; draw_not_bars_++)
   {
      for (int bar_type_=0; bar_type_<3; bar_type_++)
      {
         if (bar_type_ == barTypeNull && !draw_not_bars_)
         {
            continue;
         }
         else if (bar_type_ == barTypeNull)
         {
            CGContextSetStrokeColorWithColor(ctx, color_null_border.CGColor);
         }
         else
         {
            cs_color        = (bar_type_) ? (color_up.CGColor) : (color_down.CGColor);
            cs_border_color = (bar_type_) ? (color_up_border.CGColor) : (color_down_border.CGColor);

            CGContextSetFillColorWithColor(ctx, cs_color);
            CGContextSetStrokeColorWithColor(ctx, draw_not_bars_ ? cs_border_color : cs_color);
         }

         BOOL is_line_bar_ = NO;

         while (i >= parentChart.startIndex)
         {
            open  = openData[i];
            close = closeData[i];

            last_x_new = rect.origin.x + rect.size.width - chart_grid_right_cellsize + (i - parentChart.endIndex) * bar_width_full;

            if (bar_type_ == barTypeUp)
            {
               if (close < open)
               {
                  i--;
                  continue;
               }
            }
            else if (bar_type_ == barTypeDown)
            {
               if (close > open)
               {
                  i--;
                  continue;
               }
            }
            else if (bar_type_ == barTypeNull)
            {
               if (close != open)
               {
                  i--;
                  continue;
               }
            }

            high = highData[i];
            low  = lowData[i];

            y_close = [parentChart.yAxis getCoorValue:close];
            y_open  = [parentChart.yAxis getCoorValue:open];
            y_high  = [parentChart.yAxis getCoorValue:high];
            y_low   = [parentChart.yAxis getCoorValue:low];

            if (isnan(y_low) || isnan(y_close) || isnan(y_open) || isnan(y_high))
            {
               i--;
               continue;
            }

            r = CGRectMake(last_x_new - bar_width/2.0, y_open,
                           bar_width, y_close - y_open);

            r_bar = CGRectMake(r.origin.x + pen_1px,   r.origin.y,
                               r.size.width - pen_1px, r.size.height);

            if (draw_not_bars_)
            {
               is_line_bar_ = YES;

               if (bar_type_ != barTypeNull)
               { // Рисуем свечи отдельно
                  if (y_low != MAX(y_open, y_close))
                  {
                     CGContextMoveToPoint(ctx, last_x_new, y_low + pen_1px);
                     CGContextAddLineToPoint(ctx, last_x_new, MAX(y_open, y_close) + pen_1px);
                  }
                  if (y_high != MIN(y_open, y_close))
                  {
                     CGContextMoveToPoint(ctx, last_x_new, y_high - pen_1px);
                     CGContextAddLineToPoint(ctx, last_x_new, MIN(y_open, y_close) - pen_1px);
                  }
               }
               else
               { // Если бар нулевой, то рисуем свечи одной линией
                  CGContextMoveToPoint(ctx, last_x_new, y_low);
                  CGContextAddLineToPoint(ctx, last_x_new, y_high);
               }

               if ((r.size.width >= pen_1px*8) && (bar_type_ != barTypeNull))
               { // Обводка вокруг бара
                  CGContextAddRect(ctx, r);
                  CGContextDrawPath(ctx, kCGPathStroke);
               }

               if (bar_type_ == barTypeNull)
               { // Рисуется горизонтальная линия, когда бар нулевой
                  CGContextMoveToPoint(ctx, r.origin.x, y_open);
                  CGContextAddLineToPoint(ctx, r.origin.x + r.size.width, y_open);
               }
            }
            else
            {
               if (bar_type_ != barTypeNull)
               {
                  if (r_bar.size.width >= pen_1px)
                  { // Закрашевает бары
                     CGContextFillRect(ctx, r_bar);
                  }
                  else
                  { // Если бар тонкий, то рисуем только линию
                     is_line_bar_ = YES;
                     CGContextMoveToPoint(ctx, last_x_new, y_open);
                     CGContextAddLineToPoint(ctx, last_x_new, y_close);
                  }
               }
            }

            i--;
         }

         if (is_line_bar_)
            CGContextStrokePath(ctx);

         i = parentChart.endIndex;
      }
   }
}

-(void)setChartCursorValue:(uint)valueIndex
{
   ArrayMath* closeData = [DataStore GetVector:@"closeData"];
   ArrayMath* openData = [DataStore GetVector:@"openData"];
   double xValue = NAN;
   double yValue = NAN;
   double bar_width_full = NAN;
   if (closeData == nil || openData == nil)
      return;
   bar_width_full = (parentChart.parentFChart.xAxis.axis_rect.size.width - [Utils getChartGridRightCellSize: parentChart.parentFChart.frame]) / parentChart.range;
   xValue = layer_rect.origin.x  + (valueIndex+1) * bar_width_full ;

   int realIndex = parentChart.startIndex + valueIndex;
   double closeValue = [closeData getData][realIndex];
   double val = [self.parentChart.yAxis getCoorValue:closeValue];
   yValue = val;
   [parentChart.cursorLayer setChartCursorValue:layerName pX:xValue pY:yValue Index:valueIndex];
}


-(void)setLegendText:(int)globalIndex
{
   if (parentChart.legendBox == nil || globalIndex==-1)
      return;
   ArrayMath* highData = [DataStore GetVector:@"highData"];
   ArrayMath* lowData = [DataStore GetVector:@"lowData"];
   ArrayMath* closeData = [DataStore GetVector:@"closeData"];
   ArrayMath* openData = [DataStore GetVector:@"openData"];

   if (highData == nil)
      return;

   if(globalIndex>=[openData getLength])
      globalIndex = [openData getLength]-1;
   int realIndex = globalIndex;
   double openPrice = [openData getData][realIndex];
   double closePrice = [closeData getData][realIndex];
   double highPrice = [highData getData][realIndex];
   double lowPrice = [lowData getData][realIndex];


   NSString *LegendMsg = [[NSString alloc] initWithFormat:@"%@(%@) H:%@, L:%@, O:%@, C:%@",
                          parentChart.parentFChart.symbol,
                          [parentChart.parentFChart.chart_data getIntervalName],
                          [parentChart formatPrice:highPrice],
                          [parentChart formatPrice:lowPrice],
                          [parentChart formatPrice:openPrice],
                          [parentChart formatPrice:closePrice]];

   [parentChart.legendBox setText:LegendMsg ForKey:legendKey];
   [LegendMsg autorelease];

}

@end
