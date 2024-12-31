class MessageHistoryModel {
  String? sId;
  dynamic sender;
  String? senderModel;
  dynamic receiver;
  String? receiverModel;
  String? message;
  String? conversation;
  bool? read;
  String? createdAt;
  String? updatedAt;
  int? iV;

  MessageHistoryModel({
    this.sId,
    this.sender,
    this.senderModel,
    this.receiver,
    this.receiverModel,
    this.message,
    this.conversation,
    this.read,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  MessageHistoryModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['sender'] != null) {
      if (json['sender'] is String) {
        sender = json['sender']; // Store as String if it's a String
      } else {
        sender = Sender.fromJson(json['sender']); // Parse as Sender object
      }
    }
    senderModel = json['senderModel'];
    if (json['receiver'] != null) {
      if (json['receiver'] is String) {
        receiver = json['receiver']; // Store as String if it's a String
      } else {
        receiver =
            Receiver.fromJson(json['receiver']); // Parse as Receiver object
      }
    }
    receiverModel = json['receiverModel'];
    message = json['message'];
    conversation = json['conversation'];
    read = json['read'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (sender is Sender) {
      data['sender'] = (sender as Sender).toJson();
    } else {
      data['sender'] = sender; // If sender is a String, store it directly
    }
    data['senderModel'] = senderModel;
    if (receiver is Receiver) {
      data['receiver'] = (receiver as Receiver).toJson();
    } else {
      data['receiver'] = receiver; // If receiver is a String, store it directly
    }
    data['receiverModel'] = receiverModel;
    data['message'] = message;
    data['conversation'] = conversation;
    data['read'] = read;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Sender {
  String? sId;
  String? fullName;

  Sender({this.sId, this.fullName});

  Sender.fromJson(dynamic json) {
    if (json is String) {
      sId = json; // If input is a String, store it directly
    } else {
      sId = json['_id'];
      fullName = json['fullName'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['fullName'] = fullName;
    return data;
  }
}

class Receiver {
  String? sId;
  String? fullName;

  Receiver({this.sId, this.fullName});

  Receiver.fromJson(dynamic json) {
    if (json is String) {
      sId = json; // If input is a String, store it directly
    } else {
      sId = json['_id'];
      fullName = json['fullName'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['fullName'] = fullName;
    return data;
  }
}
