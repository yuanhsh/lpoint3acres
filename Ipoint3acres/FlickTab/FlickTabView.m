//
//  FlickTabView.m
//  FlickTabControl
//
//  Created by Shaun Harrison on 12/12/08.
//  Copyright 2008 enormego. All rights reserved.
//

#import "FlickTabView.h"
#import "FlickTabButton.h"

@interface FlickTabView (Private)
- (void)setupCaps;
@end


@implementation FlickTabView
@synthesize scrollView, leftCap, rightCap, delegate, dataSource, buttonInsets, bottomLine, upArrow;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configure];
    }
    return self;
}

- (void)configure {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, TAB_HEIGHT)] autorelease];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    scrollView.directionalLockEnabled = YES;
    scrollView.alwaysBounceVertical = NO;
    scrollView.alwaysBounceHorizontal = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = YES;
    scrollView.contentInset = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f);
    scrollView.delegate = self;
    
    UIImageView* upArrow0 = [[UIImageView alloc] initWithFrame:CGRectMake(-20.0f, TAB_HEIGHT-9, 16, 8)];
    upArrow0.image = [UIImage imageNamed:@"uparrow.png"];
    upArrow0.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    self.upArrow = upArrow0;
    [upArrow0 release];
    
    UIImageView* leftCap0 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 39.0f, TAB_HEIGHT)];
    leftCap0.image = [UIImage imageNamed:@"prevArrow.png"];
    leftCap0.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    self.leftCap = leftCap0;
    [leftCap0 release];
    
    UIImageView* rightCap0 = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-39.0f, 0.0f, 39.0f, TAB_HEIGHT)];
    rightCap0.image = [UIImage imageNamed:@"nextArrow.png"];
    rightCap0.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    self.rightCap = rightCap0;
    [rightCap0 release];
    
    bottomLine = [[[UIImageView alloc] initWithFrame:CGRectMake(0, TAB_HEIGHT-1, 320, 5)] autorelease];
    bottomLine.image = [[UIImage imageNamed:@"blueline.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
    bottomLine.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    
    [self addSubview:self.scrollView];
    [self addSubview:self.upArrow];
    [self addSubview:self.leftCap];
    [self addSubview:self.rightCap];
    [self addSubview:self.bottomLine];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOrientation) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configure];
	scrollView.scrollsToTop = NO;
	[self reloadData];
	
	if(scrollView.subviews && scrollView.subviews.count > 0) {
		[(FlickTabButton*)[scrollView.subviews objectAtIndex:0] markSelected];
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOrientation) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)presentTabs {
    scrollView.scrollsToTop = NO;
	[self reloadData];
	
	if(scrollView.subviews && scrollView.subviews.count > 0) {
		[(FlickTabButton*)[scrollView.subviews objectAtIndex:0] markSelected];
	}
}

- (void)reloadData {
	if(scrollView.subviews && scrollView.subviews.count > 0) {
		[scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	}
	
	if(!self.dataSource) {
		return;
	}
	
	NSInteger items;
	
	if((items = [self.dataSource numberOfTabsInScrollTabView:self]) == 0) {
		return;
	}
	
	NSInteger x;
	
	float origin_x = 0;
	for(x=0;x<items;x++) {
		NSString* str = [self.dataSource scrollTabView:self titleForTabAtIndex:x];
		
		FlickTabButton* button = [[FlickTabButton alloc] initWithFrame:CGRectZero];
		[button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
		
		CGSize size = [str sizeWithFont:button.font];
		
		button.frame = CGRectMake(origin_x, 0.0f, size.width+15.0f, TAB_HEIGHT);
		origin_x += size.width + 3.0f + 15.0f;
		button.text = str;
		
		[scrollView addSubview:button];
		
		[button release];
	}
	
	scrollView.contentSize = CGSizeMake(origin_x, TAB_HEIGHT);
	
	[self setupCaps];
}

- (void)buttonClicked:(FlickTabButton*)button {
    for (UIControl* subview in scrollView.subviews) {
        if (subview.selected) {
            CGPoint start = [scrollView convertPoint:subview.center toView:self];
            upArrow.center = CGPointMake(start.x, upArrow.center.y);
            break;
        }
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(scrollTabView:didSelectedTabAtIndex:)]) {
		[self.delegate scrollTabView:self didSelectedTabAtIndex:[scrollView.subviews indexOfObject:button]];
	}
    
	[scrollView.subviews makeObjectsPerformSelector:@selector(markUnselected)];
//	[button markSelected];
    upArrow.hidden = NO;
    CGPoint newCenter = [scrollView convertPoint:button.center toView:self];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         upArrow.center = CGPointMake(newCenter.x, upArrow.center.y);
                     }
                     completion:^(BOOL finished){
                         upArrow.hidden = YES;
                         [button markSelected];
                     }];
}

- (void)selectTabAtIndex:(NSInteger)index {
	[self selectTabAtIndex:index animated:NO];
}

- (void)selectTabAtIndex:(NSInteger)index animated:(BOOL)animated {
	if(!scrollView.subviews || scrollView.subviews.count < index+1) return;
    
    // added by Yuan
    if ([self selectedTabIndex] == index) {
        return;
    }
	
	[scrollView.subviews makeObjectsPerformSelector:@selector(markUnselected)];
//	[(FlickTabButton*)[scrollView.subviews objectAtIndex:index] markSelected];
	
	CGRect rect = ((FlickTabButton*)[scrollView.subviews objectAtIndex:index]).frame;
	rect.size.width += 25.0f;
	
	[scrollView scrollRectToVisible:rect animated:animated];
	
	[self setupCaps];
    
    // added by Yuan
    FlickTabButton *btn = [scrollView.subviews objectAtIndex:index];
    [self buttonClicked:btn];
}

- (void)updateOrientation {
	[self performSelector:@selector(setupCaps) withObject:nil afterDelay:0.3];
}

- (void)setupCaps {
	if(scrollView.contentSize.width <= scrollView.frame.size.width - scrollView.contentInset.left - scrollView.contentInset.right) {
		leftCap.hidden = YES;
		rightCap.hidden = YES;
	} else {
		if(scrollView.contentOffset.x > (-scrollView.contentInset.left)+10.0f) {
			leftCap.hidden = NO;
		} else {
			leftCap.hidden = YES;
		}
		
		if((scrollView.frame.size.width+scrollView.contentOffset.x)+10.0f >= scrollView.contentSize.width) {
			rightCap.hidden = YES;
		} else {
			rightCap.hidden = NO;
		}
	}
	
}

- (void)scrollViewDidScroll:(UIScrollView *)inScrollView {
	[self setupCaps];
}

- (NSInteger)selectedTabIndex {
	int x = 0;
	
	for(FlickTabButton* tab in scrollView.subviews) {
		if([tab isMemberOfClass:[FlickTabButton class]]) {
			if([tab isSelected]) return x;
		}
		
		x++;
	}
	
	return NSNotFound;
}

- (void)setButtonInsets:(UIEdgeInsets)insets {
	buttonInsets = UIEdgeInsetsMake(0.0f, insets.left, 0.0f, insets.right);
	self.scrollView.contentInset = buttonInsets;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
	[scrollView release];
	[leftCap release];
	[rightCap release];
    [bottomLine release];
    [upArrow release];
    [super dealloc];
}


@end
