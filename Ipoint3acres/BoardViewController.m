//
//  BoardViewController.m
//  Ipoint3acres
//
//  Created by YUAN on 14-2-2.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import "BoardViewController.h"
#import "ArticleViewController.h"
#import "ArticleTitleCell.h"

static NSString *CellIdentifier = @"ArticleTitleCell";

@interface BoardViewController ()

@property (nonatomic, assign) BOOL showStickThread;
@property (nonatomic, assign) BOOL isRemoteData;
@property (nonatomic, assign) NSInteger pageNo;

@end

@implementation BoardViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showStickThread = NO; // should load from user defaults
    self.isRemoteData = NO;
    self.articles = [NSMutableOrderedSet orderedSet];
    self.service = [[ServiceClient alloc] init];
    self.service.delegate = self;
    [self loadLocalData];
    [self triggerRefreshTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Unselect the selected row if any
    NSIndexPath *selection = [self.tableView indexPathForSelectedRow];
    if (selection) {
        [self.tableView deselectRowAtIndexPath:selection animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadLocalData {
    if (self.board.articles.count == 0) {
        return;
    }
    NSMutableOrderedSet *tmpSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.board.articles];
    NSSortDescriptor *stickSort = [[NSSortDescriptor alloc] initWithKey:@"isStick" ascending:NO];
    NSSortDescriptor *timeSort = [[NSSortDescriptor alloc] initWithKey:@"articleID" ascending:NO];
    [tmpSet sortUsingDescriptors:@[stickSort, timeSort]];
    self.articles = tmpSet;
    [self.tableView reloadData];
}

- (void)loadDataAtPage:(NSInteger)pageNo {
    [self.service fetchArticlesForBoard:self.board atPage:pageNo];
    self.pageNo = pageNo;
}

- (void)startLoadingMoreData {
    [self loadDataAtPage:self.pageNo + 1];
}

- (void)startRefreshingTableView {
    [super startRefreshingTableView];
    [self loadDataAtPage:1];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ArticleTitleCell heightForArticle:self.articles[indexPath.row]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.articles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ArticleTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.article = self.articles[indexPath.row];
    return cell;
}

#pragma mark - WebServiceDelegate Method

- (void)didReceiveArticles: (NSOrderedSet *)articles forBoard: (Board *)board {
    if (self.isRemoteData) {
        [self.articles addObjectsFromArray:[articles array]];
    } else {
        self.articles = [NSMutableOrderedSet orderedSetWithOrderedSet:articles];
        self.isRemoteData = YES;
    }
    
    if (!self.showStickThread) {
        // delete stick articles
    }
    
    NSSortDescriptor *stickSort = [[NSSortDescriptor alloc] initWithKey:@"isStick" ascending:NO];
    NSSortDescriptor *timeSort = [[NSSortDescriptor alloc] initWithKey:@"articleID" ascending:NO];
    [self.articles sortUsingDescriptors:@[stickSort,timeSort]];
    
    [self stopRefreshingTableView];
    [self stopLoadingMoreData];
    
    [self.tableView reloadData];
}

#pragma mark - EGORefreshTableHeaderDelegate Method

- (NSString *)egoRefreshLastUpdatedDateStoreKey {
    return self.board.name;
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ArticleViewController *controller = [segue destinationViewController];
    ArticleTitleCell *cell = (ArticleTitleCell *)sender;
    cell.isViewed = YES;
    controller.article = cell.article;
}

 

@end
