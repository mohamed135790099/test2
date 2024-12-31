class ArticleDetailsModel {
  String? sId;
  String? title;
  String? content;
  Author? author;
  String? link;
  String? image;
  String? createdAt;
  String? updatedAt;
  int? iV;

  ArticleDetailsModel({
    this.sId,
    this.title,
    this.content,
    this.author,
    this.link,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  factory ArticleDetailsModel.fromJson(Map<String, dynamic> json) {
    return ArticleDetailsModel(
      sId: json['_id'],
      title: json['title'],
      content: json['content'],
      author: json['author'] != null ? Author.fromJson(json['author']) : null,
      link: json['link'],
      image: json['image'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      iV: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'title': title,
      'content': content,
      'author': author?.toJson(),
      'link': link,
      'image': image,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': iV,
    };
  }

  @override
  String toString() {
    return 'ArticleDetailsModel(id: $sId, title: $title, content: $content)';
  }
}

class Author {
  String? sId;
  String? userName;
  String? password;
  String? role;
  List<String>? messages;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? image;

  Author({
    this.sId,
    this.userName,
    this.password,
    this.role,
    this.messages,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.image,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      sId: json['_id'],
      userName: json['userName'],
      password: json['password'],
      role: json['role'],
      messages: List<String>.from(json['messages'] ?? []),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      iV: json['__v'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'userName': userName,
      'password': password,
      'role': role,
      'messages': messages,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': iV,
      'image': image,
    };
  }
}
