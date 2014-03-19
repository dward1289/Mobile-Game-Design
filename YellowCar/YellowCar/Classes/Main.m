//
//  HelloWorldScene.m
//  VaultHacker
//
//  Created by Devona Ward on 3/3/14.
//  Copyright Devona Ward 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "IntroScene.h"
#import "Main.h"
#import "OALSimpleAudio.h"


// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@implementation HelloWorldScene
{
    CCSprite *redCar;
    CCPhysicsNode *physicsWorld;
    CCSprite *yellowCar;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    //Road background
    CCSprite* background = [CCSprite spriteWithImageNamed:@"road.png"];
    background.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
    [self addChild:background];
    
    physicsWorld = [CCPhysicsNode node];
    physicsWorld.gravity = ccp(0,0);
    physicsWorld.debugDraw = NO;
    physicsWorld.collisionDelegate = self;
    [self addChild:physicsWorld];
    
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[ Menu ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.85f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
    [[OALSimpleAudio sharedInstance] playBg:@"PT_383217_lowres.mp3" loop:YES];
    // done
	return self;
}

// -----------------------------------------------------------------------

//Gets the red car and makes it move
- (void)addRedCar:(CCTime)dt{
    
    redCar = [CCSprite spriteWithImageNamed:@"Red.png"];
    
    //Vertical range of the car driving
    redCar.position  = ccp(self.contentSize.width/4,self.contentSize.height/2);
    int minY = redCar.contentSize.height / 4;
    int maxY = self.contentSize.height - redCar.contentSize.height / 2;
    int rangeY = maxY - minY;
    int randomY = (arc4random() % rangeY) + minY;
    
    //Position of red car to drive
    redCar.position = CGPointMake(self.contentSize.width + redCar.contentSize.width/8, randomY);
    redCar.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, redCar.contentSize} cornerRadius:0];
    redCar.physicsBody.collisionGroup = @"redGroup";
    redCar.physicsBody.collisionType  = @"carCollision";
    [physicsWorld addChild:redCar];
    
    //Speed of the red car
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int randomDuration = (arc4random() % rangeDuration) + minDuration;
    
    //Flipped car to match the traffic
    redCar.scaleX = -1;
    
    //Makes the red car move
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(-redCar.contentSize.width/2, randomY)];
    //Removes the red car from the display
    CCAction *actionRemove = [CCActionRemove action];
    [redCar runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
    
}
//Gets the blue car and makes it move
- (void)addBlueCar:(CCTime)dt {
    
    CCSprite *blueCar = [CCSprite spriteWithImageNamed:@"Blue.png"];
    
    //Vertical range of the car driving
    int minY = blueCar.contentSize.height / 2;
    int maxY = self.contentSize.height - blueCar.contentSize.height / 2;
    int rangeY = maxY - minY;
    int randomY = (arc4random() % rangeY) + minY;
    
    //Positions the blue car to begin driving from the right of the screen to the left.
    blueCar.position = CGPointMake(self.contentSize.width + blueCar.contentSize.width/2, randomY);
    blueCar.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, blueCar.contentSize} cornerRadius:0];
    blueCar.physicsBody.collisionGroup = @"blueGroup";
    blueCar.physicsBody.collisionType  = @"carCollision";
    [physicsWorld addChild:blueCar];
    
    //Determines the speend of the blue car.
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int randomDuration = (arc4random() % rangeDuration) + minDuration;
    
    //Flipped car to match the traffic
    blueCar.scaleX = -1;
    
    //Makes the car move across the screen
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(-blueCar.contentSize.width/2, randomY)];
    //Removes cr from screen
    CCAction *actionRemove = [CCActionRemove action];
    [blueCar runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
}

//Gets the yellow car and makes it move (FASTEST CAR)
- (void)addYellowCar:(CCTime)dt {
    
    yellowCar = [CCSprite spriteWithImageNamed:@"Yellow.png"];
    
    //Vertical range for the car to drive on
    int minY = yellowCar.contentSize.height / 2;
    int maxY = self.contentSize.height - yellowCar.contentSize.height / 2;
    int rangeY = maxY - minY;
    int randomY = (arc4random() % rangeY) + minY;
    
    //Makes the yellow car begin driving from right to left with the traffic.
    yellowCar.position = CGPointMake(self.contentSize.width + yellowCar.contentSize.width/2, randomY);
    yellowCar.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, yellowCar.contentSize} cornerRadius:0];
    yellowCar.physicsBody.collisionGroup = @"yellowGroup";
    yellowCar.physicsBody.collisionType  = @"yellowCollision";
    [physicsWorld addChild:yellowCar];
    
    //Determins the speed of the yellow car. It's the fastest.
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int randomDuration = (arc4random() % rangeDuration) + minDuration;
    
    //Flipped the car to match the other cars
    yellowCar.scaleX = -1;
    
    //Makes the car move across the screen
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(-yellowCar.contentSize.width/2, randomY)];
    //Removes the car from screen
    CCAction *actionRemove = [CCActionRemove action];
    [yellowCar runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
}

//Get the green car sprite and makes it move
- (void)addGreenCar:(CCTime)dt {
    
    CCSprite *greenCar = [CCSprite spriteWithImageNamed:@"Green.png"];
    
    //Vertical range for the car to drive on
    int minY = greenCar.contentSize.height / 2;
    int maxY = self.contentSize.height - greenCar.contentSize.height / 1.5;
    int rangeY = maxY - minY;
    int randomY = (arc4random() % rangeY) + minY;
    
    //Makes the green car drive on to the screen from the right
    greenCar.position = CGPointMake(self.contentSize.width + greenCar.contentSize.width/6, randomY);
    greenCar.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, greenCar.contentSize} cornerRadius:0];
    greenCar.physicsBody.collisionGroup = @"greenGroup";
    greenCar.physicsBody.collisionType  = @"carCollision";
    [physicsWorld addChild:greenCar];
    
    //Determines the speed of the green car
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int randomDuration = (arc4random() % rangeDuration) + minDuration;
    
    //Flipped the car so that it doesn't look like it's driving in reverse
    greenCar.scaleX = -1;
    
    //Makes the car move across the screen
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(-greenCar.contentSize.width/2, randomY)];
    //Removes the car from screen
    CCAction *actionRemove = [CCActionRemove action];
    [greenCar runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
}

//If a car hits the yellow car, the car will make a horn sound.
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair carCollision:(CCNode *)monster yellowCollision:(CCNode *)projectile {
    
    //Honks the horn
    [[OALSimpleAudio sharedInstance] playEffect:@"car-honk-1.wav" loop:NO];
    return YES;
}
- (void)dealloc
{
    // clean up code goes here
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    //Displays cars at the given times
    [self schedule:@selector(addBlueCar:) interval:1.5];
    [self schedule:@selector(addYellowCar:) interval:3.0];
    [self schedule:@selector(addRedCar:) interval:2.5];
    [self schedule:@selector(addGreenCar:) interval:2.0];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
}

// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    
    // Log touch location
    CCLOG(@"Move sprite to @ %@",NSStringFromCGPoint(touchLoc));
    
    //Red car disappears on touch
    [redCar removeFromParent];
    //Plays the swipe noise
    [[OALSimpleAudio sharedInstance] playEffect:@"swipe.mp3" loop:NO];
    
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}


// -----------------------------------------------------------------------
@end
