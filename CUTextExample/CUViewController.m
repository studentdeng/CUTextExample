//
//  CUViewController.m
//  CUTextExample
//
//  Created by yuguang on 11/6/14.
//  Copyright (c) 2014 lion. All rights reserved.
//

#import "CUViewController.h"
#import "ActionSheetStringPicker.h"

#define FIXXED_STRING @"测试\n test"
#define MODIFY_STRING @"\nHello World"

typedef NS_ENUM(NSInteger, CU_TYPE) {
  CU_COLOR = 0,
  CU_XPOS,
  CU_YPOS,
  CU_FONT,
  CU_LINE_SPACE
} NS_ENUM_AVAILABLE_IOS(6_0);

@interface CUViewController ()
{
  CU_TYPE _type;
}

@property(weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@end

@implementation CUViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  self.textLabel.numberOfLines = 0;
  
  [self updateLabelTextWithColor];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)settingButtonClicked:(id)sender {
  
  [ActionSheetStringPicker showPickerWithTitle:@""
                                          rows:@[@"颜色", @"间距", @"baseLine", @"字体", @"行距"]
                              initialSelection:0
                                     doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                       [self updateLabelWithType:selectedIndex];
                                     } cancelBlock:^(ActionSheetStringPicker *picker) {
                                       
                                     } origin:self.view];
}

- (void)updateLabelWithType:(CU_TYPE)type
{
  _type = type;
  
  NSString *fixString = FIXXED_STRING;
  NSString *modifyString = MODIFY_STRING;
  NSString *planText = [NSString stringWithFormat:@"%@%@", fixString, modifyString];
  NSRange fixRange = [planText rangeOfString:fixString];
  NSRange modifyRange = NSMakeRange(fixRange.length, planText.length - fixRange.length);
  
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:planText];
  
  switch (type) {
    case CU_COLOR:
    {
      [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:self.slider.value alpha:1.0] range:modifyRange];
    }
      break;
    case CU_XPOS:
    {
      long number = (self.slider.value - 0.5) * 10;
      [attributedString addAttribute:NSKernAttributeName value:@(number) range:NSMakeRange(modifyRange.location + 5, 1 )];
    }
      break;
    case CU_YPOS:
    {
      long number = (self.slider.value - 0.5) * 10;
      [attributedString addAttribute:NSBaselineOffsetAttributeName value:@(number) range:modifyRange];
    }
      break;
    case CU_FONT:
    {
      long number = self.slider.value * 100;
      [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.slider.value * number] range:modifyRange];
    }
      break;
      
    case CU_LINE_SPACE:
    {
      long number = self.slider.value * 50;
      NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
      paragraphStyle.lineSpacing = number;
      paragraphStyle.alignment = NSTextAlignmentLeft;
      
      [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, planText.length - 1)];
    }
      
    default:
      break;
  }
  
  self.textLabel.attributedText = attributedString;
}

- (void)updateLabelTextWithColor
{
  NSString *fixString = FIXXED_STRING;
  NSString *modifyString = MODIFY_STRING;
  NSString *planText = [NSString stringWithFormat:@"%@%@", fixString, modifyString];
  NSRange fixRange = [planText rangeOfString:fixString];
  NSRange modifyRange = NSMakeRange(fixRange.length, planText.length - fixRange.length);
  
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:planText];
  [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:modifyRange];
  
  self.textLabel.attributedText = attributedString;
}

- (IBAction)sliderDidChanged:(id)sender {
  [self updateLabelWithType:_type];
}
@end
