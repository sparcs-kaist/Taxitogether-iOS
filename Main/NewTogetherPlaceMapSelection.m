//
//  NewTogetherPlaceMapSelection.m
//  TaxiTogether
//
//  Created by 정 창제 on 11. 8. 4..
//  Copyright 2011년 KAIST. All rights reserved.
//

#import "NewTogetherPlaceMapSelection.h"
#import "SBJsonParser.h"
#import "TogetherPlaceMapAnnotation.h"

@implementation NewTogetherPlaceMapSelection
@synthesize navBar,navItem,selectMapView,DataDict,SelectType;
-(IBAction)saveMap
{    
    if([SelectType isEqualToString:@"destination"])
    {
        if(locCoordDest.latitude == 0.0f || locCoordDest.longitude==0.0f)
        {
            [self dismissModalViewControllerAnimated:YES];
        }
        else
        {
            [DataDict setObject:[NSString stringWithFormat:@"%f",locCoordDest.latitude] forKey:@"dest_lat"];
            [DataDict setObject:[NSString stringWithFormat:@"%f",locCoordDest.longitude] forKey:@"dest_long"];
        }
    }
    else if([SelectType isEqualToString:@"departure"])
    {
        if(locCoordDepa.latitude==0.0f||locCoordDepa.longitude==0.0f)
        {
            [self dismissModalViewControllerAnimated:YES];
        }
        else
        {
            [DataDict setObject:[NSString stringWithFormat:@"%f",locCoordDepa.latitude] forKey:@"depa_lat"];
            [DataDict setObject:[NSString stringWithFormat:@"%f",locCoordDepa.longitude] forKey:@"depa_long"];
        }
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    TogetherPlaceMapAnnotation * annote = (TogetherPlaceMapAnnotation *)view.annotation;
    if(oldState==MKAnnotationViewDragStateDragging&&newState==MKAnnotationViewDragStateEnding)
    {
        [mapView deselectAnnotation:annote animated:YES];
        if([SelectType isEqualToString:@"departure"])
        {
            locCoordDepa = [view.annotation coordinate];
            [annote updateSubtitleWithLatitude:locCoordDepa.latitude Longitude:locCoordDepa.longitude];
        }
        else if([SelectType isEqualToString:@"destination"])
        {
            locCoordDest= [view.annotation coordinate];
            [annote updateSubtitleWithLatitude:locCoordDest.latitude Longitude:locCoordDest.longitude];
        }
        //[selectMapView selectAnnotation:view.annotation animated:YES];
    }
}

- (void)handleGesture:(UIGestureRecognizer *)sender
{
    if(sender.state==UIGestureRecognizerStateEnded)
    {
        // Here we get the CGPoint for the touch and convert it to latitude and longitude coordinates to display on the map
        CGPoint point = [sender locationInView:selectMapView];
        if([SelectType isEqualToString:@"departure"])
        {
            locCoordDepa = [selectMapView convertPoint:point toCoordinateFromView:selectMapView];
        }
        else if([SelectType isEqualToString:@"destination"])
        {
            locCoordDest= [selectMapView convertPoint:point toCoordinateFromView:selectMapView];
        }
        float checkLat;
        float checkLong;
        
        for(int i=0;i<[[selectMapView annotations]count];i++)
        {
            CLLocationCoordinate2D tmpCoord=[[[selectMapView annotations]objectAtIndex:i]coordinate];
            checkLat=tmpCoord.latitude;
            checkLong=tmpCoord.longitude;
            
            if([SelectType isEqualToString:@"departure"]&&checkLat==locCoordDest.latitude&&checkLong==locCoordDest.longitude)
            {
                continue;
            }
            else if([SelectType isEqualToString:@"destination"]&&checkLat==locCoordDepa.latitude&&checkLong==locCoordDepa.longitude)
            {
                continue;
            }
            else
            {
                [selectMapView removeAnnotation:[[selectMapView annotations]objectAtIndex:i]];
            }
        }
        
        TogetherPlaceMapAnnotation* pointAnno=[[[TogetherPlaceMapAnnotation alloc]init]autorelease];
        if([SelectType isEqualToString:@"departure"])
        {
            pointAnno.coordinate=CLLocationCoordinate2DMake(locCoordDepa.latitude, locCoordDepa.longitude);
            pointAnno.title=@"출발지";
            [pointAnno updateSubtitleWithLatitude:locCoordDepa.latitude Longitude:locCoordDepa.longitude];
        }
        else if([SelectType isEqualToString:@"destination"])
        {
            pointAnno.coordinate=CLLocationCoordinate2DMake(locCoordDest.latitude, locCoordDest.longitude);
            pointAnno.title=@"도착지";
            [pointAnno updateSubtitleWithLatitude:locCoordDest.latitude Longitude:locCoordDest.longitude];
        }
        
        [selectMapView addAnnotation:pointAnno];
        //[selectMapView selectAnnotation:pointAnno animated:YES];
    } 
}

-(void) displayPinCallOutView:(id<MKAnnotation>)annotation 
{
    [selectMapView selectAnnotation:annotation animated:YES];
}


-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation 
{
    MKPinAnnotationView* pin=[[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"pin"]autorelease];
    if ( annotation.coordinate.latitude == locCoordDepa.latitude && annotation.coordinate.longitude == locCoordDepa.longitude){
        pin.pinColor=MKPinAnnotationColorGreen;
        
        if ( [SelectType isEqualToString:@"departure"] ){
            pin.draggable = YES;
            [self performSelector:@selector(displayPinCallOutView:) withObject:annotation afterDelay:0.3]; // IMPORTANT
        }
        else {
            pin.draggable = NO;
        }
        
    }
    else if (annotation.coordinate.latitude == locCoordDest.latitude && annotation.coordinate.longitude == locCoordDest.longitude){
        if ( [SelectType isEqualToString:@"departure"] ){
            pin.draggable = NO;
        }
        else {
            pin.draggable = YES;
            [self performSelector:@selector(displayPinCallOutView:) withObject:annotation afterDelay:0.3]; // IMPORTANT
        }
        pin.pinColor=MKPinAnnotationColorRed;
    }
    
    
    pin.animatesDrop=YES;
    pin.canShowCallout=YES;
    
    return pin;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        addressDict=[[NSDictionary alloc]init];
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
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *saveButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveMap)];
    navItem.rightBarButtonItem=saveButton;
    [saveButton release];
    // UIBarButtonItem *pinButton=[[UIBarButtonItem alloc]initWithTitle:@"핀놓기" style:UIBarButtonItemStyleBordered target:self action:@selector(onPin)];
    // navItem.leftBarButtonItem=pinButton;
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [selectMapView addGestureRecognizer:tapGesture];
    
    selectMapView.delegate=self;
    
    MKCoordinateRegion reg;
    reg.center.latitude = 36.372688189129185;
    reg.center.longitude = 127.35953450202942;
    reg.span.latitudeDelta=0.005f;
    reg.span.longitudeDelta=0.005f;
    
    if([SelectType isEqualToString:@"destination"])
    {
        navItem.title=@"도착지표시";
        if(([[DataDict objectForKey:@"dest_long"]floatValue]!=0||
            [[DataDict objectForKey:@"dest_lat"]floatValue]!=0)&&
           ([DataDict objectForKey:@"dest_long"]!=nil||
            [DataDict objectForKey:@"dest_lat"]!=nil)&&
           (![[DataDict objectForKey:@"dest_long"]isEqualToString:@""]||
            ![[DataDict objectForKey:@"dest_lat"]isEqualToString:@""]))
        {
            reg.center.longitude=[[DataDict objectForKey:@"dest_long"]floatValue];
            reg.center.latitude=[[DataDict objectForKey:@"dest_lat"]floatValue];
            
            locCoordDest= CLLocationCoordinate2DMake([[DataDict objectForKey:@"dest_lat"]floatValue], [[DataDict objectForKey:@"dest_long"]floatValue]);
            
            TogetherPlaceMapAnnotation *dropPin= [[[TogetherPlaceMapAnnotation alloc] init] autorelease];
            dropPin.coordinate = locCoordDest;
            dropPin.title=@"도착지";
            [selectMapView addAnnotation:dropPin];
            [dropPin updateSubtitleWithLatitude:locCoordDest.latitude Longitude:locCoordDest.longitude];
        }
        
        
        if(([[DataDict objectForKey:@"depa_long"]floatValue]!=0||
            [[DataDict objectForKey:@"depa_lat"]floatValue]!=0)&&
           ([DataDict objectForKey:@"depa_long"]!=nil||
            [DataDict objectForKey:@"depa_lat"]!=nil)&&
           (![[DataDict objectForKey:@"depa_long"]isEqualToString:@""]||
            ![[DataDict objectForKey:@"depa_lat"]isEqualToString:@""]))
        {
            locCoordDepa = CLLocationCoordinate2DMake([[DataDict objectForKey:@"depa_lat"]floatValue], [[DataDict objectForKey:@"depa_long"]floatValue]);
            TogetherPlaceMapAnnotation *dropPin= [[[TogetherPlaceMapAnnotation alloc] init] autorelease];
            dropPin.coordinate = locCoordDepa;
            dropPin.title=@"출발지";
            [selectMapView addAnnotation:dropPin];
            [dropPin updateSubtitleWithLatitude:locCoordDepa.latitude Longitude:locCoordDepa.longitude];
            if([[selectMapView annotations]count]==1)
            {
                [selectMapView selectAnnotation:dropPin animated:YES];
            }
            
        }
        
    }
    else if([SelectType isEqualToString:@"departure"])
    {
        navItem.title=@"출발지표시";
        if(([[DataDict objectForKey:@"depa_long"]floatValue]!=0||
            [[DataDict objectForKey:@"depa_lat"]floatValue]!=0)&&
           ([DataDict objectForKey:@"depa_long"]!=nil||
            [DataDict objectForKey:@"depa_lat"]!=nil)&&
           (![[DataDict objectForKey:@"depa_long"]isEqualToString:@""]||
            ![[DataDict objectForKey:@"depa_lat"]isEqualToString:@""]))
        {
            reg.center.longitude=[[DataDict objectForKey:@"depa_long"]floatValue];
            reg.center.latitude=[[DataDict objectForKey:@"depa_lat"]floatValue];
            locCoordDepa = CLLocationCoordinate2DMake([[DataDict objectForKey:@"depa_lat"]floatValue], [[DataDict objectForKey:@"depa_long"]floatValue]);
            TogetherPlaceMapAnnotation *dropPin= [[[TogetherPlaceMapAnnotation alloc] init] autorelease];
            dropPin.coordinate = locCoordDepa;
            dropPin.title=@"출발지";
            [selectMapView addAnnotation:dropPin];
            [dropPin updateSubtitleWithLatitude:locCoordDepa.latitude Longitude:locCoordDepa.longitude];
            
        }
        if(([[DataDict objectForKey:@"dest_long"]floatValue]!=0||
            [[DataDict objectForKey:@"dest_lat"]floatValue]!=0)&&
           ([DataDict objectForKey:@"dest_long"]!=nil||
            [DataDict objectForKey:@"dest_lat"]!=nil)&&
           (![[DataDict objectForKey:@"dest_long"]isEqualToString:@""]||
            ![[DataDict objectForKey:@"dest_lat"]isEqualToString:@""]))
        {
            locCoordDest= CLLocationCoordinate2DMake([[DataDict objectForKey:@"dest_lat"]floatValue], [[DataDict objectForKey:@"dest_long"]floatValue]);
            
            TogetherPlaceMapAnnotation *dropPin= [[[TogetherPlaceMapAnnotation alloc] init] autorelease];
            dropPin.coordinate = locCoordDest;
            dropPin.title=@"도착지";
            [selectMapView addAnnotation:dropPin];
            [dropPin updateSubtitleWithLatitude:locCoordDest.latitude Longitude:locCoordDest.longitude];
            if([[selectMapView annotations]count]==1)
            {
                [selectMapView selectAnnotation:dropPin animated:YES];
            }
        }
    }
    
    [selectMapView setRegion:reg animated:YES];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"MapSelectionViewDidDisappear" object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
