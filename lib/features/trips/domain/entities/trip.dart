class Trip {
  const Trip({
    required this.id,
    required this.image,
    required this.title,
    required this.location,
    required this.duration,
    this.price = '',
    this.rating = '4.9',
  });

  final String id;
  final String image;
  final String title;
  final String location;
  final String duration;
  final String price;
  final String rating;
}
