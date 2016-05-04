//
//  UIView+Frame.m
//
//  Created by xiaomage on 14/3/14.
//  Copyright © 2014年 MR.z. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

/*--------------------------------------------------------------------------*/

- (void)setZb_centerX:(CGFloat)zb_centerX
{
    CGPoint center = self.center;
    center.x = zb_centerX;
    self.center = center;
}

- (CGFloat)zb_centerX
{
    return self.center.x;
}
/*--------------------------------------------------------------------------*/
- (void)setZb_centerY:(CGFloat)zb_centerY
{
    CGPoint center = self.center;
    center.y = zb_centerY;
    self.center = center;
}
- (CGFloat)zb_centerY
{
    return self.center.y;
}

/*--------------------------------------------------------------------------*/


- (void)setZb_X:(CGFloat)zb_X {
    CGRect frame = self.frame;
    frame.origin.x = zb_X;
    self.frame = frame;
}

-(CGFloat)zb_X {
    return self.frame.origin.x;
}

/*--------------------------------------------------------------------------*/

- (void)setZb_Y:(CGFloat)zb_Y {
    CGRect frame = self.frame;
    frame.origin.y = zb_Y;
    self.frame = frame;
}

- (CGFloat)zb_Y {
    return self.frame.origin.y;
}
/*--------------------------------------------------------------------------*/

- (void)setZb_width:(CGFloat)zb_width {
    
    CGRect frame = self.frame;
    frame.size.width = zb_width;
    self.frame = frame;
}

- (CGFloat)zb_width {
    return self.frame.size.width;
}
/*--------------------------------------------------------------------------*/


- (void)setZb_height:(CGFloat)zb_height {
    CGRect frame = self.frame;
    frame.size.height = zb_height;
    self.frame = frame;
}

- (CGFloat)zb_height {
    return self.frame.size.height;
}



/*--------------------------------------------------------------------------*/

- (void)setZb_size:(CGSize)zb_size{
    
    CGRect frame = self.frame;
    frame.size = zb_size;
    self.frame = frame;
}

- (CGSize)zb_size{
    
    return self.frame.size;
}

/*--------------------------------------------------------------------------*/

-(void)setZb_origin:(CGPoint)zb_origin{
    
    CGRect frame = self.frame;
    frame.origin = zb_origin;
    self.frame = frame;
}
-(CGPoint)zb_origin{

    return self.frame.origin;
}





@end
