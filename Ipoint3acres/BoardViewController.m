//
//  BoardViewController.m
//  Ipoint3acres
//
//  Created by YUAN on 14-2-2.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import "BoardViewController.h"
#import "ArticleTitleCell.h"

static NSString *CellIdentifier = @"ArticleTitleCell";

@interface BoardViewController ()

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
    self.articles = [NSOrderedSet orderedSet];
    self.service = [[ServiceClient alloc] init];
    self.service.delegate = self;
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    [self didReceiveArticles:self.board.articles forBoard:self.board];
    [self.service fetchArticlesForBoard:self.board atPage:1];
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
    self.articles = board.articles;
    [self.tableView reloadData];
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
