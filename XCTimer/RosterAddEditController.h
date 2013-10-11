//
//  RosterAddEditController.h
//  XCTimer
//
//  Created by MBradley on 12/30/12.
//  Copyright (c) 2012 MBradley. All rights reserved.
//

#import "UniversalController.h"
#import "Person+Methods.h"
#import <QuartzCore/QuartzCore.h>

@interface RosterAddEditController : UniversalController <UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDelegate, UIPopoverControllerDelegate, UIActionSheetDelegate>
{
    UITextField *activeField;
}

-(id)init;
-(id)initWithPerson:(Person*)p;
-(void)createNewPerson;
@end
