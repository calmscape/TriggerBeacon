//
//  ViewController.m
//  TriggerBeacon
//
//  Created by calmscape on 2015/12/11.
//  Copyright © 2015年 calmscape. All rights reserved.
//

@import CoreLocation;
#import "MeshbluTransmitter.h"
#import "ViewController.h"

/// 領域監視を行うビーコンのUUID文字列
#warning Change this constant according to your environment.
static NSString * const kBeaconUUID = @"33100867-20AE-4FC1-917C-7A5310DF81D8";

/// 領域の識別子(領域ごとにユニークな文字列ならなんでもよい)
#warning Change this constant according to your environment.
static NSString * const kBeaconRegionIdentifier = @"net.calmsacpe.33100867-20AE-4FC1-917C-7A5310DF81D8";

/// IDCFサーバーのIPアドレス
#warning Change this constant according to your environment.
static NSString * const kHost = @"xxx.xxx.xxx.xxx";

/// 使用するトリガーのUUID(myThingsでIDCFチャンネルのtrigger-1をトリガー条件に指定しているならtrigger-1のuuid)
#warning Change this constant according to your environment.
static NSString * const kTriggerUUID = @"353b5062-bce7-465a-822d-5f4df068edbe";

/// 使用するトリガーのトークン(myThingsでIDCFチャンネルのtrigger-1をトリガー条件に指定しているならtrigger-1のtoken)
#warning Change this constant according to your environment.
static NSString * const kTriggerToken = @"10f3d2b4";


@interface ViewController () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MeshbluTransmitter *transmitter;

// Outlets & Actions
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
- (IBAction)removeRegionButtonDidTap:(id)sender;
@end

@implementation ViewController

- (void)awakeFromNib
{
  [super awakeFromNib];

  if ([CLLocationManager locationServicesEnabled]) {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    [_locationManager requestAlwaysAuthorization];
  }

  _transmitter = [[MeshbluTransmitter alloc] initWithHost:kHost];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.

  [self p_configureViews];
  
  if ([CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
    [self p_stopMonitoringForAllRegion];

    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:kBeaconUUID];
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                identifier:kBeaconRegionIdentifier];
    [_locationManager startMonitoringForRegion:region];

    /*  startMonitoringForRegion:で指定した領域はシステムが記憶し、アプリが起動していなくても領域監視される。
     *  システムの領域監視対象から外したい場合は、アプリを削除するかstopMonitoringForRegion:で領域監視を止める必要がある。
     *  p_stopMonitoringForAllRegionを参照。
     */


    /*  locationManager:didDetermineState:forRegion:は領域を横断した時にしか呼ばれないので、
     *  領域内でアプリを起動すると呼ばれない。
     *  上記のような場合に領域に入った時の処理を行わせたい場合にはrequestStateForRegion:で
     *  状態の取得要求を行う。
     */
    [_locationManager requestStateForRegion:region];
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/// すべての領域監視を止める
- (void)p_stopMonitoringForAllRegion
{
  [_locationManager.monitoredRegions enumerateObjectsUsingBlock:^(CLRegion *region, BOOL *stop) {
    [_locationManager stopMonitoringForRegion:region];
  }];
}

- (void)p_configureViews
{
  self.regionLabel.text = kBeaconUUID;
  self.stateLabel.text = [self p_stateStringWithState:CLRegionStateUnknown];
}

- (NSString *)p_stateStringWithState:(CLRegionState)state
{
  NSArray *stateString = @[@"Unknown", @"Inside", @"Outside"];
  return [NSString stringWithFormat:@"State: %@", stateString[state]];
}

#pragma mark - Actions

- (IBAction)removeRegionButtonDidTap:(id)sender
{
  [self p_stopMonitoringForAllRegion];
}


#pragma mark - <CLLocationManagerDelegate>

/*  locationManager:didEnterRegion:と、locationManager:didExitRegion:で領域に入った/出たの判定を行っても構わないが、
 *  領域内でアプリを起動した場合は(requestStateForRegion:を呼んだとしても)これらのデリゲートが呼ばれないため、
 *  locationManager:didDetermineState:forRegion:で出入りの判定を行っている。
 */

/// 領域の状態取得要求や状態が変化した場合に呼ばれる
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
  NSLog(@"%s, %@", __PRETTY_FUNCTION__, [self p_stateStringWithState:state]);

  self.stateLabel.text = [self p_stateStringWithState:state];
  
  if (state == CLRegionStateInside) {
    // 領域に入った

    // ビーコン領域によってトリガーを変えるような場合はidentifierで領域を判別する
    if ([region.identifier isEqualToString:kBeaconRegionIdentifier]) {
      [_transmitter postStoreData:nil
                      triggerUUID:kTriggerUUID
                     triggerToken:kTriggerToken
                          success:nil
                          failure:nil
       ];
    }
  }
  else if (state == CLRegionStateOutside) {
    // 領域から出た
  }
  else {
    // 不明
  }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
  NSLog(@"%s, error=%@", __PRETTY_FUNCTION__, error.localizedDescription);
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
  NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
  NSLog(@"%s, status=%zd", __PRETTY_FUNCTION__, status);
}

@end
