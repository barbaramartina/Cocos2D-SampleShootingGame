//
//  Weapon.m
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

#import "Weapon.h"

#import "Projectile.h"

@implementation Weapon

@synthesize icon = _icon;
@synthesize projectile = _projectile;

-(void)dealloc
{
    [_projectile release];
    [_icon release];

    [super dealloc];
}

-(id)initWithProjectile:(Projectile*)projectile
              imageName:(NSString*)imageName
{
    if ((self = [super init]))
    {
        _projectile = [projectile retain];
        
        assert(imageName);

        _icon = [[CCSprite alloc] initWithFile:imageName];
        assert(_icon);
    }
    
    return self;
}


@end
