//
//  MagicalRecordCoreDataViewController.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/19/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "MagicalRecordCoreDataViewController.h"
#import "Person.h"

@interface MagicalRecordCoreDataViewController ()
@end

static NSString *kCellIdentifier = @"MyIdentifier";
@implementation MagicalRecordCoreDataViewController

#pragma mark - private methods
- (void)setNav
{
	UIView *navBGView = [[UIView alloc] initWithFrame:CGRectMake(-5, 0, 320, 44)];
	UIImageView *bgImage = [[UIImageView alloc] initWithFrame:navBGView.frame];
	bgImage.image = ImageNamed(@"bg_nav.png");
	[navBGView addSubview:bgImage];
    
    UIButton *backBtn = [UIButton buttonWithFrame:CGRectMake(0,5,38,34)
                                            title:nil
                                       titleColor:nil
                              titleHighlightColor:nil
                                        titleFont:nil
                                            image:ImageNamed(@"btn_nav_back.png")
                                      tappedImage:ImageNamed(@"btn_nav_back_pressed.png")
                                           target:self
                                           action:@selector(onBackBtnClicked)
                                              tag:0];
	[navBGView addSubview:backBtn];
    
    _editBtn = [UIButton buttonWithFrame:CGRectMake(270,7,38,30)
                                            title:@"编辑"
                                       titleColor:[UIColor whiteColor]
                              titleHighlightColor:[UIColor whiteColor]
                                        titleFont:[UIFont systemFontOfSize:13]
                                            image:ImageNamed(@"btn_common.png")
                                      tappedImage:ImageNamed(@"btn_common_pressed.png")
                                           target:self
                                           action:@selector(editAction:)
                                              tag:0];
	[navBGView addSubview:_editBtn];
    
    UIButton *addBtn = [UIButton buttonWithFrame:CGRectMake(230,7,38,30)
                                           title:@"新建"
                                      titleColor:[UIColor whiteColor]
                             titleHighlightColor:nil
                                       titleFont:[UIFont systemFontOfSize:13]
                                           image:ImageNamed(@"btn_common.png")
                                     tappedImage:ImageNamed(@"btn_common_pressed.png")
                                          target:self
                                          action:@selector(addNewPersonAction:)
                                             tag:0];
	[navBGView addSubview:addBtn];
    
    UILabel *titleLbl = [UILabel labelForNavigationBarWithTitle:_navTitle 
                                                      textColor:RGBCOLOR(200, 200, 200)  
                                                           font:[UIFont systemFontOfSize:20] 
                                                      hasShadow:YES];
    [navBGView addSubview:titleLbl];
	
	UIBarButtonItem *navLeft = [[UIBarButtonItem alloc] initWithCustomView:navBGView];
	[self.navigationItem setLeftBarButtonItem:navLeft animated:NO];
}

- (IBAction)addNewPersonAction:(id)sender
{
    NSString *randomName = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    
    // Get the local context 
    NSManagedObjectContext *localContext    = [NSManagedObjectContext MR_contextForCurrentThread];
    
    // Create a new Person in the current thread context
    Person *person                          = [Person MR_createInContext:localContext];
    person.firstname = randomName;
    person.lastname = @"fakelastname";
    person.age = [NSNumber numberWithInt:19];
    
    // Save the modification in the local context
    [localContext MR_save];
}

- (IBAction)editAction:(id)sender
{
    if(self.editing){
        [self setEditing:NO animated:YES];
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_editBtn setTitle:@"编辑" forState:UIControlStateHighlighted];
        [_tableView setEditing:NO animated:YES];
    } else{
        [self setEditing:YES animated:YES];
        [_editBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_editBtn setTitle:@"完成" forState:UIControlStateHighlighted];
        [_tableView setEditing:YES animated:YES];
    }
}
#pragma mark - lifecycle methods


- (void)setup
{
    // Custom initialization
    self.navTitle = @"CoreDataTest";
    _persons = [[NSMutableArray alloc] init];
    _fetchedResultsController = [Person MR_fetchAllSortedBy:@"firstname" 
                                                  ascending:YES 
                                              withPredicate:nil
                                                    groupBy:nil
                                                   delegate:self
                                                  inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

- (id)init
{
    self = [super initWithNibName:@"MagicalRecordCoreDataViewController" bundle:nil];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark -
#pragma mark UITableViewDelegate

// the table's selection has changed, switch to that item's UIViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Person *selectedPerson  = [_fetchedResultsController objectAtIndexPath:indexPath];
        
        // Remove the person
        [selectedPerson MR_deleteInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
        
        [[NSManagedObjectContext MR_contextForCurrentThread] MR_save];
    }
}

// tell our table how many rows it will have, in our case the size of our menuList
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    
	return [sectionInfo numberOfObjects];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Person *currentPerson       = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text         = [NSString stringWithFormat:@"%@ %@", currentPerson.firstname, currentPerson.lastname];
    cell.detailTextLabel.text   = [NSString stringWithFormat:@"%@y", currentPerson.age];
}

// tell our table what kind of cell to use and its title for the given row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (cell == nil){
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
	}
    
    // Set up the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
	return cell;
}

#pragma mark - NSFetchedResultsController Delegate Methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type){
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[_tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    
    switch(type){
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}


@end
