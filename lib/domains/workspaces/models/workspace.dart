class Workspace {
  String name;
  String description;
  String id;
  String creatorId;
  String createdAt;
  String updatedAt;

  Workspace({
    this.name,
    this.description,
    this.id,
    this.creatorId,
    this.createdAt,
    this.updatedAt,
  });

  factory Workspace.fromJson(Map<String, dynamic> parsedJson) {
    if (parsedJson != null) {
      return Workspace(
        id: parsedJson['id'],
        creatorId: parsedJson['createdId'],
        createdAt: parsedJson['createdAt'],
        updatedAt: parsedJson['updatedAt'],
        name: parsedJson['name'],
        description: parsedJson['description']
      );
    } else {
      return null;
    }
  }

  toJson() => {
    'name': name,
    'description': description,
    'id': id,
    'creatorId': creatorId,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}