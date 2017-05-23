//
//  ITTSortableView.m
//  ITTSortableView
//
//  Created by 胡鹏 on 13-8-28.
//  Copyright (c) 2013年 胡鹏. All rights reserved.
//

#define ITTSortableViewCell_DEFAULT_TAG 12345

#import "ITTSortableView.h"

typedef enum : NSInteger{
    PageDirectionPreviousPage = -1,
    PageDirectionNextPage = 1,
    PageDirectionCurrentPage = 0
} PageDirection;



@interface ITTSortableView() {
    /**
     *	parameters for drawing the interface
     */
    float _marginTop;
    float _marginLeft;
    float _hBlockDistance;
    float _vBlockDistance;
    
    /**
     *	parameters of datasource
     */
    int _columnNumber;
    int _rowNumber;
    int _cellNumber;
    int _pageSize;
    int _pageNumber;
    
    
    /**
     *	parameters for sorting cells
     */
    CGPoint _startPoint;
    
    NSInteger _selectedIndex;
    
    ITTSortableViewCell *_selectedCell;
    
    CGRect _selectedCellFrame;
    
    CGPoint _selectedCellCenter;
    
    NSInteger _currentPageIndex;
    
    /**
     *	prevent two page switch actions in a short time
     */
    BOOL _pageHasChanged;
    
    
    /**
     *	iOS5.0 has some event conficts(button used for deleting cell won't response)
     */
    __strong NSDate *_touchStartTime;
}

#pragma mark - methods of drawing interface

- (void)initParameters;

- (CGRect)getFrameOfCellAtIndex:(NSInteger)index;

- (void)layoutCells;

#pragma mark - event handlers

- (void)registerGestures;

- (void)switchToNormalMode;

#pragma mark - methods of sorting cells

/**
 *	check touch point is on a cell or not
 *
 *	@param	point	touch point
 *
 *	@return	index(index>0) of the cell if touch point is on a cell,-1 if on none of the cells
 */
- (NSInteger)checkSelectedIndex:(CGPoint)point;

/**
 *	get the index range of active page
 *
 *  according to the touch position to calculate the active page index to reduce the number of calculations
 *
 *	@param	point	current touch point 
 *
 *	@return	the index range of active page
 */
- (NSRange)getIndexRangeOfPoint:(CGPoint)point;

/**
 *	calculate a point is in the rectangle area or not
 *
 *	@param	point	point position
 *	@param	rect	rectangle area
 *
 *	@return	true if point is in the rectangle area ,false if not
 */
- (BOOL)point:(CGPoint)point inRect:(CGRect)rect;

/**
 *	get covered cell index while moving the selected cell
 *
 *	@param	point current touch point
 *
 *	@return	covered cell index ,return -1 while no cell was coverd
 */
- (NSInteger)getCoveredCellIndexOfPoint:(CGPoint)point;

/**
 *	check a point is in the effective area of rectangle or not
 *  if point in the effective area ,tiggering the reorder animation
 *
 *	@param	point	touch point
 *	@param	rect	target rectangle area
 *
 *	@return	true if point is in the effective area of rectangle,false if not
 */
- (BOOL)point:(CGPoint)point inRectEffectiveArea:(CGRect)rect;

/**
 *	reorder the positions of cells from _formIndex to _toIndex
 *
 *	@param	fromIndex	start index
 *	@param	toIndex	end index
 */
- (void)animateCellAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animationComplete:(void(^)())completeBlock;

/**
 *	check a point is on the edge of page or not
 *
 *	@param	point	touch point
 *
 *	@return	PageDirection
 */
- (PageDirection)willMoveToAdjacentPage:(CGPoint)point;

- (CGRect)getVisibleRectOfPage:(NSInteger)pageIndex;

- (void)togglePageHasChanged;

@end


@implementation ITTSortableView

- (void)dealloc
{
    ITTDINFO(@"- (void)dealloc");
    _sortableViewDelegate = nil;
    _dataSource = nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_editMode) {
        return;
    }

    _touchStartTime = [NSDate date];
    
    UITouch *touch = [[event allTouches] anyObject];
    
    _startPoint = [touch locationInView:self];
    
    _selectedIndex = [self checkSelectedIndex:_startPoint];
    
    if (_selectedIndex >= 0) {
        
        self.scrollEnabled = false;
        
        _selectedCell = [self getCellAtIndex:_selectedIndex];
        
        _selectedCell.editMode = false;
        
        [self bringSubviewToFront:_selectedCell];
        
        _selectedCellFrame = _selectedCell.frame;
        
        _selectedCellCenter = _selectedCell.center;
        
        //selectedCell.frame = CGRectInset(selectedCellFrame, -5, -5);
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_editMode) {
        return;
    }
    
    if (_selectedIndex <0) {
        return;
    }
    
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint currentPoint = [touch locationInView:self];
    
    float centerX = currentPoint.x - _startPoint.x + _selectedCellCenter.x;
    float centerY = currentPoint.y - _startPoint.y + _selectedCellCenter.y;
    
    _selectedCell.center = CGPointMake(centerX, centerY);
    
    NSInteger coveredIndex = [self getCoveredCellIndexOfPoint:currentPoint];
    
    /**
     *	judge sort condition first
     *  then the page change condition
     */
    if (coveredIndex>=0 && coveredIndex != _selectedIndex) {
        
        @synchronized(self) {
        
            [self animateCellAtIndex:_selectedIndex toIndex:coveredIndex animationComplete:^{
            
            }];
        }
        
    } else {
        
        PageDirection pageDirection = [self willMoveToAdjacentPage:currentPoint];
        
        if (pageDirection != PageDirectionCurrentPage) {
            
            @synchronized(self) {
                
                [self scrollRectToVisible:[self getVisibleRectOfPage:pageDirection + _currentPageIndex] animated:true];
                
                _pageHasChanged = true;
                
                [self performSelector:@selector(togglePageHasChanged) withObject:nil afterDelay:1];
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_editMode) {
        return;
    }
    
    NSDate *_touchEndTime = [NSDate date];
    float timeInterval = [_touchEndTime timeIntervalSinceDate:_touchStartTime];
    if (timeInterval < 0.1) {
        [self switchToNormalMode];
        return;
    }
    
    if (_selectedIndex <0) {
        return;
    }
    [UIView animateWithDuration:0.1 animations:^{
        _selectedCell.frame = _selectedCellFrame;
        
    } completion:^(BOOL finished) {
        
        self.scrollEnabled = true;
        
        _selectedCell.editMode = true;
        _selectedCell = nil;
        _selectedIndex = -1;
        
        if ([_sortableViewDelegate respondsToSelector:@selector(animationOfSortCellHasCompleted:)]) {
            [_sortableViewDelegate animationOfSortCellHasCompleted:self];
            self.scrollEnabled = true;
        }
        
    }];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (!_editMode) {
        return;
    }
    [self touchesEnded:touches withEvent:event];
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.exclusiveTouch = TRUE;		
		self.multipleTouchEnabled = FALSE;
        self.directionalLockEnabled = TRUE;
        [self registerGestures];
        self.autoresizesSubviews = false;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self layoutCells];
}

#pragma mark - interfaces

/**
 *	refresh interface
 */

- (void)reloadData
{
    [self layoutCells];
   // [self drawRect:self.frame];
}

#pragma mark - private methods

- (void)layoutCells
{
    for (UIView *subView in [self subviews]) {
        [subView removeFromSuperview];
    }
    [self initParameters];
    for (int i = 0; i<_cellNumber; i++) {
        ITTSortableViewCell *cell = [_sortableViewDelegate ITTSortableView:self cellForRowAtIndex:i];
        if (cell) {
            cell.frame = [self getFrameOfCellAtIndex:i];
            cell.tag = ITTSortableViewCell_DEFAULT_TAG+i;
            cell.delegate = self;
            cell.editMode = _editMode;
            [self addSubview:cell];
        }
    }
}
/**
 *	init parameters from delegate
 */
- (void)initParameters
{
    _marginTop = [_sortableViewDelegate respondsToSelector:@selector(marginTopOfITTSortableView:)]?[_sortableViewDelegate marginTopOfITTSortableView:self]:0;
    _marginLeft = [_sortableViewDelegate respondsToSelector:@selector(marginLeftOfITTSortableView:)]?[_sortableViewDelegate marginLeftOfITTSortableView:self]:0;
    _hBlockDistance = [_sortableViewDelegate respondsToSelector:@selector(horizontalBlockDistanceOfITTSortableView:)]?[_sortableViewDelegate horizontalBlockDistanceOfITTSortableView:self]:0;
    _vBlockDistance = [_sortableViewDelegate respondsToSelector:@selector(verticalBlockDistanceOfITTSortableView:)]?[_sortableViewDelegate verticalBlockDistanceOfITTSortableView:self]:0;
    
    //get cell number first - to be the default value of _rowNumber
    
    _cellNumber = [_dataSource respondsToSelector:@selector(numberOfCellsInITTSortableView:)]?[_dataSource numberOfCellsInITTSortableView:self]:0;
    
    _columnNumber = [_dataSource respondsToSelector:@selector(numberOfColumnsInITTSortableView:)]?[_dataSource numberOfColumnsInITTSortableView:self]:1;
    _rowNumber = [_dataSource respondsToSelector:@selector(numberOfRowsInITTSortableView:)]?[_dataSource numberOfRowsInITTSortableView:self]:_cellNumber;
    
    _pageSize = _columnNumber * _rowNumber;
    
    _pageNumber = ceil(_cellNumber * 1.0f/ _pageSize);
    
    [self setContentSize:CGSizeMake(self.frame.size.width * _pageNumber, self.frame.size.height)];
}


/**
 *	tap gesture : switch current mode to normal mode
 */
- (void)registerGestures
{
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchToNormalMode)];
//    [self addGestureRecognizer:tap];
}

/**
 *	get the rectangle of cell at index _index
 *
 *	@param	index	cell index,start from zero
 *
 *	@return	the rectangle of the cell at index _index
 */
- (CGRect)getFrameOfCellAtIndex:(NSInteger)index
{
    /**
     *	rowIndex、columnIndex、pageIndex start from zero
     */
    int rowIndex = index/_columnNumber%_rowNumber;
    int columnIndex = index%_columnNumber;
    int pageIndex = index/_pageSize;
    
    float height = [_sortableViewDelegate ITTSortableView:self heightForCellAtIndex:index];
    float width = [_sortableViewDelegate ITTSortableView:self widthForCellAtIndex:index];
    float oX = _marginLeft + columnIndex * (_hBlockDistance + width)+pageIndex*self.frame.size.width;
    float oY = _marginTop + rowIndex * (_vBlockDistance + height);
    
    CGRect rect = CGRectMake(oX, oY, width, height);
    
    return rect;
}


- (void)switchToNormalMode
{
    _editMode = false;
    [self reloadData];
    self.scrollEnabled = true;
}

#pragma mark - methods for sort

- (NSInteger)checkSelectedIndex:(CGPoint)point
{
    NSRange indexRange = [self getIndexRangeOfPoint:point];
    
    NSInteger index = -1;
    
    for (int i = indexRange.location; i<indexRange.location + indexRange.length; i++) {
        
        if (i>=_cellNumber) {
            return -1;
        }
        
        CGRect rect = [self getFrameOfCellAtIndex:i];
        
        if ([self point:point inRect:rect]) {
            index = i;
            break;
        }
    }
    return index;
}

- (NSRange)getIndexRangeOfPoint:(CGPoint)point
{
    NSInteger pageIndex = floor(point.x/self.frame.size.width);
    
    NSInteger startIndex = pageIndex * _pageSize;
    
    NSInteger endIndex = (pageIndex + 1) * _pageSize;
    
    return NSMakeRange(startIndex, endIndex - startIndex);

}

- (BOOL)point:(CGPoint)point inRect:(CGRect)rect
{
    return point.x>CGRectGetMinX(rect) && point.x<CGRectGetMaxX(rect) && point.y>CGRectGetMinY(rect) && point.y<CGRectGetMaxY(rect);
}

- (ITTSortableViewCell *)getCellAtIndex:(NSInteger)index
{
    return (ITTSortableViewCell *)[self viewWithTag:index + ITTSortableViewCell_DEFAULT_TAG];
}

/**
 *	swtich the positions of cells from _formIndex to _toIndex
 *
 *	@param	fromIndex	start index
 *	@param	toIndex	end index
 */
- (void)animateCellAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animationComplete:(void(^)())completeBlock
{
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect tempRect = [self getFrameOfCellAtIndex:fromIndex];
        
        if (toIndex>fromIndex) {
            
            for (int i = fromIndex + 1; i<=toIndex; i++) {
                
                ITTSortableViewCell *cell = [self getCellAtIndex:i];
                
                CGRect rect = cell.frame;
                
                cell.frame = tempRect;
                
                cell.tag = cell.tag - 1;

                tempRect = rect;

            }
            
        } else {
            
            for (int j = fromIndex - 1; j>=toIndex; j--) {
                
                ITTSortableViewCell *cell = [self getCellAtIndex:j];
                
                CGRect rect = cell.frame;
                
                cell.frame = tempRect;
                
                cell.tag = cell.tag + 1;
                  
                tempRect = rect;
            }

        }
        
        _selectedCellFrame = tempRect;
        
        _selectedIndex = toIndex;
        
        _selectedCell.tag = toIndex + ITTSortableViewCell_DEFAULT_TAG;
        
    } completion:^(BOOL finished) {
        completeBlock();
    }];
}


/**
 *	get covered cell index
 *
 *	@param	point current touch point
 *
 *	@return	covered cell index ,return -1 while no cell was coverd
 */
- (NSInteger)getCoveredCellIndexOfPoint:(CGPoint)point
{
    NSRange indexRange = [self getIndexRangeOfPoint:point];
    
    NSInteger index = -1;
    
    for (int i = indexRange.location; i<indexRange.location + indexRange.length; i++) {
        
        if (i>=_cellNumber) {
            return -1;
        }
        
        CGRect rect = [self getFrameOfCellAtIndex:i];
        
        if ([self point:point inRectEffectiveArea:rect]) {
            index = i;
            break;
        }
    }
    return index;
}

/**
 *  effective area of frame : 4/9 area of the frame
 *	
 */
- (BOOL)point:(CGPoint)point inRectEffectiveArea:(CGRect)rect
{
    CGRect newRect = CGRectInset(rect, rect.size.width/6, rect.size.height/6);
    return [self point:point inRect:newRect];
}

/**
 *  effective area of frame : 1/4 area of the frame
 *
 */
- (PageDirection)willMoveToAdjacentPage:(CGPoint)point
{
    //prevent two page switch actions in a short time
    
    if (_pageHasChanged) {
        return PageDirectionCurrentPage;
    }
    
    _currentPageIndex = floor(point.x/self.frame.size.width);
    
    
    CGRect currentPageRect = [self getVisibleRectOfPage:_currentPageIndex];
    
    if (point.x - CGRectGetMinX(currentPageRect)<_selectedCellFrame.size.width/4 && _currentPageIndex != 0) {

        return PageDirectionPreviousPage;
    } else if (CGRectGetMaxX(currentPageRect) - point.x<_selectedCellFrame.size.width/4 && _currentPageIndex + 1<_pageNumber) {
        
        return PageDirectionNextPage;
    }
    
    return PageDirectionCurrentPage;
}


- (CGRect)getVisibleRectOfPage:(NSInteger)pageIndex
{

    return CGRectMake(pageIndex*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
}

- (void)togglePageHasChanged
{
    _pageHasChanged = !_pageHasChanged;
}


#pragma mark - cell delegate

- (void)switchToEditMode
{
    _editMode = true;
    [self reloadData];
    
}

- (void)didSelectCell:(ITTSortableViewCell *)cell
{

    if ([_sortableViewDelegate respondsToSelector:@selector(ITTSortableView: didSelectCell:atIndex:)]) {
        
        NSInteger index = cell.tag - ITTSortableViewCell_DEFAULT_TAG;
        [_sortableViewDelegate ITTSortableView:self didSelectCell:cell atIndex:index];
    }
}

- (void)willDeleteCell:(ITTSortableViewCell *)cell
{
    if (!_editMode) {
        return;
    }
    //__strong ITTSortableViewCell *_cell = cell;
    
    NSInteger index = cell.tag - ITTSortableViewCell_DEFAULT_TAG;
    
    if ([_sortableViewDelegate respondsToSelector:@selector(ITTSortableView:willDelectCell:atIndex:)]) {
        [_sortableViewDelegate ITTSortableView:self willDelectCell:cell atIndex:index];
    }
    
    @synchronized(self) {
    
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect tempRect = cell.frame;
            
            [cell removeFromSuperview];
            
            for (int i = index + 1; i<_cellNumber; i++) {
                
                ITTSortableViewCell *nextCell = [self getCellAtIndex:i];
                nextCell.tag = nextCell.tag - 1;
                CGRect rect = nextCell.frame;
                nextCell.frame = tempRect;
                tempRect = rect;
            }
            
        } completion:^(BOOL finished) {
            
            if ([_sortableViewDelegate respondsToSelector:@selector(ITTSortableView:didDelectCell:atIndex:)]) {
                [_sortableViewDelegate ITTSortableView:self didDelectCell:cell atIndex:cell.tag - ITTSortableViewCell_DEFAULT_TAG];
            }
            
        }];
    }
}
@end
