//
//  AddAssetTypePageViewController.m
//  VertexApp
//
//  Created by Mary Rose Oh on 4/3/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "AddAssetTypePageViewController.h"
#import "HomePageViewController.h"
#import "AssetConfigurationPageViewController.h"

@interface AddAssetTypePageViewController ()

@end

@implementation AddAssetTypePageViewController

@synthesize addAssetTypeScroller;

@synthesize assetTypeNameLabel;
@synthesize assetTypeNameField;

@synthesize addAssetAttributesLabel;
@synthesize addAssetAttributesField;
@synthesize addAssetAttributesTable;
@synthesize assetAttributesArray;

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
  NSLog(@"Add Asset Type Page");
  //Keyboard dismissal
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector (dismissKeyboard)];
  [self.view addGestureRecognizer:tap];
  
  //[Cancel] navigation button
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(cancelAddAssetType)];
  
  //[Add] navigation button - Add Asset Type
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(addAssetType)];
  
  //Configure Scroller size
  self.addAssetTypeScroller.contentSize = CGSizeMake(320, 720);
  
  //Initialize assetAttributes array
  assetAttributesArray = [[NSMutableArray alloc] init];
  
  //'Remarks' is default asset attribute
  [assetAttributesArray addObject:@"Remarks"];
  
  [super viewDidLoad];
// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


#pragma mark - Add Asset Attributes in page
- (IBAction)addAssetAttributes:(id)sender
{
  [assetAttributesArray addObject:addAssetAttributesField.text];
  NSLog(@"assetAttributesArray: %@", assetAttributesArray);
  
  [addAssetAttributesTable reloadData];
  
  addAssetAttributesField.text = @"";
  [addAssetAttributesField resignFirstResponder];
}


#pragma mark - [Cancel] button implementation
-(void) cancelAddAssetType
{
  [self dismissViewControllerAnimated:YES completion:nil];
  NSLog(@"Cancel Add AssetType");
  
  //Go back to Home Page
  HomePageViewController* controller = (HomePageViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
  
  [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - Add Asset Type
-(void) addAssetType
{
  if([self validateAddAssetTypeFields])
  {
    //Set JSON Request
    NSMutableDictionary *addAssetTypeJson = [[NSMutableDictionary alloc] init];
    //TODO : Construct JSON request body Add Asset Type
    //[addAssetTypeJson setObject:@"" forKey:@"name"];
  
    NSError *error = [[NSError alloc] init];
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:addAssetTypeJson
                                   options:NSJSONWritingPrettyPrinted
                                     error:&error];
    
    NSString *jsonString = [[NSString alloc]
                            initWithData:jsonData
                                encoding:NSUTF8StringEncoding];
    
    NSLog(@"jsonData Request: %@", jsonData);
    NSLog(@"jsonString Request: %@", jsonString);
    
    //Set URL for Add Asset Type
    //TODO : WS Endpoint for add asset type
    //URL = @"http://192.168.2.113/vertex-api/asset/assetType/addAssetType";
    URL = @"http://192.168.2.107/vertex-api/asset/assetType/addAssetType";
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest
                                        requestWithURL:[NSURL URLWithString:URL]];
    
    //POST method - Create
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setHTTPBody:[NSData dataWithBytes:[jsonString UTF8String] length:[jsonString length]]];
    NSLog(@"%@", postRequest);
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:postRequest
                                          delegate:self];
    
    [connection start];
    
    NSLog(@"addAssetType - httpResponseCode: %d", httpResponseCode);
    //***
  }
  else
  {
    NSLog(@"Unable to add asset type");
  }
}


#pragma mark - Connection didFailWithError
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  NSLog(@"connection didFailWithError: %@", [error localizedDescription]);
}


#pragma mark - Connection didReceiveResponse
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
  NSHTTPURLResponse *httpResponse;
  httpResponse     = (NSHTTPURLResponse *)response;
  httpResponseCode = [httpResponse statusCode];
  NSLog(@"httpResponse status code: %d", httpResponseCode);
  
  if((httpResponseCode == 201) || (httpResponseCode == 200)) //add
  {
    UIAlertView *addAssetTypeAlert = [[UIAlertView alloc]
                                          initWithTitle:@"Add Asset Type"
                                                message:@"Asset Type Added."
                                               delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
    [addAssetTypeAlert show];
  }
  else //(httpResponseCode >= 400)
  {
    UIAlertView *addAssetTypeFailAlert = [[UIAlertView alloc]
                                              initWithTitle:@"Add Asset Type Failed"
                                                    message:@"Asset Type not added. Please try again later"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [addAssetTypeFailAlert show];
  }
  
  [self dismissViewControllerAnimated:YES completion:nil];
  NSLog(@"Add Asset Type");
}


#pragma mark - Transition to Assets Page when OK on Alert Box is clicked
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 0)
  {
    AssetConfigurationPageViewController *controller = (AssetConfigurationPageViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AssetConfigPage"];
    
    [self.navigationController pushViewController:controller animated:YES];
  }
}


#pragma mark - Login fields validation
-(BOOL) validateAddAssetTypeFields
{
  UIAlertView *addAssetTypeValidateAlert = [[UIAlertView alloc]
                                               initWithTitle:@"Incomplete Information"
                                                     message:@"Please fill out the necessary fields."
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
  
  if([assetTypeNameField.text isEqualToString:(@"")])
  {
    [addAssetTypeValidateAlert show];
    return false;
  }
  else
  {
    return true;
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
  NSString *myTitle = [[NSString alloc] initWithFormat:@"Asset Type Attributes"];
  return myTitle;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [assetAttributesArray count];
  NSLog(@"%d", [assetAttributesArray count]);
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"addAssetTypeAttributesCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  //configure the cell
  cell.textLabel.text = [self.assetAttributesArray objectAtIndex:indexPath.row];
  cell.textLabel.numberOfLines = 0;
  return cell;
}

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *selectedRowName = [[NSString alloc] init];
  selectedRowName = [updateAssetsPageEntries objectAtIndex:indexPath.row];
  NSLog(@"Selected row name: %@", selectedRowName);
  
  selectedAssetId = [assetIdArray objectAtIndex:indexPath.row];
  //selectedAssetId = @1234567890; //TEST
  NSLog(@"selectedAssetId: %@", selectedAssetId);
  
  [self performSegueWithIdentifier:@"updateAssetListToUpdateAssetPage" sender:self];
}
*/


#pragma mark - Dismiss assetTypePicker action sheet
-(void)dismissActionSheet:(id) sender
{
  [sender dismissWithClickedButtonIndex:0 animated:YES];
}


#pragma mark - Dismiss the onscreen keyboard when not in use
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
  [self.view endEditing:YES];
}


#pragma mark - Dismiss onscreen keyboard
-(void)dismissKeyboard
{
  [assetTypeNameField resignFirstResponder];
  [addAssetAttributesField resignFirstResponder];
}


@end
