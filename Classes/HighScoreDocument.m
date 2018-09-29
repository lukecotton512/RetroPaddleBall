//
//  HighScoreDocument.m
//  RetroPaddleBall
//
//  Created by Luke Cotton on 9/4/12.
//
//

#import "HighScoreDocument.h"

@implementation HighScoreDocument
@synthesize arrayContents;
// Load contents of high score array into memory.
-(BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)outError
{
    self.arrayContents = [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithBytes:[contents bytes] length:[contents length]]];
    return YES;
}
// Return the data we want to archive out.
-(id)contentsForType:(NSString *)typeName error:(NSError **)outError
{
    return [NSKeyedArchiver archivedDataWithRootObject:self.arrayContents];
}
@end
