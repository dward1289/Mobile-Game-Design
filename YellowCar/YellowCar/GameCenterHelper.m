//
//  GameCenterHelper.m
//  YellowCar
//
//  Created by Devona Ward on 4/15/14.
//  Copyright (c) 2014 Devona Ward. All rights reserved.
//

#import "GameCenterHelper.h"

@implementation GameCenterHelper

@synthesize gameCenterAvailable;


//Initiallize Game Center Helper
static GameCenterHelper *sharedHelper = nil;
+ (GameCenterHelper *) sharedInstance {
    if (!sharedHelper) {
        sharedHelper = [[GameCenterHelper alloc] init];
    }
    return sharedHelper;
}

//Check for Game Center compatibility
- (BOOL)isGameCenterAvailable {
    //Check GKLocal Player API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    //iOS 4.1 or higher check
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer
                                           options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

//Checking for Game Center availability
- (id)init {
    if ((self = [super init])) {
        gameCenterAvailable = [self isGameCenterAvailable];
        if (gameCenterAvailable) {
            NSNotificationCenter *nc =
            [NSNotificationCenter defaultCenter];
            [nc addObserver:self
                   selector:@selector(authenticationChanged)
                       name:GKPlayerAuthenticationDidChangeNotificationName
                     object:nil];
        }
    }
    return self;
}

//Checking for change in authentication
- (void)authenticationChanged {
    
    if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated) {
        NSLog(@"Authentication changed: player authenticated.");
        userAuthenticated = TRUE;
    } else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated) {
        NSLog(@"Authentication changed: player not authenticated");
        userAuthenticated = FALSE;
    }
    
}

//Checking player login status for Game Center
- (void)authenticateLocalUser {
    
    if (!gameCenterAvailable) return;
    
    NSLog(@"Authenticating Player");
    if ([GKLocalPlayer localPlayer].authenticated == NO) {
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:nil];
    } else {
        NSLog(@"Authenticated has been done, no worries!");
    }
}

//Submit score to Game Center
-(void) submitScore:(int64_t)score {
    //Name of leaderboard ID
    NSString *LI = @"com.MadGeek.YellowCar.HighScores";
    //Get the score value
    GKScore *scoreValue = [[GKScore alloc] initWithLeaderboardIdentifier:LI];
    scoreValue.value = score;
    //Check score submission status.
    [scoreValue reportScoreWithCompletionHandler:^(NSError *error){
    
        if(error != nil){
        NSLog(@"Score Failed to Save to Game Center.");
    } else {
        NSLog(@"Score Saved to Game Center.");
    }
    
}];

}
@end
