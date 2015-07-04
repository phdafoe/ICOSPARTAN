//
//  ICODetailMapViewController.m
//  iCoSpartan
//
//  Created by User on 2/7/15.
//  Copyright (c) 2015 iCologic. All rights reserved.
//

#import "ICODetailMapViewController.h"

@interface ICODetailMapViewController ()

@end

@implementation ICODetailMapViewController

- (void)centerScrollViewContents {
    
    CGSize boundsSize = self.mapParkTrainerScrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 6.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 3.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageView.frame = contentsFrame;
}

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    // Get the location within the image view where we tapped
    CGPoint pointInView = [recognizer locationInView:self.imageView];
    
    // Get a zoom scale that's zoomed in slightly, capped at the maximum zoom scale specified by the scroll view
    CGFloat newZoomScale = self.mapParkTrainerScrollView.zoomScale * 3.0f;
    newZoomScale = MIN(newZoomScale, self.mapParkTrainerScrollView.maximumZoomScale);
    
    // Figure out the rect we want to zoom to, then zoom to it
    CGSize scrollViewSize = self.mapParkTrainerScrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    [self.mapParkTrainerScrollView zoomToRect:rectToZoomTo animated:YES];
}

- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer {
    // Zoom out slightly, capping at the minimum zoom scale specified by the scroll view
    CGFloat newZoomScale = self.mapParkTrainerScrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, self.mapParkTrainerScrollView.minimumZoomScale);
    [self.mapParkTrainerScrollView setZoomScale:newZoomScale animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.nameMapParkTrainer;
    
    self.imageView.image = self.imageMapPark;
    self.descriptionMapOfParkTrainer.text = self.descriptionMapParkTrainer;
    self.nameCityPark.text = self.nameCityMapParkTrainer;
    
    self.imageView = [[UIImageView alloc] initWithImage:self.imageMapPark];
    self.imageView.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=self.imageMapPark.size};
    [self.mapParkTrainerScrollView addSubview:self.imageView];
    
    // Tell the scroll view the size of the contents
    self.mapParkTrainerScrollView.contentSize = self.imageMapPark.size;
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.mapParkTrainerScrollView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [self.mapParkTrainerScrollView addGestureRecognizer:twoFingerTapRecognizer];
    
    [self.nameCityPark setNumberOfLines:0];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Set up the minimum & maximum zoom scales
    CGRect scrollViewFrame = self.mapParkTrainerScrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.mapParkTrainerScrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.mapParkTrainerScrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    
    self.mapParkTrainerScrollView.minimumZoomScale = minScale;
    self.mapParkTrainerScrollView.maximumZoomScale = 3.5f;
    self.mapParkTrainerScrollView.zoomScale = minScale;
    
    [self centerScrollViewContents];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that we want to zoom
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so we need to re-center the contents
    [self centerScrollViewContents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








@end
