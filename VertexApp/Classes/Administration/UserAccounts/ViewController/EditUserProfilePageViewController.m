//
//  EditUserProfilePageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 4/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "EditUserProfilePageViewController.h"

@interface EditUserProfilePageViewController ()

@end

@implementation EditUserProfilePageViewController

@synthesize userAccountsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  //[Cancel] Button
  //[Edit] Button
  
  //TEST
  userAccountsArray = [[NSMutableArray alloc] initWithObjects:
                         @"Demo - user000"
                       , @"Demo - user001"
                       , @"Demo - user002"
                       , nil];
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source implementation
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  return 1;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *myTitle = [[NSString alloc] initWithFormat:@"User Accounts"];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [userAccountsArray count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"editUserProfilePageCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //configure the cell
  cell.textLabel.text          = [self.userAccountsArray objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  
  return cell;
}


@end
