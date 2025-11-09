class Checklist {
  final String name;
  final bool isExpanded;
  final List<String> items;

  Checklist({
    required this.name,
    this.isExpanded = false,
    this.items = const [],
  });

  Checklist copyWith({
    String? name,
    bool? isExpanded,
    List<String>? items,
  }) {
    return Checklist(
      name: name ?? this.name,
      isExpanded: isExpanded ?? this.isExpanded,
      items: items ?? this.items,
    );
  }
}
