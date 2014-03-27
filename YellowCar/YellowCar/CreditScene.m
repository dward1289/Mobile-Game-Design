//
//  CreditScene.m
//  YellowCar
//
//  Created by Devona Ward on 3/26/14.
//  Copyright 2014 Devona Ward. All rights reserved.
//

#import "CreditScene.h"



@implementation CreditScene

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (CreditScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    CCSprite* background = [CCSprite spriteWithImageNamed:@"Credits.png"];
    background.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
    [self addChild:background];
    
    
    // Main menu button
    CCButton *mainButton = [CCButton buttonWithTitle:@"[ Main Menu ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    mainButton.positionType = CCPositionTypeNormalized;
    mainButton.position = ccp(0.5f, 0.25f);
    [mainButton setTarget:self selector:@selector(onMainClicked:)];
    [self addChild:mainButton];
	
    // done
	return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onMainClicked:(id)sender
{
    //Main menu
    [[CCDirector sharedDirector] popSceneWithTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
    
}



// -----------------------------------------------------------------------
@end
