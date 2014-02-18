//
//  ProfileViewController.m
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/02/18.
//  Copyright (c) 2014年 Yuan. All rights reserved.
//

#import "ProfileViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "InfoURLMapper.h"
#import "DataManager.h"

@interface ProfileViewController () {
    CGFloat defaultY;
}
@property (nonatomic, strong) NSOrderedSet *userPosts; //主题
@property (nonatomic, strong) NSOrderedSet *userFavorites; //收藏
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
    
    UIImage *image = [UIImage imageNamed:@"profile_bg.jpg"];
    UIGraphicsBeginImageContext(CGSizeMake(320, 438));
    [image drawInRect:CGRectMake(0, 0, 320, 438)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.imageView = [[UIImageView alloc] initWithImage:image];
    CGRect frame = self.imageView.frame;
    frame.origin.y -= 130;
    defaultY = frame.origin.y;
    self.imageView.frame = frame;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
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
    
    self.gender = [[UIImageView alloc] initWithFrame:CGRectMake(95, 30, 18, 18)];
    self.gender.image = [UIImage imageNamed:@"icon_male.png"];
    [header addSubview:self.gender];
    
    self.infoTextView = [[UITextView alloc] initWithFrame:CGRectMake(120, 22, 160, 80)];
    self.infoTextView.backgroundColor = [UIColor clearColor];
    self.infoTextView.textColor = [UIColor whiteColor];
    self.infoTextView.editable = NO;
    self.infoTextView.scrollsToTop = NO;
    self.infoTextView.text = @"infoTextView infoTextView infoTextView infoTextView infoTextView";
    [header addSubview:self.infoTextView];
    
    self.signatureTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 90, 280, 80)];
    self.signatureTextView.backgroundColor = [UIColor clearColor];
    self.signatureTextView.textColor = [UIColor whiteColor];
    self.signatureTextView.editable = NO;
    self.signatureTextView.scrollsToTop = NO;
    self.signatureTextView.text = @"signatureTextView signatureTextView signatureTextView signatureTextView";
    [header addSubview:self.signatureTextView];
    
    self.tableView.tableHeaderView = header;
    [self.tableView setTableFooterView:[UIView new]];
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.tableView];
    
    //[self initUserData];
}

- (void)initUserData {
    NSError *error;
    NSManagedObjectContext *context = [DataManager sharedInstance].managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SiteUser" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];

    NSString *query = [NSString stringWithFormat:@"userId == '%@'", self.userID];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:query]];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count > 0) {
        
    }
    [self loadUserDataFromWeb];
}

- (void)loadUserDataFromWeb {
    
    // 1, load basic information & posts
    
    // 2, load signature
    
    // 3, if logined user, load favorites
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"UserPostCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.item];
    
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
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


@end
