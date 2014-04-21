//
//  MainScene.m
//  shootinggame
//
//  Created by Barbara Rodeker on 12/11/12.
//
//  Licensed to the Apache Software Foundation (ASF) under one
//  or more contributor license agreements.  See the NOTICE file
//  distributed with this work for additional information
//  regarding copyright ownership.  The ASF licenses this file
//  to you under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance
//  with the License.  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing,
//  software distributed under the License is distributed on an
//  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
//  KIND, either express or implied.  See the License for the
//  specific language governing permissions and limitations
//  under the License.
//

#import "MainScene.h"

#import "MainLayer.h"
#import "StartGameLayer.h"
#import "PauseLayer.h"

#import "MainScreenViewController.h"
#import "CCUIViewWrapper.h"

/********************************************/

static CGPoint kMainViewControllerPosition = {0.0f, 102.0f};

/********************************************/

@interface MainScene()

-(void)presentMainScreenController;

@end

/********************************************/

@implementation MainScene

-(void)dealloc
{
    [_mainLayer release];
    [_pauseLayer release];
    [_startGameLayer release];
    
    [_mainScreenViewController release];
    
    [super dealloc];
}

-(id)init
{
    if (( self = [super init]))
    {
        _mainLayer = [[MainLayer node] retain];
        _pauseLayer = [[PauseLayer node] retain];
        _startGameLayer = [[StartGameLayer node] retain];
        
        [self addChild:_mainLayer];
        [self presentMainScreenController];
    }
    
    return self;
}

-(void)pauseGameRequired
{
    [_mainLayer setIsTouchEnabled:NO];
    [_mainScreenViewController.view setUserInteractionEnabled:NO];
    
    [self addChild:_pauseLayer];
}

-(void)stopPauseRequired
{
    [_pauseLayer removeFromParentAndCleanup:NO];

    [_mainLayer setIsTouchEnabled:YES];
    
    [_mainScreenViewController.view setUserInteractionEnabled:YES];
    
}

-(void)startNewGameScreenRequired
{
    [_mainLayer setIsTouchEnabled:NO];
    [_mainScreenViewController.view setUserInteractionEnabled:NO];
    
    [self addChild:_startGameLayer];
}

-(void)startNewGameButtonPressed
{
    [_startGameLayer removeFromParentAndCleanup:NO];

    [_mainLayer setIsTouchEnabled:YES];

    [_mainScreenViewController.view setUserInteractionEnabled:YES];

    [_mainLayer startNewGame];
}

#pragma mark Private

-(void)presentMainScreenController
{
    if (!_mainScreenViewController)
    {
        _mainScreenViewController = [[MainScreenViewController alloc] initWithNibName:@"MainScreenViewController" bundle:nil];
    }

    CCUIViewWrapper* mainScreenWrapper = [CCUIViewWrapper wrapperForUIView:_mainScreenViewController.view];
    
    mainScreenWrapper.position = kMainViewControllerPosition;
    
    [self addChild:mainScreenWrapper];
}


@end
