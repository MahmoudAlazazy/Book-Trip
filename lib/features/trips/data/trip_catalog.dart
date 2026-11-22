import '../domain/entities/trip.dart';
import '../domain/entities/trip_details.dart';

class TripCatalog {
  const TripCatalog._();

  static const all = <Trip>[
    Trip(
      id: 'giza-pyramids',
      image: 'assets/images/pyramids.jpg',
      title: 'Giza Pyramids Tour',
      location: 'Giza',
      duration: '1 Day',
      price: 'EGP 750',
      rating: '4.8',
    ),
    Trip(
      id: 'dahab-adventure',
      image: 'assets/images/dahab.jpg',
      title: 'Dahab Adventure',
      location: 'Dahab',
      duration: '3 Days',
      price: 'EGP 2,500',
      rating: '4.8',
    ),
    Trip(
      id: 'siwa-oasis',
      image: 'assets/images/siwa.jpg',
      title: 'Siwa Oasis Escape',
      location: 'Siwa',
      duration: '2 Days',
      price: 'EGP 1,850',
      rating: '4.9',
    ),
    Trip(
      id: 'luxor-history',
      image: 'assets/images/luxor.jpg',
      title: 'Luxor History Tour',
      location: 'Luxor',
      duration: '2 Days',
      price: 'EGP 2,100',
      rating: '4.7',
    ),
    Trip(
      id: 'red-sea-getaway',
      image: 'assets/images/red_sea.jpg',
      title: 'Red Sea Getaway',
      location: 'Hurghada',
      duration: '4 Days',
      price: 'EGP 3,200',
      rating: '4.8',
    ),
  ];

  // This lookup is used by routing/SEO generation; keep it stable so every
  // rebuild does not allocate and populate a new map.
  static final byId = {for (final trip in all) trip.id: trip};

  static final detailsById = <String, TripDetails>{
    'giza-pyramids': const TripDetails(
      images: [
        'assets/images/pyramids.jpg',
        'assets/images/pyramids_2.jpg',
        'assets/images/pyramids_3.jpg',
      ],
      title: 'Giza Pyramids Tour',
      rating: '4.8',
      reviews: 128,
      duration: '1 Day',
      from: 'Cairo',
      maxPeople: 30,
      description: 'Explore the Great Pyramids of Giza and experience the history of Egypt.',
      highlights: ['Pyramids of Giza', 'Sphinx', 'Panoramic Views'],
      price: 'EGP 750',
      hotelName: 'Pyramids View Inn',
      hotelDetails: 'Comfortable stay with a panoramic view of the pyramids.',
    ),
    'dahab-adventure': const TripDetails(
      images: [
        'assets/images/dahab.jpg',
        'assets/images/red_sea.jpg',
        'assets/images/hurghada_2.jpg',
      ],
      title: 'Dahab Adventure',
      rating: '4.8',
      reviews: 96,
      duration: '3 Days',
      from: 'Cairo',
      maxPeople: 20,
      description: 'Enjoy the Red Sea, desert adventures, and the relaxed spirit of Dahab.',
      highlights: ['Blue Hole', 'Desert Safari', 'Laguna Beach'],
      price: 'EGP 2,500',
      hotelName: 'Dahab Lagoon Hotel',
      hotelDetails: 'Comfortable rooms near the beach with easy access to Dahab attractions.',
    ),
    'siwa-oasis': const TripDetails(
      images: [
        'assets/images/siwa.jpg',
        'assets/images/siwa_2.jpg',
        'assets/images/siwa.jpg',
      ],
      title: 'Siwa Oasis Escape',
      rating: '4.9',
      reviews: 84,
      duration: '2 Days',
      from: 'Cairo',
      maxPeople: 18,
      description: 'Discover Siwa\'s salt lakes, palm groves, and peaceful desert landscapes.',
      highlights: ['Salt Lakes', 'Shali Fortress', 'Desert Sunset'],
      price: 'EGP 1,850',
      hotelName: 'Siwa Eco Lodge',
      hotelDetails: 'A peaceful eco-friendly stay surrounded by palms.',
    ),
    'luxor-history': const TripDetails(
      images: [
        'assets/images/luxor.jpg',
        'assets/images/karnak_2.jpg',
        'assets/images/karnak_3.jpg',
      ],
      title: 'Luxor History Tour',
      rating: '4.7',
      reviews: 72,
      duration: '2 Days',
      from: 'Luxor',
      maxPeople: 24,
      description: 'Walk through ancient temples and discover the stories of the pharaohs in Luxor.',
      highlights: ['Karnak Temple', 'Valley of the Kings', 'Nile Cruise'],
      price: 'EGP 2,100',
      hotelName: 'Nile View Hotel',
      hotelDetails: 'Comfortable accommodation beside the Nile.',
    ),
    'red-sea-getaway': const TripDetails(
      images: [
        'assets/images/red_sea.jpg',
        'assets/images/hurghada_2.jpg',
        'assets/images/dahab.jpg',
      ],
      title: 'Red Sea Getaway',
      rating: '4.8',
      reviews: 91,
      duration: '4 Days',
      from: 'Hurghada',
      maxPeople: 20,
      description:
          'Relax on clear Red Sea beaches and explore colorful coral reefs.',
      highlights: ['Snorkeling', 'Beach Day', 'Boat Trip'],
      price: 'EGP 3,200',
      hotelName: 'Hurghada Beach Resort',
      hotelDetails: 'A beachfront resort with direct sea access.',
    ),
  };
}
