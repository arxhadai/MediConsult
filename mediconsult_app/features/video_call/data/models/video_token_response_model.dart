import 'package:equatable/equatable.dart';

class VideoTokenResponseModel extends Equatable {
  final String token;
  final String channelName;
  final int uid;
  final int expireAt;

  const VideoTokenResponseModel({
    required this.token,
    required this.channelName,
    required this.uid,
    required this.expireAt,
  });

  factory VideoTokenResponseModel.fromJson(Map<String, dynamic> json) {
    return VideoTokenResponseModel(
      token: json['token'] as String,
      channelName: json['channelName'] as String,
      uid: json['uid'] as int,
      expireAt: json['expire_at'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'channelName': channelName,
      'uid': uid,
      'expire_at': expireAt,
    };
  }

  @override
  List<Object?> get props => [token, channelName, uid, expireAt];
}