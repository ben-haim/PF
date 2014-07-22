//
//  utils.c
//  XiP
//
//  Created by Xogee MacBook on 05/07/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import "utils.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>



void SetContextLineDash(CGContextRef ctx, uint linedash)
{
    switch (linedash) 
    {
        case 1:
        {
            CGFloat dashLengths[] = CHART_DASH_1;
            CGContextSetLineDash(	ctx, 0, dashLengths, sizeof( dashLengths ) / sizeof( CGFloat ) );
        }
        break;
        case 2:
        {
            CGFloat dashLengths[] = CHART_DASH_2;
            CGContextSetLineDash(	ctx, 0, dashLengths, sizeof( dashLengths ) / sizeof( CGFloat ) );
        }
            break;
        case 3:
        {
            CGFloat dashLengths[] = CHART_DASH_3;
            CGContextSetLineDash(	ctx, 0, dashLengths, sizeof( dashLengths ) / sizeof( CGFloat ) );
        }
            break;
        case 4:
        {
            CGFloat dashLengths[] = CHART_DASH_4;
            CGContextSetLineDash(	ctx, 0, dashLengths, sizeof( dashLengths ) / sizeof( CGFloat ) );
        }
            break;
            
        default:
            break;
    }
}

@implementation Utils

+ (float) getChartGridRightCellSize:(CGRect)chartFrame
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat chartWidth = chartFrame.size.width;
        float frameRatio = (chartWidth * 2) / screenWidth;
        float endPosition = CHART_GRID_RIGHT_CELLSIZE * frameRatio;
        return endPosition;
    }
    else
    {
        return CHART_GRID_RIGHT_CELLSIZE;
    }
}

+ (float) getFontSize
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return 9.0f;
    }
    else
    {
        return 7.0f;
    }
}

+ (float) getSmallFontSize
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return 8.0f;
    }
    else
    {
        return 6.0f;
    }
}

+ (int)getMinZoom
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return 20;
    }
    else
    {
        return 20;
    }
}

+ (int)getMaxZoom
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return 1000;
    }
    else
    {
        return 500;
    }
}

+ (double)getYAxisWidth
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return 42.0;
    }
    else
    {
        return 36.0;
    }
}

+ (RgbColor)rgbColorFromColor:(UIColor *)color {
    RgbColor rgbColor;
    
    CGColorRef cgColor = [color CGColor];
    const CGFloat *colorComponents = CGColorGetComponents(cgColor);
    rgbColor.red = colorComponents[COLOR_COMPONENT_RED_INDEX];
    rgbColor.green = colorComponents[COLOR_COMPONENT_GREEN_INDEX];
    rgbColor.blue = colorComponents[COLOR_COMPONENT_BLUE_INDEX];
    
    rgbColor.redValue = (int)(rgbColor.red * COLOR_COMPONENT_SCALE_FACTOR);
    rgbColor.greenValue = (int)(rgbColor.green * COLOR_COMPONENT_SCALE_FACTOR);
    rgbColor.blueValue = (int)(rgbColor.blue * COLOR_COMPONENT_SCALE_FACTOR);
    
    return rgbColor;
}

+ (HsvColor)hsvColorFromRgbColor:(RgbColor)color {
    HsvColor hsvColor;
    
    CGFloat maximumValue = MAX(color.red, color.green);
    maximumValue = MAX(maximumValue, color.blue);
    CGFloat minimumValue = MIN(color.red, color.green);
    minimumValue = MIN(minimumValue, color.blue);
    CGFloat range = maximumValue - minimumValue;
    
    hsvColor.hueValue = 0;
    if (maximumValue == minimumValue) {
        // continue
    }
    else if (maximumValue == color.red) {
        hsvColor.hueValue = 
        (int)roundf(COMPONENT_DOMAIN_DEGREES * (color.green - color.blue) / range);
        if (hsvColor.hueValue < 0) {
            hsvColor.hueValue += COMPONENT_MAXIMUM_DEGREES;
        }
    }
    else if (maximumValue == color.green) {
        hsvColor.hueValue = 
        (int)roundf(((COMPONENT_DOMAIN_DEGREES * (color.blue - color.red) / range) + 
                     COMPONENT_OFFSET_DEGREES_GREEN));
    }
    else if (maximumValue == color.blue) {
        hsvColor.hueValue = 
        (int)roundf(((COMPONENT_DOMAIN_DEGREES * (color.red - color.green) / range) + 
                     COMPONENT_OFFSET_DEGREES_BLUE));
    }
    
    hsvColor.saturationValue = 0;
    if (maximumValue == 0.0f) {
        // continue
    }
    else {
        hsvColor.saturationValue = 
        (int)roundf(((1.0f - (minimumValue / maximumValue)) * COMPONENT_PERCENTAGE));
    }
    
    hsvColor.brightnessValue = (int)roundf((maximumValue * COMPONENT_PERCENTAGE));
    
    hsvColor.hue = (float)hsvColor.hueValue / COMPONENT_MAXIMUM_DEGREES;
    hsvColor.saturation = (float)hsvColor.saturationValue / COMPONENT_PERCENTAGE;
    hsvColor.brightness = (float)hsvColor.brightnessValue / COMPONENT_PERCENTAGE;
    
    return hsvColor;
}

+ (HsvColor)hsvColorFromColor:(UIColor *)color {
    RgbColor rgbColor = [Utils rgbColorFromColor:color];
    return [Utils hsvColorFromRgbColor:rgbColor];
}


@end