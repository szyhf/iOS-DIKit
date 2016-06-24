//
//  XCodeColors.h
//  Pods
//
//  Created by Back on 16/5/23.
//
//

#ifndef XCodeColors_h
#define XCodeColors_h
// <COPY ME> 基于XCodeColors的彩色输出=。=

#define XCODE_COLORS_ESCAPE @"\033["

#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color
#define light_xcode_color
// </COPY ME>
#ifdef light_xcode_color

#define XCODE_COLOR_Black @"0,0,0"
#define XCODE_COLOR_Dark @"84,84,84"
#define XCODE_COLOR_Light @"168,168,168"
#define XCODE_COLOR_White @"220,220,220"
#define XCODE_COLOR_Gray @"128,128,128"
#define XCODE_COLOR_Red @"220,0,0"
#define XCODE_COLOR_Green @"0,220,0"
#define XCODE_COLOR_Blue @"0,0,220"
#define XCODE_COLOR_Cyan @"0,220,220"
#define XCODE_COLOR_Yellow @"220,220,0"
#define XCODE_COLOR_Magent @"220,0,220"
#define XCODE_COLOR_Orange @"220,128,0"
#define XCODE_COLOR_Purple @"128,0,128"
#define XCODE_COLOR_Brown @"153,102,51"

#else

#define XCODE_COLOR_Black @"0,0,0"
#define XCODE_COLOR_Dark @"84,84,84"
#define XCODE_COLOR_Light @"168,168,168"
#define XCODE_COLOR_White @"255,255,255"
#define XCODE_COLOR_Gray @"128,128,128"
#define XCODE_COLOR_Red @"255,0,0"
#define XCODE_COLOR_Green @"0,255,255"
#define XCODE_COLOR_Blue @"0,0,255"
#define XCODE_COLOR_Cyan @"0,255,255"
#define XCODE_COLOR_Yellow @"255,255,0"
#define XCODE_COLOR_Magent @"255,0,255"
#define XCODE_COLOR_Orange @"255,128,0"
#define XCODE_COLOR_Purple @"128,0,128"
#define XCODE_COLOR_Brown @"153,102,51"

#endif /* XCODE_COLOR */
#define nsStringOfBlack(str) [NSString stringWithFormat:@"\033[fg%@;%@\033[;",XCODE_COLOR_Black,str]
#define  nsStringOfDark(str) [NSString stringWithFormat:@"\033[fg%@;%@\033[;",XCODE_COLOR_Dark , str]
#define  nsStringOfLight(str) [NSString stringWithFormat:@"\033[fg%@;%@\033[;",XCODE_COLOR_Light , str]
#define  nsStringOfWhite(str) [NSString stringWithFormat:@"\033[fg%@;%@\033[;",XCODE_COLOR_White , str]
#define  nsStringOfGray(str) [NSString stringWithFormat:@"\033[fg%@;%@\033[;",XCODE_COLOR_Gray , str]
#define  nsStringOfRed(str) [NSString stringWithFormat:@"\033[fg%@;%@\033[;",XCODE_COLOR_Red , str]
#define  nsStringOfGreen(str) [NSString stringWithFormat:@"\033[fg%@;%@\033[;",XCODE_COLOR_Green , str]
#define  nsStringOfBlue(str) [NSString stringWithFormat:@"\033[fg%@;%@\033[;",XCODE_COLOR_Blue , str]
#define  nsStringOfCyan(str) [NSString stringWithFormat:@"\033[fg%@;%@\033[;",XCODE_COLOR_Cyan , str]
#define  nsStringOfYellow(str) [NSString stringWithFormat:@"\033[fg%@;%@\033[;",XCODE_COLOR_Yellow , str]
#define  nsStringOfMagent(str) [NSString stringWithFormat:@"\033[fg%@;%@\033[;",XCODE_COLOR_Magent , str]
#define  nsStringOfOrange(str) [NSString stringWithFormat:@"\033[fg%@;%@\033[;",XCODE_COLOR_Orange , str]
#define  nsStringOfPurple(str) [NSString stringWithFormat:@"\033[fg%@;%@\033[;",XCODE_COLOR_Purple , str]
#define  nsStringOfBrown(str) [NSString stringWithFormat:@"\033[fg%@;%@\033[;",XCODE_COLOR_Brown , str]
#endif /* XCodeColors_h */
