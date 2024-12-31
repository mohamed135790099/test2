class MessageModel {
  String? sId;
  String? sender;
  String? senderModel;
  String? receiver;
  String? receiverModel;
  String? message;
  bool? read;
  String? createdAt;
  String? updatedAt;
  int? iV;

  MessageModel(
      {this.sId,
      this.sender,
      this.senderModel,
      this.receiver,
      this.receiverModel,
      this.message,
      this.read,
      this.createdAt,
      this.updatedAt,
      this.iV});

  MessageModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sender = json['sender'];
    senderModel = json['senderModel'];
    receiver = json['receiver'];
    receiverModel = json['receiverModel'];
    message = json['message'];
    read = json['read'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['sender'] = sender;
    data['senderModel'] = senderModel;
    data['receiver'] = receiver;
    data['receiverModel'] = receiverModel;
    data['message'] = message;
    data['read'] = read;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
