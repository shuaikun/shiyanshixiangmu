//
//  Catalog.h
//  iTotemFramework
//
//  Created by Sword on 13-1-30.
//  Copyright (c) 2013年 iTotemStudio. All rights reserved.
//

#import "ITTBaseModelObject.h"

typedef enum {
    CatalogTypeUnknown = 0,
    CatalogTypeModalView,               //1
    CatalogTypeTrasition,               //2
    CatalogTypeNetwork,                 //3
    CatalogTypePhotoGalaryView,         //4
    CatalogTypeImageSliderView,         //5
    CatalogTypeTableView,               //6
    CatalogTypeCoverFlow,               //7
    CatalogTypeActivityIndicator,       //8
    CatalogTypeAlert,                   //9
    CatalogTypeNewerHelp,               //10
    CatalogTypeStypedLabel,             //11
    CatalogTypeShare,                   //12
    CatalogTypeImageProcess,            //13
    CatalogTypeCamera,                  //14
    CatalogTypeCoreData,                //16
    CatalogTypeAutoLayout,              //16
    CatalogTypeCalendarView,            //17
    CatalogTypeLandTableView,           //18
    CatalogTypeDataCache,               //19
    CatalogTypeSortableView,            //20
    CatalogTypeWaterfall,               //21
    CatalogTypeLockView,                //22
    CatalogTypeShapedButton,            //23
    CatalogTypeImageInfoView,           //24
    CatalogTypeVersionUpdate            //25

}CatalogType;

@interface Catalog : ITTBaseModelObject<NSCopying>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) CatalogType catalogType;

@end
