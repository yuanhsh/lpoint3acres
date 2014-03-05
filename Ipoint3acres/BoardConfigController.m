//
//  BoardConfigController.m
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/03/04.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import "BoardConfigController.h"

@interface BoardConfigController ()

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableViewDataSource & Delegate methods

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"BoardNameCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.textLabel.text = @"hahha";
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
//    cell.accessoryType = UITableViewCellAccessoryCheckmark;
//}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
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

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
//    [tableData insertObject: [tableData objectAtIndex:sourceIndexPath.row] atIndex:destinationIndexPath.row];
//    [tableData removeObjectAtIndex:(sourceIndexPath.row + 1)];
}

@end
