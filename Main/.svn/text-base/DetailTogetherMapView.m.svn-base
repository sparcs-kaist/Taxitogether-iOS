//
//  DetailTogetherMapView.m
//  TaxiTogether
//
//  Created by 정 창제 on 11. 8. 5..
//  Copyright 2011년 KAIST. All rights reserved.
//

#import "DetailTogetherMapView.h"
#import "SBJsonParser.h"
#import "TogetherPlaceMapAnnotation.h"

@implementation DetailTogetherMapView
@synthesize detailMapView,navItem,SelectType,DataDict;

-(IBAction)exitView
{
    [self dismissModalViewControllerAnimated:YES];
    //[detailMapView retain];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    detailMapView.delegate=self;
    MKCoordinateRegion reg;
    
    locCoordDepa=CLLocationCoordinate2DMake([[DataDict objectForKey:@"depa_lat"] floatValue],[[DataDict objectForKey:@"depa_long"]floatValue]);
    locCoordDest=CLLocationCoordinate2DMake([[DataDict objectForKey:@"dest_lat"] floatValue],[[DataDict objectForKey:@"dest_long"]floatValue]);
    
    if([SelectType isEqualToString:@"departure"])
    {
        navItem.title=@"출발지";
        reg.center=locCoordDepa;
    }
    else if([SelectType isEqualToString:@"destination"])
    {
        navItem.title=@"도착지";
        reg.center=locCoordDest;
    }
    
    UIBarButtonItem *exitButton=[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(exitView)]autorelease];
    navItem.rightBarButtonItem=exitButton;
    
    reg.span.latitudeDelta=0.005f;
    reg.span.longitudeDelta=0.005f;
    [detailMapView setRegion:reg animated:YES];
    
    if(!([[DataDict objectForKey:@"dest_long"]isEqualToString:@""]||[[DataDict objectForKey:@"dest_lat"]isEqualToString:@""]))
    {
        TogetherPlaceMapAnnotation *dropPin= [[[TogetherPlaceMapAnnotation alloc] init] autorelease];
        dropPin.coordinate = locCoordDest;
        dropPin.title=@"도착지";
        [detailMapView addAnnotation:dropPin];
        [dropPin updateSubtitleWithLatitude:locCoordDest.latitude Longitude:locCoordDest.longitude];
    }
    if(!([[DataDict objectForKey:@"depa_long"]isEqualToString:@""]||[[DataDict objectForKey:@"depa_lat"]isEqualToString:@""]))
    {
        TogetherPlaceMapAnnotation *dropPin= [[[TogetherPlaceMapAnnotation alloc] init] autorelease];
        dropPin.coordinate = locCoordDepa;
        dropPin.title=@"출발지";
        [detailMapView addAnnotation:dropPin];
        [dropPin updateSubtitleWithLatitude:locCoordDepa.latitude Longitude:locCoordDepa.longitude];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) displayPinCallOutView:(id<MKAnnotation>)annotation 
{
    [detailMapView selectAnnotation:annotation animated:YES];
}

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation 
{
    MKPinAnnotationView* pin=[[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"pin"]autorelease];
    if ( annotation.coordinate.latitude == locCoordDepa.latitude && annotation.coordinate.longitude == locCoordDepa.longitude){
        pin.pinColor=MKPinAnnotationColorGreen;
        if ( [SelectType isEqualToString:@"departure"])
        {
            [self performSelector:@selector(displayPinCallOutView:) withObject:annotation afterDelay:0.3]; // IMPORTANT
        }
    }
    else if (annotation.coordinate.latitude == locCoordDest.latitude && annotation.coordinate.longitude == locCoordDest.longitude){
        pin.pinColor=MKPinAnnotationColorRed;
        if ( [SelectType isEqualToString:@"destination"])
        {
            [self performSelector:@selector(displayPinCallOutView:) withObject:annotation afterDelay:0.3]; // IMPORTANT
        }
    }
    pin.animatesDrop=YES;
    pin.draggable=NO;
    pin.canShowCallout=YES;  
    
    return pin;
}

@end
