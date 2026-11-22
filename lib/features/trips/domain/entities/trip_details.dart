class TripDetails {
  const TripDetails({
    required this.images,
    required this.title,
    required this.rating,
    required this.reviews,
    required this.duration,
    required this.from,
    required this.maxPeople,
    required this.description,
    required this.highlights,
    required this.price,
    this.hotelName,
    this.hotelDetails,
  });

  final List<String> images;
  final String title;
  final String rating;
  final int reviews;
  final String duration;
  final String from;
  final int maxPeople;
  final String description;
  final List<String> highlights;
  final String price;
  final String? hotelName;
  final String? hotelDetails;
}
