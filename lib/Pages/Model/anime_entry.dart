class AnimeEntryForm {
  String name;
  String genre;
  String rating;
  String review;

  AnimeEntryForm(this.name, this.genre, this.rating, this.review);

  factory AnimeEntryForm.fromJson(dynamic json) {
    return AnimeEntryForm(
        "${json['name']}",
        "${json['genre']}",
        "${json['rating']}",
        "${json['review']}"

    );
  }

  // Method to make GET parameters.
  Map toJson() => {
    'name': name,
    'genre': genre,
    'rating': rating,
    'review': review,
  };
}