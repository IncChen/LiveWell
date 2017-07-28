//
//  UserProfileViewController.m
//  LiveWell
//
//  Created by Mark on 2017/6/21.
//  Copyright © 2017年 mark. All rights reserved.
//

#import "UserProfileViewController.h"

#define Text_Color RGB(51, 51, 51)

@interface UserProfileViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *profileTv;
@property (nonatomic, strong) UILabel *hintLabel;
@property (nonatomic, strong) UILabel *lengthHintLabel;

@end

@implementation UserProfileViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initSubViews

- (void)initSubViews {
    self.navigationItem.title = @"个人简介";
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(toCancelAction)];
    self.navigationItem.leftBarButtonItem = cancelBtn;
    self.navigationItem.leftBarButtonItem.tintColor = Text_Color;
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], UITextAttributeFont, Text_Color, UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(toSaveAction)];
    self.navigationItem.rightBarButtonItem = saveBtn;
    self.navigationItem.rightBarButtonItem.tintColor = Text_Color;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], UITextAttributeFont, Text_Color, UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    
    self.profileTv = [[UITextView alloc] init];
    self.profileTv.frame = CGRectMake(12, 12, ScreenWidth-12*2, ScreenHeight-12);
    self.profileTv.text = self.profile;
    self.profileTv.font = [UIFont systemFontOfSize:14];
    self.profileTv.scrollEnabled = YES;
    self.profileTv.dataDetectorTypes = UIDataDetectorTypeAll;
    self.profileTv.delegate = self;
    self.profileTv.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.profileTv];
    
    self.hintLabel = [[UILabel alloc] init];
    self.hintLabel.frame = CGRectMake(4, 0, 200, 32);
    self.hintLabel.text = @"介绍一下自己吧";
    self.hintLabel.textColor = RGB(181, 181, 181);
    self.hintLabel.font = [UIFont systemFontOfSize:14];
    self.hintLabel.enabled = NO;
    self.hintLabel.backgroundColor = [UIColor clearColor];
    [self.profileTv addSubview:self.hintLabel];
    if ([self isNotWriteProfile]) {
        self.hintLabel.hidden = NO;
    } else {
        self.hintLabel.hidden = YES;
    }
    
    self.lengthHintLabel = [[UILabel alloc] init];
    self.lengthHintLabel.frame = CGRectMake(0, ScreenHeight-40, ScreenWidth, 40);
    self.lengthHintLabel.backgroundColor = RGBA(245, 246, 250, 1.0);
    self.lengthHintLabel.text = [NSString stringWithFormat:@"%ld/20", self.profile.length];
    self.lengthHintLabel.textColor = RGB(181, 181, 181);
    self.lengthHintLabel.font = [UIFont systemFontOfSize:14];
    self.lengthHintLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.lengthHintLabel];
}

#pragma mark - Private method

- (BOOL)isNotWriteProfile {
    if ([self.profile isEqual:[NSNull null]]
        || self.profile == nil
        || self.profile.length == 0) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - NSNotification

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    CGFloat height = keyboardRect.size.height;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    self.lengthHintLabel.frame = CGRectMake(self.lengthHintLabel.frame.origin.x,
                                     ScreenHeight-self.lengthHintLabel.frame.size.height-height,
                                     self.lengthHintLabel.frame.size.width,
                                     self.lengthHintLabel.frame.size.height);
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    self.lengthHintLabel.frame = CGRectMake(self.lengthHintLabel.frame.origin.x,
                                            ScreenHeight-self.lengthHintLabel.frame.size.height,
                                            self.lengthHintLabel.frame.size.width,
                                            self.lengthHintLabel.frame.size.height);
    [UIView commitAnimations];
}

#pragma mark - Actions

- (void)toCancelAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)toSaveAction {
    
}

#pragma mark - UITextViewDelegate

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([self.profileTv isFirstResponder]) {
        [self.profileTv resignFirstResponder];
    }
}

-(void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.hintLabel.hidden = NO;
    } else {
        self.hintLabel.hidden = YES;
    }
    
    self.lengthHintLabel.text = [NSString stringWithFormat:@"%ld/20", textView.text.length];
    if (textView.text.length > 20) {
        self.lengthHintLabel.textColor = [UIColor redColor];
    } else {
        self.lengthHintLabel.textColor = RGB(181, 181, 181);
    }
}


@end
