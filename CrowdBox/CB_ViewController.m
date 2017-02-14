//
//  CB_ViewController.m
//  CrowdBox
//
//  Created by Koby Hastings on 7/12/14.
//  Copyright (c) 2014 CrowdBox, Inc. All rights reserved.
//

#import "CB_ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>


@interface NSNull (JSON)
@end
@implementation NSNull (JSON)
- (NSUInteger)length { return 0; }
- (NSInteger)integerValue { return 0; };
- (float)floatValue { return 0; };
- (NSString *)description { return @"0(NSNull)"; }
- (NSArray *)componentsSeparatedByString:(NSString *)separator { return @[]; }
- (id)objectForKey:(id)key { return nil; }
- (BOOL)boolValue { return NO; }
@end


@interface CB_ViewController ()
@end

@implementation CB_ViewController

@synthesize activityIndicator, activityIndicatorText, mainView, venueView, venueList, headerView, venuesArray, white, grey, black, orange, voteIn, currentRound, nowPlayingKey,nowPlayingTitle,nowPlayingArtist,nowPlayingDuration,nowPlayingArtwork,songOneKey,songOneTitle,songOneArtist,songOneDuration,songOneArtwork,songOneVoteCount,songOneVotePercentage,songTwoKey,songTwoTitle,songTwoArtist,songTwoDuration,songTwoArtwork,songTwoVoteCount,songTwoVotePercentage,songThreeKey,songThreeTitle,songThreeArtist,songThreeDuration,songThreeArtwork,songThreeVoteCount,songThreeVotePercentage,songFourKey,songFourTitle,songFourArtist,songFourDuration,songFourArtwork,songFourVoteCount,songFourVotePercentage,nowPlayingLabel,nowPlayingContainer,nowPlayingArtworkContainer,nowPlayingArtistLabel,nowPlayingSongLabel,votingListContainer,votingListTitle,votingListInstruction,songOneContainer,songOneButton,songOneArtistLabel,songOneTitleLabel,songOnePercentageBar,songOnePercentage,songTwoContainer,songTwoButton,songTwoArtistLabel,songTwoTitleLabel,songTwoPercentageBar,songTwoPercentage,songThreeContainer,songThreeButton,songThreeArtistLabel,songThreeTitleLabel,songThreePercentageBar,songThreePercentage,songFourContainer,songFourButton,songFourArtistLabel,songFourTitleLabel,songFourPercentageBar,songFourPercentage,songOneVoteIn,songTwoVoteIn,songThreeVoteIn,songFourVoteIn,voteInCover,votePlaced,customAlert,logoMain,liveVenuesTagsDictionary,currentRoundId,getVenuesButton,backButton,selectedVenue;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.voteIn = NULL;
    self.votePlaced = false;
    
    [self showLoader];
    
}

- (void)viewDidAppear:(BOOL)animated {
    self.getVenuesButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 30)];
    [self checkInternet];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkInternet {
    if(![self makeTestURLCall]) {
        [self hideLoader];
        self.customAlert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                      message:@"You must be connected to the internet to use this app."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
        [customAlert show];
        UIButton *tryAgainButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 60, self.view.frame.size.height/2 - 20, 120, 40)];
        [tryAgainButton setTitle:@"Try Again" forState:UIControlStateNormal];
        tryAgainButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [tryAgainButton setTitleColor:[UIColor colorWithRed:(245.0 / 255.0) green:(157.0 / 255.0) blue:(32.0 / 255.0) alpha: 1.0] forState:UIControlStateNormal];
        [tryAgainButton.titleLabel setTextAlignment: NSTextAlignmentCenter];
        [tryAgainButton setAlpha:1.0];
        [tryAgainButton setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7]];
        tryAgainButton.layer.cornerRadius = 8; // this value vary as per your desire
        tryAgainButton.clipsToBounds = YES;
        [tryAgainButton addTarget:self action:@selector(checkInternet) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:tryAgainButton];
        [mainView bringSubviewToFront:tryAgainButton];
    } else {
        [self getNearbyVenues];
    }
    
}

- (Boolean)makeTestURLCall {
    NSURL *scriptUrl = [NSURL URLWithString:@"http://107.170.143.74"];
    NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
    if (data)
        return true;
    else
        return false;
}

- (void)getNearbyVenues
{
    PFQuery *query = [PFQuery queryWithClassName:@"Round"];
    [query whereKey:@"live" equalTo:[NSNumber numberWithBool:YES]];
    NSDate *then = [NSDate dateWithTimeIntervalSinceNow:-9];
    [query whereKey:@"updatedAt" greaterThanOrEqualTo:then];
    [query findObjectsInBackgroundWithBlock:^(NSArray *liveRounds, NSError *error) {
        if (!error) {
            [self displayVenues:liveRounds];
        } else {
            // Log details of the failure
            [self hideLoader];
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    [self.getVenuesButton setTitle:@"Refresh venue list" forState:UIControlStateNormal];
    [self.getVenuesButton setTitleColor:white forState:UIControlStateNormal];
    self.getVenuesButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.getVenuesButton addTarget: self
                             action: @selector(getNearbyVenues)
                   forControlEvents: UIControlEventTouchUpInside];
    [self.mainView addSubview:self.getVenuesButton];
}

- (void)showLoader
{
    [self.activityIndicator startAnimating];
    [activityIndicator setAlpha:1.0];
    [activityIndicatorText setAlpha:1.0];
}

- (void)hideLoader
{
    [self.activityIndicator stopAnimating];
    [activityIndicator setAlpha:0.0];
    [activityIndicatorText setAlpha:0.0];
}

- (void)backToVenues {
    [venueView removeFromSuperview];
    [self.backButton removeFromSuperview];
    [self getNearbyVenues];
    self.venueView = nil;
    self.backButton = nil;
    self.liveVenuesTagsDictionary = nil;
}

- (void)displayVenues:(NSArray*)liveRounds
{
    [self.venueView removeFromSuperview];
    self.venueView = nil;
    self.venueView = [[UIView alloc] initWithFrame:CGRectMake(20, 110, self.view.frame.size.width-40, self.view.frame.size.height-140)];

    self.white = [UIColor colorWithWhite:1 alpha:1.0];
    self.grey = [UIColor colorWithRed:(200.0 / 255.0) green:(200.0 / 255.0) blue:(200.0 / 255.0) alpha:1.0];
    self.black = [UIColor colorWithRed:(0.0 / 255.0) green:(0.0 / 255.0) blue:(0.0 / 255.0) alpha: 0.5];
    self.orange = [UIColor colorWithRed:(245.0 / 255.0) green:(157.0 / 255.0) blue:(32.0 / 255.0) alpha: 1.0];
    self.headerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, venueView.frame.size.width, 30)];
    headerView.textColor = white;
    headerView.text = @"Select a venue:";
    headerView.textAlignment = NSTextAlignmentCenter;
    [venueView addSubview:headerView];
    
    self.venueList = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, venueView.frame.size.width, venueView.frame.size.height - 60)];
    venueList.backgroundColor = black;
    [venueView addSubview:venueList];


    if(liveRounds.count > 0) {
        // for each venue returned, put it in the scroll view
        self.liveVenuesTagsDictionary = [[NSMutableArray alloc] init];
        int i = 0;
//        for(id venue in self.venuesArray) {
        for(PFObject *round in liveRounds) {
            PFObject *venue = round[@"venue"];
            [venue fetchIfNeededInBackgroundWithBlock:^(PFObject *venue, NSError *error) {
                NSString *name = venue[@"name"];
                NSString *venueid = venue.objectId;
                UIView *venueEntry = [[UIView alloc] initWithFrame:CGRectMake(14, 6+(i*34), venueList.frame.size.width, 36)];
                
                UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(venueSelected:)];
                [venueEntry addGestureRecognizer:singleFingerTap];
                UILabel *venueName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, venueEntry.frame.size.width, venueEntry.frame.size.height)];
                venueName.text = name;
                venueName.font = [UIFont systemFontOfSize:18];
                venueName.textColor = orange;
                venueEntry.tag = i;
                [self.liveVenuesTagsDictionary addObject:venueid];
                
                [venueEntry addSubview:venueName];
                [venueList addSubview:venueEntry];
            }];
            i++;
        }
        [mainView addSubview:venueView];
    } else {
        self.customAlert = [[UIAlertView alloc]
                            initWithTitle:@"No Live Venues"
                                  message:@"There are currently no live venues near you. Please try again later."
                                 delegate:self
                        cancelButtonTitle:@"OK"
                        otherButtonTitles:nil];
        [self.customAlert setTag:1];
        [self.customAlert show];
    }
    
    [self hideLoader];
    
    
}

-(void)venueSelected:(UITapGestureRecognizer*)venueSelectedGesture {
    [self.headerView removeFromSuperview];
    [self.venueList removeFromSuperview];
    [self.getVenuesButton removeFromSuperview];
    
    NSLog(@"%@", self.liveVenuesTagsDictionary);
    NSLog(@"Selected Tag = %d", [venueSelectedGesture.view tag]);
    self.selectedVenueID = [self.liveVenuesTagsDictionary objectAtIndex:[venueSelectedGesture.view tag]];
    NSLog(@"Selected Venue ID = %@", self.liveVenuesTagsDictionary);
    
    // get the venue object
    [self setSelectedVenueObject:self.selectedVenueID];
        
    PFQuery *query = [PFQuery queryWithClassName:@"Round"];
    [query whereKey:@"live" equalTo:[NSNumber numberWithBool:YES]];
    [query whereKey:@"venue"
            equalTo:[PFObject objectWithoutDataWithClassName:@"Venue" objectId:self.selectedVenueID]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *round, NSError *error) {
        if (!round) {
            NSLog(@"The getFirstObject request failed.");
        } else {
            self.currentRound = round;
            
            NSData *jsonData = [self.currentRound[@"nowPlaying"] dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *nowPlaying = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            
            jsonData = [self.currentRound[@"votingList"] dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *votingList = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            
            self.currentRoundId = self.currentRound.objectId;
            
            self.nowPlayingKey = [nowPlaying valueForKey:@"key"];
            self.nowPlayingTitle = [nowPlaying valueForKey:@"name"];
            self.nowPlayingArtist = [nowPlaying valueForKey:@"artist"];
            self.nowPlayingDuration = [nowPlaying valueForKey:@"duration"];
            self.nowPlayingArtwork = [nowPlaying valueForKey:@"icon400"];
            
            self.songOneKey = [[votingList valueForKey:@"songone"] valueForKey:@"key"];
            self.songOneTitle = [[votingList valueForKey:@"songone"] valueForKey:@"name"];
            self.songOneArtist = [[votingList valueForKey:@"songone"] valueForKey:@"artist"];
            self.songOneDuration = [[votingList valueForKey:@"songone"] valueForKey:@"duration"];
            self.songOneArtwork = [[votingList valueForKey:@"songone"] valueForKey:@"icon400"];
            self.songOneVoteCount = [[votingList valueForKey:@"songone"] valueForKey:@"vote_count"];
            self.songOneVotePercentage = [[votingList valueForKey:@"songone"] valueForKey:@"vote_percentage"];
            
            self.songTwoKey = [[votingList valueForKey:@"songtwo"] valueForKey:@"key"];
            self.songTwoTitle = [[votingList valueForKey:@"songtwo"] valueForKey:@"name"];
            self.songTwoArtist = [[votingList valueForKey:@"songtwo"] valueForKey:@"artist"];
            self.songTwoDuration = [[votingList valueForKey:@"songtwo"] valueForKey:@"duration"];
            self.songTwoArtwork = [[votingList valueForKey:@"songtwo"] valueForKey:@"icon400"];
            self.songTwoVoteCount = [[votingList valueForKey:@"songtwo"] valueForKey:@"vote_count"];
            self.songTwoVotePercentage = [[votingList valueForKey:@"songtwo"] valueForKey:@"vote_percentage"];
            
            self.songThreeKey = [[votingList valueForKey:@"songthree"] valueForKey:@"key"];
            self.songThreeTitle = [[votingList valueForKey:@"songthree"] valueForKey:@"name"];
            self.songThreeArtist = [[votingList valueForKey:@"songthree"] valueForKey:@"artist"];
            self.songThreeDuration = [[votingList valueForKey:@"songthree"] valueForKey:@"duration"];
            self.songThreeArtwork = [[votingList valueForKey:@"songthree"] valueForKey:@"icon400"];
            self.songThreeVoteCount = [[votingList valueForKey:@"songthree"] valueForKey:@"vote_count"];
            self.songThreeVotePercentage = [[votingList valueForKey:@"songthree"] valueForKey:@"vote_percentage"];
            
            self.songFourKey = [[votingList valueForKey:@"songfour"] valueForKey:@"key"];
            self.songFourTitle = [[votingList valueForKey:@"songfour"] valueForKey:@"name"];
            self.songFourArtist = [[votingList valueForKey:@"songfour"] valueForKey:@"artist"];
            self.songFourDuration = [[votingList valueForKey:@"songfour"] valueForKey:@"duration"];
            self.songFourArtwork = [[votingList valueForKey:@"songfour"] valueForKey:@"icon400"];
            self.songFourVoteCount = [[votingList valueForKey:@"songfour"] valueForKey:@"vote_count"];
            self.songFourVotePercentage = [[votingList valueForKey:@"songfour"] valueForKey:@"vote_percentage"];
            
            self.nowPlayingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, venueView.frame.size.width, 30)];
            self.nowPlayingLabel.text = @"Now Playing...";
            [self.nowPlayingLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
            [self.nowPlayingLabel setTextColor:white];
            [self.venueView addSubview:self.nowPlayingLabel];
            
            self.nowPlayingContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 34, venueView.frame.size.width, 130)];
            self.nowPlayingContainer.backgroundColor = black;
            
            self.nowPlayingArtworkContainer = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 110, 110)];
            NSURL *url = [NSURL URLWithString:self.nowPlayingArtwork];
            NSData *imagedata = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:imagedata];
            [self.nowPlayingArtworkContainer setImage:image];
            
            self.nowPlayingArtistLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nowPlayingArtworkContainer.frame.size.width+9, 26, self.venueView.frame.size.width - self.nowPlayingArtworkContainer.frame.size.width - 15, 20)];
            self.nowPlayingArtistLabel.text = self.nowPlayingArtist;
            [self.nowPlayingArtistLabel setTextColor:orange];
            [self.nowPlayingArtistLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
            self.nowPlayingArtistLabel.numberOfLines = 0;
            [self.nowPlayingArtworkContainer addSubview:self.nowPlayingArtistLabel];
            
            self.nowPlayingSongLabel = [[UILabel alloc] initWithFrame:CGRectMake(nowPlayingArtworkContainer.frame.size.width+10, 46, self.venueView.frame.size.width - self.nowPlayingArtworkContainer.frame.size.width - 15, 20)];
            self.nowPlayingSongLabel.text = self.nowPlayingTitle;
            [self.nowPlayingSongLabel setTextColor:white];
            [self.nowPlayingSongLabel setFont:[UIFont fontWithName:@"Helvetica" size:13]];
            self.nowPlayingSongLabel.numberOfLines = 0;
            [self.nowPlayingArtworkContainer addSubview:self.nowPlayingSongLabel];
            
            [self.nowPlayingContainer addSubview:self.nowPlayingArtworkContainer];
            
            [self.venueView addSubview:self.nowPlayingContainer];
            
            self.votingListContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 178, self.venueView.frame.size.width, 260)];
            self.votingListContainer.backgroundColor = black;
            
            self.votingListTitle = [[UILabel alloc] initWithFrame:CGRectMake(8, 4, self.votingListContainer.frame.size.width, 30)];
            votingListTitle.text = [NSString stringWithFormat:@"Up next at %@...", self.selectedVenue[@"name"]];
            [self.votingListTitle setFont:[UIFont fontWithName:@"Helvetica" size:12]];
            [self.votingListTitle setTextColor:grey];
            [self.votingListContainer addSubview:self.votingListTitle];
            
            // ************************ //
            // ******* SONG ONE ******* //
            // ************************ //
            self.songOneContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.votingListContainer.frame.size.width, 45)];
            
            self.songOneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.songOneContainer.frame.size.width, self.songOneContainer.frame.size.height)];
            self.songOneButton.titleLabel.text = [NSString stringWithFormat:@"%@", self.songOneKey];
            self.songOneButton.titleLabel.hidden = YES;
            [self.songOneButton addTarget:self action:@selector(placeVote:) forControlEvents:UIControlEventTouchUpInside];
            [self.songOneContainer addSubview:self.songOneButton];
            
            self.songOneArtistLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 1, self.songOneContainer.frame.size.width, 12)];
            self.songOneArtistLabel.text = self.songOneArtist;
            [self.songOneArtistLabel setTextColor:white];
            [self.songOneArtistLabel setFont:[UIFont fontWithName:@"Helvetica" size:11]];

            self.songOneTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 9, self.songOneContainer.frame.size.width, 30)];
            self.songOneTitleLabel.text = self.songOneTitle;
            [self.songOneTitleLabel setTextColor:orange];
            [self.songOneTitleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
            
            [songOneContainer addSubview:songOneArtistLabel];
            [songOneContainer addSubview:songOneTitleLabel];
            
            self.songOnePercentageBar = [[UIView alloc] initWithFrame:CGRectMake(0, 36, self.songOneContainer.frame.size.width * ([self.songOneVotePercentage floatValue]), 1)];
            self.songOnePercentageBar.backgroundColor = orange;
            [self.songOneContainer addSubview:self.songOnePercentageBar];
            
            self.songOnePercentage = [[UILabel alloc] initWithFrame:CGRectMake(songOneContainer.frame.size.width - 48, 9, 43, 30)];
            [songOnePercentage setTextAlignment:NSTextAlignmentRight];
            songOnePercentage.text = [NSString stringWithFormat:@"%i%@", (int)([songOneVotePercentage floatValue] * 100), @"%"];
            [songOnePercentage setTextColor:orange];
            [songOnePercentage setFont:[UIFont fontWithName:@"Helvetica" size:16]];
            [songOneContainer addSubview:songOnePercentage];
            
            [songOneContainer bringSubviewToFront:songOneButton];
            [votingListContainer addSubview:songOneContainer];
            

            // ************************ //
            // ******* SONG TWO ******* //
            // ************************ //
            self.songTwoContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 90, votingListContainer.frame.size.width, 45)];
            
            self.songTwoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, songTwoContainer.frame.size.width, songTwoContainer.frame.size.height)];
            songTwoButton.titleLabel.text = [NSString stringWithFormat:@"%@", songTwoKey];
            songTwoButton.titleLabel.hidden = YES;
            [songTwoButton addTarget:self action:@selector(placeVote:) forControlEvents:UIControlEventTouchUpInside];
            [songTwoContainer addSubview:songTwoButton];
            
            self.songTwoArtistLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 1, songTwoContainer.frame.size.width, 12)];
            songTwoArtistLabel.text = songTwoArtist;
            [songTwoArtistLabel setTextColor:white];
            [songTwoArtistLabel setFont:[UIFont fontWithName:@"Helvetica" size:11]];
            
            self.songTwoTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 9, songTwoContainer.frame.size.width, 30)];
            songTwoTitleLabel.text = songTwoTitle;
            [songTwoTitleLabel setTextColor:orange];
            [songTwoTitleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
            
            [songTwoContainer addSubview:songTwoArtistLabel];
            [songTwoContainer addSubview:songTwoTitleLabel];
            
            self.songTwoPercentageBar = [[UIView alloc] initWithFrame:CGRectMake(0, 36, songTwoContainer.frame.size.width * ([songTwoVotePercentage floatValue]), 1)];
            songTwoPercentageBar.backgroundColor = orange;
            [songTwoContainer addSubview:songTwoPercentageBar];
            
            self.songTwoPercentage = [[UILabel alloc] initWithFrame:CGRectMake(songTwoContainer.frame.size.width - 48, 9, 43, 30)];
            [songTwoPercentage setTextAlignment:NSTextAlignmentRight];
            songTwoPercentage.text = [NSString stringWithFormat:@"%i%@", (int)([songTwoVotePercentage floatValue] * 100), @"%"];
            [songTwoPercentage setTextColor:orange];
            [songTwoPercentage setFont:[UIFont fontWithName:@"Helvetica" size:16]];
            [songTwoContainer addSubview:songTwoPercentage];
            
            [songTwoContainer bringSubviewToFront:songTwoButton];
            [votingListContainer addSubview:songTwoContainer];
            
            // ************************ //
            // ******* SONG THREE ******* //
            // ************************ //
            self.songThreeContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 140, votingListContainer.frame.size.width, 45)];
            
            self.songThreeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, songThreeContainer.frame.size.width, songThreeContainer.frame.size.height)];
            songThreeButton.titleLabel.text = [NSString stringWithFormat:@"%@", songThreeKey];
            songThreeButton.titleLabel.hidden = YES;
            [songThreeButton addTarget:self action:@selector(placeVote:) forControlEvents:UIControlEventTouchUpInside];
            [songThreeContainer addSubview:songThreeButton];
            
            self.songThreeArtistLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 1, songThreeContainer.frame.size.width, 12)];
            songThreeArtistLabel.text = songThreeArtist;
            [songThreeArtistLabel setTextColor:white];
            [songThreeArtistLabel setFont:[UIFont fontWithName:@"Helvetica" size:11]];
            
            self.songThreeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 9, songThreeContainer.frame.size.width, 30)];
            songThreeTitleLabel.text = songThreeTitle;
            [songThreeTitleLabel setTextColor:orange];
            [songThreeTitleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
            
            [songThreeContainer addSubview:songThreeArtistLabel];
            [songThreeContainer addSubview:songThreeTitleLabel];
            
            self.songThreePercentageBar = [[UIView alloc] initWithFrame:CGRectMake(0, 36, songThreeContainer.frame.size.width * ([songThreeVotePercentage floatValue]), 1)];
            songThreePercentageBar.backgroundColor = orange;
            [songThreeContainer addSubview:songThreePercentageBar];
            
            self.songThreePercentage = [[UILabel alloc] initWithFrame:CGRectMake(songThreeContainer.frame.size.width - 48, 9, 43, 30)];
            [songThreePercentage setTextAlignment:NSTextAlignmentRight];
            songThreePercentage.text = [NSString stringWithFormat:@"%i%@", (int)([songThreeVotePercentage floatValue] * 100), @"%"];
            [songThreePercentage setTextColor:orange];
            [songThreePercentage setFont:[UIFont fontWithName:@"Helvetica" size:16]];
            [songThreeContainer addSubview:songThreePercentage];
            
            [songThreeContainer bringSubviewToFront:songThreeButton];
            [votingListContainer addSubview:songThreeContainer];
            
            // ************************ //
            // ******* SONG FOUR ****** //
            // ************************ //
            self.songFourContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 190, votingListContainer.frame.size.width, 45)];
            
            self.songFourButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, songFourContainer.frame.size.width, songFourContainer.frame.size.height)];
            songFourButton.titleLabel.text = [NSString stringWithFormat:@"%@", songFourKey];
            songFourButton.titleLabel.hidden = YES;
            [songFourButton addTarget:self action:@selector(placeVote:) forControlEvents:UIControlEventTouchUpInside];
            [songFourContainer addSubview:songFourButton];
            
            self.songFourArtistLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 1, songFourContainer.frame.size.width, 12)];
            songFourArtistLabel.text = songOneArtist;
            [songFourArtistLabel setTextColor:white];
            [songFourArtistLabel setFont:[UIFont fontWithName:@"Helvetica" size:11]];
            
            self.songFourTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 9, songFourContainer.frame.size.width - 55, 30)];
            songFourTitleLabel.text = songFourTitle;
            [songFourTitleLabel setTextColor:orange];
            [songFourTitleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
            
            [songFourContainer addSubview:songFourArtistLabel];
            [songFourContainer addSubview:songFourTitleLabel];
            
            self.songFourPercentageBar = [[UIView alloc] initWithFrame:CGRectMake(0, 36, songFourContainer.frame.size.width * ([songFourVotePercentage floatValue]), 1)];
            songFourPercentageBar.backgroundColor = orange;
            [songFourContainer addSubview:songFourPercentageBar];
            
            self.songFourPercentage = [[UILabel alloc] initWithFrame:CGRectMake(songFourContainer.frame.size.width - 48, 9, 43, 30)];
            [songFourPercentage setTextAlignment:NSTextAlignmentRight];
            songFourPercentage.text = [NSString stringWithFormat:@"%i%@", (int)([songFourVotePercentage floatValue] * 100), @"%"];
            [songFourPercentage setTextColor:orange];
            [songFourPercentage setFont:[UIFont fontWithName:@"Helvetica" size:16]];
            [songFourContainer addSubview:songFourPercentage];
            [songFourContainer bringSubviewToFront:songFourButton];
            [votingListContainer addSubview:songFourContainer];
            
            self.songOneVoteIn = [[UIImageView alloc] initWithFrame:CGRectMake(self.songOneContainer.frame.size.width*.71, 0, 44, 44)];
            image = [UIImage imageNamed:@"vote-check-mark.png"];
            [self.songOneVoteIn setImage:image];
            [self.songOneContainer addSubview:self.songOneVoteIn];
            [self.votingListContainer bringSubviewToFront:self.songOneContainer];
            [self.songOneVoteIn setAlpha:0.0];
            
            self.songTwoVoteIn = [[UIImageView alloc] initWithFrame:CGRectMake(self.songTwoContainer.frame.size.width*.71, 0, 44, 44)];
            image = [UIImage imageNamed:@"vote-check-mark.png"];
            [self.songTwoVoteIn setImage:image];
            [self.songTwoContainer addSubview:self.songTwoVoteIn];
            [self.votingListContainer bringSubviewToFront:self.songTwoContainer];
            [self.songTwoVoteIn setAlpha:0.0];
            
            self.songThreeVoteIn = [[UIImageView alloc] initWithFrame:CGRectMake(self.songThreeContainer.frame.size.width*.71, 0, 44, 44)];
            image = [UIImage imageNamed:@"vote-check-mark.png"];
            [self.songThreeVoteIn setImage:image];
            [self.songThreeContainer addSubview:self.songThreeVoteIn];
            [self.votingListContainer bringSubviewToFront:self.songThreeContainer];
            [self.songThreeVoteIn setAlpha:0.0];
            
            self.songFourVoteIn = [[UIImageView alloc] initWithFrame:CGRectMake(self.songFourContainer.frame.size.width*.71, 0, 44, 44)];
            image = [UIImage imageNamed:@"vote-check-mark.png"];
            [self.songFourVoteIn setImage:image];
            [self.songFourContainer addSubview:self.songFourVoteIn];
            [self.votingListContainer bringSubviewToFront:self.songFourContainer];
            [self.songFourVoteIn setAlpha:0.0];
            
            self.voteInCover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.votingListContainer.frame.size.width, votingListContainer.frame.size.height)];
            self.voteInCover.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
            [self.votingListContainer addSubview:self.voteInCover];
            [self.voteInCover setAlpha:0.0];
            
            [venueView addSubview:votingListContainer];
            
            [NSTimer scheduledTimerWithTimeInterval:1.2f target:self selector:@selector(updateLiveData:) userInfo:nil repeats:YES];
        }
    }];
}

// get live round by currentVenue
//

- (void)updateLiveData:(NSTimer*)timer {
    [self setSelectedVenueObject:self.selectedVenueID];
    PFObject *venue = self.currentRound[@"venue"];
    [venue fetchIfNeededInBackgroundWithBlock:^(PFObject *venue, NSError *error) {
        PFQuery *query = [PFQuery queryWithClassName:@"Round"];
        [query whereKey:@"live" equalTo:[NSNumber numberWithBool:YES]];
        [query whereKey:@"venue"
                equalTo:[PFObject objectWithoutDataWithClassName:@"Venue" objectId:venue.objectId]];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *round, NSError *error) {
            if (!round) {
                NSLog(@"Error: Failed to update round.");
            } else {
                [self updateLiveRound:round];
            }
        }];
    }];
}

- (void)placeVote:(id)sender
{
    UIButton *buttonClicked = (UIButton *)sender;
    NSString *song = buttonClicked.titleLabel.text;

    if ([self.voteIn isEqualToString:song]) {           // removing vote
        PFQuery *query = [PFQuery queryWithClassName:@"Vote"];
        [query whereKey:@"song_key" equalTo:song];
        [query whereKey:@"round" equalTo:self.currentRound];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *vote, NSError *error) {
            [vote deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [self clearVote];
            }];
        }];
    } else {
        PFObject *vote = [PFObject objectWithClassName:@"Vote"];
        vote[@"round"] = self.currentRound;
        vote[@"song_key"] = song;
        [vote saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            PFQuery *query = [PFQuery queryWithClassName:@"Round"];
            [query getObjectInBackgroundWithId:self.currentRound.objectId block:^(PFObject *updatedRound, NSError *error) {
                [self updateLiveRound:updatedRound];
            }];
            self.voteIn = song;
            self.votePlaced = true;
        }];
    }

}

- (void)updateLiveRound:(PFObject*)updatedRound {
    if(![updatedRound.objectId isEqual:self.currentRound.objectId]) {
        // We have a different round so cancel out the vote.
        [self clearVote];
    }
    self.currentRound = updatedRound;
    NSData *jsonData = [self.currentRound[@"nowPlaying"] dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *nowPlaying = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    
    jsonData = [self.currentRound[@"votingList"] dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *votingList = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    
    self.currentRoundId = self.currentRound.objectId;
    
    self.nowPlayingKey = [nowPlaying valueForKey:@"key"];
    self.nowPlayingTitle = [nowPlaying valueForKey:@"name"];
    self.nowPlayingArtist = [nowPlaying valueForKey:@"artist"];
    self.nowPlayingDuration = [nowPlaying valueForKey:@"duration"];
    self.nowPlayingArtwork = [nowPlaying valueForKey:@"icon400"];
    
    self.songOneKey = [[votingList valueForKey:@"songone"] valueForKey:@"key"];
    self.songOneTitle = [[votingList valueForKey:@"songone"] valueForKey:@"name"];
    self.songOneArtist = [[votingList valueForKey:@"songone"] valueForKey:@"artist"];
    self.songOneDuration = [[votingList valueForKey:@"songone"] valueForKey:@"duration"];
    self.songOneArtwork = [[votingList valueForKey:@"songone"] valueForKey:@"icon400"];
    self.songOneVoteCount = [[votingList valueForKey:@"songone"] valueForKey:@"vote_count"];
    self.songOneVotePercentage = [[votingList valueForKey:@"songone"] valueForKey:@"vote_percentage"];
    
    self.songTwoKey = [[votingList valueForKey:@"songtwo"] valueForKey:@"key"];
    self.songTwoTitle = [[votingList valueForKey:@"songtwo"] valueForKey:@"name"];
    self.songTwoArtist = [[votingList valueForKey:@"songtwo"] valueForKey:@"artist"];
    self.songTwoDuration = [[votingList valueForKey:@"songtwo"] valueForKey:@"duration"];
    self.songTwoArtwork = [[votingList valueForKey:@"songtwo"] valueForKey:@"icon400"];
    self.songTwoVoteCount = [[votingList valueForKey:@"songtwo"] valueForKey:@"vote_count"];
    self.songTwoVotePercentage = [[votingList valueForKey:@"songtwo"] valueForKey:@"vote_percentage"];
    
    self.songThreeKey = [[votingList valueForKey:@"songthree"] valueForKey:@"key"];
    self.songThreeTitle = [[votingList valueForKey:@"songthree"] valueForKey:@"name"];
    self.songThreeArtist = [[votingList valueForKey:@"songthree"] valueForKey:@"artist"];
    self.songThreeDuration = [[votingList valueForKey:@"songthree"] valueForKey:@"duration"];
    self.songThreeArtwork = [[votingList valueForKey:@"songthree"] valueForKey:@"icon400"];
    self.songThreeVoteCount = [[votingList valueForKey:@"songthree"] valueForKey:@"vote_count"];
    self.songThreeVotePercentage = [[votingList valueForKey:@"songthree"] valueForKey:@"vote_percentage"];
    
    self.songFourKey = [[votingList valueForKey:@"songfour"] valueForKey:@"key"];
    self.songFourTitle = [[votingList valueForKey:@"songfour"] valueForKey:@"name"];
    self.songFourArtist = [[votingList valueForKey:@"songfour"] valueForKey:@"artist"];
    self.songFourDuration = [[votingList valueForKey:@"songfour"] valueForKey:@"duration"];
    self.songFourArtwork = [[votingList valueForKey:@"songfour"] valueForKey:@"icon400"];
    self.songFourVoteCount = [[votingList valueForKey:@"songfour"] valueForKey:@"vote_count"];
    self.songFourVotePercentage = [[votingList valueForKey:@"songfour"] valueForKey:@"vote_percentage"];
    
    self.nowPlayingArtistLabel.text = self.nowPlayingArtist;
    self.nowPlayingSongLabel.text = self.nowPlayingTitle;
    NSURL *url = [NSURL URLWithString:self.nowPlayingArtwork];
    NSData *imagedata = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:imagedata];
    [self.nowPlayingArtworkContainer setImage:image];
    self.nowPlayingSongLabel.text = self.nowPlayingTitle;
    
    
    self.songOneTitleLabel.text = self.songOneTitle;
    self.songOneArtistLabel.text = self.songOneArtist;
    self.songOnePercentageBar.frame = CGRectMake(0, 36, self.songOneContainer.frame.size.width * ((double)([self.songOneVotePercentage floatValue] / 100)), 1 );
    self.songOnePercentage.text = [NSString stringWithFormat:@"%i%@", (int)([self.songOneVotePercentage floatValue]), @"%"];
    self.songOneButton.titleLabel.text = [NSString stringWithFormat:@"%@", self.songOneKey];
    
    self.songTwoTitleLabel.text = self.songTwoTitle;
    self.songTwoArtistLabel.text = self.songTwoArtist;
    self.songTwoPercentageBar.frame = CGRectMake(0, 36, self.songTwoContainer.frame.size.width * ((double)([self.songTwoVotePercentage floatValue] / 100)), 1 );
    self.songTwoPercentage.text = [NSString stringWithFormat:@"%i%@", (int)([self.songTwoVotePercentage floatValue]), @"%"];
    self.songTwoButton.titleLabel.text = [NSString stringWithFormat:@"%@", self.songTwoKey];
    
    self.songThreeTitleLabel.text = self.songThreeTitle;
    self.songThreeArtistLabel.text = self.songThreeArtist;
    self.songThreePercentageBar.frame = CGRectMake(0, 36, self.songThreeContainer.frame.size.width * ((double)([self.songThreeVotePercentage floatValue] / 100)), 1 );
    self.songThreePercentage.text = [NSString stringWithFormat:@"%i%@", (int)([self.songThreeVotePercentage floatValue]), @"%"];
    self.songThreeButton.titleLabel.text = [NSString stringWithFormat:@"%@", self.songThreeKey];
    
    self.songFourTitleLabel.text = self.songFourTitle;
    self.songFourArtistLabel.text = self.songFourArtist;
    self.songFourPercentageBar.frame = CGRectMake(0, 36, self.songFourContainer.frame.size.width * ((double)([self.songFourVotePercentage floatValue] / 100)), 1 );
    self.songFourPercentage.text = [NSString stringWithFormat:@"%i%@", (int)([self.songFourVotePercentage floatValue]), @"%"];
    self.songFourButton.titleLabel.text = [NSString stringWithFormat:@"%@", self.songFourKey];
    
    if([self.voteIn isEqualToString:self.songOneKey]) {
        [self.voteInCover setAlpha:1.0];
        [self.songOneVoteIn setAlpha:1.0];
        [self.votingListContainer bringSubviewToFront:voteInCover];
        [self.votingListContainer bringSubviewToFront:songOneContainer];
    } else if ([self.voteIn isEqualToString:self.songTwoKey]) {
        [self.voteInCover setAlpha:1.0];
        [self.songTwoVoteIn setAlpha:1.0];
        [self.votingListContainer bringSubviewToFront:voteInCover];
        [self.votingListContainer bringSubviewToFront:songTwoContainer];
    } else if ([self.voteIn isEqualToString:self.songThreeKey]) {
        [self.voteInCover setAlpha:1.0];
        [self.songThreeVoteIn setAlpha:1.0];
        [self.votingListContainer bringSubviewToFront:voteInCover];
        [self.votingListContainer bringSubviewToFront:songThreeContainer];
    } else if ([self.voteIn isEqualToString:self.songFourKey]) {
        [self.voteInCover setAlpha:1.0];
        [self.songFourVoteIn setAlpha:1.0];
        [self.votingListContainer bringSubviewToFront:voteInCover];
        [self.votingListContainer bringSubviewToFront:songFourContainer];
    }
}

-(void)clearVote {
    self.voteIn = NULL;
    [self.voteInCover setAlpha:0.0];
    [self.songOneVoteIn setAlpha:0.0];
    [self.songTwoVoteIn setAlpha:0.0];
    [self.songThreeVoteIn setAlpha:0.0];
    [self.songFourVoteIn setAlpha:0.0];
    self.votePlaced = false;
}

-(void)setSelectedVenueObject:(NSString *)selectedVenueID {
    PFQuery *query = [PFQuery queryWithClassName:@"Venue"];
    [query getObjectInBackgroundWithId:selectedVenueID block:^(PFObject *venue, NSError *error) {
        self.selectedVenue = venue;
    }];
}

@end
