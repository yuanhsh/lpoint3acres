//
//  ConfigViewController.m
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/03/04.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import "ConfigViewController.h"
#import "Appirater.h"

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
    NSLog(@"onViewTopValueChange");
}

- (IBAction)onDone:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark TableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1) {
        switch ((int32_t)indexPath.item) {
            case 1:
                [self rateThisApp];
                break;
            case 2:
                [self writeFeedBack];
                break;
            default:
                break;
        }
    }
}

- (void)rateThisApp {
    [Appirater rateApp];
}

- (void)writeFeedBack {
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:@"关于一亩三分地iOS版的意见"];
        [mc setTitle:@"意见反馈"];
        [mc setMessageBody:@"" isHTML:NO];
        [mc setToRecipients:@[@"7sgame.com@gmail.com"]];
        
        mc.navigationBar.translucent = NO;
        mc.navigationBar.tintColor = [UIColor whiteColor];
        mc.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor]};
        
        [self.navigationController presentViewController:mc animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Mail Accounts" message:@"Please set up a Mail account in order to send email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed: {
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mail sent failure" message:@"邮件发送失败！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            break;
        }
        default:
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
