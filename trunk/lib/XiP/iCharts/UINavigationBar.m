//
//  UINavigationBar.m
//  IronForex
//
//  Created by Xogee Limited on 13/12/2010.
//  Copyright 2010 IronForex. All rights reserved.
//



@implementation UINavigationBar (CustomImage)


- (void)drawRect:(CGRect)rect{
	//self.bounds = CGRectMake(0, 0, 769, 49);
	UIImage *image = [UIImage imageNamed:@"navigation_bar.png"];
	//[image drawInRect:CGRectMake(0, 0, 768, 49)];
	[image drawInRect:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, 49)];
}

- (void)setBackgroundImage:(UIImage*)image{
    if(image == NULL){ //might be called with NULL argument
        return;
    }
    UIImageView *aTabBarBackground = [[UIImageView alloc]initWithImage:image];
    aTabBarBackground.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
    [self addSubview:aTabBarBackground];
    [self sendSubviewToBack:aTabBarBackground];
    [aTabBarBackground release];
}

@end
