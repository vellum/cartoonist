//
//  VLMStaticImageCell.m
//  Cartoonist
//
//  Created by David Lu on 1/9/14.
//  Copyright (c) 2014 David Lu. All rights reserved.
//

#import "VLMStaticImageCell.h"
#import "VLMNarrationCaption.h"
#import "VLMCollectionViewLayoutAttributes.h"
#import "VLMPanelModel.h"

@implementation VLMStaticImageCell

+ (NSString *)CellIdentifier
{
    return @"VLMStaticImageCellID";
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        CGFloat pad = kItemPadding;
        
        [self setImageview:[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.base.frame.size.width, self.base.frame.size.height)]];
        [self.imageview setContentMode:UIViewContentModeScaleAspectFill];
        [self.imageview setClipsToBounds:YES];
        [self.imageview setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
        [self.base addSubview:self.imageview];
        
        VLMNarrationCaption *vvvv = [[VLMNarrationCaption alloc] initWithFrame:CGRectMake(pad, pad, self.base.frame.size.width - pad * 2, 72.0f)];
        [self setCaption:vvvv];
        [self.base addSubview:self.caption];
        
        self.imagename = nil;

    }
    return self;
}


- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
	[super applyLayoutAttributes:layoutAttributes];
    
	// Important! Check to make sure we're actually this special subclass.
	// Failing to do so could cause the app to crash!
	if (![layoutAttributes isKindOfClass:[VLMCollectionViewLayoutAttributes class]])
	{
		return;
	}
    
	VLMCollectionViewLayoutAttributes *castedLayoutAttributes = (VLMCollectionViewLayoutAttributes *)layoutAttributes;
	switch (self.cellType)
	{
		case kCellTypeCaption :
            [self.caption applyLayoutAttributes:castedLayoutAttributes];
			break;
            
		case kCellTypeNoCaption :
			break;

		default :
			break;
	}
}

- (void)configureWithModel:(VLMPanelModel *)model
{
	[super configureWithModel:model];
    
    [self.imageview setFrame:CGRectMake(0, 0, self.base.frame.size.width, self.base.frame.size.height)];
	if ([model.name length] > 0)
	{
        NSString *labelText;
        if (USE_ALL_CAPS) {
            labelText = [model.name uppercaseString];
        } else {
            labelText = model.name;
        }
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:FONT_LINE_SPACING];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        
        [self.caption setAttributedText:attributedString];
	}
	self.cellType = model.cellType;
    
	switch (self.cellType)
	{
		case kCellTypeCaption :
			self.caption.hidden = NO;
			if (model.image)
			{
				[self.imageview setImage:model.image];
			}
			break;
            
		case kCellTypeNoCaption :
			self.caption.hidden = YES;
			self.imageview.hidden = NO;
			if (model.image)
			{
				[self.imageview setImage:model.image];
			}
			break;

		default :
			break;
	}
}

@end
