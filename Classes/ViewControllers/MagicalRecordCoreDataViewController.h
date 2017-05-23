//
//  MagicalRecordCoreDataViewController.h
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/19/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

//  MagicalRecord文档参见 https://github.com/magicalpanda/MagicalRecord

#import "BaseDemoViewController.h"

@interface MagicalRecordCoreDataViewController : BaseDemoViewController<UITableViewDelegate,UITableViewDelegate,NSFetchedResultsControllerDelegate>{
    NSMutableArray *_persons;
    NSFetchedResultsController *_fetchedResultsController;
    UIButton *_editBtn;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
