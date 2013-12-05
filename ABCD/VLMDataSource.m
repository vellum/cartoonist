//
//  VLMDataSource.m
//  Cartoonist
//
//  Created by David Lu on 11/29/13.
//  Copyright (c) 2013 David Lu. All rights reserved.
//

#import "VLMDataSource.h"
#import "VLMCollectionViewCell.h"
#import "VLMCollectionViewCellWithChoices.h"
#import "VLMPanelModel.h"
#import "VLMPanelModels.h"

@interface VLMDataSource ()

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) NSString *cellChoiceIdentifier;
@property (nonatomic, copy) CollectionViewCellConfigureBlock configureCellBlock;
@property (nonatomic, copy) CollectionViewCellConfigureBlock configureCellChoiceBlock;

@end

@implementation VLMDataSource

- (id)init
{
    return nil;
}

- (id)initWithItems:(NSArray *)anItems
        cellIdentifier:(NSString *)aCellIdentifier
        cellChoiceIdentifier:(NSString *)aCellChoiceIdentifier
        configureCellBlock:(CollectionViewCellConfigureBlock)aConfigureCellBlock
        configureCellChoiceBlock:(CollectionViewCellConfigureBlock)aConfigureCellChoiceBlock
{
    self = [super init];
    if (self) {
        self.items = anItems;
        self.cellIdentifier = aCellIdentifier;
        self.cellChoiceIdentifier = aCellChoiceIdentifier;
        self.configureCellBlock = [aConfigureCellBlock copy];
        self.configureCellChoiceBlock = [aConfigureCellChoiceBlock copy];
    }
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 2)
    {
        VLMPanelModels *models = [[VLMPanelModels alloc] init];
        for (NSInteger i = 0; i < 3; i++ )
        {
            NSString *text = [NSString stringWithFormat:@"Action %i", i];
            VLMPanelModel *model = [VLMPanelModel panelModelWithName:text image:[UIImage imageNamed:@"0"]];
            [models.models addObject:model];
        }
        return models;
    }
    NSInteger remainder = 2;//indexPath.section % 3;
    NSString *imagename = [NSString stringWithFormat:@"%i", remainder];
    NSString *namename = [NSString stringWithFormat:@"%i", indexPath.section];
    return [VLMPanelModel panelModelWithName:namename image:[UIImage imageNamed:imagename]];
}

- (BOOL)isItemAtIndexPathChoice:(NSIndexPath *)indexPath{
    return [self isItemAtIndexChoice:indexPath.section];
}

- (BOOL)isItemAtIndexChoice:(NSInteger)index{
    return (index==2);
}

#pragma mark - DataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 10;
    //Return the smallest of either our curent model index plus one, or our total number of sections.
    //This will show 1 section when we only want to display section zero, etc.
    //It will prevent us from returning 11 when we only have 10 sections.
    //return MIN(currentModelArrayIndex + 1, selectionModelArray.count);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
    //Return the number of photos in the section model
    //return [[selectionModelArray[currentModelArrayIndex] models] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section<0||indexPath.section>[self numberOfSectionsInCollectionView:collectionView]-1)
    {
        return nil;
    }

    if (![self isItemAtIndexPathChoice:indexPath])
    {
        VLMCollectionViewCell *cell = (VLMCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
        id item = [self itemAtIndexPath:indexPath];
        self.configureCellBlock(cell, item);
        return cell;
    }
    else
    {
        VLMCollectionViewCellWithChoices *cell = (VLMCollectionViewCellWithChoices *)[collectionView dequeueReusableCellWithReuseIdentifier:self.cellChoiceIdentifier forIndexPath:indexPath];
        id item = [self itemAtIndexPath:indexPath];
        self.configureCellChoiceBlock(cell, item);
        return cell;
    }
}

@end