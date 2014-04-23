/*
 * http://www.gleejit.com/
 *
 * Copyright (c) 2014 Chen Xi
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "GKHWrapperOC.h"
#import "GKHWrapperCpp.h"
#include "platform/ios/CCLuaObjcBridge.h"

USING_NS_CC;

@implementation GKHWrapperOC

+(void) authenticateLocalPlayer
{
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
    [gameKitHelper authenticateLocalPlayer];
}

+(bool) isLocalPlayerAuthenticated
{
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
    return [gameKitHelper isLocalPlayerAuthenticated];
}

+(void) getPlayerInfo:(NSDictionary*)playerList
{
    NSMutableArray *objcArray = [NSMutableArray array];
    NSEnumerator *enumerator = [playerList objectEnumerator];
	id key;
	while ((key = [enumerator nextObject]))
    {
        NSString* playerID = [[playerList objectForKey:key] stringValue];
        [objcArray addObject:playerID];
	}
    
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
    [gameKitHelper getPlayerInfo:objcArray];
}

+(void) getLocalPlayerFriends
{
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
    [gameKitHelper getLocalPlayerFriends];
}

+(void) submitScore:(NSDictionary*)params
{
    int64_t score = 0;
    if ([params objectForKey:@"score"])
    {
        score = [[params objectForKey:@"score"] longLongValue];
    }
    
    NSString *category = [params objectForKey:@"category"];
    if (!category)
    {
        category = @"";
    }
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
    [gameKitHelper submitScore:score category:category];
}

+(void) retrieveTopTenAllTimeGlobalScores:(NSDictionary*)params
{
    NSString* catagory = [[params objectForKey:@"catagory"] stringValue];
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
    [gameKitHelper retrieveTopTenAllTimeGlobalScoresForCatagory:catagory];
}

+(void) _retrieveScoresForPlayers:(NSDictionary*)params timeScope:(GKLeaderboardTimeScope)timeScope
{
    NSString* playerList = [params objectForKey:@"playerList"];
    NSArray *playerIDsArray = [playerList componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
    
    NSString* catagory = [params objectForKey:@"catagory"];
    int startIndex = 0;
    if ([params objectForKey:@"startIndex"])
    {
        startIndex = [[params objectForKey:@"startIndex"] intValue];
    }
    
    int numPlayers = 0;
    if ([params objectForKey:@"numPlayers"])
    {
        numPlayers = [[params objectForKey:@"numPlayers"] intValue];
    }
    
    bool friendsOnly = false;
    if ([params objectForKey:@"friendsOnly"])
    {
        friendsOnly = [[params objectForKey:@"friendsOnly"] boolValue];
    }
    GKLeaderboardPlayerScope playerScope;
    if (friendsOnly) {playerScope = GKLeaderboardPlayerScopeFriendsOnly;}
    else {playerScope = GKLeaderboardPlayerScopeGlobal;}
    
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
    
    [gameKitHelper retrieveScoresForPlayers:playerIDsArray
                                   category:catagory
                                      range:NSMakeRange(startIndex, numPlayers)
                                playerScope:playerScope
                                  timeScope:timeScope];
}

+(void) retrieveScoresForPlayersToday:(NSDictionary*)params
{
    [GKHWrapperOC _retrieveScoresForPlayers:params
                                  timeScope:GKLeaderboardTimeScopeToday];
}

+(void) retrieveScoresForPlayersThisWeek:(NSDictionary*)params;
{
    [GKHWrapperOC _retrieveScoresForPlayers:params
                                  timeScope:GKLeaderboardTimeScopeWeek];
}

+(void) retrieveScoresForPlayersAllTime:(NSDictionary*)params
{
    [GKHWrapperOC _retrieveScoresForPlayers:params
                                  timeScope:GKLeaderboardTimeScopeAllTime];
}

+(GKAchievementCpp) getAchievementByID:(NSDictionary*)params
{
    NSString *nssid = [[params objectForKey:@"id"] stringValue];
    if (!nssid)
    {
        nssid = @"";
    }
    
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
    GKAchievement *achievement = [gameKitHelper getAchievementByID:nssid];
    
    GKAchievementCpp gkaCpp = [gameKitHelper convertGKAchievementToGKAchievementStruct:achievement];
    return gkaCpp;
}

+(void) reportAchievement:(NSDictionary*)params
{
    NSString* nssIndentifier = [[params objectForKey:@"id"] stringValue];
    if (!nssIndentifier)
    {
        nssIndentifier = @"";
    }
    float percentComplete = 0;
    if ([params objectForKey:@"percentComplete"])
    {
        percentComplete = [[params objectForKey:@"percentComplete"] floatValue];
    }
    bool showCompletionBanner = false;
    if ([params objectForKey:@"percentComplete"])
    {
        showCompletionBanner = [[params objectForKey:@"percentComplete"] boolValue];
    }
    
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
    [gameKitHelper reportAchievementWithID:nssIndentifier percentComplete:percentComplete showCompletionBanner:showCompletionBanner];
}

+(void) resetAchievements
{
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
    [gameKitHelper resetAchievements];
}

+(void) reportCachedAchievements
{
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
    [gameKitHelper reportCachedAchievements];
}

+(void) saveCachedAchievements
{
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
    [gameKitHelper saveCachedAchievements];
}

+(void) showLeaderBoard
{
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
    [gameKitHelper showLeaderboard];
}

+(void) showAchievements
{
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
    [gameKitHelper showAchievements];
}

@end
