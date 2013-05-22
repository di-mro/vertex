//
//  NoticesViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 2/26/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "NoticesViewController.h"

@interface NoticesViewController ()

@end

@implementation NoticesViewController

@synthesize noticesPageEntries;


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
  NSLog(@"Notices Page View");
  
  [self displayNoticesPageEntries];
  
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}


# pragma mark - Display entries in Notices Page
- (void) displayNoticesPageEntries
{
  noticesPageEntries = [[NSMutableArray alloc] init];
  
  NSString *entry1 = @"Create Notice";
  NSString *entry2 = @"View Notice";
  NSString *entry3 = @"Create Memorandum";
  NSString *entry4 = @"View Memorandum";
  NSString *entry5 = @"Create Billing Notice";
  
  [noticesPageEntries addObject:entry1];
  [noticesPageEntries addObject:entry2];
  [noticesPageEntries addObject:entry3];
  [noticesPageEntries addObject:entry4];
  [noticesPageEntries addObject:entry5];
}


#pragma mark - Table view data source implementation
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  return 1;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *myTitle = [[NSString alloc] initWithFormat:@"Notification Tasks"];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [noticesPageEntries count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"noticesPageCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //configure the cell
  cell.textLabel.text          = [self.noticesPageEntries objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  
  return cell;
}

//Change the Height of the Cell [Default is 45]:
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
  return 50;
}


#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch (indexPath.row)
  {
    //Create Notice
    case 0: [self performSegueWithIdentifier:@"noticesToCreateNotice" sender:self];
      break;
      /*
    //View Notice
    case 1: [self performSegueWithIdentifier:@"noticesToViewNotice" sender:self];
      break;
    //Create Memorandum
    case 2: [self performSegueWithIdentifier:@"noticesToCreateMemo" sender:self];
      break;
    //View Memorandum
    case 3: [self performSegueWithIdentifier:@"noticesToViewMemo" sender:self];
      break;
    //Create Billing Notice
    case 4: [self performSegueWithIdentifier:@"noticesToCreateBillingNotice" sender:self];
      break;
       */
    default:break;
  }
}


@end
