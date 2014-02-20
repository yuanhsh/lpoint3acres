//
//  ArticleViewController.m
//  Ipoint3acres
//
//  Created by YUAN on 14-2-6.
//  Copyright (c) 2014年 YUAN. All rights reserved.
//

#import "ArticleViewController.h"
#import "ContentCell.h"
#import "FirstFloorContentCell.h"
#import "QuoteContentCell.h"
#import "ProfileViewController.h"
#import "QWebViewController.h"

@interface ArticleViewController ()
@property (nonatomic, assign) NSInteger pageNo;
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
    
//    NSDictionary *textAttributes = @{UITextAttributeFont: [UIFont systemFontOfSize:12.0f],
//                                     UITextAttributeTextColor: [UIColor whiteColor]};
//    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    if (!self.article && self.articleID) {
        self.article = [[HTMLParser sharedInstance] articleWithID:self.articleID];
    }
    
    self.navigationItem.title = self.article.title;
    self.article.isViewed = @YES;

    [self didReceiveComments:self.article.comments forArticle:self.article];
    [self loadDataAtPage:1];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadDataAtPage:(NSInteger)pageNo {
    self.pageNo = pageNo;
    [self.service fetchCommentsForArticle:self.article atPage:pageNo];
}

- (void)startRefreshingTableView {
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
    self.navigationItem.title = self.article.title;
    [self stopLoadingMoreData];
    [self stopRefreshingTableView];
    
    if (self.comments.count == article.comments.count) {
        NSLog(@"Info: No need to refresh post tableview for article: %@", article.articleID);
        return;
    }
    self.comments = article.comments;
    
    // if all posts are loaded
    if (self.comments.count >= [self.article.commentCount integerValue] + 1) {
        [self.refreshFooterView removeFromSuperview];
        self.article.commentCount = @(self.comments.count-1);
    }
    
//    [self.comments addObjectsFromArray:[comments array]];
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
        QWebViewController *webViewController = [[QWebViewController alloc] initWithUrl:url];
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
