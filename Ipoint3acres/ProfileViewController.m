//
//  ProfileViewController.m
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/02/18.
//  Copyright (c) 2014年 Yuan. All rights reserved.
//

#import "ProfileViewController.h"
#import "ArticleViewController.h"
#import "LoginViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "InfoURLMapper.h"
#import "DataManager.h"
#import "SVWebViewController.h"

@interface ProfileViewController () {
    CGFloat defaultY;
}
@property (nonatomic, strong) NSOrderedSet *userPosts; //主题
@property (nonatomic, strong) NSOrderedSet *userFavorites; //收藏
@property (nonatomic, strong) ServiceClient *client;
@property (nonatomic, strong) SiteUser *user;

@property (nonatomic, strong) UIBarButtonItem *actionButton;
@end

@implementation ProfileViewController

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
    self.client = [[ServiceClient alloc] initWithDelegate:self];
    self.userPosts = [NSOrderedSet orderedSet];
    self.userFavorites = [NSOrderedSet orderedSet];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(100, 44), NO, 0);
//    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor whiteColor].CGColor);
//    [@"个人资料" drawInRect:CGRectMake(0, 12, 100, 44) withFont:[UIFont boldSystemFontOfSize:18]
//          lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
//    UIImage *titleImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:titleImage];
    UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.textColor = [UIColor whiteColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:18];
    titlelabel.text =@"个人资料";
    self.navigationItem.titleView = titlelabel;
    self.navigationItem.title = @"";
    
    self.actionButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more.png"] style:UIBarButtonItemStylePlain target:self action:@selector(doMoreAction)];
    self.navigationItem.rightBarButtonItem = self.actionButton;
    
    UIImage *image = [UIImage imageNamed:@"profile_bg.jpg"];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, 438), YES, 0);
    [image drawInRect:CGRectMake(0, 0, 320, 438)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.imageView = [[UIImageView alloc] initWithImage:image];
    CGRect frame = self.imageView.frame;
    frame.origin.y -= 170;
    defaultY = frame.origin.y;
    self.imageView.frame = frame;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UserPostCell"];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 170)];
    header.backgroundColor = [UIColor clearColor];
    
    self.avatar = [[UIImageView alloc] initWithFrame:CGRectMake(30, 30, 60, 60)];
    NSString *avatarPath = [[InfoURLMapper sharedInstance] getAvatarURLforUser:self.userID];
    [self.avatar setImageWithURL:[NSURL URLWithString:avatarPath] placeholderImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
    self.avatar.layer.cornerRadius = self.avatar.frame.size.height/2.0f;
    self.avatar.clipsToBounds = YES;
    [header addSubview:self.avatar];
    
    self.gender = [[UIImageView alloc] initWithFrame:CGRectMake(97, 30, 18, 18)];
    [header addSubview:self.gender];
    
    self.infoTextView = [[UITextView alloc] initWithFrame:CGRectMake(120, 20, 160, 80)];
    self.infoTextView.backgroundColor = [UIColor clearColor];
    self.infoTextView.textColor = [UIColor whiteColor];
    self.infoTextView.editable = NO;
    self.infoTextView.scrollsToTop = NO;
    self.infoTextView.text = @"";
    self.infoTextView.font = [UIFont systemFontOfSize:15];
    [header addSubview:self.infoTextView];
    
    self.signatureTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 95, 280, 80)];
    self.signatureTextView.backgroundColor = [UIColor clearColor];
    self.signatureTextView.textColor = [UIColor whiteColor];
    self.signatureTextView.editable = NO;
    self.signatureTextView.scrollsToTop = NO;
    self.signatureTextView.text = @"";
    [header addSubview:self.signatureTextView];
    
    self.tableView.tableHeaderView = header;
    [self.tableView setTableFooterView:[UIView new]];
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.tableView];
    
    [self initUserData];
    
    [self showLoginViewIfNeeded];
    if(self.userID) {
        [Flurry logEvent:@"Load Profile View" withParameters:@{@"User": self.userID}];
    }
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    if (self.viewSelf) {
//        self.userID = self.client.loginedUserId;
//        if (!self.userID) {
//            static NSString *userLoginNotification = @"UserLoginNotification";
//            LoginViewController *loginController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginController"];
//            loginController.notificationName = userLoginNotification;
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSelfProfile) name:userLoginNotification object:nil];
////            UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:loginController];
////            [self presentViewController:controller animated:YES completion:nil];
//            [self.navigationController pushViewController:loginController animated:NO];
//        }
//    }
//}

- (void)showLoginViewIfNeeded {
    if (self.viewSelf) {
        self.userID = self.client.loginedUserId;
        if (!self.userID) {
            static NSString *userLoginNotification = @"UserLoginNotification";
            LoginViewController *loginController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginController"];
            loginController.notificationName = userLoginNotification;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSelfProfile) name:userLoginNotification object:nil];

            [self addChildViewController:loginController];
            [self.view addSubview:loginController.view];
            [loginController didMoveToParentViewController:self];
            
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
}

- (void)showSelfProfile {
    self.userID = self.client.loginedUserId;
    self.navigationItem.rightBarButtonItem = self.actionButton;
    [self initUserData];
}

- (void)initUserData {
    if (!self.userID) {
        return;
    }
    NSString *avatarPath = [[InfoURLMapper sharedInstance] getAvatarURLforUser:self.userID];
    [self.avatar setImageWithURL:[NSURL URLWithString:avatarPath] placeholderImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
    
    NSError *error;
    NSManagedObjectContext *context = [DataManager sharedInstance].mainObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SiteUser" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSString *query = [NSString stringWithFormat:@"userId == '%@'", self.userID];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:query]];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count > 0) {
        SiteUser *user = fetchedObjects[0];
        [self didLoadUserProfile:user];
        [self didLoadPosts:user.posts forUser:user.userId];
        [self didLoadFavorites:user.favorites forUser:user.userId];
    }
    
    [self loadUserDataFromWeb];
}

- (void)loadUserDataFromWeb {
    // 1, load basic information
    [self.client loadUserProfile:self.userID];
    
    // 2, load user posts
    [self.client loadUserPosts:self.userID];
    
    // 3, if logined user, load favorites
    if ([self.userID isEqualToString:self.client.loginedUserId]) {
        [self.client loadUserFavorites:self.userID];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Unselect the selected row if any
    NSIndexPath *selection = [self.tableView indexPathForSelectedRow];
    if (selection) {
        [self.tableView deselectRowAtIndexPath:selection animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark WebServiceDelegate methods

- (void)didLoadUserProfile: (SiteUser *)user {
    self.user = user;
    
    if ([user.gender isEqualToString:@"男"]) {
        self.gender.image = [UIImage imageNamed:@"icon_male.png"];
    } else if ([user.gender isEqualToString:@"女"]) {
        self.gender.image = [UIImage imageNamed:@"icon_female.png"];
    } else {
        self.gender.image = nil;
    }
    
    NSString *signature = self.user.signature;
    if (!signature || [signature isEqualToString:@""]) {
        signature = @"这家伙很懒，什么也没有留下...";
    }
    self.signatureTextView.text = signature;
    
    NSMutableArray *infoArray = [NSMutableArray array];
    if (user.birthdate) {
        [infoArray addObject:user.birthdate];
    }
    if (user.college) {
        [infoArray addObject:user.college];
    }
    if (user.degree) {
        [infoArray addObject:user.degree];
    }
    if (user.major) {
        [infoArray addObject:user.major];
    }
    NSString *infoStr = [infoArray componentsJoinedByString:@", "];
    self.infoTextView.text = [NSString stringWithFormat:@"%@\n%@", user.username, infoStr];
}

- (void)didLoadPosts:(NSOrderedSet *)posts forUser:(NSString *)userId {
    self.userPosts = posts;
    [self.tableView reloadData];
}

- (void)didLoadFavorites:(NSOrderedSet *)favs forUser:(NSString *)userId {
    self.userFavorites = favs;
}

- (void)logoutSuccessed {
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)logoutFailed {
    [SVProgressHUD dismiss];
    // Alert Information
}

#pragma mark TableViewDelegate methods

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"UserPostCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    Article *post = self.userPosts[indexPath.item];
    cell.textLabel.text = post.title;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userPosts.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Article *article = self.userPosts[indexPath.item];
    ArticleViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"articleController"];
    controller.article = article;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    float offsetY = scrollView.contentOffset.y;
    CGRect frame = self.imageView.frame;
    if (offsetY < 0) {
        frame.origin.y = defaultY - offsetY * 0.7;
    } else {
        frame.origin.y = defaultY - offsetY;
    }
    self.imageView.frame = frame;
}

- (void)doMoreAction {
    NSString *logoutTitle = nil;
    if (self.viewSelf && self.client.loginedUserId) {
        logoutTitle = @"退出当前账号";
    }
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:logoutTitle otherButtonTitles:@"查看网页", nil];
    [action showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        [SVProgressHUD showWithStatus:@"正在退出..."];
        [self.client logout];
    } else if ([buttonTitle isEqualToString:@"查看网页"]) {
        NSString *url = [[InfoURLMapper sharedInstance] getProfileFullURLForUser:self.userID];
        SVWebViewController *webVC = [[SVWebViewController alloc] initWithAddress:url];
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

@end
