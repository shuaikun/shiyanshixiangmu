//
//  DataCacheViewController.m
//  iTotemFramework
//
//  Created by Sword on 13-9-6.
//  Copyright (c) 2013年 iTotemStudio. All rights reserved.
//

#import "DataCacheViewController.h"
#import "ITTDataCacheManager.h"
#import "Catalog.h"
#import "User.h"
#import "Credit.h"

@interface DataCacheViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation DataCacheViewController

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
	[self showCacheData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [super viewDidUnload];
}

- (IBAction)onClearButtonTouched:(id)sender
{
	[[ITTDataCacheManager sharedManager] clearAllCache];
}

- (IBAction)onMemoryCacheButtonTouched:(id)sender
{
	//cache data to local
    [[ITTDataCacheManager sharedManager] addObjectToMemory:@"what your name" forKey:@"helloworld"];
    [[ITTDataCacheManager sharedManager] addObjectToMemory:@"memory test" forKey:@"memorytest"];
    UIImage *image = [UIImage imageNamed:@"imageToProcess3.jpg"];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    [[ITTDataCacheManager sharedManager] addObjectToMemory:imageData forKey:@"testdata"];
    
    static NSInteger tag = 1;
    Catalog *catalog = [[Catalog alloc] init];
    catalog.name = [NSString stringWithFormat:@"this is a catalog %d", tag++];
    catalog.type = @"1";
    [[ITTDataCacheManager sharedManager] addObjectToMemory:catalog forKey:@"catalog"];
}

- (IBAction)onDiskCacheButtonTouched:(id)sender
{
	//cache data to local
    [[ITTDataCacheManager sharedManager] addObject:@"what your name" forKey:@"helloworld"];
    [[ITTDataCacheManager sharedManager] addObject:@"memory test" forKey:@"memorytest"];
    UIImage *image = [UIImage imageNamed:@"imageToProcess3.jpg"];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    [[ITTDataCacheManager sharedManager] addObject:imageData forKey:@"testdata"];
    
    static NSInteger tag = 1;
    Catalog *catalog = [[Catalog alloc] init];
    catalog.name = [NSString stringWithFormat:@"this is a catalog %d", tag++];
    catalog.type = @"1";
    [[ITTDataCacheManager sharedManager] addObject:catalog forKey:@"catalog"];
	[[ITTDataCacheManager sharedManager] doSave];	
}

- (IBAction)onConvertButtonTouched:(id)sender
{
//	[self performSelector:@selector(convert) withObject:nil afterDelay:0.0];
	[self performSelectorInBackground:@selector(convert) withObject:nil];
}

- (void)convert
{
	User *user = [[User alloc] init];
	user.userName = @"hello world!";
	user.password = @"password";
	user.age = @"10";
	NSLog(@"property names and value dic %@", [user propertiesAndValuesDictionary]);
	
	NSMutableArray *objects = [NSMutableArray array];
	NSMutableArray *compareObjects = [NSMutableArray array];
	NSInteger n = 10;
	for (NSInteger i = 0; i < n; i++) {
		User *user = [[User alloc] init];
		user.userName = [NSString stringWithFormat:@"hello world %d!", i];
		user.password = [NSString stringWithFormat:@"password %d!", i];
		user.age = [NSString stringWithFormat:@"%d", 10 + i];
		if (i % 2) {
			Credit *credit = [[Credit alloc] init];
			credit.level = [NSString stringWithFormat:@"level%d", i];
			credit.balance = [NSString stringWithFormat:@"%d", i * 100000];
			user.credit = credit;
			
			[compareObjects addObject:@{@"userName":user.userName, @"password":user.password, @"age":user.age, @"credit":@{@"level":credit.level, @"balance":credit.balance}}];
		}
		[objects addObject:user];
	}
	[objects addObject:@{@"balance":@{@"user":user, @"level":@"10"}}];
	[objects addObject:@{@"array":@[@"1", @"2"]}];
	[objects addObject:@[@"3", @"4"]];
	[objects addObject:@"5"];
	NSLog(@"begin of custom json serialize");
	NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
	for (NSInteger i = 0; i < 100; i++) {
		[NSJSONSerialization jsonStringFromArray:objects];
	}
	interval = [[NSDate date] timeIntervalSince1970] - interval;
	NSLog(@"end of custom json serialize");
	NSLog(@"time escape of custom %lf seconds", interval);
	NSLog(@"%@", [NSJSONSerialization jsonStringFromArray:objects]);
	
	NSLog(@"-------------------------------------------------\n");
	NSLog(@"%@", [NSJSONSerialization jsonStringFromDictionary:@{@"balance":@{@"user":user, @"level":@"10", @"array":@[@{@"test":@"test"},@"2"]}}]);
	NSLog(@"-------------------------------------------------\n");
	NSLog(@"%@", [NSJSONSerialization jsonStringFromDictionary:@{@"array":@[@"1", @"2"]}]);
	NSLog(@"%@", [NSJSONSerialization jsonStringFromDictionary:@{@"test":@"admin"}]);
	NSLog(@"-------------------------------------------------\n");
	NSLog(@"%@", [NSJSONSerialization jsonStringFromDictionary:@{@"array":@[@"1", @"2"]}]);
}

- (void)showCacheData
{
//    [[ITTDataCacheManager sharedManager] setDataCacheType:ITTDataCacheUserDefault];
    NSString *value = (NSString*)[[ITTDataCacheManager sharedManager] getCachedObjectByKey:@"helloworld"];
    NSLog(@"value %@", value);
    value = (NSString*)[[ITTDataCacheManager sharedManager] getCachedObjectByKey:@"memorytest"];
    NSLog(@"value %@", value);
    
	NSData *imageData = (NSData*)[[ITTDataCacheManager sharedManager] getCachedObjectByKey:@"testdata"];
    if (imageData) {
        UIImage *image = [UIImage imageWithData:imageData];
        self.imageView.image = image;
    }
	
    Catalog *catalog =  (Catalog*)[[ITTDataCacheManager sharedManager] getCachedObjectByKey:@"catalog"];
    NSLog(@"catalog %@", catalog);
    catalog.name = @"this is another catalog!";
    catalog =  (Catalog*)[[ITTDataCacheManager sharedManager] getCachedObjectByKey:@"catalog"];
    NSLog(@"catalog %@", catalog);
}
@end
