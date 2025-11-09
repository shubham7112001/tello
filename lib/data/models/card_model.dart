import 'dart:convert';

class CardModel {
    String? id;
    String? title;
    String? description;
    int? pos;
    String? cardNumber;
    dynamic rework;
    String? totalWorkingTime;
    DateTime? startTime;
    DateTime? dueDate;
    CardBoard? board;
    CardList? list;
    List<CardLabel>? labels;
    List<CardMember>? users;
    List<CardFile>? files;
    List<CardChecklist>? checklist;

    CardModel({
        this.id,
        this.title,
        this.description,
        this.pos,
        this.cardNumber,
        this.rework,
        this.totalWorkingTime,
        this.startTime,
        this.dueDate,
        this.board,
        this.list,
        this.labels,
        this.users,
        this.files,
        this.checklist,
    });

    factory CardModel.fromRawJson(String str) => CardModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CardModel.fromJson(Map<String, dynamic> json) => CardModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        pos: json["pos"],
        cardNumber: json["card_number"],
        rework: json["rework"],
        totalWorkingTime: json["total_working_time"],
        startTime: json["start_time"] == null ? null : DateTime.parse(json["start_time"]),
        dueDate: json["due_date"] == null ? null : DateTime.parse(json["due_date"]),
        board: json["board"] == null ? null : CardBoard.fromJson(json["board"]),
        list: json["list"] == null ? null : CardList.fromJson(json["list"]),
        labels: json["labels"] == null ? [] : List<CardLabel>.from(json["labels"]!.map((x) => CardLabel.fromJson(x))),
        users: json["users"] == null ? [] : List<CardMember>.from(json["users"]!.map((x) => CardMember.fromJson(x))),
        files: json["files"] == null ? [] : List<CardFile>.from(json["files"]!.map((x) => CardFile.fromJson(x))),
        checklist: json["checklist"] == null ? [] : List<CardChecklist>.from(json["checklist"]!.map((x) => CardChecklist.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "pos": pos,
        "card_number": cardNumber,
        "rework": rework,
        "total_working_time": totalWorkingTime,
        "start_time": startTime?.toIso8601String(),
        "due_date": dueDate?.toIso8601String(),
        "board": board?.toJson(),
        "list": list?.toJson(),
        "labels": labels == null ? [] : List<dynamic>.from(labels!.map((x) => x.toJson())),
        "users": users == null ? [] : List<dynamic>.from(users!.map((x) => x.toJson())),
        "files": files == null ? [] : List<dynamic>.from(files!.map((x) => x.toJson())),
        "checklist": checklist == null ? [] : List<dynamic>.from(checklist!.map((x) => x.toJson())),
    };
}

class CardBoard {
    String? id;
    String? name;
    String? description;

    CardBoard({
        this.id,
        this.name,
        this.description
    });

    factory CardBoard.fromRawJson(String str) => CardBoard.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CardBoard.fromJson(Map<String, dynamic> json) => CardBoard(
        id: json["id"],
        name: json["name"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
    };
}

class CardChecklist {
    String? id;
    int? pos;
    String? title;
    List<CardCheckPoint>? checkpoints;

    CardChecklist({
        this.id,
        this.pos,
        this.checkpoints,
        this.title
    });

    factory CardChecklist.fromRawJson(String str) => CardChecklist.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CardChecklist.fromJson(Map<String, dynamic> json) => CardChecklist(
        id: json["id"],
        pos: json["pos"],
        title: json["title"],
        checkpoints: json["checkpoints"] == null ? [] : List<CardCheckPoint>.from(json["checkpoints"]!.map((x) => CardCheckPoint.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "pos": pos,
        "title": title,
        "checkpoints": checkpoints == null ? [] : List<dynamic>.from(checkpoints!.map((x) => x.toJson())),
    };
}

class CardCheckPoint {
    String? id;
    String? title;
    bool? status;
    int? pos;

    CardCheckPoint({
        this.id,
        this.title,
        this.status,
        this.pos,
    });

    factory CardCheckPoint.fromRawJson(String str) => CardCheckPoint.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CardCheckPoint.fromJson(Map<String, dynamic> json) => CardCheckPoint(
        id: json["id"],
        title: json["title"],
        status: json["status"],
        pos: json["pos"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "status": status,
        "pos": pos,
    };
}

class CardLabel {
    String? id;
    String? name;
    String? color;

    CardLabel({
        this.id,
        this.name,
        this.color,
    });

    factory CardLabel.fromRawJson(String str) => CardLabel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CardLabel.fromJson(Map<String, dynamic> json) => CardLabel(
        id: json["id"],
        name: json["name"],
        color: json["color"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "color": color,
    };
}

class CardMember {
    String? id;
    String? name;
    String? email;
    String? username;

    CardMember({
        this.id,
        this.name,
        this.email,
        this.username
    });

    factory CardMember.fromRawJson(String str) => CardMember.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CardMember.fromJson(Map<String, dynamic> json) => CardMember(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        username: json["username"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "username": username,
    };
}

class CardList {
    String? id;
    String? name;

    CardList({
        this.id,
        this.name,
    });

    factory CardList.fromRawJson(String str) => CardList.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CardList.fromJson(Map<String, dynamic> json) => CardList(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}

class CardFile {
    String? id;
    String? name;

    CardFile({
        this.id,
        this.name,
    });

    factory CardFile.fromRawJson(String str) => CardFile.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CardFile.fromJson(Map<String, dynamic> json) => CardFile(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}