//
//  ViewController.m
//  NSSetServiceDemo
//
//  Created by Abhishek Shinde on 23/11/15.
//  Copyright © 2015 Abhishek Shinde. All rights reserved.

#import "ViewController.h"
#include <arpa/inet.h>
@interface ViewController ()
@property (strong,atomic) NSMutableArray *serviceList;
@property (strong,atomic) NSMutableArray *serviceIps;
@end

@implementation ViewController
NSNetService *service;
NSNetServiceBrowser *serviceBrowser;
bool searching;



- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.serviceList = [[NSMutableArray alloc] init];
    self.serviceIps = [[NSMutableArray alloc] init];
    
    _tableview.delegate=self;
    _tableview.dataSource = self;
    searching = NO;
    
    
    serviceBrowser = [[NSNetServiceBrowser alloc] init];
    [serviceBrowser setDelegate:self];
    [serviceBrowser searchForServicesOfType:@"_http._tcp." inDomain:@""];
    
    
}



//delegates
//service begin search
-(void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)browser{
    searching = YES;
    NSLog(@"is searching %d",searching);
}

-(void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveService:(NSNetService *)service moreComing:(BOOL)moreComing{
    
    
}
-(void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveDomain:(NSString *)domainString moreComing:(BOOL)moreComing{
    NSLog(@"this domain is not available %@",domainString);
    
}

//service stop search
-(void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)browser{
    searching = NO;
    NSLog(@"Stoped Searching");
    
}



- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
             didNotSearch:(NSDictionary *)errorDict
{
    NSLog(@"Stoped Searchingasd");
    searching = NO;
}

//network browsing fails
-(void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)service moreComing:(BOOL)moreComing{
    [self.serviceList addObject:service.name];
    [self obtainService:service.name];
    //    [self.tableview reloadData];
        NSLog(@"%@",service.type);
        NSLog(@"%@",service.hostName);
        NSLog(@"%@",service.description);
        NSLog(@"%@",service.addresses);
}






-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.serviceList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.serviceList[indexPath.row];
    cell.detailTextLabel.text = self.serviceIps[indexPath.row];
    return cell;
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)obtainService:(NSString *)name{
    service = [[NSNetService alloc] initWithDomain:@"local." type:@"_http._tcp." name:name];
    
    if (service) {
        [service setDelegate:self];
        NSLog(@"%@",service.addresses);
        [service resolveWithTimeout:0.5];
        // [service publish];
    }else
    {
        NSLog(@"An error occurred initializing the NSNetService object.");
    }
    
}

//NSNetService Delegates


-(void)netServiceDidResolveAddress:(NSNetService *)sender{
    NSLog(@"Sender %@",sender.addresses);
    
    //    for (NSData *addressData in [sender addresses]) {
    //        NSString *address = [[NSString alloc] initWithData:addressData encoding:NSUTF8StringEncoding];
    //        NSLog(@";%@";, address);
    //    }
    for (NSData *address in [sender addresses]) {
        struct sockaddr_in *socketAddress = (struct sockaddr_in *) [address bytes];
        
        NSLog(@";Service name: %@ , ip: %s ", [sender name], inet_ntoa(socketAddress->sin_addr));
        NSString *a = [NSString stringWithUTF8String:inet_ntoa(socketAddress->sin_addr)];
        [self.serviceIps addObject:a ];
    }
    [self.tableview reloadData];
}

-(void)netService:(NSNetService *)sender didNotResolve:(NSDictionary<NSString *,NSNumber *> *)errorDict{
}



@end


//    service = [[NSNetService alloc] initWithDomain:@"" type:@"_myservice_._tcp" name:@"" port:344];
//
//    if (service) {
//        [service setDelegate:self];
//        [service publish];
//    }else
//    {
//        NSLog(@"An error occurred initializing the NSNetService object.");
//    }
//
//
//NSNetService Delegates
//-(void)netServiceWillPublish:(NSNetService *)sender{
//
//}
//-(void)netServiceDidPublish:(NSNetService *)sender{
//
//}
//
//- (void)netService:(NSNetService *)sender
//     didNotPublish:(NSDictionary *)errorDict{
//    NSLog(@"%@",errorDict);
//
//}
