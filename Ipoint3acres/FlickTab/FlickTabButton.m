//
//  FlickTabButton.m
//  Enormego Frameworks
//
//  Created by Shaun Harrison on 12/12/08.
//  Copyright 2008 enormego. All rights reserved.
//

#import "FlickTabButton.h"
#import "FlickTabView.h"

#define unselectedColor [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f]
#define selectedColor [UIColor colorWithRed:0/255.0f green:122/255.0f blue:255/255.0f alpha:1.0f]

@implementation FlickTabButton

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, -1.0f, frame.size.width, frame.size.height)];
		imageView.backgroundColor = [UIColor clearColor];
		imageView.image = [[UIImage imageNamed:@"uparrow.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 0, 1)];
		imageView.hidden = YES;
        imageView.contentMode = UIViewContentModeBottom;
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, -1.0f, frame.size.width, frame.size.height)];
		label.textAlignment = NSTextAlignmentCenter;
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		label.backgroundColor = [UIColor clearColor];
//		label.font = [UIFont boldSystemFontOfSize:15.0f];
		label.textColor = unselectedColor;
		
		[self addSubview:imageView];
		[self addSubview:label];
		
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)setText:(NSString*)text {
	label.text = text;
    
    imageView.frame = CGRectMake(0.0f, -1.0f, label.frame.size.width, label.frame.size.height);
}

- (void)markSelected {
	label.textColor = selectedColor;
//	label.shadowColor = unselectedColor;
	imageView.hidden = NO;
	self.selected = YES;
}

- (void)markUnselected {
	label.textColor = unselectedColor;
//	label.shadowColor = unselectedShadowColor;
	imageView.hidden = YES;
	self.selected = NO;
}

- (NSString*)text {
	return label.text;
}

- (UIFont*)font {
	return label.font;
}

- (void)dealloc {
	[label release];
    [super dealloc];
}


@end
