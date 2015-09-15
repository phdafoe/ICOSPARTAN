/*==============================
 
 - WazzUp -
 
 Chat App Template made by FV iMAGINATION - 2015
 for codecanyon.net
 
 ===============================*/



#import "ViewPictureVC.h"

NSMutableArray *photosArray;

@interface ViewPictureVC ()




@end

@implementation ViewPictureVC

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"All Photos";

    // Setup all images of the chat
    [self setupImages];

    
}

-(void)setupImages {
    int xCoord = 0;
    int yCoord = 0;
    int buttonWidth = self.view.frame.size.width;
    int buttonHeight= self.view.frame.size.height;
    int gapBetweenButtons = 0;
    
    
    // Loop for creating buttons ========
    for (int i = 0;  i < photosArray.count;  i++) {
        
        // Create a Button for each Filter ==========
        UIImageView *photoImage = [[UIImageView alloc]initWithImage:photosArray[i]];
        photoImage.frame = CGRectMake(xCoord, yCoord, buttonWidth, buttonHeight);
        photoImage.contentMode = UIViewContentModeScaleAspectFit;
        photoImage.clipsToBounds = true;
        photoImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        [_imagesScrollView addSubview:photoImage];
        
        xCoord +=  buttonWidth + gapBetweenButtons;
    }
    
    _imagesScrollView.contentSize = CGSizeMake(buttonWidth * photosArray.count, yCoord);
    _pageControl.numberOfPages = photosArray.count;
}



// METODO PER IL PAGE CONTROL CHE CAMBIA PAGINA AD OGNI SCROLL ****************
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = _imagesScrollView.frame.size.width;
    NSInteger page = floor((_imagesScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
