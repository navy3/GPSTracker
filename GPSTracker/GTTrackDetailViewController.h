//
//  GTTrackDetailViewController.h
//  GPSTracker
//
//  Created by  on 12-7-22.
//  Copyright (c) 2012年 freelancer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGSingleChooseViewController.h"
#import "FGTextFieldViewController.h"
#import "GTDetailDao.h"
#import "GTTrackDao.h"
#import "FGTextViewViewController.h"
#import "GTRecordViewController.h"
#import "FGSinglePhotoViewController.h"

enum
{
    Text_New = 0,
    Text_Modify = 1,
    Text_Address
}TextTypes;

@class GTTrack,GTTrackDetail;

@interface GTTrackDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,FGTextFieldDelegate,FGSingleChooseDelegate,FGTextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,GTRecordDelegate,UIActionSheetDelegate,FGPhotoDelegate>

@property (nonatomic, retain) GTTrack *track;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) UITableView *tbView;

@property (nonatomic, retain) GTTrackDao *trackDao;
@property (nonatomic, retain) GTDetailDao *detailDao;
@property (nonatomic, retain) GTTrackDetail *trackDetail;
@property (nonatomic, retain) UIImagePickerController *pickerCtrl;
@property (nonatomic, assign) int textFlag;
@property (nonatomic, assign) int selectedIndex;

@end
