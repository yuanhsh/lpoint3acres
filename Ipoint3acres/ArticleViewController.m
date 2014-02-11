//
//  ArticleViewController.m
//  Ipoint3acres
//
//  Created by YUAN on 14-2-6.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import "ArticleViewController.h"
#import "ContentCell.h"

@interface ArticleViewController ()

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
    NSDictionary *textAttributes = @{UITextAttributeFont: [UIFont systemFontOfSize:12.0f],
                                     UITextAttributeTextColor: [UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    self.navigationItem.title = self.article.title;
    self.article.isViewed = @YES;

    self.comments = [NSMutableOrderedSet orderedSet];
    self.service = [[ServiceClient alloc] init];
    self.service.delegate = self;
    [self loadDataAtPage:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadDataAtPage:(NSInteger)pageNo {
    [self didReceiveComments:self.article.comments forArticle:self.article];
    [self.service fetchCommentsForArticle:self.article atPage:pageNo];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ContentCell heightForComment:self.comments[indexPath.row]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContentCell";
    ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.comment = self.comments[indexPath.row];
    
    return cell;
}

#pragma mark - WebServiceDelegate Method

- (void)didReceiveComments: (NSOrderedSet *)comments forArticle: (Article *)article {
    self.comments = article.comments;
//    [self.comments addObjectsFromArray:[comments array]];
    [self.tableView reloadData];
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
