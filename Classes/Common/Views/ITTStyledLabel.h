//
//  CTView.h
//  CoreTextMagazine
//
//  Created by Marin Todorov on 8/11/11.
//  Copyright 2011 Marin Todorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "ITTStyledLabelMarkupParser.h"

@protocol ITTStyledLabelDelegate;

@interface ITTStyledLabel : UIView{
    ITTStyledLabelMarkupParser *_parser;
    CTFrameRef _ctFrame;
    NSAttributedString *_attString;
    NSArray *_imageInfos;
    
    NSMutableArray *_imagesToDraw;
    NSMutableArray *_btnsToDraw;
}
@property (weak, nonatomic) id<ITTStyledLabelDelegate> delegate;
@property (strong, nonatomic) UIFont *font;
@property (strong, nonatomic) UIColor *color;
@property (assign, nonatomic) BOOL shouldAutoResize;

-(void)updateView;
-(void)setContentText:(NSString*)htmlLikeText;

@end
@protocol ITTStyledLabelDelegate <NSObject>
@optional
- (void)styledLabel:(ITTStyledLabel*)styledLabel linkClickedWithHref:(NSString*)href;

@end
