//
//  ViewController.m
//  tongxunlu
//
//  Created by 大麦 on 15/7/15.
//  Copyright (c) 2015年 lsp. All rights reserved.
//

#import "ViewController.h"
#import "Information.h"
#import "InfoT.h"
@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *arrayAll;
@property (nonatomic, strong) UITableView *tableV;
@property (strong, nonatomic) CoreDateManager *coreManager;


@end



@implementation ViewController


@synthesize coreManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self aa];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(!self.coreManager)
    {
       self.coreManager = [[CoreDateManager alloc]init];
    }
    [self.arrayAll removeAllObjects];
    self.arrayAll = [coreManager selectData:100 andOffset:1];
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        [self creatTableView];
    });
}

-(void)insertAction
{
    int k = arc4random()%100+100;
    NSString *useridValue = [NSString stringWithFormat:@"%d",k];
    NSString *nameValue = [NSString stringWithFormat:@"name%@",useridValue];
    NSString *sexValue = @"";
    if(k%2==0)
    {
        sexValue = @"boy";
    }
    else
    {
        sexValue = @"girl";
    }
    
    InfoT *info = [[InfoT alloc]init];
    info.name = nameValue;
    info.sex = sexValue;
    info.userid = useridValue;
    [coreManager insertCoreData:[NSMutableArray arrayWithObject:info]];
    
}
-(void)refreshAction
{
    [self.arrayAll removeAllObjects];
    self.arrayAll = [coreManager selectData:100 andOffset:1];
    [self.tableV reloadData];
}

-(void)deleAction
{
    [coreManager deleteDataWithUserId:nil];
    [self.arrayAll removeAllObjects];
    self.arrayAll = [coreManager selectData:100 andOffset:1];
    [self.tableV reloadData];
}

-(void)updateAction
{
    [coreManager updateData:[[self.arrayAll lastObject]valueForKey:@"userid"] withIsSex:[[self.arrayAll lastObject]valueForKey:@"sex"]];
    [self.tableV reloadData];
}

-(void)creatTableView
{
    UIButton *btn_insert = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn_insert setTitle:@"插入" forState:UIControlStateNormal];
    [btn_insert addTarget:self action:@selector(insertAction) forControlEvents:UIControlEventTouchUpInside];
    [btn_insert setFrame:CGRectMake(0, 20, 80, 40)];
    [self.view addSubview:btn_insert];
    
    UIButton *btn_refresh = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn_refresh setTitle:@"刷新" forState:UIControlStateNormal];
    [btn_refresh addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
    [btn_refresh setFrame:CGRectMake(80, 20, 80, 40)];
    [self.view addSubview:btn_refresh];
    
    UIButton *btn_dele = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn_dele setTitle:@"删除所有" forState:UIControlStateNormal];
    [btn_dele addTarget:self action:@selector(deleAction) forControlEvents:UIControlEventTouchUpInside];
    [btn_dele setFrame:CGRectMake(160, 20, 80, 40)];
    [self.view addSubview:btn_dele];
    
    UIButton *btn_update = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn_update setTitle:@"更新" forState:UIControlStateNormal];
    [btn_update addTarget:self action:@selector(updateAction) forControlEvents:UIControlEventTouchUpInside];
    [btn_update setFrame:CGRectMake(240, 20, 80, 40)];
    [self.view addSubview:btn_update];
    
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.backgroundColor = [UIColor greenColor];
    [tableView setFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y+100, self.view.frame.size.width,self.view.frame.size.height-200)];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableV = tableView;
    [self.view addSubview:tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayAll count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[[self.arrayAll objectAtIndex:indexPath.row]valueForKey:@"name"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[[self.arrayAll objectAtIndex:indexPath.row]valueForKey:@"sex"]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        [coreManager deleteDataWithUserId:[[self.arrayAll objectAtIndex:indexPath.row]valueForKey:@"userid"]];
        [self.arrayAll removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self refreshAction];
    }
}

int (^myBlock)(int) = ^(int num)
{
    return num;
};

-(void)aa
{
    NSLog(@"%d",myBlock(3));
}

@end
