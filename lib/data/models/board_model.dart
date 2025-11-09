
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:otper_mobile/data/models/card_model.dart';

class BoardModel {
    String name;
    String id;
    List<BoardViewListModel> lists;

    BoardModel({
        required this.name,
        required this.id,
        required this.lists,
    });

    factory BoardModel.fromRawJson(String str) => BoardModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory BoardModel.fromJson(Map<String, dynamic> json) {
      List<BoardViewListModel> parsedLists = List<BoardViewListModel>.from(
        json["lists"].map((x) => BoardViewListModel.fromJson(x)),
      );

      parsedLists.sort((a, b) => a.pos.compareTo(b.pos));

      return BoardModel(
        name: json["name"],
        id: json["id"],
        lists: parsedLists,
      );
    }

    Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "lists": List<dynamic>.from(lists.map((x) => x.toJson())),
    };
}

class BoardViewListModel {
    String id;
    String color;
    String name;
    String pos;
    List<BoardViewCardModel> cards;

    BoardViewListModel({
        required this.id,
        required this.color,
        required this.name,
        required this.pos,
        required this.cards,
    });

    factory BoardViewListModel.fromRawJson(String str) => BoardViewListModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory BoardViewListModel.fromJson(Map<String, dynamic> json){
      List<BoardViewCardModel> parsedCards = List<BoardViewCardModel>.from(
        json["cards"].map((x) => BoardViewCardModel.fromJson(x)),
      );

      debugPrint("Total card count before filtering: ${parsedCards.length}");
      parsedCards = parsedCards.where((card) => card.archivedAt == null).toList();
      debugPrint("Total card count after filtering: ${parsedCards.length}");
      parsedCards.sort((a, b) => a.pos.compareTo(b.pos));

      return BoardViewListModel(
        id: json["id"],
        color: json["color"],
        name: json["name"],
        pos: json["pos"].toString(), // safe parsing
        cards: parsedCards,
      );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "color": color,
        "name": name,
        "pos": pos,
        "cards": List<dynamic>.from(cards.map((x) => x.toJson())),
    };
}

class BoardViewCardModel {
    String id;
    String slug;
    String title;
    int pos;
    String cardNumber;
    DateTime? dueDate;
    DateTime? archivedAt;
    List<BoardViewUserModel> users;
    List<CardLabel>? labels;

    BoardViewCardModel({
        required this.id,
        required this.slug,
        required this.title,
        required this.pos,
        required this.cardNumber,
        required this.dueDate,
        required this.users,
        required this.labels,
        required this.archivedAt
    });

    factory BoardViewCardModel.fromRawJson(String str) => BoardViewCardModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory BoardViewCardModel.fromJson(Map<String, dynamic> json){
      debugPrint("title: ${json["title"]} CardSlug: ${json["slug"]}");
      return BoardViewCardModel(
        id: json["id"],
        slug: json["slug"],
        title: json["title"],
        pos: json["pos"],
        cardNumber: json["card_number"],
        dueDate: json["due_date"] == null ? null : DateTime.parse(json["due_date"]),
        users: List<BoardViewUserModel>.from(json["users"].map((x) => BoardViewUserModel.fromJson(x))),
        labels: json["labels"] == null ? [] : List<CardLabel>.from(json["labels"]!.map((x) => CardLabel.fromJson(x))),
        archivedAt: json["archived_at"] == null ? null : DateTime.parse(json["archived_at"]),
    );}

    Map<String, dynamic> toJson() => {
        "id": id,
        "slug": slug,
        "title": title,
        "pos": pos,
        "card_number": cardNumber,
        "due_date": dueDate?.toIso8601String(),
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
        "labels": labels == null ? [] : List<dynamic>.from(labels!.map((x) => x.toJson())),
        "archived_at": archivedAt?.toIso8601String(),
    };
}

class BoardViewFileElement {
    String name;

    BoardViewFileElement({
        required this.name,
    });

    factory BoardViewFileElement.fromRawJson(String str) => BoardViewFileElement.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory BoardViewFileElement.fromJson(Map<String, dynamic> json) => BoardViewFileElement(
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
    };
}

class BoardViewUserModel {
    String id;
    String name;

    BoardViewUserModel({
        required this.id,
        required this.name,
    });

    factory BoardViewUserModel.fromRawJson(String str) => BoardViewUserModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory BoardViewUserModel.fromJson(Map<String, dynamic> json) => BoardViewUserModel(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
