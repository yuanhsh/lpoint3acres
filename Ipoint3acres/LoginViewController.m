//
//  LoginViewController.m
//  Ipoint3acres
//
//  Created by YUAN on 14-2-17.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import "LoginViewController.h"
#import "SVProgressHUD.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder && [nextResponder isKindOfClass:[UITextField class]]) {
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        if ([nextResponder isKindOfClass:[UIButton class]]) {
            [self login:nextResponder];
        }
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (IBAction)login:(id)sender {
    ServiceClient *client = [[ServiceClient alloc] init];
    client.delegate = self;
    [SVProgressHUD showWithStatus:@"登录中..."];
    [client loginWithUsername:self.username.text password:self.password.text];
}

- (void)loginSuccessed {
    NSLog(@"Success Login!");
    [SVProgressHUD dismiss];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    /**
     <?xml version="1.0" encoding="gbk"?>
     <root><![CDATA[<script type="text/javascript" reload="1">if(typeof succeedhandle_ls=='function') {succeedhandle_ls('http://www.1point3acres.com/bbs/./', '欢迎您回来，中级农民-加分请看右边栏-多参与|分享|记录|反馈 yuanhsh，现在将转入登录前页面', {'username':'yuanhsh','usergroup':'中级农民-加分请看右边栏-多参与|分享|记录|反馈','uid':'50994','groupid':'12','syn':'1'});}hideWindow('ls');showDialog('欢迎您回来，中级农民-加分请看右边栏-多参与|分享|记录|反馈 yuanhsh，现在将转入登录前页面', 'notice', null, function () { window.location.href ='http://www.1point3acres.com/bbs/./'; }, 0, null, null, null, null, null, 3);</script><script type="text/javascript" src="http://www.1point3acres.com/bbs/api/uc.php?time=1392647694&code=f4a1GfRtkQAV31afwG%2BfBw9cRCyy3HItulEw8DC%2F3ceAZ0PKTSDH%2BtwXmr5tuF%2Fifg2yCByGyOY%2Bz05DOGFWpWto3Xs3izzwyZM2kOMuH3vscJY29zgdiRm1ZVcoFN2eK1JxmtfvA6r9vu3nRK5e3Y%2F1m8b8CU6nIAWWv%2BLzamvK" reload="1"></script><script type="text/javascript" src="http://www.1point3acres.com/wiki/extensions/Auth_UC/api/uc.php?time=1392647694&code=69c4%2FDgS%2BFjgXvMnLdJjqhWGyZNfavI%2B5mXd3%2FuTYUz1kfLJFRAWkKr%2Fl9vcZyfRW7D%2BlrTUwgXY05OCWA0kKknoYoSL%2FVIcA5aJ1DXUWqnfjft8N6WlrkdBxcDM1%2FyhkYIVUWlO9l8b1hzZf9K4usI8etyp8l4oTnaAaFDLCnuq" reload="1"></script><script type="text/javascript" src="http://www.1point3acres.com/wp-content/plugins/ucenter-integration/api/?time=1392647694&code=18a10EYa9lvUJg%2FUCy4jnCZ29dNhzglQpw%2FMCHmUNVQkd%2BoK40McynnnopgCIz20NbLgi5w%2Bt0Wco2cU%2FVHElG83j4Tk8aa9C%2Bfle9%2Ffa%2BTo7ONbG%2BZM0RMEU8Vj3VNyKtDVCdjHCPwUL5O%2BhXLMVEJMAK2R1acpi7lKeblSgcM8" reload="1"></script><script type="text/javascript" src="http://www.1point3acres.com/wp-content/plugins/ucenter-integration/api/uc.php?time=1392647694&code=4655fUpJrNQrUmoa2iR9wHb0ExXgZeQljQo8fJCEMfFizIrnBzuZ0ocgh0DwNH2J%2BbpBEt8hOu0BVL%2BpVe5vh5HKEa59IZyS3nSsGHOx0Dd%2Bk%2FobPzwfnNAH37YpRHoZNYnFkGEDG0nQhFSTpK9TyvVAtv6QPFLSiBsGmN6wmmeP" reload="1"></script><script type="text/javascript" src="http://www.1point3acres.com/ublog/api/uc.php?time=1392647694&code=a056b0D9EX4hOv%2FS%2Bo5opjmWEnsBHrfywcmHxxgtiuEvxj4gfbGEeQsYeT9pL%2B1kyfyfS3eGSoC3NlT1Gmweoh7PQOPzsF9p%2FJbo8Euk7tdKC56UDfUmLtPyLZxB09QkoJ3QvCVz81s6cx27GkfKu9h7bVooqIq5x18S51w3lddE" reload="1"></script>]]></root>
     */
}

- (void)loginFailed {
    NSLog(@"Failed Login!");
    [SVProgressHUD dismiss];
}
@end
