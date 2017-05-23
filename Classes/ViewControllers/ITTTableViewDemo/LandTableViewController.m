//
//  ITTLandTableViewController.m
//  iTotemFramework
//
//  Created by 次昌 叶 on 3/5/13.
//  Copyright (c) 2013 iTotemStudio. All rights reserved.
//

#import "LandTableViewController.h"
#import "ITTLandscapeTableView.h"
#import "NewMagazineCell.h"
#import "SDImageCache.h"

#define NEW_MAGAZINE_WIDTH 160

@interface LandTableViewController ()
{
    NSMutableArray *_images;
    IBOutlet ITTLandscapeTableView *_tableView;
}
@end

@implementation LandTableViewController


#pragma mark - object lifecycle
- (void)setup
{
    self.navTitle = @"landTableView demo";
}

- (id)init
{
    self = [super initWithNibName:@"LandTableViewController" bundle:nil];
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
    [self initData];

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    _tableView = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
- (void)initData
{
    _images = [[NSMutableArray alloc] init];
    [_images addObject:@"http://g.hiphotos.baidu.com/pic/w%3D230/sign=450b306e79f0f736d8fe4b023a54b382/6f061d950a7b0208959b39f063d9f2d3572cc855.jpg"];
    [_images addObject:@"http://d.hiphotos.baidu.com/pic/w%3D230/sign=0ed4835348540923aa69647da259d1dc/c9fcc3cec3fdfc0311209ec8d53f8794a4c22661.jpg"];    
    [_images addObject:@"http://content.dili360.com/public/data/posts/cover/2012/160_1352168447.jpg"];
    [_images addObject:@"http://content.dili360.com/public/data/posts/cover/2012/160_1353036365.jpg"];
    [_images addObject:@"http://content.dili360.com/public/data/posts/cover/2012/160_1352357358.jpg"];
    [_images addObject:@"http://content.dili360.com/public/data/posts/cover/2012/160_1353380430.jpg"];
    [_images addObject:@"http://content.dili360.com/public/data/posts/cover/2012/160_1352191871.jpg"];
    [_images addObject:@"http://content.dili360.com/public/data/posts/cover/2012/160_1352689704.jpg"];
    [_images addObject:@"http://content.dili360.com/public/data/posts/cover/2012/160_1350976002.jpg"];
    [_images addObject:@"http://content.dili360.com/public/data/posts/cover/2012/160_1350975768.jpg"];
    [_images addObject:@"http://content.dili360.com/public/data/posts/cover/2012/160_1350974219.jpg"];
    [_images addObject:@"http://content.dili360.com/public/data/posts/cover/2012/160_1352372947.jpg"];
    [_images addObject:@"http://content.dili360.com/public/data/posts/cover/2012/160_1354605491.jpg"];
    [_images addObject:@"http://content.dili360.com/public/data/posts/cover/2013/480_1361174398.jpg"];
    [_images addObject:@"http://content.dili360.com/public/data/posts/cover/2013/480_1360980022.jpg"];
    [_images addObject:@"http://content.dili360.com/public/data/posts/cover/2013/480_1359966552.jpg"];
    [_images addObject:@"http://content.dili360.com/public/data/posts/cover/2013/480_1359960709.jpg"];
    [_images addObject:@"http://content.dili360.com/public/data/posts/cover/2013/480_1361411785.jpg"];
    [_images addObject:@"http://content.dili360.com/public/data/posts/cover/2013/2048_1358321707.jpg"];
    [_images addObject:@"http://content.dili360.com/public/data/posts/cover/2013/2048_1357350664.jpg"];
    [_images addObject:@"http://content.dili360.com/public/data/posts/cover/2013/2048_1357370781.jpg"];
    [_images addObject:@"http://content.dili360.com/public/data/posts/cover/2012/2048_1355283823.jpg"];
    [_tableView reloadData];
}

- (IBAction)onClearCacheButonClick:(id)sender
{
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
}

#pragma mark LandscapeTableViewDataSource
- (NSInteger)numberOfRowsInLandscapeTableView:(ITTLandscapeTableView *)tableView
{
    return _images.count;
}

- (UITableViewCell *)landscapeTableView:(ITTLandscapeTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"NewMagazineCell";
    NewMagazineCell *newMagazine = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (newMagazine == nil) {
        newMagazine = [NewMagazineCell loadFromXib];
    }
    
    newMagazine.url = [_images objectAtIndex:indexPath.row];
    return newMagazine;
}

- (CGFloat)landscapeTableView:(ITTLandscapeTableView *)tableView widthForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NEW_MAGAZINE_WIDTH;
}

@end
