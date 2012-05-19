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
@synthesize indices = _indices;

static NSString *kFriendsKey = @"friends";
static NSString *kHeaderKey = @"header";

- (id)initWithStyle:(UITableViewStyle)style friends:(NSMutableArray *)friends
{
    self = [super initWithStyle:style];
    if (self) {
        self.selectedFriends = [NSMutableArray arrayWithCapacity:5];
        self.friends = [JGAFacebookFriend indexedFriendsList:friends];
        
        
        self.indices = [NSMutableArray arrayWithCapacity:_friends.count];
        for (int i =0; i < _friends.count; i++) {
            [_indices addObject:[[_friends objectAtIndex:i] objectForKey:kHeaderKey]];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Tag Friends in the Photo";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Don't Tag" 
                                                                             style:UIBarButtonItemStyleBordered 
                                                                            target:self 
                                                                            action:@selector(cancelButtonPressed:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tag" 
                                                                              style:UIBarButtonItemStyleDone 
                                                                                target:self 
                                                                             action:@selector(doneButtonPressed:)];
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
    [_delegate controllerDidCancel:self];
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
    return _friends.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[_friends objectAtIndex:section] objectForKey:kFriendsKey] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    JGAFacebookFriend *friend = [self friendForIndexPath:indexPath];
    
    if ([_selectedFriends containsObject:friend]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (friend.isMe) {
        cell.textLabel.textColor = [UIColor blueColor];
    }else {
        cell.textLabel.textColor = [UIColor blackColor];
    }

    cell.textLabel.text = friend.name;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    JGAFacebookFriend *friend = [self friendForIndexPath:indexPath];

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

# pragma mark - Sections
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView 
{
    return _indices;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index 
{
    return [_indices indexOfObject:title];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [[_friends objectAtIndex:section] objectForKey:kHeaderKey];
}

#pragma mark - Data Helpers
- (JGAFacebookFriend *)friendForIndexPath:(NSIndexPath *)indexPath
{    
    NSArray *friends = [[_friends objectAtIndex:indexPath.section] objectForKey:kFriendsKey];
    return [friends objectAtIndex:indexPath.row];
}


@end
