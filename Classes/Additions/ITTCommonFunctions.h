//
//  ITTCommonFunctions.h
//  
//
//  Created by guo hua on 11-9-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#pragma mark - CGGeometry functions
CGPoint CGRectGetCenter(CGRect rect);
CGFloat distanceBetweenPoints(CGPoint p1,CGPoint p2);
CGFloat angleOfPointFromCenter(CGPoint p,CGPoint center);
BOOL ITTIsModalViewController(UIViewController* viewController);

 
//-----
NSMutableArray *aRefImgs; // global variable.
void setRefImgs(NSMutableArray *ref);
NSMutableArray* ImgArrRef();
CGPDFDocumentRef MyGetPDFDocumentRef (const char *filename);
size_t *totalPages;
void MyDisplayPDFPage (CGContextRef myContext,size_t pageNumber,const char *filename, CGPDFOperatorTableRef tblRef, NSMutableString *mainStr);