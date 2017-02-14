//
//  CB_ViewController.h
//  CrowdBox
//
//  Created by Koby Hastings on 7/12/14.
//  Copyright (c) 2014 CrowdBox, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CB_ViewController : UIViewController

- (void)getNearbyVenues;
- (void)showLoader;
- (void)hideLoader;
- (void)displayVenues: (NSArray *)venues;
- (void)venueSelected:(UITapGestureRecognizer *)venueSelectedGesture;
- (void)placeVote:(id)sender;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *activityIndicatorText;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet NSArray *venuesArray;
@property (weak, nonatomic) IBOutlet UIImageView *logoMain;

@property UIColor *white;
@property UIColor *grey;
@property UIColor *black;
@property UIColor *orange;
@property UIView *venueView;
@property UILabel *headerView;
@property UIScrollView *venueList;
@property NSString *voteIn;
@property PFObject *currentRound;
@property NSString *currentRoundId;
@property NSString *nowPlayingKey;
@property NSString *nowPlayingTitle;
@property NSString *nowPlayingArtist;
@property NSString *nowPlayingDuration;
@property NSString *nowPlayingArtwork;
@property NSString *songOneKey;
@property NSString *songOneTitle;
@property NSString *songOneArtist;
@property NSString *songOneDuration;
@property NSString *songOneArtwork;
@property NSString *songOneVoteCount;
@property NSString *songOneVotePercentage;
@property NSString *songTwoKey;
@property NSString *songTwoTitle;
@property NSString *songTwoArtist;
@property NSString *songTwoDuration;
@property NSString *songTwoArtwork;
@property NSString *songTwoVoteCount;
@property NSString *songTwoVotePercentage;
@property NSString *songThreeKey;
@property NSString *songThreeTitle;
@property NSString *songThreeArtist;
@property NSString *songThreeDuration;
@property NSString *songThreeArtwork;
@property NSString *songThreeVoteCount;
@property NSString *songThreeVotePercentage;
@property NSString *songFourKey;
@property NSString *songFourTitle;
@property NSString *songFourArtist;
@property NSString *songFourDuration;
@property NSString *songFourArtwork;
@property NSString *songFourVoteCount;
@property NSString *songFourVotePercentage;
@property NSString *selectedVenueID;
@property UILabel *nowPlayingLabel;
@property UIView *nowPlayingContainer;
@property UIImageView *nowPlayingArtworkContainer;
@property UILabel *nowPlayingArtistLabel;
@property UILabel *nowPlayingSongLabel;
@property UIView *votingListContainer;
@property UILabel *votingListTitle;
@property UILabel *votingListInstruction;
@property UIView *songOneContainer;
@property UIButton *songOneButton;
@property UILabel *songOneArtistLabel;
@property UILabel *songOneTitleLabel;
@property UIView *songOnePercentageBar;
@property UILabel *songOnePercentage;
@property UIView *songTwoContainer;
@property UIButton *songTwoButton;
@property UILabel *songTwoArtistLabel;
@property UILabel *songTwoTitleLabel;
@property UIView *songTwoPercentageBar;
@property UILabel *songTwoPercentage;
@property UIView *songThreeContainer;
@property UIButton *songThreeButton;
@property UILabel *songThreeArtistLabel;
@property UILabel *songThreeTitleLabel;
@property UIView *songThreePercentageBar;
@property UILabel *songThreePercentage;
@property UIView *songFourContainer;
@property UIButton *songFourButton;
@property UILabel *songFourArtistLabel;
@property UILabel *songFourTitleLabel;
@property UIView *songFourPercentageBar;
@property UILabel *songFourPercentage;
@property UIImageView *songOneVoteIn;
@property UIImageView *songTwoVoteIn;
@property UIImageView *songThreeVoteIn;
@property UIImageView *songFourVoteIn;
@property UIView *voteInCover;
@property Boolean votePlaced;
@property UIAlertView *customAlert;
@property NSMutableArray *liveVenuesTagsDictionary;
@property UIButton *getVenuesButton;
@property UIButton *backButton;
@property PFObject *selectedVenue;



@end
