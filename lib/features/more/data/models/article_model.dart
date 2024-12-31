class ArticleModel {
  String? sId;
  String? title;
  String? content;
  Author? author;
  String? link;
  String? image;
  String? createdAt;
  String? updatedAt;
  int? iV;

  ArticleModel(
      {this.sId,
      this.title,
      this.content,
      this.author,
      this.link,
      this.image,
      this.createdAt,
      this.updatedAt,
      this.iV});

  ArticleModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    content = json['content'];
    author = json['author'] != null ? Author.fromJson(json['author']) : null;
    link = json['link'];
    image = json['image'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['content'] = content;
    if (author != null) {
      data['author'] = author!.toJson();
    }
    data['link'] = link;
    data['image'] = image;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Author {
  String? sId;
  String? userName;
  String? password;
  String? role;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Author(
      {this.sId,
      this.userName,
      this.password,
      this.role,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Author.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userName = json['userName'];
    password = json['password'];
    role = json['role'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['userName'] = userName;
    data['password'] = password;
    data['role'] = role;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
