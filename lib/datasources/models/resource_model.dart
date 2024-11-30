class ResourceModel {
  String id;
  String type;
  String url;

  ResourceModel({required this.id, required this.type, required this.url});

  factory ResourceModel.fromJson(Map<String, dynamic> json) {
    return ResourceModel(
        id: json['id'] as String,
        type: json['type'] as String,
        url: json['url'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'type': type, 'url': url};
  }
}
