//
//  RPBUsefulFunctions.c
//  RetroPaddleBall
//
//  Created by Luke Cotton on 6/10/14.
//
//

#include <Foundation/Foundation.h>

void RPBLog(NSString *format, ...) {
#ifdef DEBUG
    va_list args;
    va_start(args, format);
    NSLogv(format, args);
    va_end(args);
#else
    return;
#endif
}