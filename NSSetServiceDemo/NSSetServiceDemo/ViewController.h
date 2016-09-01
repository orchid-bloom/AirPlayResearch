//
//  ViewController.h
//  NSSetServiceDemo
//
//  Created by Abhishek Shinde on 23/11/15.
//  Copyright © 2015 Abhishek Shinde. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <NSNetServiceBrowserDelegate,NSNetServiceDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;


@end