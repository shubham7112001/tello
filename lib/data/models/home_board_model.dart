
class HomeBoardModel {
  final String? id;
  final String? name;
  final String? slug;
  final String? key;
  final String? description;

  HomeBoardModel({
    this.id,
    this.name,
    this.slug,
    this.key,
    this.description,
  });

  factory HomeBoardModel.fromJson(Map<String, dynamic> json) {
    return HomeBoardModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      key: json['key'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'key': key,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'HomeBoardModel{id: $id, name: $name, slug: $slug, key: $key}';
  }
}