//
//  MyTogetherParticipantsViewCell.h
//  TaxiTogether
//
//  Created by Fragarach on 7/26/11.
//  Copyright 2011 KAIST. All rights reserved.
//

#import "Asyncimageview.h"

@interface MyTogetherParticipantsViewCell : UITableViewCell {
    
    IBOutlet UIImageView *photo;
    IBOutlet UILabel *phone;
    IBOutlet UILabel *userid;
    IBOutlet UILabel *gender;
    
    UIView *imageLoading;
    AsyncImageView *photoImage;
    
    NSString* photoURL;
    NSURL *net;
    
}

@property (nonatomic,retain) IBOutlet UIImageView *photo;
@property (nonatomic,retain) IBOutlet UILabel *phone;
@property (nonatomic,retain) IBOutlet UILabel *userid;
@property (nonatomic,retain) IBOutlet UILabel *gender;
@property (nonatomic,retain) IBOutlet UIView *imageLoading;

@property (nonatomic,retain) NSString* photoURL;
@property (nonatomic,retain) NSURL* net;

-(void) loadImage;

@end
