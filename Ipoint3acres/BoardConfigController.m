//
//  BoardConfigController.m
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/03/04.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import "BoardConfigController.h"
#import "BoardNameCell.h"
#import "DataManager.h"
#import "Board.h"

@interface BoardConfigController ()
@property (nonatomic, strong) NSMutableArray *boards;
@property (nonatomic, assign) BOOL reordered;
@end

@implementation BoardConfigController

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
	self.navigationItem.title = @"板块设置";
    [self.tableView setEditing:YES animated:NO];
    [self.tableView setTableFooterView:[UIView new]];
    
    NSManagedObjectContext *context = [DataManager sharedInstance].mainObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Board" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *hiddenDescriptor = [[NSSortDescriptor alloc] initWithKey:@"hidden" ascending:YES];
    NSSortDescriptor *indexDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
    [fetchRequest setSortDescriptors:@[hiddenDescriptor, indexDescriptor]];
    self.boards = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    for (NSInteger i=0; i < self.boards.count; i++) {
        Board *board = self.boards[i];
        board.index = @(i);
    }
    [[DataManager sharedInstance] save];
    if (self.reordered) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kBoardReorderNotification object:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableViewDataSource & Delegate methods

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"BoardNameEdittingCell";
    BoardNameCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.board = self.boards[indexPath.item];
    return cell;
}

//- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    UIView *mainView = cell;
//    if (isIOS7) {
//        mainView = cell.subviews[0];
//    }
//    for(UIView* view in mainView.subviews) {
//        if([[[view class] description] isEqualToString:@"UITableViewCellReorderControl"]) {
//            // Creates a new subview the size of the entire cell
//            UIView *movedReorderControl = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(view.frame), CGRectGetMaxY(view.frame))];
//            // Adds the reorder control view to our new subview
//            [movedReorderControl addSubview:view];
//            // Adds our new subview to the cell
//            [cell addSubview:movedReorderControl];
//            // CGStuff to move it to the left
//            CGSize moveLeft = CGSizeMake(movedReorderControl.frame.size.width - view.frame.size.width, movedReorderControl.frame.size.height - view.frame.size.height);
//            CGAffineTransform transform = CGAffineTransformIdentity;
//            transform = CGAffineTransformTranslate(transform, -moveLeft.width, -moveLeft.height);
//            // Performs the transform
//            [movedReorderControl setTransform:transform];
//        }
//    }
//}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.boards.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    Board *board = [self.boards objectAtIndex:sourceIndexPath.row];
    [self.boards removeObjectAtIndex:sourceIndexPath.row];
    [self.boards insertObject:board atIndex:destinationIndexPath.row];
    self.reordered = YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Board *board = self.boards[indexPath.item];
    board.hidden = @(![board.hidden boolValue]);
    [self.tableView reloadData];
    self.reordered = YES;
}

@end
