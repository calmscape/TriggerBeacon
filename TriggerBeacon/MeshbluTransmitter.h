//
//  MeshbluTransmitter.h
//  TriggerBeacon
//
//  Created by Masahiro Murase on 2015/12/11.
//  Copyright (c) 2015年 calmscape. All rights reserved.
//

#import <Foundation/Foundation.h>

// required: AFNetworking


@interface MeshbluTransmitter : NSObject

/// 接続するサーバー
@property (readonly, nonatomic, copy) NSString *host;

/**
 サーバー情報を指定して初期化する
 @param host 接続するサーバー
 */
- (instancetype)initWithHost:(NSString *)host;


/**
 HTTP POSTでMeshbluにデータを保存する
 @param parameters Meshbluがデータベースに保存するパラメータ。nilならダミーデータが格納される。
 @param triggerUUID 認証用のトリガーUUID。このUUIDはデータ格納先としても使われる。
 @param triggerToken 認証用のトリガーToken
 @param successBlock 送信が成功した場合に呼ばれるブロック
 @param failureBlock 送信が失敗した場合に呼ばれるブロック。エラー原因はerror引数に格納される。
 */
- (void)postStoreData:(NSDictionary *)parameters triggerUUID:(NSString *)triggerUUID triggerToken:(NSString *)triggerToken success:(void (^)(void))successBlock failure:(void (^)(NSError *error))failureBlock;

@end
