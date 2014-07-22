//
//  ArrowsLayer.h
//  XiP
//
//  Created by Alexandros Ioannou on 3/23/12.
//  Copyright (c) 2012 Xogee. All rights reserved.
//

#import "BaseBoxLayer.h"

@interface ArrowsLayer : BaseBoxLayer
{
    NSString* mUpData;
    NSString* mDownData;
    uint mUpArrowsColor;
    uint mDownArrowsColor;
}

@property (nonatomic, strong) NSString* mUpData; 
@property (nonatomic, strong) NSString* mDownData;
@property (assign) uint mUpArrowsColor;
@property (assign) uint mDownArrowsColor;

- (id)initWithDataStore:(BaseDataStore*)_DataStore 
            ParentChart:(XYChart*)_parentChart
              UpData:(NSString*)upData
              DownData:(NSString*)downData 
              LayerName:(NSString*)_layerName
                UpArrowsColor:(uint)upArrowsColor
                DownArrowsColor:(uint)downArrowsColor;

@end
