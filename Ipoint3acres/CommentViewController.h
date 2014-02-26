//
//  CommentViewController.h
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/02/26.
//  Copyright (c) 2014年 YUAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSPDFTextView.h"

@interface CommentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet PSPDFTextView *textView;
- (IBAction)cancel:(id)sender;
- (IBAction)send:(id)sender;

@end
