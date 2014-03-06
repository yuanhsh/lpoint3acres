//
//  CommentViewController.h
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/02/26.
//  Copyright (c) 2014年 YUAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSPDFTextView.h"
#import "Models.h"
#import "ServiceClient.h"

@interface CommentViewController : UIViewController <WebServiceDelegate>
@property (weak, nonatomic) Comment *comment;
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet PSPDFTextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)cancel:(id)sender;
- (IBAction)send:(id)sender;

@end
