//
//  BillingTasksViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 3/8/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "BillingTasksViewController.h"

@interface BillingTasksViewController ()

@end

@implementation BillingTasksViewController

@synthesize billingTasksPageEntries;

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
  [self displayBillingTasksPageEntries];
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Display entries in Billing Page
- (void) displayBillingTasksPageEntries
{
  billingTasksPageEntries = [[NSMutableArray alloc] init];
  
  NSString *entry1 = @"Generate One-Time Billing";
  NSString *entry2 = @"View One-Time Billing";
  NSString *entry3 = @"Recurring Bill Configuration";
  NSString *entry4 = @"View Recurring Info";
  
  [billingTasksPageEntries addObject:entry1];
  [billingTasksPageEntries addObject:entry2];
  [billingTasksPageEntries addObject:entry3];
  [billingTasksPageEntries addObject:entry4];
}

#pragma mark - Table view data source implementation
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  return 1;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *myTitle = [[NSString alloc] initWithFormat:@"Billing Tasks"];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [billingTasksPageEntries count];
  NSLog(@"%d", [billingTasksPageEntries count]);
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"billingTasksPageCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //configure the cell
  cell.textLabel.text = [self.billingTasksPageEntries objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  return cell;
}

//Change the Height of the Cell [Default is 45]:
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
  return 70;
}


#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  /*
  switch (indexPath.row)
  {
    //
    case 0: [self performSegueWithIdentifier:@"" sender:self];
      break;
    //
    case 1: [self performSegueWithIdentifier:@"" sender:self];
      break;
    //
    case 2: [self performSegueWithIdentifier:@"" sender:self];
      break;
    //
    default: break;
  }
  */  
}


@end
