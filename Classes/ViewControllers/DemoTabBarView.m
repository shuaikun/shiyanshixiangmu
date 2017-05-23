//
//  DemoTabBarView.m
//  iTotemFramework
//
//  Created by Sword on 13-1-30.
//  Copyright (c) 2013年 iTotemStudio. All rights reserved.
//

#import "DemoTabBarView.h"

@interface DemoTabBarView()
{
    UIButton        *_selectedButton;    
}

@property (strong, nonatomic) IBOutlet UIButton *tab1Button;
@property (strong, nonatomic) IBOutlet UIButton *tab2Button;
@property (strong, nonatomic) IBOutlet UIButton *tab3Button;
@property (strong, nonatomic) IBOutlet UIButton *tab4Button;
@property (strong, nonatomic) IBOutlet UIButton *tab5Button;
@end

@implementation DemoTabBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    _selectedButton = nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - public methods
- (void) setSelectedIndex:(NSInteger)selectedIndex
{
    [self selectTabAtIndex:selectedIndex];
}

#pragma mark - private methods
- (void)selectTabAtIndex:(int)index
{
    //    _selectedButton.selected = FALSE;
    
    UIColor *c1 = UIColorBlue; // [UIColor colorWithRed:35.f/255.f green:119.f/255.f blue:194.f/255.f alpha:1.f];
    UIColor *c2 = UIColorBackground; //[UIColor colorWithRed:248.f/255.f green:248.f/255.f blue:248.f/255.f alpha:1.f];
    
    switch (index) {
        case 0:{
            /*
            [_tab1Button setImage:[UIImage imageNamed:@"SZ_HOME_HOME.png"] forState:UIControlStateNormal];
            [_tab1Button setImage:[UIImage imageNamed:@"SZ_HOME_HOME_H.png"] forState:UIControlStateHighlighted];
            [_tab1Button setImage:[UIImage imageNamed:@"SZ_HOME_HOME_H.png"] forState:UIControlStateSelected];
            [_tab1Button setBackgroundColor:c1];
            */
            
            [_tab2Button setImage:[UIImage imageNamed:@"SZ_HOME_REPORT_H.png"] forState:UIControlStateNormal];
            [_tab2Button setImage:[UIImage imageNamed:@"SZ_HOME_REPORT_H.png"] forState:UIControlStateHighlighted];
            [_tab2Button setImage:[UIImage imageNamed:@"SZ_HOME_REPORT_H.png"] forState:UIControlStateSelected];
            [_tab2Button setBackgroundColor:c1];

            [_tab3Button setImage:[UIImage imageNamed:@"SZ_HOME_KAOQIN.png"] forState:UIControlStateNormal];
            [_tab3Button setImage:[UIImage imageNamed:@"SZ_HOME_KAOQIN_H.png"] forState:UIControlStateHighlighted];
            [_tab3Button setImage:[UIImage imageNamed:@"SZ_HOME_KAOQIN_H.png"] forState:UIControlStateSelected];
            [_tab3Button setBackgroundColor:c2];
            
            [_tab4Button setImage:[UIImage imageNamed:@"SZ_HOME_MINE.png"] forState:UIControlStateNormal];
            [_tab4Button setImage:[UIImage imageNamed:@"SZ_HOME_MINE_H.png"] forState:UIControlStateHighlighted];
            [_tab4Button setImage:[UIImage imageNamed:@"SZ_HOME_MINE_H.png"] forState:UIControlStateSelected];
            [_tab4Button setBackgroundColor:c2];
            
            /*
            [_tab5Button setImage:[UIImage imageNamed:@"SZ_HOME_MORE.png"] forState:UIControlStateNormal];
            [_tab5Button setImage:[UIImage imageNamed:@"SZ_HOME_MORE_H.png"] forState:UIControlStateHighlighted];
            [_tab5Button setImage:[UIImage imageNamed:@"SZ_HOME_MORE_H.png"] forState:UIControlStateSelected];
            [_tab5Button setBackgroundColor:c2];*/
            
            _selectedButton = _tab2Button;
            break;
        }
        case 1:{
            /*
             [_tab1Button setImage:[UIImage imageNamed:@"SZ_HOME_HOME.png"] forState:UIControlStateNormal];
             [_tab1Button setImage:[UIImage imageNamed:@"SZ_HOME_HOME_H.png"] forState:UIControlStateHighlighted];
             [_tab1Button setImage:[UIImage imageNamed:@"SZ_HOME_HOME_H.png"] forState:UIControlStateSelected];
             [_tab1Button setBackgroundColor:c1];
             */
            
            [_tab2Button setImage:[UIImage imageNamed:@"SZ_HOME_REPORT.png"] forState:UIControlStateNormal];
            [_tab2Button setImage:[UIImage imageNamed:@"SZ_HOME_REPORT_H.png"] forState:UIControlStateHighlighted];
            [_tab2Button setImage:[UIImage imageNamed:@"SZ_HOME_REPORT_H.png"] forState:UIControlStateSelected];
            [_tab2Button setBackgroundColor:c2];
            
            [_tab3Button setImage:[UIImage imageNamed:@"SZ_HOME_KAOQIN_H.png"] forState:UIControlStateNormal];
            [_tab3Button setImage:[UIImage imageNamed:@"SZ_HOME_KAOQIN_H.png"] forState:UIControlStateHighlighted];
            [_tab3Button setImage:[UIImage imageNamed:@"SZ_HOME_KAOQIN_H.png"] forState:UIControlStateSelected];
            [_tab3Button setBackgroundColor:c1];
            
            [_tab4Button setImage:[UIImage imageNamed:@"SZ_HOME_MINE.png"] forState:UIControlStateNormal];
            [_tab4Button setImage:[UIImage imageNamed:@"SZ_HOME_MINE_H.png"] forState:UIControlStateHighlighted];
            [_tab4Button setImage:[UIImage imageNamed:@"SZ_HOME_MINE_H.png"] forState:UIControlStateSelected];
            [_tab4Button setBackgroundColor:c2];
            
            /*
             [_tab5Button setImage:[UIImage imageNamed:@"SZ_HOME_MORE.png"] forState:UIControlStateNormal];
             [_tab5Button setImage:[UIImage imageNamed:@"SZ_HOME_MORE_H.png"] forState:UIControlStateHighlighted];
             [_tab5Button setImage:[UIImage imageNamed:@"SZ_HOME_MORE_H.png"] forState:UIControlStateSelected];
             [_tab5Button setBackgroundColor:c2];*/
            
            _selectedButton = _tab3Button;
            break;
        }
        case 2:{
            /*
             [_tab1Button setImage:[UIImage imageNamed:@"SZ_HOME_HOME.png"] forState:UIControlStateNormal];
             [_tab1Button setImage:[UIImage imageNamed:@"SZ_HOME_HOME_H.png"] forState:UIControlStateHighlighted];
             [_tab1Button setImage:[UIImage imageNamed:@"SZ_HOME_HOME_H.png"] forState:UIControlStateSelected];
             [_tab1Button setBackgroundColor:c1];
             */
            
            [_tab2Button setImage:[UIImage imageNamed:@"SZ_HOME_REPORT.png"] forState:UIControlStateNormal];
            [_tab2Button setImage:[UIImage imageNamed:@"SZ_HOME_REPORT_H.png"] forState:UIControlStateHighlighted];
            [_tab2Button setImage:[UIImage imageNamed:@"SZ_HOME_REPORT_H.png"] forState:UIControlStateSelected];
            [_tab2Button setBackgroundColor:c2];
            
            [_tab3Button setImage:[UIImage imageNamed:@"SZ_HOME_KAOQIN.png"] forState:UIControlStateNormal];
            [_tab3Button setImage:[UIImage imageNamed:@"SZ_HOME_KAOQIN_H.png"] forState:UIControlStateHighlighted];
            [_tab3Button setImage:[UIImage imageNamed:@"SZ_HOME_KAOQIN_H.png"] forState:UIControlStateSelected];
            [_tab3Button setBackgroundColor:c2];
            
            [_tab4Button setImage:[UIImage imageNamed:@"SZ_HOME_MINE_H.png"] forState:UIControlStateNormal];
            [_tab4Button setImage:[UIImage imageNamed:@"SZ_HOME_MINE_H.png"] forState:UIControlStateHighlighted];
            [_tab4Button setImage:[UIImage imageNamed:@"SZ_HOME_MINE_H.png"] forState:UIControlStateSelected];
            [_tab4Button setBackgroundColor:c1];
                         
            
            /*
             [_tab5Button setImage:[UIImage imageNamed:@"SZ_HOME_MORE.png"] forState:UIControlStateNormal];
             [_tab5Button setImage:[UIImage imageNamed:@"SZ_HOME_MORE_H.png"] forState:UIControlStateHighlighted];
             [_tab5Button setImage:[UIImage imageNamed:@"SZ_HOME_MORE_H.png"] forState:UIControlStateSelected];
             [_tab5Button setBackgroundColor:c2];*/
            
            _selectedButton = _tab3Button;
            break;
        }
        case 3:{
            /*
            [_tab4Button setImage:[UIImage imageNamed:@"SZ_HOME_MINE_H.png"] forState:UIControlStateNormal];
            [_tab4Button setImage:[UIImage imageNamed:@"SZ_HOME_MINE_H.png"] forState:UIControlStateHighlighted];
            [_tab4Button setImage:[UIImage imageNamed:@"SZ_HOME_MINE_H.png"] forState:UIControlStateSelected];
            [_tab4Button setBackgroundColor:c1];
            
            [_tab1Button setImage:[UIImage imageNamed:@"SZ_HOME_HOME.png"] forState:UIControlStateNormal];
            [_tab1Button setImage:[UIImage imageNamed:@"SZ_HOME_HOME_H.png"] forState:UIControlStateHighlighted];
            [_tab1Button setImage:[UIImage imageNamed:@"SZ_HOME_HOME_H.png"] forState:UIControlStateSelected];
            [_tab1Button setBackgroundColor:c2];
            
            [_tab2Button setImage:[UIImage imageNamed:@"SZ_HOME_REPORT.png"] forState:UIControlStateNormal];
            [_tab2Button setImage:[UIImage imageNamed:@"SZ_HOME_REPORT_H.png"] forState:UIControlStateHighlighted];
            [_tab2Button setImage:[UIImage imageNamed:@"SZ_HOME_REPORT_H.png"] forState:UIControlStateSelected];
            [_tab2Button setBackgroundColor:c2];
            
            
            [_tab3Button setImage:[UIImage imageNamed:@"SZ_HOME_KAOQIN.png"] forState:UIControlStateNormal];
            [_tab3Button setImage:[UIImage imageNamed:@"SZ_HOME_KAOQIN_H.png"] forState:UIControlStateHighlighted];
            [_tab3Button setImage:[UIImage imageNamed:@"SZ_HOME_KAOQIN_H.png"] forState:UIControlStateSelected];
            [_tab3Button setBackgroundColor:c2];
            
            
            [_tab5Button setImage:[UIImage imageNamed:@"SZ_HOME_MORE.png"] forState:UIControlStateNormal];
            [_tab5Button setImage:[UIImage imageNamed:@"SZ_HOME_MORE_H.png"] forState:UIControlStateHighlighted];
            [_tab5Button setImage:[UIImage imageNamed:@"SZ_HOME_MORE_H.png"] forState:UIControlStateSelected];
            [_tab5Button setBackgroundColor:c2];
             */
            break;
        }
        case 4:{
            /*
            [_tab5Button setImage:[UIImage imageNamed:@"SZ_HOME_MORE_H.png"] forState:UIControlStateNormal];
            [_tab5Button setImage:[UIImage imageNamed:@"SZ_HOME_MORE_H.png"] forState:UIControlStateHighlighted];
            [_tab5Button setImage:[UIImage imageNamed:@"SZ_HOME_MORE_H.png"] forState:UIControlStateSelected];
            [_tab5Button setBackgroundColor:c1];
            
            [_tab1Button setImage:[UIImage imageNamed:@"SZ_HOME_HOME.png"] forState:UIControlStateNormal];
            [_tab1Button setImage:[UIImage imageNamed:@"SZ_HOME_HOME_H.png"] forState:UIControlStateHighlighted];
            [_tab1Button setImage:[UIImage imageNamed:@"SZ_HOME_HOME_H.png"] forState:UIControlStateSelected];
            [_tab1Button setBackgroundColor:c2];
            
            [_tab2Button setImage:[UIImage imageNamed:@"SZ_HOME_REPORT.png"] forState:UIControlStateNormal];
            [_tab2Button setImage:[UIImage imageNamed:@"SZ_HOME_REPORT_H.png"] forState:UIControlStateHighlighted];
            [_tab2Button setImage:[UIImage imageNamed:@"SZ_HOME_REPORT_H.png"] forState:UIControlStateSelected];
            [_tab2Button setBackgroundColor:c2];
            
            [_tab3Button setImage:[UIImage imageNamed:@"SZ_HOME_KAOQIN.png"] forState:UIControlStateNormal];
            [_tab3Button setImage:[UIImage imageNamed:@"SZ_HOME_KAOQIN_H.png"] forState:UIControlStateHighlighted];
            [_tab3Button setImage:[UIImage imageNamed:@"SZ_HOME_KAOQIN_H.png"] forState:UIControlStateSelected];
            [_tab3Button setBackgroundColor:c2];
            
            [_tab4Button setImage:[UIImage imageNamed:@"SZ_HOME_MINE.png"] forState:UIControlStateNormal];
            [_tab4Button setImage:[UIImage imageNamed:@"SZ_HOME_MINE_H.png"] forState:UIControlStateHighlighted];
            [_tab4Button setImage:[UIImage imageNamed:@"SZ_HOME_MINE_H.png"] forState:UIControlStateSelected];
            [_tab4Button setBackgroundColor:c2];

            _selectedButton = _tab5Button;
            */
            break;
        }
        default:
            break;
    }
}

- (IBAction)onTab1BtnClicked
{
    if ([self shouldSelectTab:0]) {
        [self selectTabAtIndex:0];
        [self notifyDelegate:0];
    }
}

- (IBAction)onTab2BtnClicked
{
    if ([self shouldSelectTab:0]) {
        [self selectTabAtIndex:0];
        [self notifyDelegate:0];
    }
}

- (IBAction)onTab3BtnClicked
{
    if ([self shouldSelectTab:1]) {
        [self selectTabAtIndex:1];
        [self notifyDelegate:1];
    }
}

- (IBAction)onTab4BtnClicked
{
    if ([self shouldSelectTab:2]) {
        [self selectTabAtIndex:2];
        [self notifyDelegate:2];
    }
}

- (IBAction)onTab5BtnClicked
{
    if ([self shouldSelectTab:4]) {
        [self selectTabAtIndex:4];
        [self notifyDelegate:4];
    }
}
@end
