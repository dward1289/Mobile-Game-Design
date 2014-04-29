//
//  GameCenterHelper.h
//  YellowCar
//
//  Created by Devona Ward on 4/15/14.
//  Copyright (c) 2014 Devona Ward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GameCenterHelper : NSObject {
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
}

@property (assign, readonly) BOOL gameCenterAvailable;


+ (GameCenterHelper *)sharedInstance;
- (void)authenticateLocalUser;
-(void) submitScore:(int64_t)score;



@end
