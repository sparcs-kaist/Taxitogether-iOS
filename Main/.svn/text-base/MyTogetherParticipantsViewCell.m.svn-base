//
//  MyTogetherParticipantsViewCell.m
//  TaxiTogether
//
//  Created by Fragarach on 7/26/11.
//  Copyright 2011 KAIST. All rights reserved.
//

#import "MyTogetherParticipantsViewCell.h"
#import "Asyncimageview.h"


@implementation MyTogetherParticipantsViewCell
@synthesize userid, phone, photo, gender, photoURL, net, imageLoading;


-(void) removeProgressViewWithSuccess
{
    //NSLog(@"HELLO SUCCESS");
    [imageLoading removeFromSuperview];
}

-(void) removeProgressViewWithFail
{
    //NSLog(@"HELLO FAIL");
    //NSMutableString *staticpath = [[NSMutableString alloc]initWithString: @"static/"];
}

-(void)awakeFromNib 
{
    photoImage = [[AsyncImageView alloc] initWithFrame:self.photo.frame];
    //NSLog(@"awake from nib");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeProgressViewWithSuccess) 
                                                 name:@"ProfileImageSuccess" object:photoImage];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeProgressViewWithFail) 
                                                 name:@"ProfileImageFail" object:photoImage];
}

-(void)dealloc
{
    //NSLog(@"dealloc");

   [[NSNotificationCenter defaultCenter] removeObserver: self];    
   [super dealloc];
}

-(void) loadImage 
{
    //NSLog(@"LOADIMAGE");
    NSMutableString *staticpath = [[NSMutableString alloc]initWithString: @"static/"];
    [staticpath appendString:photoURL];
    [photoImage loadImageFromURL: [NSURL URLWithString:staticpath relativeToURL:net]];
    [photo addSubview:photoImage];
    imageLoading.center = photo.center;
    [photo addSubview:imageLoading];
    
    [staticpath release];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state 
}

@end

