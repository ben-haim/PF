//
//  PFAccountSpeedometr.m
//  PFTrader
//
//  Created by Vit on 13.05.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//
#import "PFAccountSpeedometr.h"
#import "UIColor+Skin.h"
#import "NSString+DoubleFormatter.h"

const CGFloat offset = 10.0f;
const CGFloat startArk = M_PI*0.7f;
const CGFloat endArk = M_PI*2.3f;
const CGFloat lineWidthRatio = 10.66f;

@interface PFAccountSpeedometr ()

@property (nonatomic, assign) double positiveValue;
@property (nonatomic, assign) double negativeValue;

@end

@implementation PFAccountSpeedometr

@synthesize positiveValue;
@synthesize negativeValue;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect_
{
   CGContextRef context_ = UIGraphicsGetCurrentContext();

   CGContextSetShouldAntialias(context_, true);
   CGContextSetInterpolationQuality(context_, kCGInterpolationHigh);

   if ((negativeValue == 0) && (positiveValue == 0))
   {
      [ self drawArcWithContext: context_
                        andRect: rect_
                andStartPercent: 0.0f
                  andEndPercent: 100.0f
                       andColor: [UIColor blackColor] ];
   }
   else
   {
      [ self drawArcWithContext: context_
                        andRect: rect_
                andStartPercent: 0.0f
                  andEndPercent: self.borderLineInPercent
                       andColor: [UIColor redTextColor] ];

      [ self drawArcWithContext: context_
                        andRect: rect_
                andStartPercent: self.borderLineInPercent
                  andEndPercent: 100.0f
                       andColor: [UIColor greenTextColor] ];
   }

   // Draw Labels
   NSString* positive_Str_ = [NSString stringWithMoney: positiveValue];
   NSString* negative_Str_ = [NSString stringWithMoney: fabs(negativeValue)];

   if (positiveValue != 0) positive_Str_ = [ @"+" stringByAppendingString: positive_Str_ ];
   if (negativeValue != 0) negative_Str_ = [ @"-" stringByAppendingString: negative_Str_ ];

   UIFont* font_ = [UIFont fontWithName: @"Helvetica" size: 10.0f];
   double radius_ = MIN(CGRectGetMidX(rect_), CGRectGetMidY(rect_)) - offset;
   double center_x_ = CGRectGetMidX(rect_);
   double center_y_ = CGRectGetMidY(rect_);
   CGRect left_Label_Rect_ =  CGRectMake(center_x_, center_y_+radius_*0.91f, radius_*1.15f, 20);
   CGRect right_Label_Rect_ = CGRectMake(center_x_-radius_*1.15f, center_y_+radius_*0.91f, radius_*1.15f, 20);

   CGContextSetFillColorWithColor(context_, (positiveValue != 0) ? [UIColor greenTextColor].CGColor : [UIColor grayTextColor].CGColor);
   [ positive_Str_ drawInRect: left_Label_Rect_
                     withFont: font_
                lineBreakMode: NSLineBreakByTruncatingMiddle
                    alignment: NSTextAlignmentCenter ];

   CGContextSetFillColorWithColor(context_, (negativeValue != 0) ? [UIColor redTextColor].CGColor : [UIColor grayTextColor].CGColor);
   [ negative_Str_ drawInRect: right_Label_Rect_
                     withFont: font_
                lineBreakMode: NSLineBreakByTruncatingMiddle
                    alignment: NSTextAlignmentCenter ];
}

-(void)drawArcWithContext: (CGContextRef)context_
                  andRect: (CGRect)rect_
          andStartPercent: (CGFloat)start_
            andEndPercent: (CGFloat)end_
                 andColor: (UIColor*)color_
{
   CGFloat line_width_ = (MIN(rect_.size.width, rect_.size.height) - offset) / lineWidthRatio;

   CGContextSetLineWidth(context_, line_width_);
   CGContextSetStrokeColorWithColor(context_, /*color_.CGColor*/[UIColor colorWithPatternImage: [PFAccountSpeedometr gradientImageWithSize: rect_.size andColor: color_]].CGColor);
   CGContextBeginPath(context_);
   CGContextAddArc(context_,
                   CGRectGetMidX(rect_),
                   CGRectGetMidY(rect_),
                   MIN(CGRectGetMidX(rect_), CGRectGetMidY(rect_)) - offset - line_width_ / 2.0f,
                   [self radianFromPercents: start_],
                   [self radianFromPercents: end_], NO);
   CGContextStrokePath(context_);
}

-(void)redrawWithPositiveValue: (double)pos_
              andNegativeValue: (double)neg_
{
   positiveValue = pos_;
   negativeValue = neg_;
   [self setNeedsDisplay];
}

-(CGFloat)radianFromPercents: (CGFloat)percents_
{
   return (endArk - startArk)/100 * percents_ + startArk;
}

-(CGFloat)borderLineInPercent
{
   return 100/(positiveValue - negativeValue) * (-negativeValue) ;
}

+(UIColor *)gradientImageWithLabel:( UILabel* )label_
                  andColor:( UIColor* )color_
{
   return [ UIColor colorWithPatternImage:[ self gradientImageWithSize: [label_.text sizeWithFont: label_.font] andColor: color_ ] ];
}

+(UIImage *)gradientImageWithSize:( CGSize )size_
                  andColor:( UIColor* )color_
{
   CGFloat width_ = size_.width;
   CGFloat height_ = size_.height;

   UIGraphicsBeginImageContext(CGSizeMake(width_, height_));

   CGContextRef context_ = UIGraphicsGetCurrentContext();

   UIGraphicsPushContext(context_);

   CGGradientRef gloss_gradient_;
   CGColorSpaceRef rgb_color_space_;
   size_t num_locations_ = 2;
   CGFloat locations_[2] = { 0.0, 1.0 };

   CGFloat red_, green_, blue_;
   CGFloat red_end_, green_end_, blue_end_;
   [color_ getRed: &red_ green: &green_ blue: &blue_ alpha: nil];

   if (CGColorEqualToColor(color_.CGColor, [UIColor grayTextColor].CGColor))
   {
      red_end_   = red_   - 0.2;
      green_end_ = green_ - 0.2;
      blue_end_  = blue_  - 0.2;
   }
   else if (CGColorEqualToColor(color_.CGColor, [UIColor blackColor].CGColor))
   {
      red_end_ = 0;
      green_end_ = 0;
      blue_end_ = 0;
   }
   else if (CGColorEqualToColor(color_.CGColor, [UIColor greenTextColor].CGColor))
   {
      red_end_ = 40.0 / 255.0;
      green_end_ = 240.0 / 255.0;
      blue_end_ = 157.0 / 255.0;

      red_ = 30.0 / 255.0;
      green_ = 240.0 / 255.0;
      blue_ = 30.0 / 255.0;
   }
   else if (CGColorEqualToColor(color_.CGColor, [UIColor redTextColor].CGColor))
   {
      red_end_ = red_;
      green_end_ = green_+.1;
      blue_end_ = blue_+.1;

      red_ = 1.0;
      green_ = 0.0;
      blue_ = 0.0;
   }
   else
   {
      red_end_ = 0;
      green_end_ = 0;
      blue_end_ = 0;
   }

   CGFloat components_[8] = { red_,     green_,     blue_,     1.0,   // Start color
                              red_end_, green_end_, blue_end_, 1.0 }; // End color
   rgb_color_space_ = CGColorSpaceCreateDeviceRGB();
   gloss_gradient_ = CGGradientCreateWithColorComponents(rgb_color_space_, components_, locations_, num_locations_);
   CGPoint top_center_ = CGPointMake(0, 0);
   CGPoint bottom_center_ = CGPointMake(0, size_.height);
   CGContextDrawLinearGradient(context_, gloss_gradient_, top_center_, bottom_center_, 0);

   CGGradientRelease(gloss_gradient_);
   CGColorSpaceRelease(rgb_color_space_);

   UIGraphicsPopContext();

   UIImage *gradient_image_ = UIGraphicsGetImageFromCurrentImageContext();

   UIGraphicsEndImageContext();

   return gradient_image_;
}

@end
