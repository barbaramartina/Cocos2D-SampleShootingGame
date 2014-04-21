//
//  Projectile.m
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

#import "Projectile.h"


@implementation Projectile
@synthesize icon = _icon;

-(void)dealloc
{
    [_icon release];
    
    [super dealloc];
}

-(id)initWithVelocity:(CGFloat)velocity imageName:(NSString*)imageName
{
    if ((self = [super init]))
    {
        _velocity = velocity;
        
        assert(imageName);
        
        _icon = [[CCSprite alloc] initWithFile:imageName];
        assert(_icon);
    }
    
    return self;
}


@end
