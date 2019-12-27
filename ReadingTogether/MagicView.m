//
//  MagicView.m
//  ReadingTogether
//
//  Created by WeiHan on 1/14/15.
//  Copyright (c) 2015 Wei Han. All rights reserved.
//

#import "MagicView.h"

#define ClickEffect     1

#define kStrAllEventsNotification        @"kStrAllEventsNotification"

#if ClickEffect
#define kStrTouchBeginEventNotification          @"kStrTouchBeginEventNotification"
#define kStrTouchMovedEventNotification          @"kStrTouchMovedEventNotification"
#endif

#define kStrSelectorKey             @"kStrSelectorKey"
#define kStrReceiverKey             @"kStrReceiverKey"
#define kStrUIEventKey              @"kStrUIEventKey"


@interface MagicView()
{
    UILabel *resultLabel;
}

@end

@implementation MagicView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor lightGrayColor];
        self.clipsToBounds = YES;
        
        resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 300, 50)];
        resultLabel.textColor = [UIColor blueColor];
        resultLabel.font = [UIFont systemFontOfSize:20];
        resultLabel.text = @"(Result)";
        [self addSubview:resultLabel];
        
        
        [self addTarget:self action:@selector(triggerEvent:) forControlEvents:UIControlEventAllEvents];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(triggerNotification:)
                                                     name:kStrAllEventsNotification
                                                   object:nil];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat width = rect.size.width, height = rect.size.height, margin = 5;
    CGRect arrRect[4] = {CGRectMake(0, 0, width, margin),
                        CGRectMake(width - margin, 0, margin, height),
                        CGRectMake(0, height - margin, width, margin),
                        CGRectMake(0, 0, margin, height)};
    CGContextAddRects(ctx, arrRect, sizeof(arrRect) / sizeof(arrRect[0]));
    CGContextSetFillColor(ctx, CGColorGetComponents([[[UIColor redColor] colorWithAlphaComponent:0.6] CGColor]));
    CGContextFillPath(ctx);
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:30], NSParagraphStyleAttributeName: paragraphStyle};
    
    [[NSString stringWithFormat:@"%@", _identifier] drawWithRect:CGRectMake(width / 2 - 100, height / 2, 300, 100)
                         options:NSStringDrawingTruncatesLastVisibleLine
                      attributes:attributes
                         context:nil];
}

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    [super sendAction:action to:target forEvent:event];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kStrAllEventsNotification object:@{kStrSelectorKey: NSStringFromSelector(action), kStrReceiverKey: target, kStrUIEventKey: event}];
}

#pragma mark -

- (void)triggerEvent:(id)sender
{
    NSLog(@"triggerEvent: id: %@ sender: %@", _identifier, sender);
}

- (void)triggerNotification:(NSNotification*)notification
{
    NSDictionary *obj = notification.object;
    id receiver = [obj objectForKey:kStrReceiverKey];
    
    if ([self isEqual:receiver])
        return;
    
    SEL action = NSSelectorFromString([obj objectForKey:kStrSelectorKey]);
    UIEvent *event = [obj objectForKey:kStrUIEventKey];
    
    
//    NSLog(@"sendAction: id: %@ event: %@", _identifier, event);
    
    UITouch *touch = [[event allTouches] allObjects][0];
    if (touch.phase == UITouchPhaseBegan)
    {
        [self touchesBegan:[event allTouches] withEvent:nil];
    }
    else if (touch.phase == UITouchPhaseMoved)
    {
        [self touchesMoved:[event allTouches] withEvent:nil];
    }
    else
    {
        [super sendAction:action to:self forEvent:event];
    }
}

/*
- (void)triggerTouchEvent:(NSNotification*)notification
{
    NSDictionary *obj = notification.object;
    id receiver = [obj objectForKey:kStrReceiverKey];
    
    if ([self isEqual:receiver])
        return;
    
    SEL action = NSSelectorFromString([obj objectForKey:kStrSelectorKey]);
    UIEvent *event = [obj objectForKey:kStrUIEventKey];
    
    [super sendAction:action to:self forEvent:event];
}
 */

- (void)showResultPoint:(CGPoint)point
{
    resultLabel.text = [NSString stringWithFormat:@"x:%f, y:%f", point.x, point.y];
}

#pragma mark - ClickEffect

#if ClickEffect

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (event)
        [super touchesBegan:touches withEvent:event];
    
    CGPoint touchPoint= [[touches anyObject]locationInView:self.superview];
    [self showResultPoint:touchPoint];
    CALayer *waveLayer= [CALayer layer];
    waveLayer.frame = CGRectMake(touchPoint.x-1, touchPoint.y-1, 10, 10);
    int colorInt=arc4random()%7;
    switch (colorInt) {
        case 0:
            waveLayer.borderColor = [UIColor redColor].CGColor;
            break;
        case 1:
            waveLayer.borderColor = [UIColor grayColor].CGColor;
            break;
        case 2:
            waveLayer.borderColor = [UIColor purpleColor].CGColor;
            break;
        case 3:
            waveLayer.borderColor = [UIColor orangeColor].CGColor;
            break;
        case 4:
            waveLayer.borderColor = [UIColor yellowColor].CGColor;
            break;
        case 5:
            waveLayer.borderColor = [UIColor greenColor].CGColor;
            break;
        case 6:
            waveLayer.borderColor = [UIColor blueColor].CGColor;
            break;
        default:
            waveLayer.borderColor = [UIColor blackColor].CGColor;
            break;
    }
    waveLayer.borderWidth =0.5;
    waveLayer.cornerRadius =5.0;
    
    [self.layer addSublayer:waveLayer];
    [self scaleBegin:waveLayer];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (event)
        [super touchesMoved:touches withEvent:event];
    
    CGPoint touchPoint= [[touches anyObject]locationInView:self.superview];
    [self showResultPoint:touchPoint];
    CALayer *waveLayer= [CALayer layer];
    waveLayer.frame = CGRectMake(touchPoint.x-1, touchPoint.y-1, 10, 10);
    int colorInt=arc4random()%7;
    switch (colorInt) {
        case 0:
            waveLayer.borderColor = [UIColor redColor].CGColor;
            break;
        case 1:
            waveLayer.borderColor = [UIColor grayColor].CGColor;
            break;
        case 2:
            waveLayer.borderColor = [UIColor purpleColor].CGColor;
            break;
        case 3:
            waveLayer.borderColor = [UIColor orangeColor].CGColor;
            break;
        case 4:
            waveLayer.borderColor = [UIColor yellowColor].CGColor;
            break;
        case 5:
            waveLayer.borderColor = [UIColor greenColor].CGColor;
            break;
        case 6:
            waveLayer.borderColor = [UIColor blueColor].CGColor;
            break;
        default:
            waveLayer.borderColor = [UIColor blackColor].CGColor;
            break;
    }
    
    
    waveLayer.borderWidth =0.5;
    waveLayer.cornerRadius =5.0;
    
    [self.layer addSublayer:waveLayer];
    [self scaleBegin:waveLayer];
}

-(void)scaleBegin:(CALayer *)aLayer
{
    const float maxScale=120.0;
    if (aLayer.transform.m11<maxScale) {
        if (aLayer.transform.m11==1.0) {
            [aLayer setTransform:CATransform3DMakeScale( 1.1, 1.1, 1.0)];
            
        }else{
            [aLayer setTransform:CATransform3DScale(aLayer.transform, 1.1, 1.1, 1.0)];
        }
        [self performSelector:_cmd withObject:aLayer afterDelay:0.03];
    }else [aLayer removeFromSuperlayer];
}

#endif // ClickEffect

@end
