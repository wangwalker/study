//
//  VideoCollection.m
//  Snippets
//
//  Created by Walker Wang on 2021/12/1.
//  Copyright © 2021 Walker. All rights reserved.
//

#import "VideoCollection.h"
#import "VideoAssetInfo.h"

@interface VideoCollection () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic) UICollectionView *collection;
@property (nonatomic) NSMutableArray<VideoAssetInfo*>* assetInfos;
@end
@implementation VideoCollection

- (instancetype)init{
    if ((self = [super init])) {
        _assetInfos = [@[] mutableCopy];
        [self addSubview:self.collection];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.collection setFrame:self.frame];
}
- (void)appendAssetInfo:(VideoAssetInfo *)asset{
    [_assetInfos addObject:asset];
    [_collection reloadData];
}
- (NSArray *)infos{
    return [_assetInfos copy];
}

#pragma mark - Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _assetInfos.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VideoCollectionCell *cell = (VideoCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"avf-cell" forIndexPath:indexPath];
    [cell config:_assetInfos[indexPath.row]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - Getter

- (UICollectionView *)collection{
    if (!_collection) {
        CGFloat w = (UIScreen.mainScreen.bounds.size.width-2-16)/3;
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 1.f;
        layout.minimumInteritemSpacing = 1.f;
        layout.estimatedItemSize = CGSizeMake((int)w, (int)w);
        layout.itemSize = layout.estimatedItemSize;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *cv = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [cv registerClass:VideoCollectionCell.class forCellWithReuseIdentifier:@"avf-cell"];
        [cv setDelegate:self];
        [cv setDataSource:self];
        [cv setAlwaysBounceHorizontal:YES];
        _collection = cv;
    }
    return _collection;
}
@end


@interface VideoCollectionCell ()
@property (nonatomic) UIImageView *imageView;
@end

@implementation VideoCollectionCell

- (void)config:(VideoAssetInfo *)info{
    self.imageView.image = info.thumbnail;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}
- (void)setupUI{
    [self.contentView addSubview:self.imageView];
    self.layer.borderColor = UIColor.lightGrayColor.CGColor;
    self.layer.borderWidth = 1.f;
    [self addRoundCorner];
}
- (void)addRoundCorner{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:maskLayer.bounds cornerRadius:10];
    maskLayer.strokeColor = UIColor.lightGrayColor.CGColor;
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.borderColor = UIColor.greenColor.CGColor;
        _imageView.layer.borderWidth = 1.f;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

@end
