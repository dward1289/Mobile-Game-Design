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
#import "CCSpriteFrame.h"
#import "CCSprite.h"
#import "CCSpriteFrameCache.h"
#import "CCAnimation.h"
#import "GameCenterHelper.h"

// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@implementation HelloWorldScene
{
    CCSprite *redCar;
    CCPhysicsNode *physicsWorld;
    CCSprite *yellowCar;
    CCSprite *greenCar;
    CCSprite *blueCar;
    CCSprite *turningSign;
    CCButton *resumeButton;
    int scoreNum;
    NSString *theScore;
    CCLabelTTF *actualScore;
    int timeNum;
    NSString *theTime;
    CCLabelTTF *timeIt;
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
    
    // Create pause button
    CCButton *pauseButton = [CCButton buttonWithTitle:@"[PAUSE]" fontName:@"Verdana-Bold" fontSize:18.0f];
    pauseButton.positionType = CCPositionTypeNormalized;
    pauseButton.position = ccp(0.85f, 0.95f);
    [pauseButton setTarget:self selector:@selector(onPauseClicked:)];
    [self addChild:pauseButton];
        
    //Time label
    CCLabelTTF *timeTxt = [CCLabelTTF labelWithString:@"Time: " fontName:@"Verdana-Bold" fontSize:18.0f];
    timeTxt.positionType = CCPositionTypeNormalized;
    timeTxt.color = [CCColor yellowColor];
    timeTxt.position = ccp(0.10f, 0.95f);
    [self addChild:timeTxt];
    
    //Timer data
    timeNum=120;
    theTime = [NSString stringWithFormat:@"%i", timeNum];
    
    //Displays the timer
    timeIt = [CCLabelTTF labelWithString:theTime fontName:@"Verdana-Bold" fontSize:18.0f];
    timeIt.positionType = CCPositionTypeNormalized;
    timeIt.color = [CCColor yellowColor];
    timeIt.position = ccp(0.20f, 0.95f); // Middle of screen
    [self addChild:timeIt];
    
    //Score label
    CCLabelTTF *scoreIt = [CCLabelTTF labelWithString:@"Score: " fontName:@"Verdana-Bold" fontSize:18.0f];
    scoreIt.positionType = CCPositionTypeNormalized;
    scoreIt.color = [CCColor yellowColor];
    scoreIt.position = ccp(0.10f, 0.85f); // Middle of screen
    [self addChild:scoreIt];
    
    //Score data
    scoreNum=0;
    theScore = [NSString stringWithFormat:@"%i", scoreNum];
    
    //Displays the score
    actualScore = [CCLabelTTF labelWithString:theScore fontName:@"Verdana-Bold" fontSize:18.0f];
    actualScore.positionType = CCPositionTypeNormalized;
    actualScore.color = [CCColor yellowColor];
    actualScore.position = ccp(0.20f, 0.85f); // Middle of screen
    [self addChild:actualScore];

    //Background music
    [[OALSimpleAudio sharedInstance] playBg:@"PT_383217_lowres.mp3" loop:YES];
    
    //Starts the timer
    [self schedule: @selector(clockIt:) interval:1.0];
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
    
    blueCar = [CCSprite spriteWithImageNamed:@"Blue.png"];
    
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
    
    greenCar = [CCSprite spriteWithImageNamed:@"Green.png"];
    
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

//If a car hits the yellow car, the car will disappear.
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair carCollision:(CCNode *)oc yellowCollision:(CCNode *)yc {
    
    [oc removeFromParent];
    [[OALSimpleAudio sharedInstance] playEffect:@"swipe.mp3" loop:NO];
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

    //onTouch for the Yellow Car
    CGRect rect = CGRectMake(yellowCar.position.x-(yellowCar.contentSize.width/2), yellowCar.position.y-(yellowCar.contentSize.height/2),yellowCar.contentSize.width, yellowCar.contentSize.height);
    //Checks for yellow car
    if (CGRectContainsPoint(rect, touchLoc)) {
        //Gets earned points
        scoreNum ++;
        //Honks the horn
        [[OALSimpleAudio sharedInstance] playEffect:@"car-honk-1.wav" loop:NO];
        
        [actualScore setString:[NSString stringWithFormat:@" %d",scoreNum]];
    }
    
    
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

//Timer begins to count down
- (void)clockIt:(id)sender
{
    timeNum--;
    [timeIt setString:[NSString stringWithFormat:@" %d",timeNum]];
    
    if(timeNum < 90){
        
        //Green Car Speed Up
        int minY = greenCar.contentSize.height / 2;
        int maxY = self.contentSize.height - greenCar.contentSize.height / 1.5;
        int rangeY = maxY - minY;
        int randomY = (arc4random() % rangeY) + minY;
        int maxDurationG = 3.0;
        CCAction *actionMove = [CCActionMoveTo actionWithDuration:maxDurationG position:CGPointMake(-greenCar.contentSize.width/2, randomY)];
        //Removes the car from screen
        CCAction *actionRemove = [CCActionRemove action];
        [greenCar runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
        
        //Red Car Speed Up
        int minYR = redCar.contentSize.height / 2;
        int maxYR = self.contentSize.height - redCar.contentSize.height / 1.5;
        int rangeYR = maxYR - minYR;
        int randomYR = (arc4random() % rangeYR) + minYR;
        int maxDurationR = 3.0;
        CCAction *actionMoveR = [CCActionMoveTo actionWithDuration:maxDurationR position:CGPointMake(-redCar.contentSize.width/2, randomYR)];
        //Removes the car from screen
        CCAction *actionRemoveR = [CCActionRemove action];
        [redCar runAction:[CCActionSequence actionWithArray:@[actionMoveR,actionRemoveR]]];
        
        //Blue Car Speed Up
        int minYB = blueCar.contentSize.height / 2;
        int maxYB = self.contentSize.height - blueCar.contentSize.height / 1.5;
        int rangeYB = maxYB - minYB;
        int randomYB = (arc4random() % rangeYB) + minYB;
        int maxDurationB = 3.0;
        CCAction *actionMoveB = [CCActionMoveTo actionWithDuration:maxDurationB position:CGPointMake(-blueCar.contentSize.width/2, randomYB)];
        //Removes the car from screen
        CCAction *actionRemoveB = [CCActionRemove action];
        [blueCar runAction:[CCActionSequence actionWithArray:@[actionMoveB,actionRemoveB]]];
        
        //Yellow Car Speed Up
        int minYY = yellowCar.contentSize.height / 2;
        int maxYY = self.contentSize.height - yellowCar.contentSize.height / 1.5;
        int rangeYY = maxYY - minYY;
        int randomYY = (arc4random() % rangeYY) + minYY;
        int maxDurationY = 3.0;
        CCAction *actionMoveY = [CCActionMoveTo actionWithDuration:maxDurationY position:CGPointMake(-yellowCar.contentSize.width/2, randomYY)];
        //Removes the car from screen
        CCAction *actionRemoveY = [CCActionRemove action];
        [yellowCar runAction:[CCActionSequence actionWithArray:@[actionMoveY,actionRemoveY]]];
        
    }else if (timeNum < 60){
        
        //Green Car Speed Up
        int minY = greenCar.contentSize.height / 2;
        int maxY = self.contentSize.height - greenCar.contentSize.height / 1.5;
        int rangeY = maxY - minY;
        int randomY = (arc4random() % rangeY) + minY;
        int maxDurationG = 1.0;
        CCAction *actionMove = [CCActionMoveTo actionWithDuration:maxDurationG position:CGPointMake(-greenCar.contentSize.width/2, randomY)];
        //Removes the car from screen
        CCAction *actionRemove = [CCActionRemove action];
        [greenCar runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
        
        //Red Car Speed Up
        int minYR = redCar.contentSize.height / 2;
        int maxYR = self.contentSize.height - redCar.contentSize.height / 1.5;
        int rangeYR = maxYR - minYR;
        int randomYR = (arc4random() % rangeYR) + minYR;
        int maxDurationR = 1.0;
        CCAction *actionMoveR = [CCActionMoveTo actionWithDuration:maxDurationR position:CGPointMake(-redCar.contentSize.width/2, randomYR)];
        //Removes the car from screen
        CCAction *actionRemoveR = [CCActionRemove action];
        [redCar runAction:[CCActionSequence actionWithArray:@[actionMoveR,actionRemoveR]]];
        
        //Blue Car Speed Up
        int minYB = blueCar.contentSize.height / 2;
        int maxYB = self.contentSize.height - blueCar.contentSize.height / 1.5;
        int rangeYB = maxYB - minYB;
        int randomYB = (arc4random() % rangeYB) + minYB;
        int maxDurationB = 1.0;
        CCAction *actionMoveB = [CCActionMoveTo actionWithDuration:maxDurationB position:CGPointMake(-blueCar.contentSize.width/2, randomYB)];
        //Removes the car from screen
        CCAction *actionRemoveB = [CCActionRemove action];
        [blueCar runAction:[CCActionSequence actionWithArray:@[actionMoveB,actionRemoveB]]];
        
        //Yellow Car Speed Up
        int minYY = yellowCar.contentSize.height / 2;
        int maxYY = self.contentSize.height - yellowCar.contentSize.height / 1.5;
        int rangeYY = maxYY - minYY;
        int randomYY = (arc4random() % rangeYY) + minYY;
        int maxDurationY = 1.0;
        CCAction *actionMoveY = [CCActionMoveTo actionWithDuration:maxDurationY position:CGPointMake(-yellowCar.contentSize.width/2, randomYY)];
        //Removes the car from screen
        CCAction *actionRemoveY = [CCActionRemove action];
        [yellowCar runAction:[CCActionSequence actionWithArray:@[actionMoveY,actionRemoveY]]];
    }
    //Stops time and game is over.
    if(timeNum == 0){
        
        //Removes sprites
        [yellowCar removeFromParent];
        [redCar removeFromParent];
        [blueCar removeFromParent];
        [greenCar removeFromParent];
        timeIt.visible = FALSE;
        [[OALSimpleAudio sharedInstance]stopBg];
        [self unscheduleAllSelectors];
        
        //Gets view size
        CGSize winSize = [[CCDirector sharedDirector] viewSize];
        //Creates time up sign
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"TU.plist"];
        CCSpriteFrame *spriteSheet = [CCSpriteFrame frameWithImageNamed:@"TU1.png"];
        turningSign = [CCSprite spriteWithSpriteFrame:spriteSheet];
        turningSign.position = ccp(winSize.width/2, winSize.height/2);
        
        [self addChild:turningSign];

        //Animation
        NSMutableArray *signAnimFrames = [NSMutableArray array];
        
        for (int i=1; i<=3; i++) {
            [signAnimFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"TU%d.png",i]]];
        }
        
        CCAnimation *signAnim = [CCAnimation animationWithSpriteFrames:signAnimFrames delay:0.2f];
        CCActionAnimate *animationAction = [CCActionAnimate actionWithAnimation:signAnim];
        //Make animtion repeat constantly
        CCActionRepeatForever *repeatingAnimation = [CCActionRepeatForever actionWithAction:animationAction];
        [turningSign runAction:repeatingAnimation];
        
        //Submit score to Game Center
        [[GameCenterHelper sharedInstance] submitScore:scoreNum];
        
        //Done button
        CCButton *doneButton = [CCButton buttonWithTitle:@"[PLAY AGAIN]" fontName:@"Verdana-Bold" fontSize:18.0f];
        doneButton.positionType = CCPositionTypeNormalized;
        doneButton.position = ccp(0.5f, 0.3f);
        [doneButton setTarget:self selector:@selector(onDoneClicked:)];
        [self addChild:doneButton];
    }
}

//Navigates back to home screen
- (void)onDoneClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}
//Pauses game
- (void)onPauseClicked:(id)sender
{
   //Pause
   [[CCDirector sharedDirector] pause];
    
    //Resume button visible
    resumeButton = [CCButton buttonWithTitle:@"[RESUME]" fontName:@"Verdana-Bold" fontSize:18.0f];
    resumeButton.positionType = CCPositionTypeNormalized;
    resumeButton.position = ccp(0.85f, 0.85f);
    [resumeButton setTarget:self selector:@selector(onResumeClicked:)];
    [self addChild:resumeButton];
    
}

//Resumes game
- (void)onResumeClicked:(id)sender
{
    //Resume
    [[CCDirector sharedDirector] resume];
    [resumeButton removeFromParent];
    
    
}

// -----------------------------------------------------------------------
@end
