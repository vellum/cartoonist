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
#import "VLMParser.h"

@interface VLMDataSource ()

// FIXME: work out improperly defined references to strong/copy objects
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) NSString *cellChoiceIdentifier;
@property (nonatomic, strong) VLMParser *parser;
@property (nonatomic, copy) CollectionViewCellConfigureBlock configureCellBlock;
@property (nonatomic, copy) CollectionViewCellConfigureBlock configureCellChoiceBlock;
@property (nonatomic) BOOL isDataLoaded;

@end

@implementation VLMDataSource

- (id)init
{
	if (self = [super init])
	{
		return self;
	}
	return nil;
}

- (id)initWithCellIdentifier:(NSString *)aCellIdentifier
		cellChoiceIdentifier:(NSString *)aCellChoiceIdentifier
		  configureCellBlock:(CollectionViewCellConfigureBlock)aConfigureCellBlock
	configureCellChoiceBlock:(CollectionViewCellConfigureBlock)aConfigureCellChoiceBlock
{
	self = [super init];
	if (self)
	{
		self.cellIdentifier = aCellIdentifier;
		self.cellChoiceIdentifier = aCellChoiceIdentifier;
		self.configureCellBlock = [aConfigureCellBlock copy];
		self.configureCellChoiceBlock = [aConfigureCellChoiceBlock copy];
		self.isDataLoaded = NO;
		self.parser = [[VLMParser alloc] init];
		[self registerObservers];
		[self loadData];
	}
	return self;
}

- (void)registerObservers
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(receiveSelectedBranchNotification:)
												 name:@"selectedNewBranch"
											   object:nil];
}

- (void)receiveSelectedBranchNotification:(NSNotification *)notification
{
	NSLog(@"Successfully received the test notification!");
	NSMutableDictionary *dictionary = self.parser.rootNode;
	self.items = [self.parser parseRootNode:dictionary keepReference:NO];


	// debug
	for (id item in self.items)
	{
		NSLog(@"%@", item);
		if ([item isKindOfClass:[VLMPanelModels class]])
		{
			VLMPanelModels *p = (VLMPanelModels *)item;
			NSLog(@"\t%i", [[p.sourceNode objectForKey:@"selected"] integerValue]);
		} else {
            VLMPanelModel *p = (VLMPanelModel *)item;
            NSLog(@"\t%@", p.name);
        }
	}             // data looks ok

	[[NSNotificationCenter defaultCenter] postNotificationName:@"decisionTreeUpdated" object:nil];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadData
{
	NSError *err = nil;
	NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
	NSString *contents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
	NSData *data = [contents dataUsingEncoding:NSUTF8StringEncoding];

	if (!contents)
	{
		// handle error
		NSLog(@"err");
		return;
	}
	else
	{
		// NSLog(@"contents:%@", contents);
		NSLog(@"parsing");
		NSError *e = nil;
		NSMutableDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
		if (e)
		{
			NSLog(@"e");
		}
		else
		{
			NSLog(@"loaded");
			self.items = [self.parser parseRootNode:dictionary keepReference:YES];
		}
		self.isDataLoaded = YES;
	}
	// MAYBE NEED TO SEND A NOTIFICATION THAT WE HAVE NEW DATA
	// SO THAT THE COLLECTIONVIEW CAN UPDATE ITSELF
}

- (void)saveData
{
	/*
	 * NSTextView *textView; //your NSTextView object
	 * NSError *err = nil;
	 * NSString *path = [[NSBundle mainBundle] pathForResource:@"EditableFile" ofType:@"txt"];
	 * NSString *contents = [textView string];
	 * if(![contents writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
	 * //handle error
	 * }
	 */
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
	if (!self.isDataLoaded || !self.items)
	{
		return nil;
	}

	if (indexPath.section < 0 || indexPath.section > [self.items count] - 1)
	{
		return nil;
	}

	id o = [self.items objectAtIndex:indexPath.section];
	if ([o isKindOfClass:[VLMPanelModel class]])
	{
		VLMPanelModel *model = (VLMPanelModel *)o;
		return model;
	}
	else if ([o isKindOfClass:[VLMPanelModels class]])
	{
		VLMPanelModels *models = (VLMPanelModels *)o;
		return models;
	}
	NSLog(@"Warning: item in data source is not a valid VLMPanelModel or VLMPanelModels.");
	return nil;
}

- (BOOL)isItemAtIndexPathChoice:(NSIndexPath *)indexPath
{
	return [self isItemAtIndexChoice:indexPath.section];
}

- (BOOL)isItemAtIndexChoice:(NSInteger)index
{
	if (!self.isDataLoaded || !self.items)
	{
		return NO;
	}
	if (index < 0 || index > [self.items count] - 1)
	{
		return NO;
	}

	id o = [self.items objectAtIndex:index];
	if ([o isKindOfClass:[VLMPanelModels class]])
	{
		return YES;
	}
	return NO;
}

#pragma mark - DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	if (!self.isDataLoaded || !self.items)
	{
		return 0;
	}
	return [self.items count];
	// Return the smallest of either our curent model index plus one, or our total number of sections.
	// This will show 1 section when we only want to display section zero, etc.
	// It will prevent us from returning 11 when we only have 10 sections.
	// return MIN(currentModelArrayIndex + 1, selectionModelArray.count);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return 1;
	// Return the number of photos in the section model
	// return [[selectionModelArray[currentModelArrayIndex] models] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section < 0 || indexPath.section > [self numberOfSectionsInCollectionView:collectionView] - 1)
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