//
//  ArticleViewController.m
//  Ipoint3acres
//
//  Created by YUAN on 14-2-6.
//  Copyright (c) 2014年 YUAN. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import "ArticleViewController.h"
#import "ContentCell.h"
#import "FirstFloorContentCell.h"
#import "QuoteContentCell.h"
#import "ProfileViewController.h"
#import "SVWebViewController.h"
#import "CommentViewController.h"
#import "FXBlurView.h"
#import "SettingManager.h"
#import "GADBannerView.h"

@interface ArticleViewController ()
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) GADBannerView *bannerView;
@end

@implementation ArticleViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.comments = [NSMutableOrderedSet orderedSet];
    self.service = [[ServiceClient alloc] init];
    self.service.delegate = self;
    [self.tableView setTableFooterView:[UIView new]];
    
#ifdef FREE_VERSION
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    self.bannerView.adUnitID = @"a15319907d8f243";
    self.bannerView.rootViewController = self;
    [self.view addSubview:self.bannerView];
    [self.bannerView loadRequest:[self gAdRequest]];
#endif
    
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more.png"] style:UIBarButtonItemStylePlain target:self action:@selector(doMoreAction)];
    self.navigationItem.rightBarButtonItem = actionButton;
    
    if (!self.article && self.articleID) {
        self.article = [[HTMLParser sharedInstance] articleWithID:self.articleID];
    }
    
    UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.textColor = [UIColor whiteColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:16];
    self.titleLabel = titlelabel;
    self.navigationItem.titleView = titlelabel;
    self.navigationItem.title = @"";
    self.article.isViewed = @YES;

    [self didReceiveComments:self.article.comments forArticle:self.article];
    NSInteger currentCount = self.article.comments.count;
    NSInteger commentCount = [self.article.commentCount integerValue];
    if (currentCount == 0) {
        [self triggerRefreshTableView];
    } else if((commentCount < kCommentCountPerPage && currentCount != commentCount+1) ||
              (commentCount >= kCommentCountPerPage &&  currentCount < kCommentCountPerPage)) {
        [self startRefreshingTableView];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startLoadingMoreData) name:kCommentSuccessNotification object:nil];
    [Flurry logEvent:@"加载文章页面" withParameters:@{@"帖子ID": self.article.articleID}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (GADRequest *)gAdRequest {
    GADRequest *request = [GADRequest request];
    
    @try {
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        [request setLocationWithLatitude:locationManager.location.coordinate.latitude
                               longitude:locationManager.location.coordinate.longitude
                                accuracy:locationManager.location.horizontalAccuracy];
    }
    @catch (NSException *exception) {}
    @finally {}
    
    // Make the request for a test ad. Put in an identifier for the simulator as well as any devices
    // you want to receive test ads.
//#ifdef DEBUG
    request.testing = YES;
    request.testDevices = @[GAD_SIMULATOR_ID];
//#endif

    // TODO: Add your device/simulator test identifiers here. Your device identifier is printed to
    // the console when the app is launched.
    return request;
}

- (void)loadDataAtPage:(NSInteger)pageNo {
    self.pageNo = pageNo;
    [self.service fetchCommentsForArticle:self.article atPage:pageNo];
}

- (void)startRefreshingTableView {
    [super startRefreshingTableView];
    [self loadDataAtPage:1];
}

- (void)startLoadingMoreData {
    NSInteger loadedCount = self.comments.count;
//    NSInteger count = [self.article.commentCount integerValue];
//    if (loadedCount >= count) {
//        [self stopLoadingMoreData];
//        return;
//    } else {
        NSInteger currentPage = loadedCount / kCommentCountPerPage;
        [self loadDataAtPage:currentPage+1];
//    }
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Comment *comment = self.comments[indexPath.row];
    if ([comment.floorNo intValue] == 1) {
        FirstFloorContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FirstFloorContentCell"];
        return [cell heightForComment:comment];
    } else if(comment.quoteContent != nil){
        return [QuoteContentCell heightForComment:comment];
    } else {
        return [ContentCell heightForComment:comment];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *FirstFloorCellIdentifier = @"FirstFloorContentCell";
    static NSString *CellIdentifier = @"ContentCell";
    static NSString *QuoteCellIdentifier = @"QuoteContentCell";
    
    Comment *comment = self.comments[indexPath.row];
    if ([comment.floorNo intValue] == 1) {
        FirstFloorContentCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstFloorCellIdentifier];
        cell.comment = comment;
        cell.delegate = self;
        return cell;
    } else if(comment.quoteContent != nil){
        QuoteContentCell *cell = [tableView dequeueReusableCellWithIdentifier:QuoteCellIdentifier];
        cell.comment = comment;
        return cell;
    } else {
        ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.comment = comment;
        return cell;
    }
    
}

#pragma mark - WebServiceDelegate Method

- (void)didReceiveComments: (NSOrderedSet *)comments forArticle: (Article *)article {
    if (article.shortTitle) {
        self.titleLabel.text = article.shortTitle;
    }
    [self stopLoadingMoreData];
    [self stopRefreshingTableView];
//    [self dismissLoadingHeaderAndFooter];
    
    if (self.comments.count == article.comments.count) {
//        NSLog(@"Info: No need to refresh post tableview for article: %@", article.articleID);
        return;
    }
    self.comments = article.comments;
    
    // if all posts are loaded
    if (self.comments.count >= [self.article.commentCount integerValue] + 1) {
        if (self.refreshFooterView) {
            [self.refreshFooterView removeFromSuperview];
            self.refreshFooterView = nil;
        }
        self.article.commentCount = @(self.comments.count-1);
    }
    
    [self.tableView reloadData];
}

#pragma mark - ContentCellDelegate Method

- (void)requestOpenURL:(NSString *)url {
    InfoURLMapper *mapper = [InfoURLMapper sharedInstance];
    NSString *userId = [mapper getUserIDfromUserLink:url];
    NSString *articleId = [mapper getArticleIDfromURL:url];
    if (userId) {
        ProfileViewController *profileController = [self.storyboard instantiateViewControllerWithIdentifier:@"profileController"];
        profileController.userID = userId;
        [self.navigationController pushViewController:profileController animated:YES];
    } else if(articleId) {
        ArticleViewController *articleController = [self.storyboard instantiateViewControllerWithIdentifier:@"articleController"];
        articleController.articleID = articleId;
        [self.navigationController pushViewController:articleController animated:YES];
    } else {
        SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:url];
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}

- (void)doMoreAction {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"查看网页", @"查看楼主", @"回复楼主", nil];
    [action showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"查看网页"]) {
        NSString *url = [[InfoURLMapper sharedInstance] getArticleFullURL:self.article.articleID];
        SVWebViewController *webVC = [[SVWebViewController alloc] initWithAddress:url];
        [self.navigationController pushViewController:webVC animated:YES];
    } else if ([buttonTitle isEqualToString:@"回复楼主"]) {
        CommentViewController *commentController = [self.storyboard instantiateViewControllerWithIdentifier:@"commentController"];
        commentController.comment = self.comments[0];
        [self presentViewController:commentController animated:YES completion:nil];
    } else if ([buttonTitle isEqualToString:@"查看楼主"]) {
        Comment *comment = self.comments[0];
        ProfileViewController *profileController = [self.storyboard instantiateViewControllerWithIdentifier:@"profileController"];
        profileController.userID = comment.commenterID;
        [self.navigationController pushViewController:profileController animated:YES];
    }
}

#pragma mark - Navigation

- (IBAction)viewUser:(id)sender {
    UITapGestureRecognizer *tapGR = (UITapGestureRecognizer*)sender;
    CGPoint touchLocation = [tapGR locationOfTouch:0 inView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:touchLocation];
    if (indexPath) {
        Comment *comment = self.comments[indexPath.row];
        ProfileViewController *profileController = [self.storyboard instantiateViewControllerWithIdentifier:@"profileController"];
        profileController.userID = comment.commenterID;
        [self.navigationController pushViewController:profileController animated:YES];
    } else {
        NSLog(@"ViewUser indexPath is NULL!");
    }
}

- (IBAction)makeComment:(id)sender {
    CommentViewController *commentController = [self.storyboard instantiateViewControllerWithIdentifier:@"commentController"];
    UITapGestureRecognizer *tapGR = (UITapGestureRecognizer*)sender;
    CGPoint touchLocation = [tapGR locationOfTouch:0 inView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:touchLocation];
    if (indexPath) {
        commentController.comment = self.comments[indexPath.row];
        [self presentViewController:commentController animated:YES completion:nil];
    } else {
        NSLog(@"makeComment indexPath is NULL!");
    }
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
