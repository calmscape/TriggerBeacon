//
//  MeshbluTransmitter.m
//  TriggerBeacon
//
//  Created by Masahiro Murase on 2015/12/11.
//  Copyright (c) 2015年 calmscape. All rights reserved.
//

#import "AFNetworking.h"
#import "MeshbluTransmitter.h"

@interface MeshbluTransmitter ()
@property (readwrite, nonatomic, copy) NSString *host;
@end

@implementation MeshbluTransmitter

- (instancetype)initWithHost:(NSString *)host
{
  self = [super init];
  if (self) {
    _host = host;
  }
  return self;
}

/// HTTP POSTでMeshbluにデータを保存する
- (void)postStoreData:(NSDictionary *)parameters triggerUUID:(NSString *)triggerUUID triggerToken:(NSString *)triggerToken success:(void (^)(void))successBlock failure:(void (^)(NSError *error))failureBlock
{
  NSDictionary *postParameters = parameters ? parameters : @{@"foo": @"bar"};

  NSString *httpURLString = [NSString stringWithFormat:@"http://%@", _host];
  NSURL *hostURL = [NSURL URLWithString:httpURLString];
  AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:hostURL];
  
  manager.requestSerializer = [AFJSONRequestSerializer serializer];
  [manager.requestSerializer setValue:triggerUUID forHTTPHeaderField:@"meshblu_auth_uuid"];
  [manager.requestSerializer setValue:triggerToken forHTTPHeaderField:@"meshblu_auth_token"];

  [manager POST:[@"/data" stringByAppendingPathComponent:triggerUUID]
     parameters:postParameters
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"success: %@", responseObject);
          if (successBlock) {
            successBlock();
          }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
          NSLog(@"error: %@", error.localizedDescription);
          if (failureBlock) {
            failureBlock(error);
          }
        }];

}

@end
