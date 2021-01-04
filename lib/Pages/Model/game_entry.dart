class GameEntryForm {
  String name;
  String platform;
  String rating;
  String review;

  GameEntryForm(this.name, this.platform, this.rating, this.review);

  factory GameEntryForm.fromJson(dynamic json) {
    return GameEntryForm(
        "${json['name']}",
        "${json['platform']}",
        "${json['rating']}",
        "${json['review']}"

    );
  }

  // Method to make GET parameters.
  Map toJson() => {
    'name': name,
    'platform': platform,
    'rating': rating,
    'review': review,
  };
}