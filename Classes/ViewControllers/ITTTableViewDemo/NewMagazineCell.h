//
//  BigBookView.h
//  NationalGeography
//
//  Created by xiaoyu on 12-10-9.
//
//

#import <UIKit/UIKit.h>

@interface NewMagazineCell : UITableViewCell
@property (nonatomic, strong) NSString *url;
+(id)loadFromXib;
@end
