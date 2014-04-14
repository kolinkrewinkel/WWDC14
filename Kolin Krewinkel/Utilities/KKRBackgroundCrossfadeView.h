//
//  KKRBackgroundCrossfadeView.h
//  Kolin Krewinkel
//
//  Created by Kolin Krewinkel on 4/13/14.
//  Copyright (c) 2014 Kolin Krewinkel. All rights reserved.
//

@class KKRBackgroundCrossfadeView;
@interface KKRBackgroundCrossfadeTransition : UIPercentDrivenInteractiveTransition

+ (instancetype)transitionWithPrimaryView:(UIView *)primaryView secondaryView:(UIView *)secondaryView crossfadeView:(KKRBackgroundCrossfadeView *)crossfadeView;

@property (nonatomic, weak, readonly) KKRBackgroundCrossfadeView *crossfadeView;

@end

@interface KKRBackgroundCrossfadeView : UIView

@property (nonatomic, strong) UIImage *currentImage;
@property (nonatomic, strong) UIImage *nextImage;

@property (nonatomic, strong) KKRBackgroundCrossfadeTransition *transition;

- (void)transferImages;

@end
