//
//  TLTagsControl.h
//  TagsInputSample
//
//  Created by Антон Кузнецов on 11.02.15.
//  Copyright (c) 2015 TheLightPrjg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLTagsControl : UIScrollView

@property (nonatomic, strong) NSMutableArray *tags;

- (void)addTag:(NSString *)tag;

@end
