//
//  ABViewController.h
//  ArrivalBoard
//
//  Created by Erik Benoist on 5/17/14.
//  Copyright (c) 2014 eb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ArrivalClient.h"
#import "ETA.h"


@interface ABViewController : UITableViewController<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *places;
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
