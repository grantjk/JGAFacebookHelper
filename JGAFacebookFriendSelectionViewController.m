//
//  JGATTFacebookFriendSelectionViewController.m
//  ticktalk
//
//  Created by John Grant on 12-05-11.
//  Copyright (c) 2012 Healthcare Made Simple. All rights reserved.
//

#import "JGAFacebookFriendSelectionViewController.h"

#import "JGAFacebookFriend.h"

@interface JGAFacebookFriendSelectionViewController ()

@end

@implementation JGAFacebookFriendSelectionViewController
@synthesize friends = _friends;
@synthesize selectedFriends = _selectedFriends;
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.selectedFriends = [NSMutableArray arrayWithCapacity:5];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Tag Friends in the Photo";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Don't Tag" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPressed:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tag" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonPressed:)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)cancelButtonPressed:(id)sender
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)doneButtonPressed:(id)sender
{
    [_delegate controller:self didSelectFriends:_selectedFriends];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    JGAFacebookFriend *friend = [_friends objectAtIndex:indexPath.row];
    
    if ([_selectedFriends containsObject:friend]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    cell.textLabel.text = friend.name;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    JGAFacebookFriend *friend = [_friends objectAtIndex:indexPath.row];

    if ([_selectedFriends containsObject:friend]) {
        [self deselectFriend:friend inCell:cell];
    }else {
        [self selectFriend:friend inCell:cell];
    }
}

- (void)selectFriend:(JGAFacebookFriend *)friend inCell:(UITableViewCell *)cell
{
    [_selectedFriends addObject:friend];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}
- (void)deselectFriend:(JGAFacebookFriend *)friend inCell:(UITableViewCell *)cell
{
    [_selectedFriends removeObject:friend];
    cell.accessoryType = UITableViewCellAccessoryNone;
}


@end
