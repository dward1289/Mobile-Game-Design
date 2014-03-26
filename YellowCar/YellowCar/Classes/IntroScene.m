//
//  IntroScene.m
//  YellowCar
//
//  Created by Devona Ward on 3/3/14.
//  Copyright Devona Ward 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "IntroScene.h"
#import "InstructionScene.h"
#import "Main.h"

// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@implementation IntroScene

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (IntroScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    // Hello world
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Yellow Car" fontName:@"Chalkduster" fontSize:36.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor yellowColor];
    label.position = ccp(0.5f, 0.5f); // Middle of screen
    [self addChild:label];
    
    // Start button
    CCButton *startButton = [CCButton buttonWithTitle:@"[ Start ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    startButton.positionType = CCPositionTypeNormalized;
    startButton.position = ccp(0.5f, 0.35f);
    [startButton setTarget:self selector:@selector(onStartClicked:)];
    [self addChild:startButton];
    
    CCButton *instructionButton = [CCButton buttonWithTitle:@"[ How to Play ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    instructionButton.positionType = CCPositionTypeNormalized;
    instructionButton.position = ccp(0.5f, 0.25f);
    [instructionButton setTarget:self selector:@selector(onInstructionClicked:)];
    [self addChild:instructionButton];
    
    CCButton *creditButton = [CCButton buttonWithTitle:@"[ Credits ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    creditButton.positionType = CCPositionTypeNormalized;
    creditButton.position = ccp(0.5f, 0.15f);
    [creditButton setTarget:self selector:@selector(onCreditClicked:)];
    [self addChild:creditButton];
	
    // done
	return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onStartClicked:(id)sender
{
    // start game
    [[CCDirector sharedDirector] replaceScene:[HelloWorldScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

- (void)onInstructionClicked:(id)sender
{
    // Instructions
    [[CCDirector sharedDirector] pushScene:[InstructionScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

- (void)onCreditClicked:(id)sender
{
    // Credits
    [[CCDirector sharedDirector] replaceScene:[HelloWorldScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}


// -----------------------------------------------------------------------
@end
