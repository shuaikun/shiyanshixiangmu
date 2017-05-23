//
//  ITTCommonFunctions.m
//  AiTuPianPad
//
//  Created by guo hua on 11-9-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ITTCommonFunctions.h"
CGFloat distanceBetweenPoints(CGPoint p1,CGPoint p2)
{
    return sqrtf((p1.x-p2.x)*(p1.x-p2.x)+(p1.y-p2.y)*(p1.y-p2.y));
}

CGFloat angleOfPointFromCenter(CGPoint p,CGPoint center)
{
    CGFloat angle = -1;
    CGFloat r = distanceBetweenPoints(p, center);
    CGFloat cos = (p.x-center.x)/r;
    CGFloat y = p.y - center.y;
    if(y < 0){
        angle = acosf(cos);
    }else if(y > 0){
        angle = 2*M_PI - acosf(cos);
    }
    return angle;
}

CGPoint CGRectGetCenter(CGRect rect)
{
    return CGPointMake(rect.origin.x+(rect.size.width/2), rect.origin.y+(rect.size.height/2));
}


BOOL ITTIsModalViewController(UIViewController* viewController)
{
    BOOL isModalViewController = NO;
    if ([viewController respondsToSelector:@selector(presentingViewController)]) {
        if ([viewController presentingViewController]) {
            isModalViewController = YES;
        }
    }else {
        if (viewController.navigationController) {
            if([viewController.navigationController parentViewController] != nil){
                isModalViewController = YES;
            }
        }else{
            if([viewController parentViewController] != nil){
                isModalViewController = YES;
            }
        }
    }
    return isModalViewController;
}




//-------------
//NSMutableArray *aRefImgs; // global variable.
void setRefImgs(NSMutableArray *ref){
    aRefImgs=ref;
}

NSMutableArray* ImgArrRef(){
    return aRefImgs;
}
CGPDFDocumentRef MyGetPDFDocumentRef (const char *filename) {
    CFStringRef path;
    CFURLRef url;
    CGPDFDocumentRef document;
    path = CFStringCreateWithCString (NULL, filename,kCFStringEncodingUTF8);
    url = CFURLCreateWithFileSystemPath (NULL, path, kCFURLPOSIXPathStyle, 0);
    CFRelease (path);
    document = CGPDFDocumentCreateWithURL (url);// 2
    CFRelease(url);
    int count = CGPDFDocumentGetNumberOfPages (document);// 3
    if (count == 0) {
        printf("`%s' needs at least one page!", filename);
        return NULL;
    }
    return document;
}

//size_t *totalPages;
void MyDisplayPDFPage (CGContextRef myContext,size_t pageNumber,const char *filename, CGPDFOperatorTableRef tblRef, NSMutableString *mainStr) {
    CGPDFDocumentRef document;
    CGPDFPageRef page;
    document = MyGetPDFDocumentRef (filename);// 1
    totalPages=CGPDFDocumentGetNumberOfPages(document);
    page = CGPDFDocumentGetPage (document, pageNumber);// 2
    CGContextDrawPDFPage (myContext, page);// 3
    CGContextTranslateCTM(myContext, 0, 20);
    CGContextScaleCTM(myContext, 1.0, -1.0);
    CGPDFDocumentRelease (document);// 4
}

