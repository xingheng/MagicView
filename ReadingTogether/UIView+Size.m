//
//  UIView+Size.m
//  ReadingTogether
//
//  Created by WeiHan on 1/14/15.
//  Copyright (c) 2015 Wei Han. All rights reserved.
//

#import "UIView+Size.h"

@implementation UIView (Size)

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}


- (CGFloat)top
{
    return self.frame.origin.y;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

@end
