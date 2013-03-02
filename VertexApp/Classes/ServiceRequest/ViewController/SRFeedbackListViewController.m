//
//  SRFeedbackListViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 3/1/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "SRFeedbackListViewController.h"

@interface SRFeedbackListViewController ()

@end

@implementation SRFeedbackListViewController

@synthesize displaySRFeedbackListEntries;
@synthesize displaySRFeedbackSubtitles;

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
  [self displaySRFeedbackListPageEntries];
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Display entries in Service Requests Feedback List Page
- (void) displaySRFeedbackListPageEntries
{
  /* !- TODO For demo only, remove hard coded values-! */
  displaySRFeedbackListEntries = [[NSMutableArray alloc] init];
  NSString *entry1 = @"Aircon leak fix";
  NSString *entry2 = @"Faulty electrical wiring";
  NSString *entry3 = @"Lightbulb replacement";
  
  [displaySRFeedbackListEntries addObject:entry1];
  [displaySRFeedbackListEntries addObject:entry2];
  [displaySRFeedbackListEntries addObject:entry3];
  
  /* !- TODO For the subtitles/details, remove these hard coded values -! */
  displaySRFeedbackSubtitles = [[NSMutableArray alloc] init];
  NSString *sub1 = @"2013-02-28";
  NSString *sub2 = @"2013-03-04";
  NSString *sub3 = @"2013-03-10";
  
  [displaySRFeedbackSubtitles addObject:sub1];
  [displaySRFeedbackSubtitles addObject:sub2];
  [displaySRFeedbackSubtitles addObject:sub3];
}

#pragma mark - Table view data source implementation
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  return 1;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *myTitle = [[NSString alloc] initWithFormat:@"Service Request Feedback List"];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [displaySRFeedbackListEntries count];
  NSLog(@"%d", [displaySRFeedbackListEntries count]);
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"Service Requests Feedback Page List");
  static NSString *CellIdentifier = @"srFeedbackListCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //Configure the cell title & subtitle
  cell.textLabel.text = [self.displaySRFeedbackListEntries objectAtIndex:indexPath.row];
  cell.detailTextLabel.text = [self.displaySRFeedbackSubtitles objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  return cell;
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  [self performSegueWithIdentifier:@"srFeedbackListToQuestions" sender:self];
}


@end
