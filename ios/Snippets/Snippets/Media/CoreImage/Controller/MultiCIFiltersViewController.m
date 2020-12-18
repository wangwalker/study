//
//  MultiCIFiltersViewController.m
//  Snippets
//
//  Created by Walker on 2020/12/17.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "MultiCIFiltersViewController.h"
#import "CIFilterInputView.h"
#import "CIFilterInputModel.h"
#import "CIFilterInputViewModel.h"
#import "CIFilterAttributePanel.h"

@interface MultiCIFiltersViewController ()
@property (nonatomic) UILabel *filterNameLabel;
@property (nonatomic) UIImageView *inputImageView;
@property (nonatomic) CIFilterAttributePanel *attributePanel;

@property (nonatomic, copy) NSString *filterName;

@end

@implementation MultiCIFiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self setupBarButtons];
    [self addObservers];
}

- (void)setupUI{
    [self.view addSubview:self.filterNameLabel];
    [self.view addSubview:self.inputImageView];
}

- (void)setupBarButtons{
    UIBarButtonItem *selectFilter, *process;
    
    selectFilter = [[UIBarButtonItem alloc] initWithTitle:@"滤镜" style:UIBarButtonItemStylePlain target:self action:@selector(selectFilter:)];
    process = [[UIBarButtonItem alloc] initWithTitle:@"处理" style:UIBarButtonItemStylePlain target:self action:@selector(processImage:)];
    
    self.navigationItem.rightBarButtonItems = @[selectFilter, process];
}

- (void)selectFilter:(UIBarButtonItem *)sender{
    NSArray *blurs = [CIFilter filterNamesInCategory:@"CICategoryBlur"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择滤镜" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSString *blurName in blurs) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:[CIFilter localizedNameForFilterName:blurName] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self setFilterName:blurName];
        }];
        [alert addAction:action];
    }
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

- (void)processImage:(UIBarButtonItem *)sender{
    CIFilter *filter = _attributePanel.inputModel.recentFilter;
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"blackboard.jpg"], .95);
    
    [filter setValue:[CIImage imageWithData:imageData] forKey:@"inputImage"];
    [_inputImageView setImage:[UIImage imageWithCIImage:filter.outputImage]];
}

#pragma mark - KVO

- (void)addObservers{
    [self addObserver:self forKeyPath:@"filterName" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"filterName"]) {
        [self configUIWithFilterName:change[NSKeyValueChangeNewKey]];
    }
}

- (void)configUIWithFilterName:(NSString *)filterName{
    _filterNameLabel.text = filterName;
    _attributePanel = [CIFilterAttributePanel panelWithName:filterName];
    
    if ([self.view.subviews containsObject:_attributePanel]) {
        for (UIView *view in _attributePanel.subviews) {
            [view removeFromSuperview];
        }
        [_attributePanel removeFromSuperview];
    }
    [self.view addSubview:_attributePanel];
    
    [self.view setNeedsLayout];
    [self.view setNeedsDisplay];
    [self.view layoutIfNeeded];
}

#pragma mark - Getter

- (UILabel *)filterNameLabel{
    if (!_filterNameLabel) {
        _filterNameLabel = [[UILabel alloc] init];
        _filterNameLabel.font = [UIFont systemFontOfSize:20.f];
        _filterNameLabel.textColor = [UIColor lightGrayColor];
        _filterNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _filterNameLabel;
}
- (UIImageView *)inputImageView{
    if (!_inputImageView) {
        _inputImageView = [[UIImageView alloc] init];
        _inputImageView.image = [UIImage imageNamed:@"blackboard.jpg"];
    }
    return _inputImageView;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    CGFloat ivWidth = CGRectGetWidth(self.view.bounds)-100.f;
    CGFloat ivHeight = ivWidth*.75;
    CGPoint center = self.view.center;
    
    self.inputImageView.frame = CGRectMake(0, 0, ivWidth, ivHeight);
    self.inputImageView.center = CGPointMake(center.x, center.y-150);
    
    self.filterNameLabel.frame = CGRectMake(0, 0, ivWidth, 32.f);
    self.filterNameLabel.center = CGPointMake(center.x, CGRectGetMinY(self.inputImageView.frame)-32.f);
    
    self.attributePanel.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds)*.75);
    self.attributePanel.center = CGPointMake(center.x, CGRectGetMaxY(self.view.bounds)-CGRectGetWidth(self.view.bounds));
}

@end
