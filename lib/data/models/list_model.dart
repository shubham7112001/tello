// import 'package:otper_mobile/data/models/card_model.dart';

// class ListModel {
//   String? id;
//   String? name;
//   int? pos;
//   List<CardModel>? cards;

//   ListModel({this.id, this.name, this.cards, this.pos});

//   factory ListModel.fromJson(Map<String, dynamic> json) {
//     return ListModel(
//       id: json['id'],
//       name: json['name'],
//       pos: json['pos'],
//       cards: (json['cards'] as List<dynamic>?)
//           ?.map((e) => CardModel.fromJson(e))
//           .toList(),
//     );
//   }
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'name': name,
//     'pos' : pos,
//     'cards': cards?.map((e) => e.toJson()).toList(),
//   };
// }
