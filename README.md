TriggerBeacon
===========

iBeaconをmyThingsのトリガーにするためのサンプル

### 要件
本サンプルコードを動かすには、iOS 8.0以降および Bluetooth 4.0に対応したiOSデバイスが必要になります。iOSシミュレータでは動作しません。

利用デバイスのBluetooth機能および、位置情報サービスをONにした状態で使用してください。

HTTP通信にAFNetworkingを使用しているため、プロジェクトフォルダで```pod install```してインストールしてください。

### 機能概要
* 指定したUUIDを持つビーコン領域に侵入するとIDCFチャンネルサーバー上のMeshbluにトリガーを通知する

### カスタマイズ
ViewController.m にある以下の文字列定数を環境に合わせて変更してください。

```objective-c
/// 領域監視を行うビーコンのUUID文字列
static NSString * const kBeaconUUID = @"33100867-20AE-4FC1-917C-7A5310DF81D8";

/// 領域の識別子(領域ごとにユニークな文字列ならなんでもよい)
static NSString * const kBeaconRegionIdentifier = @"net.calmsacpe.33100867-20AE-4FC1-917C-7A5310DF81D8";

/// IDCFサーバーのIPアドレス
static NSString * const kHost = @"xxx.xxx.xxx.xxx";

/// 使用するトリガーのUUID(myThingsでIDCFチャンネルのtrigger-1をトリガー条件に指定しているならtrigger-1のuuid)
static NSString * const kTriggerUUID = @"353b5062-bce7-465a-822d-5f4df068edbe";

/// 使用するトリガーのトークン(myThingsでIDCFチャンネルのtrigger-1をトリガー条件に指定しているならtrigger-1のtoken)
static NSString * const kTriggerToken = @"10f3d2b4";
```

### ソフトウェアライセンスについて
This software is released under the MIT License, see LICENSE.md.
