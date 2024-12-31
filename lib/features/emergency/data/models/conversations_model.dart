class ConversationsModel {
  String? sId;
  List<Participants>? participants;
  List<String>? participantModel;
  String? createdAt;
  String? updatedAt;
  int? iV;
  LastMessage? lastMessage; // Changed to LastMessage object

  ConversationsModel({
    this.sId,
    this.participants,
    this.participantModel,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.lastMessage, // Initialize lastMessage as LastMessage object
  });

  ConversationsModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['participants'] != null) {
      participants = <Participants>[];
      json['participants'].forEach((v) {
        participants!.add(Participants.fromJson(v));
      });
    }
    participantModel = json['participantModel']?.cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];

    // Check if lastMessage is a map or string
    if (json['lastMessage'] is Map) {
      lastMessage = LastMessage.fromJson(json['lastMessage']);
    } else {
      lastMessage = null; // or handle it as needed
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (participants != null) {
      data['participants'] = participants!.map((v) => v.toJson()).toList();
    }
    data['participantModel'] = participantModel;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['lastMessage'] = lastMessage != null
        ? lastMessage!.toJson()
        : null; // Handle lastMessage as an object
    return data;
  }
}

class Participants {
  String? sId;
  String? fullName;

  Participants({
    this.sId,
    this.fullName,
  });

  Participants.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['fullName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['fullName'] = fullName;
    return data;
  }
}

class LastMessage {
  String? sId;
  String? conversation;
  String? sender;
  String? senderModel;
  String? receiver;
  String? receiverModel;
  String? message;
  bool? isRead;
  String? readAt;
  String? createdAt;
  String? updatedAt;
  int? iV;

  LastMessage({
    this.sId,
    this.conversation,
    this.sender,
    this.senderModel,
    this.receiver,
    this.receiverModel,
    this.message,
    this.isRead,
    this.readAt,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  LastMessage.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    conversation = json['conversation'];
    sender = json['sender'];
    senderModel = json['senderModel'];
    receiver = json['receiver'];
    receiverModel = json['receiverModel'];
    message = json['message'];
    isRead = json['isRead'];
    readAt = json['readAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['conversation'] = conversation;
    data['sender'] = sender;
    data['senderModel'] = senderModel;
    data['receiver'] = receiver;
    data['receiverModel'] = receiverModel;
    data['message'] = message;
    data['isRead'] = isRead;
    data['readAt'] = readAt;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
