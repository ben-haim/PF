@implementation UINavigationController (RotationIOS6)

-(BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;//UIInterfaceOrientationMaskPortraitUpsideDown | UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end

@implementation UIViewController (RotationIOS6)

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;//UIInterfaceOrientationMaskPortraitUpsideDown | UIInterfaceOrientationMaskPortrait;
}

@end

