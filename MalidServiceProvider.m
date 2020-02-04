/*
    Copyright (c) 2020, Sveinbjorn Thordarson <sveinbjorn@sveinbjorn.org>
    All rights reserved.

    Redistribution and use in source and binary forms, with or without modification,
    are permitted provided that the following conditions are met:

    1. Redistributions of source code must retain the above copyright notice, this
    list of conditions and the following disclaimer.

    2. Redistributions in binary form must reproduce the above copyright notice, this
    list of conditions and the following disclaimer in the documentation and/or other
    materials provided with the distribution.

    3. Neither the name of the copyright holder nor the names of its contributors may
    be used to endorse or promote products derived from this software without specific
    prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
    IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
    INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
    NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
    PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
    WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
    ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
    POSSIBILITY OF SUCH DAMAGE.
*/

#import "MalidServiceProvider.h"

@implementation MalidServiceProvider

- (void)malidLookup:(NSPasteboard *)pboard userData:(NSString *)userData error:(NSString **)error {
    // Test for strings on the pasteboard.
    NSArray *classes = [NSArray arrayWithObject:[NSString class]];
    NSDictionary *options = [NSDictionary dictionary];
 
    if (![pboard canReadObjectForClasses:classes options:options]) {
         *error = @"No string in pasteboard.";
         return;
    }
 
    // Get the string and preprocess it
    NSString *pboardString = [pboard stringForType:NSPasteboardTypeString];
    NSArray *words = [pboardString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *word2lookup;
    for (NSString *w in words) {
        if (w) {
            word2lookup = w;
            break;
        }
    }
    
    if (!word2lookup) {
         *error = @"No word to look up.";
         return;
    }
    
    BOOL success = [self _lookUp:word2lookup];
    if (!success) {
        *error = @"Failed to open browser.";
        return;
    }
}

- (BOOL)_lookUp:(NSString *)providedString {
    NSString *urlStr = [NSString stringWithFormat:@"https://malid.is/leit/%@",
                        [providedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:urlStr]];
}

@end
