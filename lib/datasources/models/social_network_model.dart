class SocialNetworkModel {
  final String id;
  final String name;
  final String code;
  final String url;
  final String? username;
  final String? fullUrl;

  SocialNetworkModel({
    required this.id,
    required this.name,
    required this.code,
    required this.url,
    this.username,
    this.fullUrl,
  });

  factory SocialNetworkModel.fromJson(Map<String, dynamic> json) {
    return SocialNetworkModel(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      url: json['url'] as String,
      username: json['username'] as String?,
      fullUrl: json['fullUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'url': url,
      'username': username,
      'fullUrl': fullUrl,
    };
  }
}

