//
//  KeyboardViewController.m
//  ArmenianKeyboard
//
//  Created by Yurii Aleksanian on 11.06.2022.
//

#import "KeyboardViewController.h"
#import <AudioToolbox/AudioToolbox.h>


@interface KeyboardViewController ()

@property (strong, nonatomic) IBOutlet UIView *MainView;

@property (weak, nonatomic) IBOutlet UIView *SymbolsView;
@property (weak, nonatomic) IBOutlet UIView *SmallView;
@property (weak, nonatomic) IBOutlet UIView *BigView;

@property (nonatomic,assign) BOOL uppercase;
@property (nonatomic,assign) BOOL symbols;

@property (nonatomic, strong) UIButton *nextKeyboardButton;
@end

@implementation KeyboardViewController

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Perform custom UI setup here
    self.nextKeyboardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    _SymbolsView.hidden = true;
    _BigView.hidden = true;
    
    [self CloseSymbolsView];
    [self OpenBigView];
    
    [self SetViewsSize];
}

- (void)viewWillAppear
{
    [self SetViewsSize];
}
- (void)viewDidAppear
{
    [self SetViewsSize];
}
- (void)viewDidLayoutSubviews
{
    [self SetViewsSize];
}

- (void)viewWillLayoutSubviews
{
    self.nextKeyboardButton.hidden = !self.needsInputModeSwitchKey;
    [super viewWillLayoutSubviews];
    
    [self SetViewsSize];
}

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
    
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
    
    [self.nextKeyboardButton setTitleColor:textColor forState:UIControlStateNormal];
}

- (void) SetViewsSize
{
    CGRect frame = _SymbolsView.frame;
    frame.size.width = 389;
    frame.size.height = 218;
    
    _MainView.frame = frame;
    _SymbolsView.frame = frame;
    _BigView.frame = frame;
    _SmallView.frame = frame;
    
    [self.inputView setNeedsUpdateConstraints];
}

- (IBAction)KeyboardButtonPressed:(UIButton *)sender {
    
    [self.textDocumentProxy insertText: [NSString stringWithFormat:@"%@", sender.accessibilityHint]];
    
    [self CloseSymbolsView];
    [self CloseBigView];

    AudioServicesPlaySystemSound(1104);
}

- (IBAction)ClearText:(UIButton *)sender {
    [self.textDocumentProxy deleteBackward];
    
    AudioServicesPlaySystemSound(1104);
}


- (IBAction)SpaceAction:(UIButton *)sender {
    [self.textDocumentProxy insertText: @" "];
    
    AudioServicesPlaySystemSound(1104);
}

- (IBAction)ReturnKey:(UIButton *)sender {
    [self.textDocumentProxy insertText: @"\n" ];
    
    AudioServicesPlaySystemSound(1104);
}


- (IBAction)UpperCaseButton:(UIButton *)sender {
    
    if (!_uppercase) {
        [self OpenBigView];
    }
    else{
        [self CloseBigView];
    }
    
    AudioServicesPlaySystemSound(1104);
}

- (IBAction)SymbolsButton:(UIButton *)sender {
    
    if (!_symbols) {
        [self OpenSymbolsView];

    }
    else{
        [self CloseSymbolsView];
    }
    
    AudioServicesPlaySystemSound(1104);
}

-(void)OpenSymbolsView {
    _SymbolsView.hidden = false;
    _BigView.hidden = true;
    _SmallView.hidden = true;
    
    _symbols = true;
    _uppercase = false;
}

-(void) CloseSymbolsView
{
    _SymbolsView.hidden = true;
    _BigView.hidden = true;
    _SmallView.hidden = false;
    
    _symbols = false;
    _uppercase = false;
}


-(void)OpenBigView {
    _BigView.hidden = false;
    _SmallView.hidden = true;
    _SymbolsView.hidden = true;
    
    _uppercase = true;
    _symbols = false;
}

-(void)CloseBigView {
    _BigView.hidden = true;
    _SmallView.hidden = false;
    _SymbolsView.hidden = true;
    
    _uppercase = false;
    _symbols = false;
}

- (IBAction)SentenceEnd:(id)sender {
    [self CloseSymbolsView];
    [self OpenBigView];
}

@end
