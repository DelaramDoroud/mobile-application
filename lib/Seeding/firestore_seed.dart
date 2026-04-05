import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreSeeder {
  static Future<void> run() async {
    final db = FirebaseFirestore.instance;
    final batch = db.batch();

    // ---------------------- 1) destinations (6x) ----------------------
    final destinations = [
      {
        "id": "dest_bali",
        "name": "Bali",
        "country": "Indonesia",
        "city": "Denpasar",
        "geo": {"lat": -8.4095, "lng": 115.1889},
        "tags": ["beach", "culture", "nature"],
        "bestSeasons": ["Apr", "May", "Jun", "Sep", "Oct"],
        "descriptionShort": "Island of Gods with beaches & rice terraces.",
        "descriptionLong":
            "Bali offers beaches, temples, and nature experiences...",
        "heroImage": "images/destinations/dest_bali/hero.jpg",
        "gallery": [
          "images/destinations/dest_bali/gallery/1.jpg",
          "images/destinations/dest_bali/gallery/2.jpg",
        ],
        "ratingAvg": 4.7,
        "ratingCount": 1284,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "dest_yogyakarta",
        "name": "Yogyakarta",
        "country": "Indonesia",
        "city": "Yogyakarta",
        "geo": {"lat": -7.7956, "lng": 110.3695},
        "tags": ["culture", "history", "temples"],
        "bestSeasons": ["May", "Jun", "Jul", "Aug", "Sep"],
        "descriptionShort": "Cultural heart of Java.",
        "descriptionLong":
            "Home to Borobudur and Prambanan, rich in Javanese culture...",
        "heroImage": "images/destinations/dest_yogyakarta/hero.jpg",
        "gallery": ["images/destinations/dest_yogyakarta/gallery/1.jpg"],
        "ratingAvg": 4.6,
        "ratingCount": 732,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "dest_jakarta",
        "name": "Jakarta",
        "country": "Indonesia",
        "city": "Jakarta",
        "geo": {"lat": -6.2088, "lng": 106.8456},
        "tags": ["city", "food", "shopping"],
        "bestSeasons": ["Jun", "Jul", "Aug"],
        "descriptionShort": "Vibrant capital of Indonesia.",
        "descriptionLong": "Skyscrapers, street food, museums and urban vibes.",
        "heroImage": "images/destinations/dest_jakarta/hero.jpg",
        "gallery": ["images/destinations/dest_jakarta/gallery/1.jpg"],
        "ratingAvg": 4.2,
        "ratingCount": 510,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "dest_lombok",
        "name": "Lombok",
        "country": "Indonesia",
        "city": "Mataram",
        "geo": {"lat": -8.5833, "lng": 116.1167},
        "tags": ["beach", "surf", "nature"],
        "bestSeasons": ["May", "Jun", "Jul", "Aug", "Sep"],
        "descriptionShort": "Pristine beaches and Mount Rinjani.",
        "descriptionLong": "Quieter than Bali with great surf and trekking.",
        "heroImage": "images/destinations/dest_lombok/hero.jpg",
        "gallery": ["images/destinations/dest_lombok/gallery/1.jpg"],
        "ratingAvg": 4.5,
        "ratingCount": 420,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "dest_komodo",
        "name": "Komodo",
        "country": "Indonesia",
        "city": "Labuan Bajo",
        "geo": {"lat": -8.4964, "lng": 119.8877},
        "tags": ["nature", "wildlife", "diving"],
        "bestSeasons": ["Apr", "May", "Jun", "Sep"],
        "descriptionShort": "Home of Komodo dragons.",
        "descriptionLong": "Islands, pink beaches and world-class diving.",
        "heroImage": "images/destinations/dest_komodo/hero.jpg",
        "gallery": ["images/destinations/dest_komodo/gallery/1.jpg"],
        "ratingAvg": 4.8,
        "ratingCount": 380,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "dest_bandung",
        "name": "Bandung",
        "country": "Indonesia",
        "city": "Bandung",
        "geo": {"lat": -6.9175, "lng": 107.6191},
        "tags": ["mountain", "coffee", "shopping"],
        "bestSeasons": ["Jun", "Jul", "Aug", "Sep"],
        "descriptionShort": "Cool climate city in West Java.",
        "descriptionLong":
            "Tea plantations, volcano day trips, and factory outlets.",
        "heroImage": "images/destinations/dest_bandung/hero.jpg",
        "gallery": ["images/destinations/dest_bandung/gallery/1.jpg"],
        "ratingAvg": 4.4,
        "ratingCount": 300,
        "createdAt": FieldValue.serverTimestamp(),
      },
    ];
    for (final d in destinations) {
      batch.set(db.collection('destinations').doc(d["id"] as String), d);
    }

    // ---------------------- 2) accommodations (6x) ----------------------
    final accommodations = [
      {
        "id": "acc_ubud_retreat",
        "destination": {"id": "dest_bali", "name": "Indonesia - Denpasar"},
        "type": "villa",
        "name": "Ubud Jungle Retreat",
        "stars": 4,
        "ratingAvg": 4.5,
        "ratingCount": 310,
        "pricePerNight": 78,
        "currency": "USD",
        "maxGuests": 4,
        "bedrooms": 2,
        "beds": 2,
        "bathrooms": 2,
        "amenities": ["wifi", "ac", "breakfast", "pool", "spa"],
        "location": {"lat": -8.506, "lng": 115.262, "address": "Ubud, Bali"},
        "images": [
          "images/accommodations/acc_ubud_retreat/1.jpg",
          "images/accommodations/acc_ubud_retreat/2.jpg",
        ],
        "policies": {
          "checkIn": "14:00",
          "checkOut": "12:00",
          "cancel": "Free <= 24h",
        },
        "availability": [
          {
            "from": DateTime.utc(2025, 10, 1),
            "to": DateTime.utc(2025, 12, 31),
            "rooms": 6,
            "pricePerNight": 78,
          },
        ],
        "description":
            "Nestled in the lush forests of Ubud, this 4-star villa offers a serene escape surrounded by nature. "
            "Enjoy the outdoor pool, spa treatments, and daily breakfast included in your stay. "
            "Rooms are available from October 1 to December 31, 2025. Check-in starts at 14:00 and check-out is until 12:00. "
            "Free cancellation is available up to 24 hours before arrival.",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "acc_kuta_beach_inn",
        "destination": {"id": "dest_bali", "name": "Indonesia - Denpasar"},
        "type": "hotel",
        "name": "Kuta Beach Inn",
        "stars": 3,
        "ratingAvg": 4.1,
        "ratingCount": 220,
        "pricePerNight": 45,
        "currency": "USD",
        "maxGuests": 2,
        "bedrooms": 1,
        "beds": 1,
        "bathrooms": 1,
        "amenities": ["wifi", "ac", "breakfast"],
        "location": {"lat": -8.717, "lng": 115.168, "address": "Kuta, Bali"},
        "images": ["images/accommodations/acc_kuta_beach_inn/1.jpg"],
        "policies": {
          "checkIn": "14:00",
          "checkOut": "12:00",
          "cancel": "Free <= 48h",
        },
        "availability": [
          {
            "from": DateTime.utc(2025, 9, 1),
            "to": DateTime.utc(2025, 12, 31),
            "rooms": 10,
            "pricePerNight": 45,
          },
        ],
        "description":
            "Located just steps from the beach, Kuta Beach Inn provides affordable comfort with 3-star service. "
            "Enjoy air-conditioned rooms, free Wi-Fi, and complimentary breakfast each morning. "
            "Available from September through December 2025. Check-in from 14:00 and check-out at 12:00. "
            "Free cancellation up to 48 hours before your stay.",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "acc_jogja_heritage_bnb",
        "destination": {
          "id": "dest_yogyakarta",
          "name": "Indonesia - Yogyakarta",
        },
        "type": "apartment",
        "name": "Jogja Heritage BnB",
        "stars": 3,
        "ratingAvg": 4.3,
        "ratingCount": 180,
        "pricePerNight": 32,
        "currency": "USD",
        "maxGuests": 3,
        "bedrooms": 1,
        "beds": 2,
        "bathrooms": 1,
        "amenities": ["wifi", "breakfast", "parking"],
        "location": {
          "lat": -7.801,
          "lng": 110.364,
          "address": "Kota Gede, Yogyakarta",
        },
        "images": ["images/accommodations/acc_jogja_heritage_bnb/1.jpg"],
        "policies": {
          "checkIn": "13:00",
          "checkOut": "11:00",
          "cancel": "Free <= 24h",
        },
        "availability": [
          {
            "from": DateTime.utc(2025, 8, 1),
            "to": DateTime.utc(2025, 12, 31),
            "rooms": 5,
            "pricePerNight": 32,
          },
        ],
        "description":
            "Jogja Heritage BnB offers cozy rooms in the heart of Yogyakarta’s cultural district. "
            "This 3-star apartment includes breakfast, Wi-Fi, and private parking. "
            "Available between August and December 2025. Check-in begins at 13:00 and check-out at 11:00. "
            "Free cancellation up to 24 hours prior to arrival.",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "acc_jakarta_central_hotel",
        "destination": {"id": "dest_jakarta", "name": "Indonesia - Jakarta"},
        "type": "hotel",
        "name": "Jakarta Central Hotel",
        "stars": 4,
        "ratingAvg": 4.2,
        "ratingCount": 540,
        "pricePerNight": 70,
        "currency": "USD",
        "maxGuests": 3,
        "bedrooms": 1,
        "beds": 2,
        "bathrooms": 1,
        "amenities": ["wifi", "ac", "gym", "breakfast"],
        "location": {"lat": -6.2, "lng": 106.816, "address": "Central Jakarta"},
        "images": ["images/accommodations/acc_jakarta_central_hotel/1.jpg"],
        "policies": {
          "checkIn": "14:00",
          "checkOut": "12:00",
          "cancel": "Free <= 24h",
        },
        "availability": [
          {
            "from": DateTime.utc(2025, 9, 15),
            "to": DateTime.utc(2025, 9, 31),
            "rooms": 12,
            "pricePerNight": 70,
          },
        ],
        "description":
            "Situated in the heart of Jakarta, this 4-star hotel combines comfort and convenience with modern amenities. "
            "Facilities include a gym, air conditioning, and complimentary breakfast. "
            "Rooms are available from September 15 to 31, 2025. Check-in starts at 14:00, check-out by 12:00. "
            "Free cancellation available within 24 hours of booking.",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "acc_rinjani_camp",
        "destination": {"id": "dest_lombok", "name": "Indonesia - Mataram"},
        "type": "eco-lodges",
        "name": "Rinjani Base Camp",
        "stars": 2,
        "ratingAvg": 4.0,
        "ratingCount": 95,
        "pricePerNight": 18,
        "currency": "USD",
        "maxGuests": 2,
        "bedrooms": 1,
        "beds": 2,
        "bathrooms": 1,
        "amenities": ["parking", "kitchen"],
        "location": {
          "lat": -8.411,
          "lng": 116.457,
          "address": "Senaru, Lombok",
        },
        "images": ["images/accommodations/acc_rinjani_camp/1.jpg"],
        "policies": {
          "checkIn": "12:00",
          "checkOut": "10:00",
          "cancel": "Non-refundable",
        },
        "availability": [
          {
            "from": DateTime.utc(2025, 7, 1),
            "to": DateTime.utc(2025, 11, 30),
            "rooms": 8,
            "pricePerNight": 18,
          },
        ],
        "description":
            "For nature lovers and trekkers, Rinjani Base Camp offers simple eco-lodges near the famous volcano trails. "
            "Facilities include a shared kitchen and parking. "
            "Rooms are available from July to November 2025. Check-in starts at 12:00 and check-out by 10:00. "
            "Please note that bookings are non-refundable.",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "acc_labuan_bajo_resort",
        "destination": {"id": "dest_komodo", "name": "Indonesia - Labuan Bajo"},
        "type": "hotel",
        "name": "Labuan Bajo Resort",
        "stars": 5,
        "ratingAvg": 4.8,
        "ratingCount": 260,
        "pricePerNight": 150,
        "currency": "USD",
        "maxGuests": 4,
        "bedrooms": 2,
        "beds": 3,
        "bathrooms": 2,
        "amenities": ["wifi", "ac", "pool", "spa", "breakfast"],
        "location": {"lat": -8.487, "lng": 119.889, "address": "Labuan Bajo"},
        "images": ["images/accommodations/acc_labuan_bajo_resort/1.jpg"],
        "policies": {
          "checkIn": "15:00",
          "checkOut": "12:00",
          "cancel": "Free <= 72h",
        },
        "availability": [
          {
            "from": DateTime.utc(2025, 9, 1),
            "to": DateTime.utc(2025, 12, 31),
            "rooms": 6,
            "pricePerNight": 150,
          },
        ],
        "description":
            "Labuan Bajo Resort is a luxurious 5-star hotel overlooking the sea. "
            "Guests can enjoy world-class facilities such as a swimming pool, spa, and complimentary breakfast. "
            "Available from September to December 2025. Check-in from 15:00 and check-out by 12:00. "
            "Free cancellation up to 72 hours before your arrival.",
        "createdAt": FieldValue.serverTimestamp(),
      },
    ];
    for (final a in accommodations) {
      batch.set(db.collection('accommodations').doc(a["id"] as String), a);
    }

    // ---------------------- 3) tours (6x) ----------------------
    final tours = [
      {
        "id": "tour_bali_nature_3d",
        "origin": {"id": "dest_yogyakarta", "name": "Indonesia - Yogyakarta"},
        "destination": {"id": "dest_bali", "name": "Indonesia - Denpasar"},
        "type": "nature",
        "name": "Bali Nature Escape (3D2N)",
        "durationDays": 3,
        "groupSizeMax": 12,
        "price": 199,
        "currency": "USD",
        "includes": ["guide", "meals", "transport"],
        "difficulty": "easy",
        "dates": {
          "startDate": DateTime.utc(2025, 10, 10),
          "endDate": DateTime.utc(2025, 10, 20),
        },
        "images": ["images/tours/tour_bali_nature_3d/1.jpg"],
        "ratingAvg": 4.6,
        "ratingCount": 150,
        "gearSuggestions": ["hiking-shoes", "raincoat"],
        "description":
            "Explore the lush forests and rice terraces of Bali on this 3-day nature escape. "
            "Departing from Yogyakarta on October 10, 2025, and returning on October 20, 2025, "
            "you’ll travel by private transport with a local guide. Bring your hiking shoes and a raincoat for the outdoor adventures.",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "tour_ubud_culture_day",
        "origin": {"id": "dest_yogyakarta", "name": "Indonesia - Yogyakarta"},
        "destination": {"id": "dest_bali", "name": "Indonesia - Denpasar"},
        "type": "culture",
        "name": "Ubud Temples & Ricefields",
        "durationDays": 1,
        "groupSizeMax": 16,
        "price": 59,
        "currency": "USD",
        "includes": ["guide", "transport"],
        "difficulty": "easy",
        "dates": {
          "startDate": DateTime.utc(2025, 9, 25),
          "endDate": DateTime.utc(2025, 10, 2),
        },
        "images": ["images/tours/tour_ubud_culture_day/1.jpg"],
        "ratingAvg": 4.5,
        "ratingCount": 210,
        "gearSuggestions": ["hat"],
        "description":
            "Immerse yourself in Balinese culture on a full-day tour of Ubud’s temples and rice terraces. "
            "Departing from Yogyakarta between September 25 and October 2, 2025, this relaxing trip includes transport and a local guide. "
            "A hat is recommended for sun protection during the day.",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "tour_borobudur_sunrise",
        "origin": {"id": "dest_komodo", "name": "Indonesia - Labuan Bajo"},
        "destination": {
          "id": "dest_yogyakarta",
          "name": "Indonesia - Yogyakarta",
        },
        "type": "history",
        "name": "Borobudur Sunrise Tour",
        "durationDays": 1,
        "groupSizeMax": 20,
        "price": 39,
        "currency": "USD",
        "includes": ["transport", "ticket"],
        "difficulty": "easy",
        "dates": {
          "startDate": DateTime.utc(2025, 9, 15),
          "endDate": DateTime.utc(2025, 10, 15),
        },
        "images": ["images/tours/tour_borobudur_sunrise/1.jpg"],
        "ratingAvg": 4.7,
        "ratingCount": 320,
        "gearSuggestions": ["light-jacket"],
        "description":
            "Witness the stunning sunrise over Borobudur Temple on this one-day historical journey. "
            "Departing from Labuan Bajo between September 15 and October 15, 2025, "
            "you’ll travel comfortably by road and return by evening. Bring a light jacket for the early morning chill.",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "tour_komodo_boat_2d",
        "origin": {"id": "dest_bali", "name": "Indonesia - Denpasar"},
        "destination": {"id": "dest_komodo", "name": "Indonesia - Labuan Bajo"},
        "type": "adventure",
        "name": "Komodo Liveaboard (2D1N)",
        "durationDays": 2,
        "groupSizeMax": 10,
        "price": 299,
        "currency": "USD",
        "includes": ["meals", "boat", "guide"],
        "difficulty": "moderate",
        "dates": {
          "startDate": DateTime.utc(2025, 9, 20),
          "endDate": DateTime.utc(2025, 10, 5),
        },
        "images": ["images/tours/tour_komodo_boat_2d/1.jpg"],
        "ratingAvg": 4.8,
        "ratingCount": 140,
        "gearSuggestions": ["snorkel"],
        "description":
            "Sail through the Komodo Islands on a 2-day liveaboard adventure. "
            "Depart from Denpasar between September 20 and October 5, 2025, "
            "and explore the turquoise waters of Labuan Bajo by boat with an expert guide. "
            "Don’t forget your snorkel gear for underwater exploration.",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "tour_rinjani_trek_3d",
        "origin": {"id": "dest_bali", "name": "Indonesia - Denpasar"},
        "destination": {"id": "dest_lombok", "name": "Indonesia - Mataram"},
        "type": "adventure",
        "name": "Rinjani Trek (3D2N)",
        "durationDays": 3,
        "groupSizeMax": 12,
        "price": 249,
        "currency": "USD",
        "includes": ["guide", "meals", "camping"],
        "difficulty": "hard",
        "dates": {
          "startDate": DateTime.utc(2025, 9, 10),
          "endDate": DateTime.utc(2025, 10, 1),
        },
        "images": ["images/tours/tour_rinjani_trek_3d/1.jpg"],
        "ratingAvg": 4.6,
        "ratingCount": 90,
        "gearSuggestions": ["trekking-poles"],
        "description":
            "Challenge yourself with a 3-day trek up Mount Rinjani, departing from Denpasar between September 10 and October 1, 2025. "
            "Camp under the stars and enjoy breathtaking views of Lombok. "
            "This adventure includes meals and camping gear—trekking poles are highly recommended.",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "tour_bandung_volcano",
        "origin": {"id": "dest_lombok", "name": "Indonesia - Mataram"},
        "destination": {"id": "dest_bandung", "name": "Indonesia - Bandung"},
        "type": "nature",
        "name": "Tangkuban Perahu & Tea Fields",
        "durationDays": 1,
        "groupSizeMax": 18,
        "price": 55,
        "currency": "USD",
        "includes": ["transport", "guide"],
        "difficulty": "easy",
        "dates": {
          "startDate": DateTime.utc(2025, 9, 18),
          "endDate": DateTime.utc(2025, 10, 18),
        },
        "images": ["images/tours/tour_bandung_volcano/1.jpg"],
        "ratingAvg": 4.4,
        "ratingCount": 160,
        "gearSuggestions": ["comfortable-shoes"],
        "description":
            "Discover the volcanic beauty of Tangkuban Perahu and the surrounding tea fields on this relaxing one-day trip. "
            "Departing from Mataram between September 18 and October 18, 2025, you’ll travel by private car with a local guide. "
            "Wear comfortable shoes for easy walking through the scenic fields.",
        "createdAt": FieldValue.serverTimestamp(),
      },
    ];
    for (final t in tours) {
      batch.set(db.collection('tours').doc(t["id"] as String), t);
    }

    // ---------------------- 4) attractions (8x) ----------------------
    final attractions = [
      {
        "id": "attr_tegalalang",
        "destination": {"id": "dest_bali", "name": "Bali"},
        "name": "Tegalalang Rice Terrace",
        "category": "nature",
        "description": "Iconic rice terraces near Ubud.",
        "ticketPrice": 5,
        "openHours": "06:00-18:00",
        "location": {"lat": -8.434, "lng": 115.279, "address": "Ubud, Bali"},
        "images": ["images/attractions/attr_tegalalang/1.jpg"],
        "ratingAvg": 4.7,
        "ratingCount": 420,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "attr_uluwatu_temple",
        "destination": {"id": "dest_bali", "name": "Bali"},
        "name": "Uluwatu Temple",
        "category": "culture",
        "description": "Clifftop temple with sunset views.",
        "ticketPrice": 7,
        "openHours": "07:00-19:00",
        "location": {"lat": -8.829, "lng": 115.083, "address": "Pecatu, Bali"},
        "images": ["images/attractions/attr_uluwatu_temple/1.jpg"],
        "ratingAvg": 4.6,
        "ratingCount": 600,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "attr_borobudur",
        "destination": {"id": "dest_yogyakarta", "name": "Yogyakarta"},
        "name": "Borobudur Temple",
        "category": "history",
        "description": "9th-century Mahayana Buddhist temple.",
        "ticketPrice": 25,
        "openHours": "06:00-17:00",
        "location": {
          "lat": -7.607,
          "lng": 110.204,
          "address": "Magelang, Central Java",
        },
        "images": ["images/attractions/attr_borobudur/1.jpg"],
        "ratingAvg": 4.8,
        "ratingCount": 1200,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "attr_prambanan",
        "destination": {"id": "dest_yogyakarta", "name": "Yogyakarta"},
        "name": "Prambanan Temple",
        "category": "history",
        "description": "Largest Hindu temple site in Indonesia.",
        "ticketPrice": 23,
        "openHours": "06:00-17:00",
        "location": {
          "lat": -7.752,
          "lng": 110.491,
          "address": "Sleman, Yogyakarta",
        },
        "images": ["images/attractions/attr_prambanan/1.jpg"],
        "ratingAvg": 4.7,
        "ratingCount": 900,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "attr_kota_tua",
        "destination": {"id": "dest_jakarta", "name": "Jakarta"},
        "name": "Kota Tua Jakarta",
        "category": "history",
        "description": "Historic old town filled with colonial architecture and museums.",
        "ticketPrice": 4,
        "openHours": "08:00-20:00",
        "location": {
          "lat": -6.1352,
          "lng": 106.8133,
          "address": "Taman Fatahillah, Jakarta",
        },
        "images": ["images/attractions/attr_kota_tua/1.jpg"],
        "ratingAvg": 4.4,
        "ratingCount": 780,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "attr_rinjani_senaru",
        "destination": {"id": "dest_lombok", "name": "Lombok"},
        "name": "Mount Rinjani Senaru Trail",
        "category": "nature",
        "description": "Popular gateway route to Lombok's iconic volcano and crater rim.",
        "ticketPrice": 12,
        "openHours": "05:00-17:00",
        "location": {
          "lat": -8.3469,
          "lng": 116.4037,
          "address": "Senaru, North Lombok",
        },
        "images": ["images/attractions/attr_rinjani_senaru/1.jpg"],
        "ratingAvg": 4.8,
        "ratingCount": 540,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "attr_komodo_view",
        "destination": {"id": "dest_komodo", "name": "Komodo"},
        "name": "Padar Island Viewpoint",
        "category": "nature",
        "description": "Famous ridge with panoramic island views.",
        "ticketPrice": 15,
        "openHours": "06:00-18:00",
        "location": {"lat": -8.662, "lng": 119.580, "address": "Padar Island"},
        "images": ["images/attractions/attr_komodo_view/1.jpg"],
        "ratingAvg": 4.9,
        "ratingCount": 500,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "attr_kawah_putih",
        "destination": {"id": "dest_bandung", "name": "Bandung"},
        "name": "Kawah Putih",
        "category": "nature",
        "description": "Crater lake with turquoise water.",
        "ticketPrice": 6,
        "openHours": "07:00-17:00",
        "location": {
          "lat": -7.166,
          "lng": 107.402,
          "address": "Ciwidey, Bandung",
        },
        "images": ["images/attractions/attr_kawah_putih/1.jpg"],
        "ratingAvg": 4.5,
        "ratingCount": 650,
        "createdAt": FieldValue.serverTimestamp(),
      },
    ];
    for (final a in attractions) {
      batch.set(db.collection('attractions').doc(a["id"] as String), a);
    }

    // ---------------------- 5) transports (6x) ----------------------
    final transports = [
      {
        "id": "tr_dps_jog_bus_1",
        "mode": "bus",
        "operator": "Kura-Kura Express",
        "from": {"code": "dest_bali", "city": "Denpasar"},
        "to": {"code": "dest_yogyakarta", "city": "Yogyakarta"},
        "schedule": {
          "departAt": DateTime.utc(2025, 10, 5, 8),
          "arriveAt": DateTime.utc(2025, 10, 6, 6),
        },
        "basePrice": 35,
        "currency": "USD",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "tr_dps_jog_flight_1",
        "mode": "flight",
        "operator": "Garuda Indonesia",
        "from": {"code": "dest_bali", "city": "Denpasar"},
        "to": {"code": "dest_yogyakarta", "city": "Yogyakarta"},
        "schedule": {
          "departAt": DateTime.utc(2025, 10, 5, 11),
          "arriveAt": DateTime.utc(2025, 10, 5, 13),
        },
        "basePrice": 120,
        "currency": "USD",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "tr_cgk_dps_flight_1",
        "mode": "flight",
        "operator": "AirAsia",
        "from": {"code": "dest_jakarta", "city": "Jakarta"},
        "to": {"code": "dest_bali", "city": "Denpasar"},
        "schedule": {
          "departAt": DateTime.utc(2025, 9, 20, 9),
          "arriveAt": DateTime.utc(2025, 9, 20, 12),
        },
        "basePrice": 85,
        "currency": "USD",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "tr_dps_lop_boat_1",
        "mode": "boat",
        "operator": "Fast Boat Lombok",
        "from": {"code": "dest_bali", "city": "Denpasar"},
        "to": {"code": "dest_lombok", "city": "Lombok"},
        "schedule": {
          "departAt": DateTime.utc(2025, 9, 25, 7),
          "arriveAt": DateTime.utc(2025, 9, 25, 10),
        },
        "basePrice": 40,
        "currency": "USD",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "tr_cgk_bdo_train_1",
        "mode": "train",
        "operator": "KAI",
        "from": {"code": "dest_jakarta", "city": "Jakarta"},
        "to": {"code": "dest_bandung", "city": "Bandung"},
        "schedule": {
          "departAt": DateTime.utc(2025, 10, 2, 8),
          "arriveAt": DateTime.utc(2025, 10, 2, 12),
        },
        "basePrice": 18,
        "currency": "USD",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "tr_bjo_dps_ferry_1",
        "mode": "boat",
        "operator": "Flores Ferry",
        "from": {"code": "dest_komodo", "city": "Labuan Bajo"},
        "to": {"code": "dest_bali", "city": "Denpasar"},
        "schedule": {
          "departAt": DateTime.utc(2025, 10, 7, 6),
          "arriveAt": DateTime.utc(2025, 10, 7, 16),
        },
        "basePrice": 55,
        "currency": "USD",
        "createdAt": FieldValue.serverTimestamp(),
      },
    ];
    for (final t in transports) {
      batch.set(db.collection('transports').doc(t["id"] as String), t);
    }

    // ---------------------- 6) reviews (نمونه) ----------------------
    final reviews = <Map<String, dynamic>>[];
    // برای همه اقامتگاه‌ها 2 نظر بساز
    for (final a in accommodations) {
      reviews.addAll([
        {
          "id": "rev_${a['id']}_1",
          "targetType": "accommodation",
          "targetId": a["id"],
          "userId": "sara_1",
          "rating": (a['stars'] ?? 4),
          "text":
              "I really enjoyed staying at ${a['name']}. Clean rooms, great location and very kind staff!",
          "createdAt": DateTime.utc(2025, 9, 10),
        },
        {
          "id": "rev_${a['id']}_2",
          "targetType": "accommodation",
          "targetId": a["id"],
          "userId": "john_2",
          "rating": ((a['stars'] ?? 3)),
          "text":
              "Good experience at ${a['name']}, though breakfast could be better. Overall, worth the price.",
          "createdAt": DateTime.utc(2025, 9, 12),
        },
      ]);
    }

    // برای همه تورها 3 نظر بساز
    for (final t in tours) {
      reviews.addAll([
        {
          "id": "rev_${t['id']}_1",
          "targetType": "tour",
          "targetId": t["id"],
          "userId": "alice_3",
          "rating": (t['ratingAvg'] ?? 4),
          "text":
              "The ${t['name']} was fantastic! Our guide was super friendly and knowledgeable.",
          "createdAt": DateTime.utc(2025, 9, 20),
        },
        {
          "id": "rev_${t['id']}_2",
          "targetType": "tour",
          "targetId": t["id"],
          "userId": "mark_4",
          "rating": ((t['ratingAvg'] ?? 4.5)),
          "text":
              "Really enjoyed ${t['name']}! Would definitely recommend it to friends.",
          "createdAt": DateTime.utc(2025, 9, 22),
        },
        {
          "id": "rev_${t['id']}_3",
          "targetType": "tour",
          "targetId": t["id"],
          "userId": "reza_5",
          "rating": 5,
          "text":
              "Amazing experience on ${t['name']}! Everything was well organized and beautiful views all around.",
          "createdAt": DateTime.utc(2025, 9, 25),
        },
      ]);
    }

    // final reviews = [
    //   {
    //     "id": "rev_001",
    //     "targetType": "accommodation",
    //     "targetId": "acc_ubud_retreat",
    //     "userId": "demo_user_1",
    //     "rating": 5,
    //     "text": "Great jungle vibe and friendly staff.",
    //     "createdAt": DateTime.utc(2025, 9, 1, 10),
    //   },
    //   {
    //     "id": "rev_002",
    //     "targetType": "tour",
    //     "targetId": "tour_borobudur_sunrise",
    //     "userId": "demo_user_2",
    //     "rating": 4,
    //     "text": "Magical sunrise, well organized.",
    //     "createdAt": DateTime.utc(2025, 9, 5, 8),
    //   },
    // ];
    for (final r in reviews) {
      batch.set(db.collection('reviews').doc(r["id"] as String), r);
    }

    // ---------------------- 7) system/config ----------------------
    final config = {
      "filterOptions": {
        "amenities": [
          "wifi",
          "ac",
          "breakfast",
          "pool",
          "spa",
          "parking",
          "kitchen",
          "gym",
        ],
        "tourTypes": [
          "nature",
          "city",
          "adventure",
          "culture",
          "food",
          "history",
        ],
        "tags": [
          "beach",
          "culture",
          "history",
          "nature",
          "family",
          "budget",
          "luxury",
          "mountain",
          "diving",
        ],
      },
    };
    batch.set(db.collection('system').doc('config'), config);

    await batch.commit();
  }
}
