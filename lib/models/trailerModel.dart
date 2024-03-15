class TrailerModel {
  String key; // Key of the trailer (e.g., YouTube video ID)
  String name; // Name or title of the trailer

  TrailerModel({
    required this.key,
    required this.name,
  });

  factory TrailerModel.fromJson(Map<String, dynamic> json) {
    // Factory method to create TrailerModel object from JSON data
    return TrailerModel(
      key: json["key"], // Trailer key (e.g., YouTube video ID)
      name: json["name"], // Trailer name or title
    );
  }
}
