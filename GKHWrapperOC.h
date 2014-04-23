//
//  GKHWrapperOC.h
//  runrun
//
//  Created by chenxi on 14-3-31.
//
//

#import <Foundation/Foundation.h>
#import "GKHWrapperOC.h"
#import "GameKitHelper.h"

@interface GKHWrapperOC : NSObject

+(void) _retrieveScoresForPlayers:(NSDictionary*)params timeScope:(GKLeaderboardTimeScope)timeScope;

// Players
+(void) authenticateLocalPlayer;
+(bool) isLocalPlayerAuthenticated;
+(void) getLocalPlayerFriends;
+(void) getPlayerInfo:(NSDictionary*)playList;

// Scores
+(void) submitScore:(NSDictionary*)params;
+(void) retrieveTopTenAllTimeGlobalScores:(NSDictionary*)params;
+(void) retrieveScoresForPlayersToday:(NSDictionary*)params;
+(void) retrieveScoresForPlayersThisWeek:(NSDictionary*)params;
+(void) retrieveScoresForPlayersAllTime:(NSDictionary*)params;

// Achivements
+(GKAchievementCpp) getAchievementByID:(NSDictionary*)params;
+(void) reportAchievement:(NSDictionary*)params;
+(void) resetAchievements;
+(void) reportCachedAchievements;
+(void) saveCachedAchievements;

// Game Center Views
+(void) showLeaderBoard;
+(void) showAchievements;

//delegate
//+(void) setDelegate:(NSDictionary*) params;
@end
