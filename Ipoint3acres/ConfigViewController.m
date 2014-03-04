//
//  ConfigViewController.m
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/03/04.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import "ConfigViewController.h"

@interface ConfigViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *viewTopSwitch;

@end

@implementation ConfigViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    NSDictionary *textAttributes = @{UITextAttributeTextColor: [UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onViewTopValueChange:(id)sender {
    
}

- (IBAction)onDone:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
