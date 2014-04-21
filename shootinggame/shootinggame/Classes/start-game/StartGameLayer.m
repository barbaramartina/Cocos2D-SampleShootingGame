//
//  StartGameLayer.m
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

#import "StartGameLayer.h"

#import "AppDelegate.h"
#import "MainScene.h"

/***********************************************/

@interface StartGameLayer()

-(void)addStartNewGameGameButton;
-(void)startNewGamePressed;

@end

/***********************************************/

@implementation StartGameLayer

-(void)dealloc
{

    [super dealloc];
}

-(id)init
{
    if ((self = [super init]))
    {
        [self addStartNewGameGameButton];
    }
    
    return self;
}

#pragma mark Private

-(void)addStartNewGameGameButton
{
    CCMenuItemFont* menuOption = [CCMenuItemFont itemWithString:@"Start new game"
                                                                 target:self
                                                               selector:@selector(startNewGamePressed)];
    
    CCMenu* menu = [CCMenu menuWithItems:menuOption, nil];
    menu.position = CGPointMake(160.0f, 240.0f);
    
    [self addChild:menu];
}

-(void)startNewGamePressed
{
    [((AppController*)[[UIApplication sharedApplication] delegate]).mainScene startNewGameButtonPressed];
}



@end
