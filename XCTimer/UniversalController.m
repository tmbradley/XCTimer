//
//  UniversalController.m
//  XCTimer
//
//  Created by MBradley on 12/7/12.
//  Copyright (c) 2012 MBradley. All rights reserved.
//

#import "UniversalController.h"

@interface UniversalController ()

@end

@implementation UniversalController
{
    UIButton *button1;
    UIButton *button2;
}
@synthesize managedObjectContext = _managedObjectContext;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(UIView *)createSortView
{
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.frame = CGRectMake(0,55,(self.view.frame.size.width/4)-2.5,40);
    [button1 addTarget:self action:@selector(sortNameDec) forControlEvents:UIControlEventTouchUpInside];
    [button1 setTitle:@"Decending" forState:UIControlStateNormal];
    [button1 setBackgroundImage:[UIImage imageNamed:@"background.png"] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonView addSubview:button1];
    button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button2.frame = CGRectMake(self.view.frame.size.width/4,55,(self.view.frame.size.width/4)-2.5,40);
    [button2 addTarget:self action:@selector(sortNameAcc) forControlEvents:UIControlEventTouchUpInside];
    [button2 setTitle:@"Ascending" forState:UIControlStateNormal];
    [button2 setBackgroundImage:[UIImage imageNamed:@"background.png"] forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonView addSubview:button2];
    UILabel *nameSortLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,40,(self.view.frame.size.width/2)-2.5,15)];
    nameSortLabel.text= @"Sort by Last Name";
    nameSortLabel.textColor = [UIColor whiteColor];
    nameSortLabel.backgroundColor =[UIColor clearColor];
    nameSortLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nameSortLabel];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button3.frame = CGRectMake(5+2*(self.view.frame.size.width/4),55,(self.view.frame.size.width/4)-2.5,40);
    [button3 addTarget:self action:@selector(sortTimeDec) forControlEvents:UIControlEventTouchUpInside];
    [button3 setTitle:@"Decending" forState:UIControlStateNormal];
    [button3 setBackgroundImage:[UIImage imageNamed:@"background.png"] forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonView addSubview:button3];
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button4.frame = CGRectMake(5+3*(self.view.frame.size.width/4),55,(self.view.frame.size.width/4)-2.5,40);
    [button4 addTarget:self action:@selector(sortTimeAcc) forControlEvents:UIControlEventTouchUpInside];
    [button4 setTitle:@"Ascending" forState:UIControlStateNormal];
    [button4 setBackgroundImage:[UIImage imageNamed:@"background.png"] forState:UIControlStateNormal];
    [button4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonView addSubview:button4];
    UILabel *timeSortLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2,40,(self.view.frame.size.width/2)-2.5,15)];
    timeSortLabel.text= @"Sort by Time";
    timeSortLabel.textColor = [UIColor whiteColor];
    timeSortLabel.backgroundColor =[UIColor clearColor];
    timeSortLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:timeSortLabel];
    return buttonView;
}
-(UIView *)createSortView1
{
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.frame = CGRectMake(0,55,(self.view.frame.size.width/2)-2.5,40);
    [button1 addTarget:self action:@selector(sortDateDec) forControlEvents:UIControlEventTouchUpInside];
    [button1 setTitle:@"ˇ Sort By Date ˇ" forState:UIControlStateNormal];
    [button1 setBackgroundImage:[UIImage imageNamed:@"background.png"] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button1.tag = 1;
    self.b1Down = YES;
    [buttonView addSubview:button1];
    
    button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button2.frame = CGRectMake(5+2*(self.view.frame.size.width/4),55,(self.view.frame.size.width/2)-2.5,40);
    [button2 addTarget:self action:@selector(sortTimeDec) forControlEvents:UIControlEventTouchUpInside];
    [button2 setTitle:@"ˇ Sort By Time ˇ" forState:UIControlStateNormal];
    [button2 setBackgroundImage:[UIImage imageNamed:@"background.png"] forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button2.tag = 2;
    self.b2Down = YES;
    [buttonView addSubview:button2];
    return buttonView;
}
-(void)sortByDate
{
    
}
-(void)sortByTime
{
    
}
-(void)sortByName
{
    
}

-(void)sortNameDec
{
    
}
-(void)sortNameAcc
{
    
}
-(void)sortTimeDec
{
    
}
-(void)sortTimeAcc
{
    
}
-(void)sortDateDec
{
    
}
-(void)sortDateAcc
{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
