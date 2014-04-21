//
//  MainLayer.m
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

#import "MainLayer.h"

#import "Weapon.h"
#import "Projectile.h"
#import "Target.h"

/********************************************/

static NSString* kWeaponDefaultSpriteName = @"weapon1.png";
static CGPoint kWeaponPosition = {160.0f, 98.0f};

/********************************************/

@interface MainLayer()

-(void)addDefaultWeapon;
-(void)spawnTargets;
-(void)spawnProjectileToPoint:(CGPoint)point;
-(void)addTargetSprite:(CCSprite*)targetSprite
             fromPoint:(CGPoint)fromPoint
               toPoint:(CGPoint)toPoint;

@end

/********************************************/

@implementation MainLayer

-(void)dealloc
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    
    [_projectileSprites release];
    [_targetSprites release];
    [_currentWeapon release];
    
    [super dealloc];
}

-(id)init
{
    if ((self = [super init]))
    {
        [self addDefaultWeapon];
        
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
        
        _projectileSprites = [[NSMutableArray alloc] init];
        _targetSprites = [[NSMutableArray alloc] init];
        
        [self schedule:@selector(detectCollisions)
              interval:0.1f];
    }
    
    return self;
}

-(void)onEnter
{
    [self startNewGame];
    
    [super onEnter];
}

-(void)startNewGame
{
    [_projectileSprites removeAllObjects];
    [_targetSprites removeAllObjects];
    
    [self spawnTargets];
}

-(void)detectCollisions
{
    NSMutableArray* projectilesToDelete = [[NSMutableArray alloc] init];
    NSMutableArray* targetsToDelete = [[NSMutableArray alloc] init];
    
    
    for (CCSprite* projectile in _projectileSprites)
    {
        CGRect projectileRect = CGRectMake(projectile.position.x - (projectile.contentSize.width / 2),
                                           projectile.position.y - (projectile.contentSize.height / 2),
                                           projectile.contentSize.width,
                                           projectile.contentSize.height);
        
        for (CCSprite* target in _targetSprites)
        {
            CGRect targetRect = CGRectMake(target.position.x - (target.contentSize.width / 2),
                                           target.position.y - (target.contentSize.height / 2),
                                           target.contentSize.width,
                                           target.contentSize.height);
            
            if (CGRectIntersectsRect(targetRect, projectileRect))
            {
                [targetsToDelete addObject:target];
                [projectilesToDelete addObject:projectile];
            }
        
        }
        
    }
    
    for (CCSprite* targetToDelete in targetsToDelete)
    {
        [_targetSprites removeObject:targetToDelete];
        [targetToDelete stopAllActions];
        [targetToDelete removeFromParentAndCleanup:YES];
    }
    for (CCSprite* projectileToDelete in projectilesToDelete)
    {
        [_projectileSprites removeObject:projectileToDelete];
        [projectileToDelete stopAllActions];
        [projectileToDelete removeFromParentAndCleanup:YES];
    }
    
    [projectilesToDelete release];
    [targetsToDelete release];
}

#pragma mark Private

-(void)addDefaultWeapon
{
    Projectile* projectile = [[Projectile alloc] initWithVelocity:40.0f
                                                        imageName:@"projectile1.png"];
    
    _currentWeapon = [[Weapon alloc] initWithProjectile:projectile
                                              imageName:kWeaponDefaultSpriteName];
    
    _currentWeapon.icon.position = kWeaponPosition;
    
    [projectile release];
    
    [self addChild:_currentWeapon.icon];
}

-(void)spawnTargets
{
    for (int count = 0; count < 60; count++)
    {
        CCSprite* target = nil;
        
        if ( ( count % 3 ) == 0)
        {
           target = [CCSprite spriteWithFile:@"target1.png"];
        }
        else
        {
            target = [CCSprite spriteWithFile:@"target3.png"];
        }
        
        CGPoint fromPoint = CGPointMake(-50, rand() % 480);
        CGPoint toPoint = CGPointMake(200 + (rand() % 320), 540 + (rand() % 30));
        
        [self addTargetSprite:target
                    fromPoint:fromPoint
                      toPoint:toPoint];
    }
}

-(void)addTargetSprite:(CCSprite*)targetSprite fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    [_targetSprites addObject:targetSprite];
    
    targetSprite.position = fromPoint;
    
    [self addChild:targetSprite];
    
    [targetSprite runAction:[CCMoveTo actionWithDuration:3.0f * (rand() % 10)
                                                position:toPoint]];
}

-(void)spawnProjectileToPoint:(CGPoint)point
{
    //leer el tipo de projectile crear el sprite physics y hacerlo mover)
    CCSprite* projectileSprite = [[CCSprite alloc] initWithTexture:_currentWeapon.projectile.icon.texture];
    
    projectileSprite.position = kWeaponPosition;
    
    [_projectileSprites addObject:projectileSprite];
    
    [self addChild:projectileSprite];
    
    int xOffset = 0;

    if (point.x < 160.0f)
    {
        xOffset = -80.0f;
    }
    else
    {
        xOffset = 80.0f;
    }
    
    CGPoint finalPoint = CGPointMake(point.x + xOffset, point.y + 500.0f);

    CCSequence* actionSequence = [CCSequence actionOne:[CCMoveTo actionWithDuration:0.35f position:point]
                                                   two:[CCMoveTo actionWithDuration:0.35f position:finalPoint]];
    
    [projectileSprite runAction:actionSequence];
    
    [projectileSprite release];
}

#pragma mark CCTargetedTouchDelegate

-(BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent *)event
{
	CGPoint point = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[[CCDirector sharedDirector] view]]];
                     
    //Are we touching the weapon sprite?
    CCSprite* weaponIcon = _currentWeapon.icon;
    
    CGRect iconRect = CGRectMake(weaponIcon.position.x - (weaponIcon.textureRect.size.width / 2),
                                 weaponIcon.position.y - (weaponIcon.textureRect.size.height / 2),
                                 weaponIcon.textureRect.size.width,
                                 weaponIcon.textureRect.size.height);
    
   if (CGRectContainsPoint(iconRect, point))
   {
       return YES;
   }
    
    return NO;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint point = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[[CCDirector sharedDirector] view]]];

    [self spawnProjectileToPoint:point];
}
       

@end
