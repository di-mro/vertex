//
//  ViewEssePageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 4/12/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "ViewEssePageViewController.h"
#import "EsseDetailPageViewController.h"

@interface ViewEssePageViewController ()

@end

@implementation ViewEssePageViewController

@synthesize viewEssePageEntries;
@synthesize esseNameArray;
@synthesize esseIdArray;
@synthesize esse;
@synthesize selectedEsseId;

@synthesize URL;
@synthesize httpResponseCode;


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
  [self displayViewEssePageEntries];
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - Display entries in View Esse Page
- (void) displayViewEssePageEntries
{
  viewEssePageEntries = [[NSMutableArray alloc] init];
  
  //URL = @"http://192.168.2.113/vertex-api/esse/getEsseList";
  URL = @"";
  
  NSMutableURLRequest *getRequest = [NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:URL]];
  
  [getRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  [getRequest setHTTPMethod:@"GET"];
  NSLog(@"%@", getRequest);
  
  NSURLConnection *connection = [[NSURLConnection alloc]
                                 initWithRequest:getRequest
                                 delegate:self];
  [connection start];
  
  NSHTTPURLResponse *urlResponse = [[NSHTTPURLResponse alloc] init];
  NSError *error = [[NSError alloc] init];
  
  NSData *responseData = [NSURLConnection
                          sendSynchronousRequest:getRequest
                          returningResponse:&urlResponse
                          error:&error];
  
  if (responseData == nil)
  {
    //Show an alert if connection is not available
    UIAlertView *connectionAlert = [[UIAlertView alloc]
                                    initWithTitle:@"Warning"
                                    message:@"No network connection detected. Displaying data from phone cache."
                                    delegate:self
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
    [connectionAlert show];
    
    /* !- For demo only, remove hard coded values. Must retrieve listing in CoreData DB -! */
    NSString *entry1 = @"Demo - Esse_1";
    NSString *entry2 = @"Demo - Esse_2";
    NSString *entry3 = @"Demo - Esse_3";
    NSString *entry4 = @"Demo - Esse_4";
    NSString *entry5 = @"Demo - Esse_5";
    
    [viewEssePageEntries addObject:entry1];
    [viewEssePageEntries addObject:entry2];
    [viewEssePageEntries addObject:entry3];
    [viewEssePageEntries addObject:entry4];
    [viewEssePageEntries addObject:entry5];
  }
  else
  {
    //JSON
    esse = [NSJSONSerialization
                      JSONObjectWithData:responseData
                      options:kNilOptions
                      error:&error];
    NSLog(@"esse JSON: %@", esse);
    
    viewEssePageEntries = [esse valueForKey:@"name"];
    
    esseNameArray = [[NSMutableArray alloc] init];
    esseIdArray = [[NSMutableArray alloc] init];
    
    esseNameArray = [esse valueForKey:@"name"];
    esseIdArray = [esse valueForKey:@"id"];
  }
}


#pragma mark - Table view data source implementation
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  return 1;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *myTitle = [[NSString alloc] initWithFormat:@"Esse List"];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [viewEssePageEntries count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"viewEssePageCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //configure the cell
  cell.textLabel.text = [self.viewEssePageEntries objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  return cell;
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *selectedRowName = [[NSString alloc] init];
  selectedRowName = [viewEssePageEntries objectAtIndex:indexPath.row];
  NSLog(@"Selected row name: %@", selectedRowName);
  
  selectedEsseId = [esseIdArray objectAtIndex:indexPath.row];
  NSLog(@"selectedEsseId: %@", selectedEsseId);
  
  [self performSegueWithIdentifier:@"viewEsseToEsseDetail" sender:self];
}


#pragma mark - prepare for segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"viewEsseToEsseDetail"])
  {
    [segue.destinationViewController setEsseId:selectedEsseId];
  }
}


@end
