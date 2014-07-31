/*
     File: AVCamViewController.h
 Abstract: A view controller that coordinates the transfer of information between the user interface and the capture manager.
  Version: 1.2
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2011 Apple Inc. All Rights Reserved.
 
 */

#import <UIKit/UIKit.h>
#import "Reachability.h"

#define MAX_FONT_SIZE 30
#define MIN_FONT_SIZE 14
#define DEFAULT_FONT_SIZE 20

@class AVCamCaptureManager, AVCamPreviewView, AVCaptureVideoPreviewLayer;
 @class RWMReportVCViewController;
@class  Reachability;
@interface AVCamViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate, NSURLConnectionDelegate, UIAlertViewDelegate> {
    
    
    BOOL textFinishedLoading;
    BOOL recordingStarted;
    BOOL sessionHasBeenEvaluated;
    BOOL isVideoViewHidden;
    NSString *aContent;
    NSString *aTitle;
    NSString *studentName;
    
    NSURL *urlToUpload;
    NSString *filePathToforVid;
    NSOperationQueue         *operationQueue;
    //for aws
     
    int fontSize;
    
    //for progress  fo upload
     IBOutlet UIProgressView  *uploadProgress1;
}
@property (nonatomic, strong) RWMReportVCViewController *reportVC;
@property (strong, nonatomic) NSString *theToken;
@property (strong, nonatomic) IBOutlet UITextView *recorderTextView;
@property (strong, nonatomic) IBOutlet UIButton *uploadVideoBtn;
@property (strong, nonatomic) IBOutlet UIButton *showReportButton;

@property (strong, nonatomic) IBOutlet UIButton *notMeButton;
@property (strong, nonatomic) IBOutlet UILabel *studentNameLbl;

@property (nonatomic,strong) AVCamCaptureManager *captureManager;
@property (nonatomic,strong) IBOutlet UIView *videoPreviewView;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic,strong) IBOutlet UIBarButtonItem *cameraToggleButton;
@property (nonatomic,strong) IBOutlet UIBarButtonItem *recordButton;
@property (nonatomic,strong) IBOutlet UIBarButtonItem *stillButton;
@property (nonatomic,strong) IBOutlet UILabel *focusModeLabel;
@property (nonatomic,strong) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) NSString *tokenString;

@property (strong, nonatomic) IBOutlet UIButton *plusTextSize;

@property (strong, nonatomic) IBOutlet UIButton *minusTextSizeBtn;
@property (strong, nonatomic) IBOutlet UIImageView *helperOverlayImg;

@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (nonatomic, copy) NSDictionary *res;
#pragma mark Toolbar Actions
- (IBAction)toggleRecording:(id)sender;
- (IBAction)captureStillImage:(id)sender;
- (IBAction)toggleCamera:(id)sender;
-(void)setTokenFromSegue:(NSString*)aToken;
//-(IBAction)uploadVideo:(id)sender;
-(void)  goToReportsScreenWithSessionID:(NSString*)sessionID;
-(IBAction)goToReports:(id)sender withSessionID: (NSString*)sessionID;
-(void) showEndAlert;
-(IBAction)hideScreen:(id)sender;


-(IBAction)increaseTextSize:(id)sender;
-(IBAction)decreaseTextSize:(id)sender;
- (IBAction)showHelp:(id)sender;
-(IBAction)wrongName:(id)sender;

@end

