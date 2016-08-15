//
//  ViewController.m
//  CoolPig
//
//  Created by Eahom on 16/8/15.
//  Copyright © 2016年 Eahom. All rights reserved.
//

#import <opencv2/core.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/imgproc.hpp>

#ifdef WITH_OPENCV_CONTRIB
#import <opencv2/xphoto.hpp>
#endif

#import "ViewController.h"

#define RAND_0_1() ((double)arc4random() / 0x100000000)

@interface ViewController () {
    cv::Mat originalMat;
    cv::Mat updatedMat;
}

@property IBOutlet UIImageView *imageView;
@property (nonatomic, strong) NSTimer *timer;

- (void)updateImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImage *originalImage = [UIImage imageNamed:@"Piggy.png"];
    
    UIImageToMat(originalImage, originalMat);
    
    switch (originalMat.type()) {
        case CV_8UC1:
            // The cv::Mat is in grayscale format.
            // Convert it to RGB format.
            cv::cvtColor(originalMat, originalMat, cv::COLOR_GRAY2BGR);
            break;
            
        case CV_8UC4:
            // The cv::Mat is in RGBA format.
            // Convert it to RGB format.
            cv::cvtColor(originalMat, originalMat, cv::COLOR_RGBA2BGR);
#ifdef WITH_OPENCV_CONTRIB
            // Adjust the white balance.
            cv::xphoto::autowbGrayworld(originalMat, originalMat);
#endif
            break;
            
        case CV_8UC3:
            // The cv::Mat is in RGB format.
#ifdef WITH_OPENCV_CONTRIB
            // Adjust the white balance.
            cv::xphoto::autowbGrayworld(originalMat, originalMat);
#endif
            break;
            
        default:
            break;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(updateImage) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateImage {
    // Generate a random color.
    double r = 0.5 + RAND_0_1() * 1.0;
    double g = 0.6 + RAND_0_1() * 0.8;
    double b = 0.4 + RAND_0_1() * 1.2;
    cv::Scalar randomColor(r, g, b);
    
    // Create an updated, tinted cv::Mat by multiplying the
    // original cv::Mat and the random color.
    cv::multiply(originalMat, randomColor, updatedMat);
    
    // Convert the updated cv::Mat to a UIImage and display
    // it in the UIImageView.
    self.imageView.image = MatToUIImage(updatedMat);
}

@end
