//
//  CTView.m
//  CoreTextMagazine
//
//  Created by Marin Todorov on 8/11/11.
//  Copyright 2011 Marin Todorov. All rights reserved.
//

#import "ITTStyledLabel.h"
#import <CoreText/CoreText.h>
#import "ITTStyledLabelMarkupParser.h"
#import "ITTStyleLabelContentButton.h"

@interface ITTStyledLabel()
@end

@implementation ITTStyledLabel
#pragma mark - private methods
- (void)prepareButtonsWithFrame:(CTFrameRef)f
{
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(f); //1
    
    CGPoint origins[[lines count]];
    CTFrameGetLineOrigins(f, CFRangeMake(0, 0), origins); //2
    
    NSUInteger lineIndex = 0;
    for (id lineObj in lines) { //5
        CTLineRef line = (__bridge CTLineRef)lineObj;
        
        for (id runObj in (NSArray *)CFBridgingRelease(CTLineGetGlyphRuns(line))) { //6
            CTRunRef run = (__bridge CTRunRef)runObj;
            
            // add button
            CFDictionaryRef attrs = CTRunGetAttributes(run);
            NSDictionary *attrDic = (__bridge id)attrs;
            BOOL hasLink = NO;
            if (attrDic[@"hasLink"]) {
                hasLink = [attrDic[@"hasLink"] boolValue];
            }
            if (hasLink) {
                CGRect runBounds;
                CGFloat ascent;//height above the baseline
                CGFloat descent;//height below the baseline
                runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL); //8
                runBounds.size.height = ascent + descent;
                
                CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
                runBounds.origin.x = origins[lineIndex].x + xOffset;
                runBounds.origin.y = origins[lineIndex].y;
                
                NSString *href = attrDic[@"href"];
                [_btnsToDraw addObject:@[href, NSStringFromCGRect(runBounds)]];
            }
        }
        lineIndex++;
    }
}
-(void)prepareImagesWithFrame:(CTFrameRef)f
{
    if (!_imageInfos || [_imageInfos count] == 0) {
        return;
    }
    
    [_imagesToDraw removeAllObjects];
    
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(f); //1
    
    CGPoint origins[[lines count]];
    CTFrameGetLineOrigins(f, CFRangeMake(0, 0), origins); //2
    
    int imgIndex = 0; //3
    NSDictionary* nextImage = _imageInfos[imgIndex];
    int imgLocation = [nextImage[@"location"] intValue];
    
    //find images
    CFRange frameRange = CTFrameGetVisibleStringRange(f); //4
    while ( imgLocation < frameRange.location ) {
        imgIndex++;
        if (imgIndex>=[_imageInfos count]) return; //quit if no images for this column
        nextImage = _imageInfos[imgIndex];
        imgLocation = [nextImage[@"location"] intValue];
    }
    
    NSUInteger lineIndex = 0;
    for (id lineObj in lines) { //5
        CTLineRef line = (__bridge CTLineRef)lineObj;
        
        for (id runObj in (__bridge NSArray *)CTLineGetGlyphRuns(line)) { //6
            CTRunRef run = (__bridge CTRunRef)runObj;
            CFRange runRange = CTRunGetStringRange(run);
            
            //process image
            if ( runRange.location <= imgLocation && runRange.location+runRange.length > imgLocation ) { //7
                CGRect runBounds;
                CGFloat ascent;//height above the baseline
                CGFloat descent;//height below the baseline
                runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL); //8
                runBounds.size.height = ascent + descent;
                
                CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL); //9
                //runBounds.origin.x = origins[lineIndex].x + self.frame.origin.x + xOffset;
                runBounds.origin.x = origins[lineIndex].x + xOffset;
                
                runBounds.origin.y = origins[lineIndex].y + self.frame.origin.y;
                runBounds.origin.y -= descent;
                
                
                UIImage *img = [UIImage imageNamed: nextImage[@"fileName"] ];
                CGPathRef pathRef = CTFrameGetPath(f); //10
                CGRect colRect = CGPathGetBoundingBox(pathRef);
                
                CGRect imgBounds = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y - self.frame.origin.y);
                ITTDINFO(@"image bounds%@",NSStringFromCGRect(imgBounds));
                [_imagesToDraw addObject: //11
                 @[img, NSStringFromCGRect(imgBounds)]
                 ];
                //load the next image //12
                imgIndex++;
                if (imgIndex < [_imageInfos count]) {
                    nextImage = _imageInfos[imgIndex];
                    imgLocation = [nextImage[@"location"] intValue];
                }
                
            }
        }
        lineIndex++;
    }
}

- (void)linkClickedWithHref:(ITTStyleLabelContentButton*)btn
{
    if (_delegate && [_delegate respondsToSelector:@selector(styledLabel:linkClickedWithHref:)]) {
        [_delegate styledLabel:self linkClickedWithHref:btn.href];
    }
    ITTDINFO(@"link href:%@",btn.href);
}

- (void)initView
{
    _shouldAutoResize = YES;
    _imagesToDraw = [[NSMutableArray alloc] init];
    _btnsToDraw = [[NSMutableArray alloc] init];
    _font = [UIFont systemFontOfSize:13];
    _color = [UIColor blackColor];
}

#pragma mark - lifecycle methods
-(void)dealloc
{
    _delegate = nil;
//    CFRelease(_ctFrame);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self initView];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Flip the coordinate system
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CTFrameDraw(_ctFrame, context);
    // add images
    for (NSArray* imageData in _imagesToDraw) {
        UIImage* img = imageData[0];
        CGRect imgBounds = CGRectFromString(imageData[1]);
        CGContextDrawImage(context, imgBounds, img.CGImage);
    }
    // add btns
    // 1.remove all existing btns
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[ITTStyleLabelContentButton class]]) {
            [view removeFromSuperview];
        }
    }
    // 2.add all btns
    for (NSArray *btnData in _btnsToDraw) {
        NSString *href = btnData[0];
        CGRect btnFrame = CGRectFromString(btnData[1]);
        ITTStyleLabelContentButton *btn = [ITTStyleLabelContentButton buttonWithType:UIButtonTypeCustom];
        //set frame for btn :since the Matrix is flipped upside down, the btn frame should do that too.
        CGRect adjustedBtnFrame = CGRectMake(btnFrame.origin.x, self.bounds.size.height - btnFrame.origin.y - btnFrame.size.height, btnFrame.size.width, btnFrame.size.height);
        btn.frame = adjustedBtnFrame;
        //btn.backgroundColor = [UIColor grayColor];
        
        btn.href = href;
        [btn addTarget:self action:@selector(linkClickedWithHref:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
    }
}

#pragma mark - public methods

-(void)setContentText:(NSString*)htmlLikeText
{
    if (!_parser) {
        _parser = [[ITTStyledLabelMarkupParser alloc] initWithFont:_font
                                                             color:_color];
    }else {
        [_parser setFont:_font color:_color];
    }
    
    [_parser setMarkupText:htmlLikeText];
    //设置CoreText
    _attString = _parser.attributedString;
    _imageInfos = _parser.images;
    [self updateView];
}

- (void)updateView
{
    ITTDINFO(@"updating styled label view");
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)_attString);
    
    if (_shouldAutoResize) {
        // check actual frame size
        CGRect rectWithBigEnoughtHeight = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, 10000);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, rectWithBigEnoughtHeight);
        
        CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
        CFRelease(path);
        
        // set correct frame size
        CGSize frameSize = [self measureFrame:frameRef];
        CFRelease(frameRef);
        //ITTDINFO(@"correct frameSize:%@",NSStringFromCGSize(frameSize));
        
        self.height = frameSize.height + _parser.paragraphSpace * 2;
        // recalculate path
        CGMutablePathRef adjustedPath = CGPathCreateMutable();
        CGPathAddRect(adjustedPath, NULL, self.bounds);
        _ctFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), adjustedPath, NULL);
        CFRelease(adjustedPath);
        
        [self prepareImagesWithFrame:_ctFrame];
        [self prepareButtonsWithFrame:_ctFrame];
        [self setNeedsDisplay];
    }else{
        // do not resize
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, self.bounds);
        _ctFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
        CFRelease(path);
        [self prepareImagesWithFrame:_ctFrame];
        [self prepareButtonsWithFrame:_ctFrame];
        [self setNeedsDisplay];
    }
    CFRelease(framesetter);
}

- (CGSize)measureFrame:(CTFrameRef)frame
{
    CGPathRef framePath = CTFrameGetPath(frame);
    CGRect frameRect = CGPathGetBoundingBox(framePath);
    CFArrayRef lines = CTFrameGetLines(frame);
    CFIndex numLines = CFArrayGetCount(lines);
    CGFloat maxWidth = 0;
    CGFloat textHeight = 0;
    CFIndex lastLineIndex = numLines - 1;
    
    for(CFIndex index = 0; index < numLines; index++)
    {
        CGFloat ascent, descent, leading, width;
        CTLineRef line = (CTLineRef) CFArrayGetValueAtIndex(lines, index);
        width = CTLineGetTypographicBounds(line, &ascent,  &descent, &leading);
        if (width > maxWidth) { maxWidth = width; }
        if (index == lastLineIndex) {
            CGPoint lastLineOrigin;
            CTFrameGetLineOrigins(frame, CFRangeMake(lastLineIndex, 1), &lastLineOrigin);
            textHeight =  CGRectGetMaxY(frameRect) - lastLineOrigin.y + descent;
        }
    }
    return CGSizeMake(ceil(maxWidth), ceil(textHeight));
}

@end
