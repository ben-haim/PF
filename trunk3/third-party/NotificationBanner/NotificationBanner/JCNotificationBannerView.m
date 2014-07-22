#import "JCNotificationBannerView.h"

const CGFloat kJCNotificationBannerViewOutlineWidth = 2;
const CGFloat kJCNotificationBannerViewMargin = 5;

@interface JCNotificationBannerView () {
  BOOL isPresented;
  NSObject* isPresentedMutex;
}

- (void) handleSingleTap:(UIGestureRecognizer *)gestureRecognizer;

@end

@implementation JCNotificationBannerView

@synthesize notificationBanner;
@synthesize iconImageView;
@synthesize titleLabel;
@synthesize messageLabel;

- (id) initWithNotification:(JCNotificationBanner*)notification {
  self = [super init];
  if (self) {
    isPresentedMutex = [NSObject new];

     UIColor* text_color_ = [ UIColor colorWithRed: 34.f / 255 green: 34.f / 255 blue: 34.f / 255 alpha: 1.f ];
    self.backgroundColor = [UIColor whiteColor];
     self.iconImageView = [[ UIImageView alloc ] initWithImage: [ UIImage imageNamed: @"Icon-Small" ]];
     self.iconImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:self.iconImageView];
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = text_color_;
    self.titleLabel.backgroundColor = [UIColor clearColor];
     self.titleLabel.shadowOffset = CGSizeMake(0.f, 0.f);
    [self addSubview:self.titleLabel];
    self.messageLabel = [UILabel new];
    self.messageLabel.font = [UIFont systemFontOfSize:14];
    self.messageLabel.textColor = text_color_;
    self.messageLabel.backgroundColor = [UIColor clearColor];
      self.messageLabel.shadowOffset = CGSizeMake(0.f, 0.f);
    [self addSubview:self.messageLabel];

    UITapGestureRecognizer* tapRecognizer;
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(handleSingleTap:)];
    [self addGestureRecognizer:tapRecognizer];

    self.notificationBanner = notification;
  }
  return self;
}

- (void) drawRect:(CGRect)rect {
  CGRect bounds = self.bounds;

  CGFloat lineWidth = kJCNotificationBannerViewOutlineWidth;
  CGFloat radius = 10;
  CGFloat height = bounds.size.height;
  CGFloat width = bounds.size.width;

  CGContextRef context = UIGraphicsGetCurrentContext();

  CGContextSetAllowsAntialiasing(context, true);
  CGContextSetShouldAntialias(context, true);

  CGMutablePathRef outlinePath = CGPathCreateMutable();

  CGPathMoveToPoint(outlinePath, NULL, lineWidth, 0);
  CGPathAddLineToPoint(outlinePath, NULL, lineWidth, height - radius - lineWidth);
  CGPathAddArc(outlinePath, NULL, radius + lineWidth, height - radius - lineWidth, radius, -M_PI, M_PI_2, 1);
  CGPathAddLineToPoint(outlinePath, NULL, width - radius - lineWidth, height - lineWidth);
  CGPathAddArc(outlinePath, NULL, width - radius - lineWidth, height - radius - lineWidth, radius, M_PI_2, 0, 1);
  CGPathAddLineToPoint(outlinePath, NULL, width - lineWidth, 0);

   CGContextSetRGBStrokeColor(context, 1.f, 1.f, 1.f, 1.f);
   
  CGContextSetRGBFillColor(context, 1.f, 1.f, 1.f, 1.f);
  CGContextAddPath(context, outlinePath);
  CGContextFillPath(context);

  CGContextAddPath(context, outlinePath);
  CGContextSetRGBFillColor(context, 1.f, 1.f, 1.f, 1.f);
  CGContextSetLineWidth(context, lineWidth);
  CGContextDrawPath(context, kCGPathStroke);

  CGPathRelease(outlinePath);
}

- (void) layoutSubviews {
  if (!(self.frame.size.width > 0)) { return; }

  CGFloat totalBorder = kJCNotificationBannerViewOutlineWidth + kJCNotificationBannerViewMargin;
  CGFloat currentX = kJCNotificationBannerViewOutlineWidth + kJCNotificationBannerViewMargin;
  CGFloat y = kJCNotificationBannerViewOutlineWidth + kJCNotificationBannerViewMargin;
  CGFloat contentHeight = self.frame.size.height - (totalBorder * 2);
  CGFloat contentWidth = self.frame.size.width - (totalBorder * 2);

  self.iconImageView.frame = CGRectMake(currentX, y, contentHeight, contentHeight);
  currentX += contentHeight + kJCNotificationBannerViewMargin;

  CGFloat textWidth = contentWidth - contentHeight - kJCNotificationBannerViewMargin;
   self.titleLabel.frame = CGRectMake(currentX, y + 2, textWidth, self.bounds.size.height - 2*( y + 2 ) );
   //self.titleLabel.frame = CGRectMake(currentX, y + 2, textWidth, 22);
  //self.messageLabel.frame = CGRectMake(currentX, y + 24, textWidth, 18);
}

- (void) setNotificationBanner:(JCNotificationBanner*)notification {
  notificationBanner = notification;

  self.titleLabel.text = notification.title;
  self.messageLabel.text = notification.message;
}

- (void) handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
  if (notificationBanner && notificationBanner.tapHandler) {
    notificationBanner.tapHandler();
  }
}

- (BOOL) getCurrentPresentingStateAndAtomicallySetPresentingState:(BOOL)state {
  @synchronized(isPresentedMutex) {
    BOOL originalState = isPresented;
    isPresented = state;
    return originalState;
  }
}

@end
