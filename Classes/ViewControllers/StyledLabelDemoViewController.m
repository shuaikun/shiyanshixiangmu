//
//  StyledLabelDemoViewController.m
//  iTotemFramework
//
//  Created by jack 廉洁 on 4/11/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "StyledLabelDemoViewController.h"
#import "UIAlertView+ITTAdditions.h"

@interface StyledLabelDemoViewController ()

@end

@implementation StyledLabelDemoViewController

#pragma mark - private methods
- (void)setup
{
    self.navTitle = @"图文混排";    
}

#pragma mark - lifecycle methods

- (id)init
{
    self = [super initWithNibName:@"StyledLabelDemoViewController" bundle:nil];
    if (self) {
        [self setup];
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setup];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //NSString *text = @"这是一个<img src=\"1.png\" width=\"20\" height=\"20\" >表情测年本报讯2012年</font>，<font color=\"0,0,255\" strokeColor=\"none\" fontName=\"American Typewriter\">按照政企分开、别被下面那些复杂的表达式吓倒</font>，只要跟着我一步一步来，你会发现正则表达式其实并没有你想像中的那么困难。当然，如果你看完了这篇教程之后，<font color=\"123,123,70\">发现自己明白了很多，却又几乎什么都记不得，那也是很正常的——我认为，没接触过正则表达<img src=\"2.png\" width=\"20\" height=\"20\">式的人在</font>看完这篇教程后，从这里换行\r能把提到过的语法记住80%以上的可能性为零。这里只是让你明白基本的原理，以后你还需要多练习，多使用，<a href=\"somethinguseful\"><font color=\"255,0,0\">这是一个链接，有点击事件响应</font></a>这里只是让你明白基本的原理，这里只是让你明白基本的原理，这里只是让你明白基本的原理，这里只是让你明白基本的原理这里只是让你明白基本的原理，这里只是让你明白基本的原理，这里只是让你明白基本的原理 \r再来一遍\r这是一个<img src=\"1.png\" width=\"20\" height=\"20\" >表情测年本报讯2012年</font>，<font color=\"0,0,255\" strokeColor=\"none\" fontName=\"American Typewriter\">按照政企分开、别被下面那些复杂的表达式吓倒</font>，只要跟着我一步一步来，你会发现正则表达式其实并没有你想像中的那么困难。当然，如果你看完了这篇教程之后，<font color=\"123,123,70\">发现自己明白了很多，却又几乎什么都记不得，那也是很正常的——我认为，没接触过正则表达<img src=\"2.png\" width=\"20\" height=\"20\">式的人在</font>看完这篇教程后，从这里换行\r能把提到过的语法记住80%以上的可能性为零。这里只是让你明白基本的原理，以后你还需要多练习，多使用，<a href=\"somethinguseful\">  这也是一个链接，有点击事件响应  </a>这里只是让你明白基本的原理，这里只是让你明白基本的原理，这里只是让你明白基本的原理，这里只是让你明白基本的原理这里只是让你明白基本的原理，这里只是让你明白基本的原理，这里只是让你明白基本的原理";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"zombies" ofType:@"txt"];
    NSString *text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    _styleLabel.delegate = self;
    _styleLabel.font = [UIFont systemFontOfSize:14]; // default font is systemFontOfSize 13
    _styleLabel.color = [UIColor greenColor];        // default color is black
    //_styleLabel.shouldAutoResize = NO;               // default is YES
    [_styleLabel setContentText:text];
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.width, _styleLabel.height + _styleLabel.top * 2)];
    
}
#pragma mark - public methods
- (void)styledLabel:(ITTStyledLabel*)styledLabel linkClickedWithHref:(NSString*)href
{
    [UIAlertView popupAlertByDelegate:nil title:@"链接被点击" message:href];
}

@end
