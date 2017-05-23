/*
 * Copyright 2009 Facebook
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0
 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "FBStreamDialog.h"
#import "FBSession.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
// global

static NSString* kStreamURL = @"http://www.facebook.com/connect/prompt_feed.php";

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation FBStreamDialog

@synthesize attachment        = _attachment,
		    actionLinks       = _actionLinks,
            targetId          = _targetId,
            userMessagePrompt = _userMessagePrompt;

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithSession:(FBSession*)session {
	if (self = [super initWithSession:session]) {
		_attachment        = @"";
		_actionLinks       = @"";
		_targetId          = @"";
		_userMessagePrompt = @"";
	}
	return self;
}

- (void)dealloc {
	[_attachment        release];
	[_actionLinks       release];
	[_targetId          release];
	[_userMessagePrompt release];
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// FBDialog

- (void)load {
	NSDictionary* getParams = @{@"display": @"touch"};
	
	NSDictionary* postParams = @{@"api_key": _session.apiKey,
								@"session_key": _session.sessionKey,
								@"preview": @"1",
								@"callback": @"fbconnect:success",
								@"cancel": @"fbconnect:cancel",
								@"attachment": _attachment,
								@"action_links": _actionLinks,
								@"target_id": _targetId,
								@"user_message_prompt": _userMessagePrompt};
	
	[self loadURL:kStreamURL method:@"POST" get:getParams post:postParams];
}

@end
