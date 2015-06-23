//
//  ICODetailSpartanNivel1ViewController.h
//  ICOSPARTAN
//
//  Created by User on 4/6/15.
//  Copyright (c) 2015 iCologic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICODetailSpartanNivel1ViewController : UIViewController


//Modelos de datos
@property NSString *titleLabel;
@property NSString *descriptionLabel;
@property UIImage *imageView1;
@property UIImage *imageView2;

//Sincronizacion en la vista
@property (weak, nonatomic) IBOutlet UILabel *nameTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionSpartanLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageSpartanView;
@property (weak, nonatomic) IBOutlet UIImageView *imageSpartanView2;


@end
