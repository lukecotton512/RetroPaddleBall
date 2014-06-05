//
//  main.m
//  CoreGraphicsDrawing
//
//  Created by Luke Cotton on 2/5/11.
//  Copyright 2011 Luke Cotton. All rights reserved.
//
#import <dlfcn.h>
#import <sys/types.h>
#import <UIKit/UIKit.h>
#import "CoreGraphicsDrawingAppDelegate.h"
#ifndef PT_DENY_ATTACH
    #define PT_DENY_ATTACH 31
#endif
#ifdef DEBUG
    BOOL debugIsEnabled=YES;
#else
    BOOL debugIsEnabled=NO;
#endif
//inline void initapp();
typedef int (*ptrace_ptr_t)(int _request, pid_t _pid, caddr_t _addr, int _data);
static inline void initapp() {
    void *handle = dlopen(0, RTLD_GLOBAL|RTLD_NOW);
    char char1=0x00;
    char charA[7]={0x70, 0x74, 0x72, 0x61, 0x63, 0x65, char1};
    ptrace_ptr_t ptrace_ptr = (ptrace_ptr_t)dlsym(handle, charA);
    ptrace_ptr(PT_DENY_ATTACH,0,0,0);
    dlclose(handle);
}
int main(int argc, char *argv[]) {
    @autoreleasepool {
        if(debugIsEnabled==NO) {
            initapp();
        }
        srandom(time(NULL));
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([CoreGraphicsDrawingAppDelegate class]));
    }
}
