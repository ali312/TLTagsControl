//
//  ViewController.m
//  TagsInputSample
//
//  Created by Антон Кузнецов on 11.02.15.
//  Copyright (c) 2015 TheLightPrjg. All rights reserved.
//

#import "ViewController.h"
#import "TLTagsControl.h"
@interface ViewController ()<TLTagsControlDelegate>

@property (nonatomic, strong) IBOutlet TLTagsControl *defaultEditingTagControl;
@property (nonatomic, strong) IBOutlet TLTagsControl *blueEditingTagControl;
@property (nonatomic, strong) IBOutlet TLTagsControl *redEditingTagControl;
@property (nonatomic, strong) IBOutlet TLTagsControl *defauldListingTagControl;
@property (nonatomic, strong) IBOutlet TLTagsControl *blueListingTagControl;
@property (nonatomic, strong) IBOutlet TLTagsControl *redListingTagControl;

@end

@implementation ViewController {
    TLTagsControl *demoTagsControl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSMutableArray *tags = [NSMutableArray arrayWithArray:@[@"A", @"Tag", @"One", @"More", @"Tag", @"And", @"Yet", @"Another", @"One"]];
    _defaultEditingTagControl.tags = [tags mutableCopy];
    _blueEditingTagControl.tags = [tags mutableCopy];
    _redEditingTagControl.tags = [tags mutableCopy];
    _defaultEditingTagControl.tagPlaceholder = @"Placeholder";
    
    _defauldListingTagControl.tags = [tags mutableCopy];
    _blueListingTagControl.tags = [tags mutableCopy];
    _redListingTagControl.tags = [tags mutableCopy];
    
    _defauldListingTagControl.mode = TLTagsControlModeList;
    _blueListingTagControl.mode = TLTagsControlModeList;
    _redListingTagControl.mode = TLTagsControlModeList;
    
    UIColor *blueBackgroundColor = [UIColor colorWithRed:75.0/255.0 green:186.0/255.0 blue:251.0/255.0 alpha:1];
    UIColor *redBackgroundColor = [UIColor colorWithRed:233.0/255.0 green:70.0/255.0 blue:78.0/255.0 alpha:1];
    UIColor *darkRedButtonColor = [UIColor colorWithRed:250.0/255.0 green:140.0/255.0 blue:140.0/255.0 alpha:1];
    UIColor *whiteTextColor = [UIColor whiteColor];
    
    _blueEditingTagControl.tagsBackgroundColor = blueBackgroundColor;
    _blueEditingTagControl.tagsDeleteButtonColor = whiteTextColor;
    _blueEditingTagControl.tagsTextColor = whiteTextColor;
    
    _blueListingTagControl.tagsBackgroundColor = blueBackgroundColor;
    _blueListingTagControl.tagsTextColor = whiteTextColor;
    
    _redEditingTagControl.tagsBackgroundColor = redBackgroundColor;
    _redEditingTagControl.tagsDeleteButtonColor = darkRedButtonColor;
    _redEditingTagControl.tagsTextColor = whiteTextColor;
    
    _redListingTagControl.tagsBackgroundColor = redBackgroundColor;
    _redListingTagControl.tagsTextColor = whiteTextColor;
    
    [_defaultEditingTagControl reloadTagSubviews];
    [_blueEditingTagControl reloadTagSubviews];
    [_redEditingTagControl reloadTagSubviews];
    [_defauldListingTagControl reloadTagSubviews];
    [_blueListingTagControl reloadTagSubviews];
    [_redListingTagControl reloadTagSubviews];
    [_redListingTagControl setTapDelegate:self];
    
    demoTagsControl = [[TLTagsControl alloc]initWithFrame:CGRectMake(8, 340, self.view.frame.size.width - 16, 36)
                                                  andTags:@[@"These", @"Tags", @"Are", @"Tapable"]
                                      withTagsControlMode:TLTagsControlModeList];
    
    [demoTagsControl reloadTagSubviews];
    [demoTagsControl setTapDelegate:self];
    [self.view addSubview:demoTagsControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TLTagsControlDelegate
- (void)tagsControl:(TLTagsControl *)tagsControl tappedAtIndex:(NSInteger)index {
    NSLog(@"Tag \"%@\" was tapped", tagsControl.tags[index]);
}

@end
