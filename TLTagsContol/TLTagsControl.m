//
//  TLTagsControl.m
//  TagsInputSample
//
//  Created by Антон Кузнецов on 11.02.15.
//  Copyright (c) 2015 TheLightPrjg. All rights reserved.
//

#import "TLTagsControl.h"

@interface TLTagsControl () <UITextFieldDelegate, UIGestureRecognizerDelegate>

@end

@implementation TLTagsControl {
    UITextField                 *tagInputField_;
    NSMutableArray              *tagSubviews_;
}

@synthesize tapDelegate;

- (instancetype)init {
    self = [super init];
    
    if (self != nil) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame andTags:(NSArray *)tags withTagsControlMode:(TLTagsControlMode)mode {
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        [self commonInit];
        [self setTags:[[NSMutableArray alloc]initWithArray:tags]];
        [self setMode:mode];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self != nil) {
        [self commonInit];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

- (void)commonInit {
    _tags = [NSMutableArray array];
    
    self.layer.cornerRadius = 5;
    
    tagSubviews_ = [NSMutableArray array];
    
    tagInputField_ = [[UITextField alloc] initWithFrame:self.frame];
    tagInputField_.layer.cornerRadius = 5;
    tagInputField_.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tagInputField_.backgroundColor = [UIColor whiteColor];
    tagInputField_.delegate = self;
    tagInputField_.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    tagInputField_.placeholder = @"tag";
    tagInputField_.autocorrectionType = UITextAutocorrectionTypeNo;
    
    if (_mode == TLTagsControlModeEdit) {
        [self addSubview:tagInputField_];
    }
}

#pragma mark - layout stuff

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize contentSize = self.contentSize;
    CGRect frame = CGRectMake(0, 0, 100, self.frame.size.height);
    CGRect tempViewFrame;
    NSInteger tagIndex = 0;
    for (UIView *view in tagSubviews_) {
        tempViewFrame = view.frame;
        NSInteger index = [tagSubviews_ indexOfObject:view];
        if (index != 0) {
            UIView *prevView = tagSubviews_[index - 1];
            tempViewFrame.origin.x = prevView.frame.origin.x + prevView.frame.size.width + 4;
        } else {
            tempViewFrame.origin.x = 0;
        }
        tempViewFrame.origin.y = frame.origin.y;
        view.frame = tempViewFrame;
        
        if (_mode == TLTagsControlModeList) {
            view.tag = tagIndex;
            
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureAction:)];
            [tapRecognizer setNumberOfTapsRequired:1];
            [tapRecognizer setDelegate:self];
            [view setUserInteractionEnabled:YES];
            [view addGestureRecognizer:tapRecognizer];
        }
        
        tagIndex++;
    }
    
    if (_mode == TLTagsControlModeEdit) {
        frame = tagInputField_.frame;
        frame.size.height = self.frame.size.height;
        frame.origin.y = 0;
        
        if (tagSubviews_.count == 0) {
            frame.origin.x = 7;
        } else {
            UIView *view = tagSubviews_.lastObject;
            frame.origin.x = view.frame.origin.x + view.frame.size.width + 4;
        }
        
        if (self.frame.size.width - tagInputField_.frame.origin.x > 100) {
            frame.size.width = self.frame.size.width - frame.origin.x - 12;
        } else {
            frame.size.width = 100;
        }
        tagInputField_.frame = frame;
    } else {
        UIView *lastTag = tagSubviews_.lastObject;
        if (lastTag != nil) {
            frame = lastTag.frame;
        } else {
            frame.origin.x = 7;
        }
    }
    
    contentSize.width = frame.origin.x + frame.size.width;
    contentSize.height = self.frame.size.height;
    
    self.contentSize = contentSize;
    
    tagInputField_.placeholder = (_tagPlaceholder == nil) ? @"tag" : _tagPlaceholder;
}

- (void)addTag:(NSString *)tag {
    for (NSString *oldTag in _tags) {
        if ([oldTag isEqualToString:tag]) {
            return;
        }
    }
    
    [_tags addObject:tag];
    [self reloadTagSubviews];
    
    CGSize contentSize = self.contentSize;
    CGPoint offset = self.contentOffset;
    
    if (contentSize.width > self.frame.size.width) {
        if (_mode == TLTagsControlModeEdit) {
            offset.x = tagInputField_.frame.origin.x + tagInputField_.frame.size.width - self.frame.size.width;
        } else {
            UIView *lastTag = tagSubviews_.lastObject;
            offset.x = lastTag.frame.origin.x + lastTag.frame.size.width - self.frame.size.width;
        }
    } else {
        offset.x = 0;
    }
    
    self.contentOffset = offset;
}

- (void)reloadTagSubviews {
    
    for (UIView *view in tagSubviews_) {
        [view removeFromSuperview];
    }
    
    [tagSubviews_ removeAllObjects];
    
    UIColor *tagBackgrounColor = _tagsBackgroundColor != nil ? _tagsBackgroundColor : [UIColor colorWithRed:0.9
                                                                                                      green:0.91
                                                                                                       blue:0.925
                                                                                                      alpha:1];
    UIColor *tagTextColor = _tagsTextColor != nil ? _tagsTextColor : [UIColor darkGrayColor];
    UIColor *tagDeleteButtonColor = _tagsDeleteButtonColor != nil ? _tagsDeleteButtonColor : [UIColor blackColor];
    
    
    
    for (NSString *tag in _tags) {
        float width = [tag boundingRectWithSize:CGSizeMake(3000,tagInputField_.frame.size.height)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:tagInputField_.font}
                                        context:nil].size.width;
        
        UIView *tagView = [[UIView alloc] initWithFrame:tagInputField_.frame];
        CGRect tagFrame = tagView.frame;
        tagView.layer.cornerRadius = 5;
        tagFrame.origin.y = tagInputField_.frame.origin.y;
        tagView.backgroundColor = tagBackgrounColor;
        
        UILabel *tagLabel = [[UILabel alloc] init];
        CGRect labelFrame = tagLabel.frame;
        tagLabel.font = tagInputField_.font;
        labelFrame.size.width = width + 16;
        labelFrame.size.height = tagInputField_.frame.size.height;
        tagLabel.text = tag;
        tagLabel.textColor = tagTextColor;
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.clipsToBounds = YES;
        tagLabel.layer.cornerRadius = 5;
        
        if (_mode == TLTagsControlModeEdit) {
            UIButton *deleteTagButton = [[UIButton alloc] initWithFrame:tagInputField_.frame];
            CGRect buttonFrame = deleteTagButton.frame;
            [deleteTagButton.titleLabel setFont:tagInputField_.font];
            [deleteTagButton addTarget:self action:@selector(deleteTagButton:) forControlEvents:UIControlEventTouchUpInside];
            buttonFrame.size.width = deleteTagButton.frame.size.height;
            buttonFrame.size.height = tagInputField_.frame.size.height;
            [deleteTagButton setTag:tagSubviews_.count];
            [deleteTagButton setTitle:@"✕" forState:UIControlStateNormal];
            [deleteTagButton setTitleColor:tagDeleteButtonColor forState:UIControlStateNormal];
            buttonFrame.origin.y = 0;
            buttonFrame.origin.x = labelFrame.size.width;
            
            deleteTagButton.frame = buttonFrame;
            tagFrame.size.width = labelFrame.size.width + buttonFrame.size.width;
            [tagView addSubview:deleteTagButton];
            labelFrame.origin.x = 0;
        } else {
            tagFrame.size.width = labelFrame.size.width + 5;
            labelFrame.origin.x = (tagFrame.size.width - labelFrame.size.width) * 0.5;
        }
        
        [tagView addSubview:tagLabel];
        labelFrame.origin.y = 0;
        UIView *lastView = tagSubviews_.lastObject;
        
        if (lastView != nil) {
            tagFrame.origin.x = lastView.frame.origin.x + lastView.frame.size.width + 4;
        }
        
        tagLabel.frame = labelFrame;
        tagView.frame = tagFrame;
        [tagSubviews_ addObject:tagView];
        [self addSubview:tagView];
    }
    
    
    if (_mode == TLTagsControlModeEdit) {
        if (tagInputField_.superview == nil) {
            [self addSubview:tagInputField_];
        }
        CGRect frame = tagInputField_.frame;
        if (tagSubviews_.count == 0) {
            frame.origin.x = 7;
        } else {
            UIView *view = tagSubviews_.lastObject;
            frame.origin.x = view.frame.origin.x + view.frame.size.width + 4;
        }
        tagInputField_.frame = frame;
        
    } else {
        if (tagInputField_.superview != nil) {
            [tagInputField_ removeFromSuperview];
        }
    }
    
    [self setNeedsLayout];
}

#pragma mark - buttons handlers

- (void)deleteTagButton:(UIButton *)sender {
    UIView *view = sender.superview;
    [view removeFromSuperview];
    
    NSInteger index = [tagSubviews_ indexOfObject:view];
    [_tags removeObjectAtIndex:index];
    [self reloadTagSubviews];
}

- (void)tagButtonPressed:(id)sender {
    UIButton *button = sender;
    
    tagInputField_.text = @"";
    [self addTag:button.titleLabel.text];
}

#pragma mark - textfield stuff

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length > 0) {
        NSString *tag = textField.text;
        textField.text = @"";
        [self addTag:tag];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *resultingString;
    NSString *text = textField.text;
    
    
    if (string.length == 1 && [string rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location != NSNotFound) {
        return NO;
    } else {
        if (!text || [text isEqualToString:@""]) {
            resultingString = string;
        } else {
            if (range.location + range.length > text.length) {
                range.length = text.length - range.location;
            }
            
            resultingString = [textField.text stringByReplacingCharactersInRange:range
                                                                      withString:string];
        }
        
        NSArray *components = [resultingString componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]];
        
        if (components.count > 2) {
            for (NSString *component in components) {
                if (component.length > 0 && [component rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location == NSNotFound) {
                    [self addTag:component];
                    break;
                }
            }
            
            return NO;
        }
        
        return YES;
    }
}

#pragma mark - other

- (void)setMode:(TLTagsControlMode)mode {
    _mode = mode;
}

- (void)setTags:(NSMutableArray *)tags {
    _tags = tags;
}

- (void)setPlaceholder:(NSString *)tagPlaceholder {
    _tagPlaceholder = tagPlaceholder;
}

- (void)gestureAction:(id)sender {
    UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)sender;
    [tapDelegate tagsControl:self tappedAtIndex:tapRecognizer.view.tag];
}

@end
