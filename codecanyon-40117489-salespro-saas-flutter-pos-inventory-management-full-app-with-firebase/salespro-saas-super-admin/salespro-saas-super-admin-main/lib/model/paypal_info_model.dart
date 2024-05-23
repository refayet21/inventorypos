class PaypalInfoModel {
  PaypalInfoModel({
    required this.paypalClientId,
    required this.paypalClientSecret,
    required this.isLive,
  });

  String paypalClientId, paypalClientSecret;
  bool isLive;

  PaypalInfoModel.fromJson(Map<dynamic, dynamic> json)
      : paypalClientId = json['paypalClientId'],
        paypalClientSecret = json['paypalClientSecret'],
        isLive = json['isLive'];

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'paypalClientId': paypalClientId,
        'paypalClientSecret': paypalClientSecret,
        'isLive': isLive,
      };
}
