import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreSeeder {
  static Future<void> run() async {
    final db = FirebaseFirestore.instance;
    final writes = <_SeedWrite>[];

    void seedSet(
      DocumentReference<Map<String, dynamic>> ref,
      Map<String, dynamic> data,
    ) {
      writes.add(_SeedWrite(ref, data));
    }

    await _deleteCollection(db.collection('destinations'));
    await _deleteCollection(db.collection('accommodations'));
    await _deleteCollection(db.collection('tours'));
    await _deleteCollection(db.collection('attractions'));
    await _deleteCollection(db.collection('transports'));

    final destinations = <Map<String, dynamic>>[
      {
        "id": "dest_rasht",
        "name": "Rasht",
        "country": "Iran",
        "city": "Rasht",
        "geo": {"lat": 37.2808, "lng": 49.5832},
        "tags": ["food", "nature", "rain"],
        "bestSeasons": ["Apr", "May", "Sep", "Oct"],
        "descriptionShort":
            "Gilan's food capital, rainy streets, bazaars, and forest access.",
        "descriptionLong":
            "Rasht is the capital of Gilan province, known for its creative local cuisine, Municipal Square, old bazaar, humid Caspian climate, and quick access to Masuleh, Anzali Lagoon, and green mountain roads.",
        "heroImage": "images/pic1.png",
        "gallery": ["images/pic2.jpg"],
        "ratingAvg": 4.6,
        "ratingCount": 980,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "dest_tehran",
        "name": "Tehran",
        "country": "Iran",
        "city": "Tehran",
        "geo": {"lat": 35.7219, "lng": 51.3347},
        "tags": ["museums", "city", "mountain"],
        "bestSeasons": ["Apr", "May", "Sep", "Oct"],
        "descriptionShort":
            "Iran's capital with museums, palaces, galleries, and Alborz views.",
        "descriptionLong":
            "Tehran combines Golestan and Sa'dabad palaces, the Grand Bazaar, contemporary galleries, busy cafe districts, and mountain escapes around Darband, Tochal, and the northern foothills.",
        "heroImage": "images/pic2.jpg",
        "gallery": ["images/pic3.jpg"],
        "ratingAvg": 4.5,
        "ratingCount": 2100,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "dest_qeshm",
        "name": "Qeshm",
        "country": "Iran",
        "city": "Qeshm",
        "geo": {"lat": 26.9581, "lng": 56.2719},
        "tags": ["island", "geopark", "nature"],
        "bestSeasons": ["Nov", "Dec", "Jan", "Feb", "Mar"],
        "descriptionShort":
            "Persian Gulf island with geopark landscapes, mangroves, and bazaars.",
        "descriptionLong":
            "Qeshm is Iran's largest island and a UNESCO Global Geopark area, known for the Valley of Stars, Hara mangrove forests, Chahkooh Canyon, local markets, and Hormuz Strait coastal routes.",
        "heroImage": "images/pic3.jpg",
        "gallery": ["images/pic4.jpg"],
        "ratingAvg": 4.6,
        "ratingCount": 860,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "dest_kish",
        "name": "Kish",
        "country": "Iran",
        "city": "Kish",
        "geo": {"lat": 26.5325, "lng": 53.9738},
        "tags": ["island", "beach", "shopping"],
        "bestSeasons": ["Nov", "Dec", "Jan", "Feb", "Mar"],
        "descriptionShort":
            "Resort island with beaches, shopping centers, and water activities.",
        "descriptionLong":
            "Kish is a Persian Gulf resort destination with coral beaches, malls, cycling paths, diving, marine recreation, and landmark hotels such as Dariush and Toranj.",
        "heroImage": "images/pic4.jpg",
        "gallery": ["images/pic5.jpg"],
        "ratingAvg": 4.7,
        "ratingCount": 1250,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "dest_isfahan",
        "name": "Isfahan",
        "country": "Iran",
        "city": "Isfahan",
        "geo": {"lat": 32.6539, "lng": 51.6660},
        "tags": ["architecture", "history", "culture"],
        "bestSeasons": ["Apr", "May", "Sep", "Oct"],
        "descriptionShort":
            "Safavid architecture, Naqsh-e Jahan Square, bridges, and bazaars.",
        "descriptionLong":
            "Isfahan is one of Iran's major heritage cities, centered on Naqsh-e Jahan Square, Imam Mosque, Sheikh Lotfollah Mosque, Ali Qapu, historic bazaars, and Zayandeh Rud bridges.",
        "heroImage": "images/pic5.jpg",
        "gallery": ["images/pic6.jpg"],
        "ratingAvg": 4.8,
        "ratingCount": 1760,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "dest_yazd",
        "name": "Yazd",
        "country": "Iran",
        "city": "Yazd",
        "geo": {"lat": 31.8974, "lng": 54.3569},
        "tags": ["desert", "heritage", "architecture"],
        "bestSeasons": ["Mar", "Apr", "Oct", "Nov"],
        "descriptionShort":
            "Desert city with windcatchers, adobe lanes, and Zoroastrian heritage.",
        "descriptionLong":
            "Yazd is a UNESCO-listed desert city known for its historic adobe fabric, windcatchers, Amir Chakhmaq Complex, fire temples, qanats, and traditional courtyard hotels.",
        "heroImage": "images/pic6.jpg",
        "gallery": ["images/pic7.jpg"],
        "ratingAvg": 4.7,
        "ratingCount": 1120,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "dest_shiraz",
        "name": "Shiraz",
        "country": "Iran",
        "city": "Shiraz",
        "geo": {"lat": 29.5918, "lng": 52.5837},
        "tags": ["poetry", "gardens", "history"],
        "bestSeasons": ["Apr", "May", "Oct", "Nov"],
        "descriptionShort":
            "Gardens, poetry, bazaars, and access to Persepolis.",
        "descriptionLong":
            "Shiraz is known for Eram Garden, Hafez and Saadi tombs, Vakil Bazaar, Nasir al-Mulk Mosque, and day trips to Persepolis and Naqsh-e Rostam.",
        "heroImage": "images/dest_amsterdam.png",
        "gallery": ["images/pic8.jpg"],
        "ratingAvg": 4.8,
        "ratingCount": 1650,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "dest_hamedan",
        "name": "Hamedan",
        "country": "Iran",
        "city": "Hamedan",
        "geo": {"lat": 34.7989, "lng": 48.5150},
        "tags": ["history", "mountain", "heritage"],
        "bestSeasons": ["May", "Jun", "Sep", "Oct"],
        "descriptionShort":
            "Ancient Ecbatana, Alisadr Cave access, tombs, and mountain air.",
        "descriptionLong":
            "Hamedan is one of Iran's oldest cities, known for the tombs of Avicenna and Baba Taher, Ganjnameh, Alvand mountain routes, and access to Alisadr Cave.",
        "heroImage": "images/pic8.jpg",
        "gallery": ["images/pic9.jpg"],
        "ratingAvg": 4.5,
        "ratingCount": 740,
        "createdAt": FieldValue.serverTimestamp(),
      },
    ];
    for (final d in destinations) {
      seedSet(db.collection('destinations').doc(d["id"] as String), d);
    }

    Map<String, dynamic> stay({
      required String id,
      required String destinationId,
      required String destinationName,
      required String type,
      required String name,
      required int stars,
      required double ratingAvg,
      required int ratingCount,
      required int pricePerNight,
      required int maxGuests,
      required int bedrooms,
      required int beds,
      required int bathrooms,
      required List<String> amenities,
      required double lat,
      required double lng,
      required String address,
      required List<String> images,
      required String checkIn,
      required String checkOut,
      required String cancel,
      required int rooms,
      required String description,
    }) {
      final roomOptions =
          type == "hotel"
              ? [
                {
                  "id": "single",
                  "label": "1 person room",
                  "capacity": 1,
                  "maxGuests": 1,
                  "bedrooms": 1,
                  "beds": 1,
                  "bathrooms": 1,
                  "rooms": rooms,
                  "pricePerNight": pricePerNight,
                  "currency": "USD",
                },
                {
                  "id": "double",
                  "label": "2 person room",
                  "capacity": 2,
                  "maxGuests": 2,
                  "bedrooms": 1,
                  "beds": 1,
                  "bathrooms": 1,
                  "rooms": rooms,
                  "pricePerNight": (pricePerNight * 1.35).round(),
                  "currency": "USD",
                },
                {
                  "id": "family",
                  "label": "4 person room",
                  "capacity": 4,
                  "maxGuests": 4,
                  "bedrooms": 2,
                  "beds": 3,
                  "bathrooms": 1,
                  "rooms": rooms,
                  "pricePerNight": (pricePerNight * 2.15).round(),
                  "currency": "USD",
                },
              ]
              : <Map<String, dynamic>>[];

      return {
        "id": id,
        "destination": {"id": destinationId, "name": destinationName},
        "type": type,
        "name": name,
        "stars": stars,
        "ratingAvg": ratingAvg,
        "ratingCount": ratingCount,
        "pricePerNight": pricePerNight,
        "currency": "USD",
        "maxGuests": maxGuests,
        "bedrooms": bedrooms,
        "beds": beds,
        "bathrooms": bathrooms,
        "amenities": amenities,
        "roomOptions": roomOptions,
        "location": {"lat": lat, "lng": lng, "address": address},
        "images": images,
        "policies": {
          "checkIn": checkIn,
          "checkOut": checkOut,
          "cancel": cancel,
        },
        "availability": [
          {
            "from": DateTime.utc(2026, 7, 16),
            "to": DateTime.utc(2026, 12, 15),
            "rooms": rooms,
            "pricePerNight": pricePerNight,
          },
        ],
        "description": description,
        "createdAt": FieldValue.serverTimestamp(),
      };
    }

    final accommodations = <Map<String, dynamic>>[
      stay(
        id: "acc_rasht_kadus_grand_hotel",
        destinationId: "dest_rasht",
        destinationName: "Iran - Rasht",
        type: "hotel",
        name: "Kadus Grand Hotel Rasht",
        stars: 5,
        ratingAvg: 4.4,
        ratingCount: 280,
        pricePerNight: 72,
        maxGuests: 2,
        bedrooms: 1,
        beds: 1,
        bathrooms: 1,
        amenities: ["wifi", "ac", "breakfast", "parking", "restaurant"],
        lat: 37.261776,
        lng: 49.591021,
        address: "Manzariyeh, Rasht, Gilan Province",
        images: [
          "images/acc_rasht_kadus_grand_hotel_1.png",
          "images/acc_rasht_kadus_grand_hotel_2.png",
          "images/acc_rasht_kadus_grand_hotel_3.png",
          "images/acc_rasht_kadus_grand_hotel_4.png",
        ],
        checkIn: "14:00",
        checkOut: "12:00",
        cancel: "Free <= 48h",
        rooms: 6,
        description:
            "A long-running full-service hotel in Rasht's Manzariyeh area, suitable for city stays, business trips, and access to central Rasht and Gilan day routes.",
      ),
      stay(
        id: "acc_rasht_shabestan_hotel",
        destinationId: "dest_rasht",
        destinationName: "Iran - Rasht",
        type: "hotel",
        name: "Shabestan Hotel",
        stars: 3,
        ratingAvg: 4.3,
        ratingCount: 165,
        pricePerNight: 38,
        maxGuests: 3,
        bedrooms: 1,
        beds: 2,
        bathrooms: 1,
        amenities: ["wifi", "ac", "breakfast", "kitchen", "laundry"],
        lat: 37.277918,
        lng: 49.585194,
        address: "Near Rasht Bazaar, Rasht, Gilan Province",
        images: [
          "images/acc_rasht_shabestan_hotel_1.png",
          "images/acc_rasht_shabestan_hotel_2.png",
          "images/acc_rasht_shabestan_hotel_3.png",
          "images/acc_rasht_shabestan_hotel_4.png",
        ],
        checkIn: "14:00",
        checkOut: "12:00",
        cancel: "Free <= 48h",
        rooms: 5,
        description:
            "A small guesthouse-style stay near Rasht Bazaar and Municipal Square, useful for food-focused travelers who want local streets, shared kitchen access, and short drives around Gilan.",
      ),
      stay(
        id: "acc_tehran_espinas_palace",
        destinationId: "dest_tehran",
        destinationName: "Iran - Tehran",
        type: "hotel",
        name: "Espinas Palace Hotel Tehran",
        stars: 5,
        ratingAvg: 4.7,
        ratingCount: 720,
        pricePerNight: 180,
        maxGuests: 2,
        bedrooms: 1,
        beds: 1,
        bathrooms: 1,
        amenities: ["wifi", "ac", "breakfast", "pool", "spa", "gym", "parking"],
        lat: 35.792946,
        lng: 51.356363,
        address: "Behroud Square, Saadat Abad, Tehran",
        images: [
          "images/acc_tehran_espinas_palace_1.png",
          "images/acc_tehran_espinas_palace_2.png",
          "images/acc_tehran_espinas_palace_3.png",
          "images/acc_tehran_espinas_palace_4.png",
          "images/acc_tehran_espinas_palace_5.png",
          "images/acc_tehran_espinas_palace_6.png",
        ],
        checkIn: "14:00",
        checkOut: "12:00",
        cancel: "Free <= 72h",
        rooms: 10,
        description:
            "A major five-star hotel in Saadat Abad, known for business facilities, conference halls, city views, restaurants, and access to north Tehran routes.",
      ),
      stay(
        id: "acc_tehran_parsian_azadi",
        destinationId: "dest_tehran",
        destinationName: "Iran - Tehran",
        type: "hotel",
        name: "Parsian Azadi Hotel Tehran",
        stars: 4,
        ratingAvg: 4.4,
        ratingCount: 260,
        pricePerNight: 92,
        maxGuests: 4,
        bedrooms: 2,
        beds: 2,
        bathrooms: 1,
        amenities: ["wifi", "ac", "kitchen", "washer", "parking"],
        lat: 35.791580,
        lng: 51.389751,
        address: "Evin and Velenjak area, north Tehran",
        images: [
          "images/acc_tehran_parsian_azadi_1.png",
          "images/acc_tehran_parsian_azadi_2.png",
          "images/acc_tehran_parsian_azadi_3.png",
          "images/acc_tehran_parsian_azadi_4.png",
        ],
        checkIn: "14:00",
        checkOut: "12:00",
        cancel: "Free <= 72h",
        rooms: 5,
        description:
            "A serviced apartment option in north Tehran for families and longer stays, with kitchen and laundry facilities and access to Evin, Velenjak, Vanak, and mountain-side districts.",
      ),
      stay(
        id: "acc_qeshm_irman_boutique",
        destinationId: "dest_qeshm",
        destinationName: "Iran - Qeshm",
        type: "hotel",
        name: "Irman Boutique Hotel Qeshm",
        stars: 4,
        ratingAvg: 4.5,
        ratingCount: 240,
        pricePerNight: 119,
        maxGuests: 3,
        bedrooms: 1,
        beds: 2,
        bathrooms: 1,
        amenities: ["wifi", "ac", "parking", "coffee-shop", "laundry"],
        lat: 26.943423,
        lng: 56.272299,
        address: "Payam Street, Pajohesh Street, Nakhl Zarrin, Qeshm",
        images: [
          "images/acc_qeshm_irman_boutique_1.png",
          "images/acc_qeshm_irman_boutique_2.png",
          "images/acc_qeshm_irman_boutique_3.png",
          "images/acc_qeshm_irman_boutique_4.png",
        ],
        checkIn: "14:00",
        checkOut: "12:00",
        cancel: "Free <= 48h",
        rooms: 4,
        description:
            "A boutique hotel in Qeshm with 38 rooms across 5 floors, close to City Center 1 and 2, Setareh, Pardis, and Ferdowsi commercial complexes.",
      ),
      stay(
        id: "acc_qeshm_fulton_hotel",
        destinationId: "dest_qeshm",
        destinationName: "Iran - Qeshm",
        type: "eco-lodge",
        name: "Qeshm Geopark Eco Lodge",
        stars: 3,
        ratingAvg: 4.4,
        ratingCount: 150,
        pricePerNight: 48,
        maxGuests: 4,
        bedrooms: 2,
        beds: 3,
        bathrooms: 1,
        amenities: ["wifi", "ac", "kitchen", "parking", "local-breakfast"],
        lat: 26.9499,
        lng: 56.2462,
        address: "Qeshm island village area, Hormozgan Province",
        images: [
          "images/acc_qeshm_fulton_hotel_1.png",
          "images/acc_qeshm_fulton_hotel_2.png",
          "images/acc_qeshm_fulton_hotel_3.png",
          "images/acc_qeshm_fulton_hotel_4.png",
        ],
        checkIn: "14:00",
        checkOut: "12:00",
        cancel: "Free <= 48h",
        rooms: 5,
        description:
            "A village-style eco lodge for Qeshm Geopark routes, suitable for families and nature travelers heading toward Chahkooh, Valley of Stars, Hara Forest, and coastal drives.",
      ),
      stay(
        id: "acc_kish_dariush_grand_hotel",
        destinationId: "dest_kish",
        destinationName: "Iran - Kish",
        type: "hotel",
        name: "Dariush Grand Hotel Kish",
        stars: 5,
        ratingAvg: 4.7,
        ratingCount: 540,
        pricePerNight: 180,
        maxGuests: 2,
        bedrooms: 1,
        beds: 1,
        bathrooms: 1,
        amenities: ["wifi", "ac", "breakfast", "pool", "gym", "restaurant"],
        lat: 26.535070,
        lng: 54.027700,
        address: "Dariush Square, Kish Island",
        images: [
          "images/acc_kish_dariush_grand_hotel_1.png",
          "images/acc_kish_dariush_grand_hotel_2.png",
          "images/acc_kish_dariush_grand_hotel_3.png",
          "images/acc_kish_dariush_grand_hotel_4.png",
        ],
        checkIn: "14:00",
        checkOut: "12:00",
        cancel: "Free <= 72h",
        rooms: 8,
        description:
            "A five-star Kish landmark inspired by Persepolis architecture, located on the eastern side of Kish Island and known for resort-style services.",
      ),
      stay(
        id: "acc_kish_toranj_marine_hotel",
        destinationId: "dest_kish",
        destinationName: "Iran - Kish",
        type: "hotel",
        name: "Toranj Marine Hotel Kish",
        stars: 5,
        ratingAvg: 4.6,
        ratingCount: 420,
        pricePerNight: 165,
        maxGuests: 2,
        bedrooms: 1,
        beds: 1,
        bathrooms: 1,
        amenities: ["wifi", "ac", "breakfast", "spa", "restaurant", "sea-view"],
        lat: 26.565440,
        lng: 53.923183,
        address: "Northwest coast, Kish Island",
        images: [
          "images/acc_kish_toranj_marine_hotel_1.png",
          "images/acc_kish_toranj_marine_hotel_2.png",
          "images/acc_kish_toranj_marine_hotel_3.png",
          "images/acc_kish_toranj_marine_hotel_4.png",
        ],
        checkIn: "14:00",
        checkOut: "12:00",
        cancel: "Free <= 72h",
        rooms: 7,
        description:
            "A five-star marine hotel complex in the northwest of Kish, known for over-water accommodation, coastal setting, and quiet resort atmosphere.",
      ),
      stay(
        id: "acc_isfahan_abbasi_hotel",
        destinationId: "dest_isfahan",
        destinationName: "Iran - Isfahan",
        type: "hotel",
        name: "Abbasi Hotel Isfahan",
        stars: 5,
        ratingAvg: 4.8,
        ratingCount: 680,
        pricePerNight: 130,
        maxGuests: 2,
        bedrooms: 1,
        beds: 1,
        bathrooms: 1,
        amenities: [
          "wifi",
          "ac",
          "breakfast",
          "garden",
          "restaurant",
          "parking",
        ],
        lat: 32.651675,
        lng: 51.670335,
        address: "Chaharbagh Abbasi Avenue, Isfahan",
        images: [
          "images/acc_isfahan_abbasi_hotel_1.png",
          "images/acc_isfahan_abbasi_hotel_2.png",
          "images/acc_isfahan_abbasi_hotel_3.png",
          "images/acc_isfahan_abbasi_hotel_4.png",
          "images/acc_isfahan_abbasi_hotel_5.png",
          "images/acc_isfahan_abbasi_hotel_6.png",
        ],
        checkIn: "14:00",
        checkOut: "12:00",
        cancel: "Free <= 72h",
        rooms: 8,
        description:
            "A famous historic hotel in a roughly 300-year-old Safavid-era caravanserai on Chaharbagh Abbasi Avenue, close to Isfahan's main heritage core.",
      ),
      stay(
        id: "acc_isfahan_kowsar_hotel",
        destinationId: "dest_isfahan",
        destinationName: "Iran - Isfahan",
        type: "hotel",
        name: "Si-o-se-pol Family Apartment",
        stars: 4,
        ratingAvg: 4.3,
        ratingCount: 190,
        pricePerNight: 62,
        maxGuests: 5,
        bedrooms: 2,
        beds: 3,
        bathrooms: 1,
        amenities: ["wifi", "ac", "kitchen", "washer", "parking"],
        lat: 32.644824,
        lng: 51.665638,
        address: "Mellat Boulevard, near Si-o-se-pol, Isfahan",
        images: [
          "images/acc_isfahan_kowsar_hotel_1.png",
          "images/acc_isfahan_kowsar_hotel_2.png",
          "images/acc_isfahan_kowsar_hotel_3.png",
          "images/acc_isfahan_kowsar_hotel_4.png",
          "images/acc_isfahan_kowsar_hotel_5.png",
        ],
        checkIn: "14:00",
        checkOut: "12:00",
        cancel: "Free <= 48h",
        rooms: 4,
        description:
            "A family apartment near Si-o-se-pol and the Zayandeh Rud corridor, practical for longer stays with kitchen, laundry, and easy access to Chaharbagh and central Isfahan.",
      ),
      stay(
        id: "acc_yazd_moshir_al_mamalek",
        destinationId: "dest_yazd",
        destinationName: "Iran - Yazd",
        type: "guesthouse",
        name: "Moshir al-Mamalek Garden Hotel Yazd",
        stars: 4,
        ratingAvg: 4.6,
        ratingCount: 330,
        pricePerNight: 78,
        maxGuests: 3,
        bedrooms: 1,
        beds: 2,
        bathrooms: 1,
        amenities: [
          "wifi",
          "ac",
          "breakfast",
          "garden",
          "restaurant",
          "parking",
        ],
        lat: 31.917891,
        lng: 54.337945,
        address: "Enghelab Street, Moshir Boulevard, Yazd",
        images: [
          "images/acc_yazd_moshir_al_mamalek_1.png",
          "images/acc_yazd_moshir_al_mamalek_2.png",
          "images/acc_yazd_moshir_al_mamalek_3.png",
          "images/acc_yazd_moshir_al_mamalek_4.png",
        ],
        checkIn: "14:00",
        checkOut: "12:00",
        cancel: "Free <= 48h",
        rooms: 6,
        description:
            "A Qajar-era garden hotel and one of Yazd's well-known heritage stays, with traditional garden atmosphere and access to Amir Chakhmaq and Yazd historic districts.",
      ),
      stay(
        id: "acc_yazd_dad_hotel",
        destinationId: "dest_yazd",
        destinationName: "Iran - Yazd",
        type: "hotel",
        name: "Dad Hotel Yazd",
        stars: 4,
        ratingAvg: 4.5,
        ratingCount: 300,
        pricePerNight: 82,
        maxGuests: 3,
        bedrooms: 1,
        beds: 2,
        bathrooms: 1,
        amenities: ["wifi", "ac", "breakfast", "pool", "restaurant", "parking"],
        lat: 31.886018,
        lng: 54.365813,
        address: "10th Farvardin Street, Yazd",
        images: [
          "images/acc_yazd_dad_hotel_1.png",
          "images/acc_yazd_dad_hotel_2.png",
          "images/acc_yazd_dad_hotel_3.png",
          "images/acc_yazd_dad_hotel_4.png",
        ],
        checkIn: "14:00",
        checkOut: "12:00",
        cancel: "Free <= 48h",
        rooms: 6,
        description:
            "A restored traditional hotel in Yazd with courtyard-style architecture, close to the old city fabric and popular heritage routes.",
      ),
      stay(
        id: "acc_shiraz_zandiyeh_hotel",
        destinationId: "dest_shiraz",
        destinationName: "Iran - Shiraz",
        type: "hotel",
        name: "Zandiyeh Hotel Shiraz",
        stars: 5,
        ratingAvg: 4.7,
        ratingCount: 430,
        pricePerNight: 118,
        maxGuests: 2,
        bedrooms: 1,
        beds: 1,
        bathrooms: 1,
        amenities: ["wifi", "ac", "breakfast", "pool", "spa", "restaurant"],
        lat: 29.619845,
        lng: 52.544825,
        address: "Hejrat Street, near Karim Khan Citadel, Shiraz",
        images: [
          "images/acc_shiraz_zandiyeh_hotel_1.png",
          "images/acc_shiraz_zandiyeh_hotel_2.png",
          "images/acc_shiraz_zandiyeh_hotel_3.png",
          "images/acc_shiraz_zandiyeh_hotel_4.png",
        ],
        checkIn: "14:00",
        checkOut: "12:00",
        cancel: "Free <= 72h",
        rooms: 7,
        description:
            "A five-star hotel near Karim Khan Citadel and the historic center, convenient for Vakil Bazaar, Nasir al-Mulk Mosque, and central Shiraz walks.",
      ),
      stay(
        id: "acc_shiraz_chamran_grand_hotel",
        destinationId: "dest_shiraz",
        destinationName: "Iran - Shiraz",
        type: "apartment",
        name: "Qasrodasht Garden Villa Shiraz",
        stars: 4,
        ratingAvg: 4.4,
        ratingCount: 155,
        pricePerNight: 88,
        maxGuests: 6,
        bedrooms: 3,
        beds: 4,
        bathrooms: 1,
        amenities: ["wifi", "ac", "kitchen", "garden", "parking", "washer"],
        lat: 29.637929,
        lng: 52.560764,
        address: "Qasrodasht and Chamran Boulevard area, Shiraz",
        images: [
          "images/acc_shiraz_chamran_grand_hotel_1.png",
          "images/acc_shiraz_chamran_grand_hotel_2.png",
          "images/acc_shiraz_chamran_grand_hotel_3.png",
          "images/acc_shiraz_chamran_grand_hotel_4.png",
        ],
        checkIn: "14:00",
        checkOut: "12:00",
        cancel: "Free <= 48h",
        rooms: 3,
        description:
            "A garden villa-style stay in the Qasrodasht and Chamran Boulevard area, useful for families who prefer private space, kitchen facilities, parking, and quick access to northwest Shiraz gardens.",
      ),
      stay(
        id: "acc_hamedan_parsian_buali",
        destinationId: "dest_hamedan",
        destinationName: "Iran - Hamedan",
        type: "hotel",
        name: "Parsian BuAli Hotel Hamedan",
        stars: 4,
        ratingAvg: 4.2,
        ratingCount: 210,
        pricePerNight: 64,
        maxGuests: 2,
        bedrooms: 1,
        beds: 1,
        bathrooms: 1,
        amenities: ["wifi", "ac", "breakfast", "restaurant", "parking"],
        lat: 34.785078,
        lng: 48.512992,
        address: "BuAli Sina Street, Hamedan",
        images: [
          "images/acc_hamedan_parsian_buali_1.png",
          "images/acc_hamedan_parsian_buali_2.png",
          "images/acc_hamedan_parsian_buali_3.png",
          "images/acc_hamedan_parsian_buali_4.png",
        ],
        checkIn: "14:00",
        checkOut: "12:00",
        cancel: "Free <= 48h",
        rooms: 5,
        description:
            "A central Hamedan hotel on BuAli Sina Street, practical for visiting Avicenna Mausoleum, city squares, Ganjnameh, and Alvand mountain routes.",
      ),
      stay(
        id: "acc_hamedan_baba_taher_hotel",
        destinationId: "dest_hamedan",
        destinationName: "Iran - Hamedan",
        type: "eco-lodge",
        name: "Hotel Baba Taher Hamedan",
        stars: 3,
        ratingAvg: 4.2,
        ratingCount: 145,
        pricePerNight: 46,
        maxGuests: 4,
        bedrooms: 2,
        beds: 3,
        bathrooms: 1,
        amenities: ["wifi", "breakfast", "kitchen", "parking", "mountain-view"],
        lat: 34.810492,
        lng: 48.510636,
        address: "Ganjnameh and Alvand foothills area, Hamedan",
        images: [
          "images/acc_hamedan_baba_taher_hotel_1.png",
          "images/acc_hamedan_baba_taher_hotel_2.png",
          "images/acc_hamedan_baba_taher_hotel_3.png",
          "images/acc_hamedan_baba_taher_hotel_4.png",
        ],
        checkIn: "14:00",
        checkOut: "12:00",
        cancel: "Free <= 48h",
        rooms: 5,
        description:
            "A lodge-style stay near the Alvand foothills and Ganjnameh route, suitable for travelers who want mountain air, simple kitchen access, parking, and short routes back to Hamedan city.",
      ),
    ];

    const activeDestinationIds = {
      "dest_rasht",
      "dest_tehran",
      "dest_qeshm",
      "dest_kish",
      "dest_isfahan",
      "dest_yazd",
      "dest_shiraz",
      "dest_hamedan",
    };
    final activeAccommodations =
        accommodations.where((a) {
          final destination = Map<String, dynamic>.from(a["destination"] ?? {});
          return activeDestinationIds.contains(destination["id"]);
        }).toList();

    for (final a in activeAccommodations) {
      seedSet(db.collection('accommodations').doc(a["id"] as String), a);
    }

    final tours = <Map<String, dynamic>>[
      {
        "id": "tour_tehran_landmarks_bazaar",
        "origin": {"id": "dest_tehran", "name": "Iran - Tehran"},
        "destination": {"id": "dest_tehran", "name": "Iran - Tehran"},
        "type": "city",
        "types": ["city", "culture", "history"],
        "tripScope": "domestic",
        "name": "Tehran Landmarks and Grand Bazaar Day",
        "durationDays": 1,
        "groupSizeMax": 14,
        "price": 38,
        "currency": "EUR",
        "includes": ["guide", "museum-ticket", "local-transport"],
        "difficulty": "easy",
        "dates": {
          "startDate": DateTime.utc(2026, 7, 16, 9),
          "endDate": DateTime.utc(2026, 7, 16),
        },
        "images": [
          "images/tour_tehran_landmarks_bazaar_1.png",
          "images/tour_tehran_landmarks_bazaar_2.png",
          "images/tour_tehran_landmarks_bazaar_3.png",
          "images/tour_tehran_landmarks_bazaar_4.png",
          "images/tour_tehran_landmarks_bazaar_5.png",
          "images/tour_tehran_landmarks_bazaar_6.png",
          "images/tour_tehran_landmarks_bazaar_7.png",
        ],
        "ratingAvg": 4.7,
        "ratingCount": 180,
        "gearSuggestions": ["comfortable-shoes", "water-bottle"],
        "description":
            "A one-day Tehran city route covering Milad Tower, Tabiat Bridge, Azadi Tower, Golestan Palace, and Tehran Grand Bazaar, with time for landmark views, Qajar-era architecture, and the historic market lanes.",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "tour_tehran_darband_tochal_alborz",
        "origin": {"id": "dest_tehran", "name": "Iran - Tehran"},
        "destination": {"id": "dest_tehran", "name": "Iran - Tehran"},
        "type": "nature",
        "types": ["nature", "adventure"],
        "tripScope": "domestic",
        "name": "Darband, Tochal and Alborz Trails Day",
        "durationDays": 1,
        "groupSizeMax": 12,
        "price": 32,
        "currency": "EUR",
        "includes": ["guide", "local-transport", "snack"],
        "difficulty": "moderate",
        "dates": {
          "startDate": DateTime.utc(2026, 7, 17, 8),
          "endDate": DateTime.utc(2026, 7, 17),
        },
        "images": [
          "images/tour_tehran_darband_tochal_alborz_1.png",
          "images/tour_tehran_darband_tochal_alborz_2.png",
          "images/tour_tehran_darband_tochal_alborz_3.png",
          "images/tour_tehran_darband_tochal_alborz_4.png",
          "images/tour_tehran_darband_tochal_alborz_5.png",
          "images/tour_tehran_darband_tochal_alborz_6.png",
        ],
        "ratingAvg": 4.6,
        "ratingCount": 145,
        "gearSuggestions": ["hiking-shoes", "light-jacket", "water-bottle"],
        "description":
            "A one-day north Tehran outdoor route covering Darband, Tochal cable car, Bam-e Tehran, and accessible Alborz hiking paths, with mountain views and time for a moderate foothill walk.",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "tour_shiraz_persepolis_marvdasht",
        "origin": {"id": "dest_shiraz", "name": "Iran - Shiraz"},
        "destination": {"id": "dest_shiraz", "name": "Iran - Shiraz"},
        "type": "history",
        "tripScope": "domestic",
        "name": "Persepolis and Marvdasht History Day",
        "durationDays": 1,
        "groupSizeMax": 16,
        "price": 45,
        "currency": "EUR",
        "includes": ["guide", "ticket", "local-transport"],
        "difficulty": "easy",
        "dates": {
          "startDate": DateTime.utc(2026, 7, 18, 8),
          "endDate": DateTime.utc(2026, 7, 18),
        },
        "images": [
          "images/tour_shiraz_persepolis_marvdasht_1.jpg",
          "images/tour_shiraz_persepolis_marvdasht_2.jpg",
          "images/tour_shiraz_persepolis_marvdasht_3.jpg",
          "images/tour_shiraz_persepolis_marvdasht_4.jpg",
          "images/tour_shiraz_persepolis_marvdasht_5.jpg",
          "images/tour_shiraz_persepolis_marvdasht_6.jpg",
        ],
        "ratingAvg": 4.8,
        "ratingCount": 230,
        "gearSuggestions": ["hat", "sunscreen", "comfortable-shoes"],
        "description":
            "A one-day historical tour from Shiraz to Persepolis near Marvdasht, focused on the Achaemenid terrace, monumental stairways, palace reliefs, and the archaeological context of ancient Parseh.",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "tour_shiraz_hafez_saadi_nasir",
        "origin": {"id": "dest_shiraz", "name": "Iran - Shiraz"},
        "destination": {"id": "dest_shiraz", "name": "Iran - Shiraz"},
        "type": "history",
        "tripScope": "domestic",
        "name": "Shiraz Poetry and Pink Mosque City Tour",
        "durationDays": 1,
        "groupSizeMax": 14,
        "price": 34,
        "currency": "EUR",
        "includes": ["guide", "ticket", "local-transport"],
        "difficulty": "easy",
        "dates": {
          "startDate": DateTime.utc(2026, 7, 19, 8, 30),
          "endDate": DateTime.utc(2026, 7, 19),
        },
        "images": [
          "images/tour_shiraz_hafez_saadi_nasir_1.jpg",
          "images/tour_shiraz_hafez_saadi_nasir_2.jpg",
          "images/tour_shiraz_hafez_saadi_nasir_3.jpg",
          "images/tour_shiraz_hafez_saadi_nasir_4.jpg",
        ],
        "ratingAvg": 4.7,
        "ratingCount": 190,
        "gearSuggestions": ["comfortable-shoes", "water-bottle"],
        "description":
            "A one-day inner-city historical route through Hafezieh, Saadieh, and Nasir al-Mulk Mosque, combining Persian poetry, garden tombs, Qajar-era stained glass, and old Shiraz neighborhoods.",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "tour_isfahan_naqsh_jahan_bridges",
        "origin": {"id": "dest_isfahan", "name": "Iran - Isfahan"},
        "destination": {"id": "dest_isfahan", "name": "Iran - Isfahan"},
        "type": "city",
        "tripScope": "domestic",
        "name": "Isfahan Naqsh-e Jahan and Bridges",
        "durationDays": 1,
        "groupSizeMax": 16,
        "price": 40,
        "currency": "EUR",
        "includes": ["guide", "ticket", "local-transport"],
        "difficulty": "easy",
        "dates": {
          "startDate": DateTime.utc(2026, 8, 4, 8, 30),
          "endDate": DateTime.utc(2026, 8, 4),
        },
        "images": [
          "images/tour_isfahan_naqsh_jahan_bridges_1.jpg",
          "images/tour_isfahan_naqsh_jahan_bridges_2.png",
          "images/tour_isfahan_naqsh_jahan_bridges_3.jpg",
          "images/tour_isfahan_naqsh_jahan_bridges_4.jpg",
          "images/tour_isfahan_naqsh_jahan_bridges_5.jpg",
          "images/tour_isfahan_naqsh_jahan_bridges_6.jpg",
        ],
        "ratingAvg": 4.8,
        "ratingCount": 260,
        "gearSuggestions": ["comfortable-shoes", "hat", "water-bottle"],
        "description":
            "A one-day city tour covering Naqsh-e Jahan Square, Sheikh Lotfollah Mosque, Ali Qapu Palace, Chehel Sotoun Palace, Si-o-se-pol, and Khaju Bridge, focused on Safavid architecture and Zayandeh Rud landmarks.",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "tour_isfahan_abyaneh_kashan",
        "origin": {"id": "dest_isfahan", "name": "Iran - Isfahan"},
        "destination": {"id": "dest_isfahan", "name": "Iran - Isfahan"},
        "type": "culture",
        "tripScope": "domestic",
        "name": "Abyaneh and Kashan Heritage Day",
        "durationDays": 1,
        "groupSizeMax": 12,
        "price": 48,
        "currency": "EUR",
        "includes": ["guide", "local-transport", "village-entry"],
        "difficulty": "easy",
        "dates": {
          "startDate": DateTime.utc(2026, 8, 6, 7),
          "endDate": DateTime.utc(2026, 8, 6),
        },
        "images": [
          "images/tour_isfahan_abyaneh_kashan_1.jpg",
          "images/tour_isfahan_abyaneh_kashan_2.jpg",
          "images/tour_isfahan_abyaneh_kashan_3.jpg",
          "images/tour_isfahan_abyaneh_kashan_4.jpg",
          "images/tour_isfahan_abyaneh_kashan_5.jpg",
        ],
        "ratingAvg": 4.6,
        "ratingCount": 150,
        "gearSuggestions": ["comfortable-shoes", "hat", "camera"],
        "description":
            "A one-day excursion from Isfahan toward Abyaneh village and Kashan, combining red-clay village architecture, mountain scenery, and Kashan's historic-house and garden heritage zone.",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "tour_kish_gulf_adventure",
        "origin": {"id": "dest_kish", "name": "Iran - Kish"},
        "destination": {"id": "dest_kish", "name": "Iran - Kish"},
        "type": "adventure",
        "tripScope": "domestic",
        "name": "Kish Persian Gulf Adventure Day",
        "durationDays": 1,
        "groupSizeMax": 10,
        "price": 75,
        "currency": "EUR",
        "includes": [
          "guide",
          "diving-session",
          "parasail",
          "glass-bottom-boat",
        ],
        "difficulty": "moderate",
        "dates": {
          "startDate": DateTime.utc(2026, 9, 10, 9),
          "endDate": DateTime.utc(2026, 9, 10),
        },
        "images": [
          "images/tour_kish_gulf_adventure_1.png",
          "images/tour_kish_gulf_adventure_2.png",
          "images/tour_kish_gulf_adventure_3.png",
          "images/tour_kish_gulf_adventure_4.jpg",
        ],
        "ratingAvg": 4.6,
        "ratingCount": 175,
        "gearSuggestions": ["swimwear", "sunscreen", "towel", "waterproof-bag"],
        "description":
            "A one-day adventure tour in Kish with diving in the Persian Gulf, parasailing, glass-bottom boats, and time around Coral Beach for water activities and coastal views.",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "tour_kish_sunset_food_city",
        "origin": {"id": "dest_kish", "name": "Iran - Kish"},
        "destination": {"id": "dest_kish", "name": "Iran - Kish"},
        "type": "city",
        "types": ["city", "culture"],
        "tripScope": "domestic",
        "name": "Kish Sunset, Coastal Route and Dinner",
        "durationDays": 1,
        "groupSizeMax": 12,
        "price": 55,
        "currency": "EUR",
        "includes": ["guide", "dinner", "bike-rental", "local-transport"],
        "difficulty": "easy",
        "dates": {
          "startDate": DateTime.utc(2026, 9, 12, 15),
          "endDate": DateTime.utc(2026, 9, 12),
        },
        "images": [
          "images/tour_kish_sunset_food_city_1.jpg",
          "images/tour_kish_sunset_food_city_2.png",
          "images/tour_kish_sunset_food_city_3.png",
          "images/tour_kish_sunset_food_city_4.jpg",
          "images/tour_kish_sunset_food_city_5.png",
        ],
        "ratingAvg": 4.5,
        "ratingCount": 140,
        "gearSuggestions": ["light-jacket", "comfortable-shoes"],
        "description":
            "A one-day Kish food and city route visiting the Greek Ship, sunset on the west coast, Kish recreational pier, the coastal cycling path, and dinner at a seaside restaurant.",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "tour_qeshm_geopark_adventure",
        "origin": {"id": "dest_qeshm", "name": "Iran - Qeshm"},
        "destination": {"id": "dest_qeshm", "name": "Iran - Qeshm"},
        "type": "adventure",
        "tripScope": "domestic",
        "name": "Qeshm Geopark Adventure Day",
        "durationDays": 1,
        "groupSizeMax": 10,
        "price": 62,
        "currency": "EUR",
        "includes": ["guide", "local-transport", "geopark-entry"],
        "difficulty": "moderate",
        "dates": {
          "startDate": DateTime.utc(2026, 10, 2, 8),
          "endDate": DateTime.utc(2026, 10, 2),
        },
        "images": [
          "images/tour_qeshm_geopark_adventure_1.jpg",
          "images/tour_qeshm_geopark_adventure_2.jpg",
          "images/tour_qeshm_geopark_adventure_3.jpg",
          "images/tour_qeshm_geopark_adventure_4.png",
          "images/tour_qeshm_geopark_adventure_5.png",
        ],
        "ratingAvg": 4.8,
        "ratingCount": 160,
        "gearSuggestions": ["hiking-shoes", "hat", "sunscreen", "water-bottle"],
        "description":
            "A one-day Qeshm adventure and nature route through the Valley of Stars, Chahkooh Canyon, Bam-e Qeshm viewpoints, and Namakdan Salt Cave, focused on the island's UNESCO Global Geopark landscapes.",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "tour_qeshm_hormuz_island",
        "origin": {"id": "dest_qeshm", "name": "Iran - Qeshm"},
        "destination": {"id": "dest_qeshm", "name": "Iran - Qeshm"},
        "type": "nature",
        "types": ["nature", "culture"],
        "tripScope": "domestic",
        "name": "Qeshm to Hormuz Island Day",
        "durationDays": 1,
        "groupSizeMax": 12,
        "price": 48,
        "currency": "EUR",
        "includes": ["guide", "boat", "local-transport"],
        "difficulty": "easy",
        "dates": {
          "startDate": DateTime.utc(2026, 10, 4, 8, 30),
          "endDate": DateTime.utc(2026, 10, 4),
        },
        "images": [
          "images/tour_qeshm_hormuz_island_1.png",
          "images/tour_qeshm_hormuz_island_2.jpg",
          "images/tour_qeshm_hormuz_island_3.jpg",
          "images/tour_qeshm_hormuz_island_4.jpg",
          "images/tour_qeshm_hormuz_island_5.jpg",
        ],
        "ratingAvg": 4.7,
        "ratingCount": 135,
        "gearSuggestions": ["sandals", "hat", "sunscreen", "water-bottle"],
        "description":
            "A one-day tour from Qeshm to Hormuz Island by boat, covering Hormuz's colorful soil landscapes, Rainbow Valley, Portuguese Castle area, coastal viewpoints, and local island culture.",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "tour_rasht_lahijan_food_nature",
        "origin": {"id": "dest_rasht", "name": "Iran - Rasht"},
        "destination": {"id": "dest_rasht", "name": "Iran - Rasht"},
        "type": "nature",
        "types": ["nature", "culture"],
        "tripScope": "domestic",
        "name": "Lahijan Tea Hills and Gilan Food",
        "durationDays": 1,
        "groupSizeMax": 12,
        "price": 34,
        "currency": "EUR",
        "includes": ["guide", "local-transport", "lunch", "tea-tasting"],
        "difficulty": "easy",
        "dates": {
          "startDate": DateTime.utc(2026, 7, 22, 8),
          "endDate": DateTime.utc(2026, 7, 22),
        },
        "images": [
          "images/tour_rasht_lahijan_food_nature_1.jpg",
          "images/tour_rasht_lahijan_food_nature_2.png",
          "images/tour_rasht_lahijan_food_nature_3.jpg",
          "images/tour_rasht_lahijan_food_nature_4.png",
          "images/tour_rasht_lahijan_food_nature_5.png",
        ],
        "ratingAvg": 4.6,
        "ratingCount": 125,
        "gearSuggestions": ["rain-jacket", "comfortable-shoes"],
        "description":
            "A one-day Rasht to Lahijan food and nature tour with tea-field scenery, Sheytan Kooh area views, local tea, and a Gilan-style lunch focused on regional flavors.",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "tour_rasht_masuleh_food_nature",
        "origin": {"id": "dest_rasht", "name": "Iran - Rasht"},
        "destination": {"id": "dest_rasht", "name": "Iran - Rasht"},
        "type": "nature",
        "tripScope": "domestic",
        "name": "Masuleh Mountain Village and Local Food",
        "durationDays": 1,
        "groupSizeMax": 12,
        "price": 38,
        "currency": "EUR",
        "includes": ["guide", "local-transport", "lunch"],
        "difficulty": "moderate",
        "dates": {
          "startDate": DateTime.utc(2026, 7, 23, 8),
          "endDate": DateTime.utc(2026, 7, 23),
        },
        "images": [
          "images/tour_rasht_masuleh_food_nature_1.jpg",
          "images/tour_rasht_masuleh_food_nature_2.jpg",
          "images/tour_rasht_masuleh_food_nature_3.jpg",
          "images/tour_rasht_masuleh_food_nature_4.jpg",
          "images/tour_rasht_masuleh_food_nature_5.jpg",
        ],
        "ratingAvg": 4.7,
        "ratingCount": 150,
        "gearSuggestions": ["walking-shoes", "rain-jacket", "camera"],
        "description":
            "A one-day nature and food route from Rasht to Masuleh, known for stepped village architecture, mountain air, bazaar lanes, and Gilan-style local dishes.",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "tour_hamedan_alisadr_cave",
        "origin": {"id": "dest_hamedan", "name": "Iran - Hamedan"},
        "destination": {"id": "dest_hamedan", "name": "Iran - Hamedan"},
        "type": "adventure",
        "tripScope": "domestic",
        "name": "Ali-Sadr Cave Adventure Day",
        "durationDays": 1,
        "groupSizeMax": 14,
        "price": 44,
        "currency": "EUR",
        "includes": ["guide", "ticket", "local-transport", "boat-route"],
        "difficulty": "easy",
        "dates": {
          "startDate": DateTime.utc(2026, 7, 18, 8),
          "endDate": DateTime.utc(2026, 7, 18),
        },
        "images": [
          "images/tour_hamedan_alisadr_cave_1.png",
          "images/tour_hamedan_alisadr_cave_2.png",
          "images/tour_hamedan_alisadr_cave_3.png",
          "images/tour_hamedan_alisadr_cave_4.png",
          "images/tour_hamedan_alisadr_cave_5.jpg",
          "images/tour_hamedan_alisadr_cave_6.jpg",
        ],
        "ratingAvg": 4.7,
        "ratingCount": 175,
        "gearSuggestions": ["light-jacket", "comfortable-shoes"],
        "description":
            "A one-day adventure from Hamedan to Ali-Sadr Cave, one of Iran's best-known water caves, with guided cave access, boat sections, and surrounding mountain-village scenery.",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "tour_hamedan_city_history_ganjnameh",
        "origin": {"id": "dest_hamedan", "name": "Iran - Hamedan"},
        "destination": {"id": "dest_hamedan", "name": "Iran - Hamedan"},
        "type": "history",
        "tripScope": "domestic",
        "name": "Hamedan Avicenna, Ecbatana and Ganjnameh",
        "durationDays": 1,
        "groupSizeMax": 14,
        "price": 32,
        "currency": "EUR",
        "includes": ["guide", "ticket", "local-transport"],
        "difficulty": "easy",
        "dates": {
          "startDate": DateTime.utc(2026, 7, 20, 9),
          "endDate": DateTime.utc(2026, 7, 20),
        },
        "images": [
          "images/tour_hamedan_city_history_ganjnameh_1.png",
          "images/tour_hamedan_city_history_ganjnameh_2.jpg",
          "images/tour_hamedan_city_history_ganjnameh_3.png",
          "images/tour_hamedan_city_history_ganjnameh_4.png",
          "images/tour_hamedan_city_history_ganjnameh_5.png",
        ],
        "ratingAvg": 4.5,
        "ratingCount": 110,
        "gearSuggestions": ["comfortable-shoes", "water-bottle"],
        "description":
            "A one-day Hamedan city tour covering Avicenna Mausoleum, Ganjnameh inscriptions and waterfall area, the ancient Ecbatana site, and key historic streets around the city center.",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "tour_yazd_old_city_history",
        "origin": {"id": "dest_yazd", "name": "Iran - Yazd"},
        "destination": {"id": "dest_yazd", "name": "Iran - Yazd"},
        "type": "history",
        "tripScope": "domestic",
        "name": "Yazd Old City and Windcatchers",
        "durationDays": 1,
        "groupSizeMax": 14,
        "price": 33,
        "currency": "EUR",
        "includes": ["guide", "ticket", "local-transport"],
        "difficulty": "easy",
        "dates": {
          "startDate": DateTime.utc(2026, 8, 16, 8, 30),
          "endDate": DateTime.utc(2026, 8, 16),
        },
        "images": [
          "images/tour_yazd_old_city_history_1.jpg",
          "images/tour_yazd_old_city_history_2.jpg",
          "images/tour_yazd_old_city_history_3.jpg",
          "images/tour_yazd_old_city_history_4.jpg",
          "images/tour_yazd_old_city_history_5.jpg",
          "images/tour_yazd_old_city_history_6.jpg",
        ],
        "ratingAvg": 4.7,
        "ratingCount": 165,
        "gearSuggestions": ["hat", "comfortable-shoes", "water-bottle"],
        "description":
            "A one-day historical tour in Yazd covering Amir Chakhmaq Square, the UNESCO-listed old city fabric, Yazd windcatchers, Jameh Mosque of Yazd, and Alexander's Prison area.",
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "tour_yazd_desert_meybod_caravanserai",
        "origin": {"id": "dest_yazd", "name": "Iran - Yazd"},
        "destination": {"id": "dest_yazd", "name": "Iran - Yazd"},
        "type": "adventure",
        "tripScope": "domestic",
        "name": "Yazd Desert, Camel Ride and Meybod Caravanserai",
        "durationDays": 1,
        "groupSizeMax": 12,
        "price": 45,
        "currency": "EUR",
        "includes": ["guide", "local-transport", "camel-ride", "dinner"],
        "difficulty": "moderate",
        "dates": {
          "startDate": DateTime.utc(2026, 8, 18, 15),
          "endDate": DateTime.utc(2026, 8, 18),
        },
        "images": [
          "images/tour_yazd_desert_meybod_caravanserai_1.jpg",
          "images/tour_yazd_desert_meybod_caravanserai_2.png",
          "images/tour_yazd_desert_meybod_caravanserai_3.jpg",
          "images/tour_yazd_desert_meybod_caravanserai_4.png",
          "images/tour_yazd_desert_meybod_caravanserai_5.png",
        ],
        "ratingAvg": 4.6,
        "ratingCount": 125,
        "gearSuggestions": ["sunscreen", "hat", "light-jacket", "water-bottle"],
        "description":
            "A one-day Yazd desert experience with desert walking, camel riding, sunset watching, a starry-sky stop, and a visit to Meybod Caravanserai on the heritage route.",
        "createdAt": FieldValue.serverTimestamp(),
      },
    ];
    for (final t in tours) {
      t["types"] ??= [t["type"]];
      t["capacity"] ??= t["groupSizeMax"] ?? 12;
      t["remainingCapacity"] ??= t["capacity"];
      seedSet(db.collection('tours').doc(t["id"] as String), t);
    }

    final attractions = <Map<String, dynamic>>[
      {
        "id": "attr_rasht_bazaar",
        "destination": {"id": "dest_rasht", "name": "Rasht"},
        "name": "Rasht Bazaar",
        "category": "market",
        "description":
            "A lively traditional bazaar known for local foods, tea, rice, olives, fish, and the everyday rhythm of Gilan.",
        "ticketPrice": 0,
        "openHours": "08:00-21:00",
        "location": {
          "lat": 37.2787,
          "lng": 49.5890,
          "address": "Rasht Bazaar, Rasht",
        },
        "images": [
          "images/attr_rasht_bazaar_1.jpg",
          "images/attr_rasht_bazaar_2.jpg",
          "images/attr_rasht_bazaar_3.jpg",
          "images/attr_rasht_bazaar_4.jpg",
          "images/attr_rasht_bazaar_5.jpg",
        ],
        "ratingAvg": 4.7,
        "ratingCount": 860,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "attr_rasht_rudkhan_castle",
        "destination": {"id": "dest_rasht", "name": "Rasht"},
        "name": "Rudkhan Castle",
        "category": "history",
        "description":
            "A forest mountain fortress reached by a scenic stairway through dense Gilan woodland.",
        "ticketPrice": 2,
        "openHours": "08:00-18:00",
        "location": {
          "lat": 37.0680,
          "lng": 49.2384,
          "address": "Rudkhan Castle, Fuman County",
        },
        "images": [
          "images/attr_rasht_rudkhan_castle_1.jpg",
          "images/attr_rasht_rudkhan_castle_2.jpg",
          "images/attr_rasht_rudkhan_castle_3.jpg",
          "images/attr_rasht_rudkhan_castle_4.jpg",
        ],
        "ratingAvg": 4.7,
        "ratingCount": 920,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "attr_kish_kariz",
        "destination": {"id": "dest_kish", "name": "Kish"},
        "name": "Kariz Underground City",
        "category": "culture",
        "description":
            "An underground qanat complex with coral-stone ceilings, heritage passages, shops, and cool island air.",
        "ticketPrice": 5,
        "openHours": "09:00-22:00",
        "location": {
          "lat": 26.5480,
          "lng": 53.9760,
          "address": "Kariz Underground City, Kish",
        },
        "images": [
          "images/attr_kish_kariz_1.jpg",
          "images/attr_kish_kariz_2.jpg",
          "images/attr_kish_kariz_3.jpg",
          "images/attr_kish_kariz_4.jpg",
        ],
        "ratingAvg": 4.6,
        "ratingCount": 780,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "attr_kish_ocean_water_park",
        "destination": {"id": "dest_kish", "name": "Kish"},
        "name": "Ocean Water Park",
        "category": "water park",
        "description":
            "A large themed water park in Kish with slides, pools, family areas, and island-style recreation.",
        "ticketPrice": 18,
        "openHours": "10:00-18:00",
        "location": {
          "lat": 26.5039,
          "lng": 53.9989,
          "address": "Ocean Water Park, Kish",
        },
        "images": [
          "images/attr_kish_ocean_water_park_1.jpg",
          "images/attr_kish_ocean_water_park_2.jpg",
          "images/attr_kish_ocean_water_park_3.jpg",
          "images/attr_kish_ocean_water_park_4.jpg",
        ],
        "ratingAvg": 4.7,
        "ratingCount": 840,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "attr_qeshm_chahkooh_canyon",
        "destination": {"id": "dest_qeshm", "name": "Qeshm"},
        "name": "Chahkooh Canyon",
        "category": "nature",
        "description":
            "A dramatic sandstone canyon with narrow passages, weathered rock walls, and one of Qeshm's most recognizable geopark landscapes.",
        "ticketPrice": 2,
        "openHours": "08:00-18:00",
        "location": {
          "lat": 26.8017,
          "lng": 55.8134,
          "address": "Chahkooh Canyon, Qeshm",
        },
        "images": [
          "images/attr_qeshm_chahkooh_canyon_1.jpg",
          "images/attr_qeshm_chahkooh_canyon_2.jpg",
          "images/attr_qeshm_chahkooh_canyon_3.jpg",
          "images/attr_qeshm_chahkooh_canyon_4.jpg",
        ],
        "ratingAvg": 4.8,
        "ratingCount": 930,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "attr_qeshm_hara_forest",
        "destination": {"id": "dest_qeshm", "name": "Qeshm"},
        "name": "Hara Mangrove Forest",
        "category": "nature",
        "description":
            "Protected mangrove forests in the Persian Gulf, best explored by local boat at high tide.",
        "ticketPrice": 4,
        "openHours": "08:00-18:00",
        "location": {
          "lat": 26.8978,
          "lng": 55.7596,
          "address": "Hara Forest, Qeshm",
        },
        "images": [
          "images/attr_qeshm_hara_forest_1.jpg",
          "images/attr_qeshm_hara_forest_2.png",
          "images/attr_qeshm_hara_forest_3.jpg",
          "images/attr_qeshm_hara_forest_4.png",
        ],
        "ratingAvg": 4.8,
        "ratingCount": 1010,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "attr_yazd_dolatabad_garden",
        "destination": {"id": "dest_yazd", "name": "Yazd"},
        "name": "Dolat Abad Garden",
        "category": "culture",
        "description":
            "A Persian garden famous for its tall windcatcher, pavilions, pools, and traditional Yazd architecture.",
        "ticketPrice": 3,
        "openHours": "08:00-22:00",
        "location": {
          "lat": 31.8973,
          "lng": 54.3576,
          "address": "Dolat Abad Garden, Yazd",
        },
        "images": [
          "images/attr_yazd_dolatabad_garden_1.jpg",
          "images/attr_yazd_dolatabad_garden_2.jpg",
          "images/attr_yazd_dolatabad_garden_3.jpg",
          "images/attr_yazd_dolatabad_garden_4.jpg",
        ],
        "ratingAvg": 4.7,
        "ratingCount": 870,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "attr_yazd_fire_temple",
        "destination": {"id": "dest_yazd", "name": "Yazd"},
        "name": "Yazd Fire Temple",
        "category": "history",
        "description":
            "A Zoroastrian fire temple with a preserved sacred flame and displays about Yazd's religious heritage.",
        "ticketPrice": 2,
        "openHours": "08:00-20:00",
        "location": {
          "lat": 31.8919,
          "lng": 54.3607,
          "address": "Yazd Fire Temple, Yazd",
        },
        "images": [
          "images/attr_yazd_fire_temple_1.jpg",
          "images/attr_yazd_fire_temple_2.jpg",
          "images/attr_yazd_fire_temple_3.jpg",
          "images/attr_yazd_fire_temple_4.jpg",
        ],
        "ratingAvg": 4.6,
        "ratingCount": 740,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "attr_shiraz_eram_garden",
        "destination": {"id": "dest_shiraz", "name": "Shiraz"},
        "name": "Eram Garden",
        "category": "garden",
        "description":
            "A celebrated Persian garden with cypress trees, flowerbeds, water channels, and a historic Qajar mansion.",
        "ticketPrice": 3,
        "openHours": "08:00-20:00",
        "location": {
          "lat": 29.6350,
          "lng": 52.5255,
          "address": "Eram Garden, Shiraz",
        },
        "images": [
          "images/attr_shiraz_eram_garden_1.jpg",
          "images/attr_shiraz_eram_garden_2.jpg",
          "images/attr_shiraz_eram_garden_3.jpg",
          "images/attr_shiraz_eram_garden_4.jpg",
        ],
        "ratingAvg": 4.8,
        "ratingCount": 1120,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "attr_shiraz_vakil_bazaar",
        "destination": {"id": "dest_shiraz", "name": "Shiraz"},
        "name": "Vakil Bazaar",
        "category": "market",
        "description":
            "A historic covered bazaar with brick arches, caravanserai courtyards, carpets, spices, and Shirazi crafts.",
        "ticketPrice": 0,
        "openHours": "09:00-21:00",
        "location": {
          "lat": 29.6156,
          "lng": 52.5467,
          "address": "Vakil Bazaar, Shiraz",
        },
        "images": [
          "images/attr_shiraz_vakil_bazaar_1.jpg",
          "images/attr_shiraz_vakil_bazaar_2.jpg",
          "images/attr_shiraz_vakil_bazaar_3.jpg",
          "images/attr_shiraz_vakil_bazaar_4.jpg",
          "images/attr_shiraz_vakil_bazaar_5.jpg",
        ],
        "ratingAvg": 4.7,
        "ratingCount": 980,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "attr_hamedan_baba_taher_tomb",
        "destination": {"id": "dest_hamedan", "name": "Hamedan"},
        "name": "Baba Taher Mausoleum",
        "category": "history",
        "description":
            "A landmark mausoleum dedicated to the Persian poet Baba Taher, set in a central Hamedan square.",
        "ticketPrice": 1,
        "openHours": "08:00-20:00",
        "location": {
          "lat": 34.8067,
          "lng": 48.5134,
          "address": "Baba Taher Square, Hamedan",
        },
        "images": [
          "images/attr_hamedan_baba_taher_tomb_1.jpg",
          "images/attr_hamedan_baba_taher_tomb_2.jpg",
          "images/attr_hamedan_baba_taher_tomb_3.jpg",
        ],
        "ratingAvg": 4.6,
        "ratingCount": 690,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "attr_hamedan_mishan_plain",
        "destination": {"id": "dest_hamedan", "name": "Hamedan"},
        "name": "Mishan Plain",
        "category": "nature",
        "description":
            "A mountain plain on the Alvand route, popular for hiking, cool weather, and wide Hamedan views.",
        "ticketPrice": 0,
        "openHours": "00:00-23:59",
        "location": {
          "lat": 34.7310,
          "lng": 48.4420,
          "address": "Mishan Plain, Alvand Mountain, Hamedan",
        },
        "images": [
          "images/attr_hamedan_mishan_plain_1.jpg",
          "images/attr_hamedan_mishan_plain_2.jpg",
          "images/attr_hamedan_mishan_plain_3.jpg",
          "images/attr_hamedan_mishan_plain_4.jpg",
          "images/attr_hamedan_mishan_plain_5.jpg",
        ],
        "ratingAvg": 4.7,
        "ratingCount": 610,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "attr_tehran_chitgar_lake",
        "destination": {"id": "dest_tehran", "name": "Tehran"},
        "name": "Chitgar Lake",
        "category": "point of interest",
        "description":
            "A large urban lake in west Tehran with walking paths, restaurants, cycling, and evening skyline views.",
        "ticketPrice": 0,
        "openHours": "00:00-23:59",
        "location": {
          "lat": 35.7447,
          "lng": 51.2146,
          "address": "Chitgar Lake, Tehran",
        },
        "images": [
          "images/attr_tehran_chitgar_lake_1.jpg",
          "images/attr_tehran_chitgar_lake_2.jpg",
          "images/attr_tehran_chitgar_lake_3.jpg",
          "images/attr_tehran_chitgar_lake_4.jpg",
          "images/attr_tehran_chitgar_lake_5.jpg",
        ],
        "ratingAvg": 4.5,
        "ratingCount": 1050,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "attr_tehran_lalan_village",
        "destination": {"id": "dest_tehran", "name": "Tehran"},
        "name": "Lalan Village",
        "category": "nature",
        "description":
            "A mountain village near Tehran known for cool weather, walking routes, gardens, and access to Alborz foothill scenery.",
        "ticketPrice": 0,
        "openHours": "00:00-23:59",
        "location": {
          "lat": 35.9870,
          "lng": 51.5950,
          "address": "Lalan Village, Shemiranat, Tehran Province",
        },
        "images": [
          "images/attr_tehran_lalan_village_1.jpg",
          "images/attr_tehran_lalan_village_2.jpg",
          "images/attr_tehran_lalan_village_3.jpg",
          "images/attr_tehran_lalan_village_4.jpg",
          "images/attr_tehran_lalan_village_5.jpg",
          "images/attr_tehran_lalan_village_6.jpg",
        ],
        "ratingAvg": 4.6,
        "ratingCount": 820,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "attr_isfahan_vank_cathedral",
        "destination": {"id": "dest_isfahan", "name": "Isfahan"},
        "name": "Vank Cathedral",
        "category": "culture",
        "description":
            "An Armenian cathedral in Jolfa with frescoes, a museum, and a distinct chapter of Isfahan's cultural history.",
        "ticketPrice": 3,
        "openHours": "08:30-17:30",
        "location": {
          "lat": 32.6349,
          "lng": 51.6566,
          "address": "Vank Cathedral, Jolfa, Isfahan",
        },
        "images": [
          "images/attr_isfahan_vank_cathedral_1.jpg",
          "images/attr_isfahan_vank_cathedral_2.jpg",
          "images/attr_isfahan_vank_cathedral_3.jpg",
          "images/attr_isfahan_vank_cathedral_4.jpg",
        ],
        "ratingAvg": 4.7,
        "ratingCount": 890,
        "createdAt": FieldValue.serverTimestamp(),
      },
      {
        "id": "attr_isfahan_bazaar",
        "destination": {"id": "dest_isfahan", "name": "Isfahan"},
        "name": "Isfahan Bazaar",
        "category": "market",
        "description":
            "A historic bazaar route around Naqsh-e Jahan Square with handicrafts, carpets, copperwork, sweets, and old caravanserais.",
        "ticketPrice": 0,
        "openHours": "09:00-21:00",
        "location": {
          "lat": 32.6600,
          "lng": 51.6750,
          "address": "Grand Bazaar, Isfahan",
        },
        "images": [
          "images/attr_isfahan_bazaar_1.jpg",
          "images/attr_isfahan_bazaar_2.jpg",
          "images/attr_isfahan_bazaar_3.jpg",
          "images/attr_isfahan_bazaar_4.jpg",
          "images/attr_isfahan_bazaar_5.jpg",
        ],
        "ratingAvg": 4.7,
        "ratingCount": 1180,
        "createdAt": FieldValue.serverTimestamp(),
      },
    ];
    for (final a in attractions) {
      seedSet(db.collection('attractions').doc(a["id"] as String), a);
    }

    final transports = _buildTransports(destinations);
    for (final t in transports) {
      seedSet(db.collection('transports').doc(t["id"] as String), t);
    }

    final reviews = <Map<String, dynamic>>[];
    for (final a in activeAccommodations) {
      reviews.addAll([
        {
          "id": "rev_${a['id']}_1",
          "targetType": "accommodation",
          "targetId": a["id"],
          "userId": "sara_1",
          "rating": (a['stars'] ?? 4),
          "text":
              "I really enjoyed staying at ${a['name']}. The location was convenient and the room was clean.",
          "createdAt": DateTime.utc(2026, 6, 10),
        },
        {
          "id": "rev_${a['id']}_2",
          "targetType": "accommodation",
          "targetId": a["id"],
          "userId": "john_2",
          "rating": ((a['stars'] ?? 3)),
          "text":
              "${a['name']} was comfortable and easy to reach from the main sights.",
          "createdAt": DateTime.utc(2026, 6, 12),
        },
      ]);
    }

    for (final t in tours) {
      reviews.addAll([
        {
          "id": "rev_${t['id']}_1",
          "targetType": "tour",
          "targetId": t["id"],
          "userId": "alice_3",
          "rating": (t['ratingAvg'] ?? 4),
          "text":
              "The ${t['name']} was well organized and the guide gave useful context.",
          "createdAt": DateTime.utc(2026, 7, 20),
        },
        {
          "id": "rev_${t['id']}_2",
          "targetType": "tour",
          "targetId": t["id"],
          "userId": "mark_4",
          "rating": ((t['ratingAvg'] ?? 4.5)),
          "text":
              "Really enjoyed ${t['name']}. The pacing worked well for a short Europe trip.",
          "createdAt": DateTime.utc(2026, 7, 22),
        },
      ]);
    }
    for (final r in reviews) {
      seedSet(db.collection('reviews').doc(r["id"] as String), r);
    }

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
          "washer",
          "rooftop",
          "restaurant",
          "garden",
          "coffee-shop",
          "laundry",
          "sea-view",
          "local-breakfast",
          "mountain-view",
        ],
        "tourTypes": ["nature", "city", "adventure", "culture", "history"],
        "tags": [
          "architecture",
          "art",
          "beach",
          "canals",
          "culture",
          "cycling",
          "food",
          "history",
          "mountain",
          "museums",
          "nature",
          "theatre",
        ],
      },
    };
    seedSet(db.collection('system').doc('config'), config);

    await _commitSeedWrites(db, writes);
  }

  static List<Map<String, dynamic>> _buildTransports(
    List<Map<String, dynamic>> destinations,
  ) {
    const departureSlots = [
      [8, 15],
      [17, 45],
    ];
    final result = <Map<String, dynamic>>[];

    for (final from in destinations) {
      for (final to in destinations) {
        if (from["id"] == to["id"]) continue;

        final fromId = from["id"] as String;
        final toId = to["id"] as String;
        final fromCity = from["city"] as String;
        final toCity = to["city"] as String;
        final distance = _distanceKm(from, to);
        final routeModes = _transportModesFor(fromId, toId, distance);

        for (var i = 0; i < routeModes.length; i++) {
          final mode = routeModes[i];
          final slot = departureSlots[i];
          final depart = DateTime.utc(
            2026,
            7 + ((fromCity.length + toCity.length + i) % 5),
            16 + ((fromCity.length * 3 + toCity.length + i * 5) % 12),
            slot[0],
            slot[1],
          );
          final durationHours = _durationHours(mode, distance);
          final arrive = depart.add(
            Duration(minutes: (durationHours * 60).round()),
          );

          result.add({
            "id": "tr_${_slug(fromCity)}_${_slug(toCity)}_${mode}_${i + 1}",
            "mode": mode,
            "operator": _operatorFor(mode, fromId, toId),
            "company": _operatorFor(mode, fromId, toId),
            if (mode == "flight")
              "flightNumber": _transportNumber(mode, fromId, toId, i),
            if (mode == "train")
              "trainNumber": _transportNumber(mode, fromId, toId, i),
            "from": {"code": fromId, "city": fromCity},
            "to": {"code": toId, "city": toCity},
            "schedule": {"departAt": depart, "arriveAt": arrive},
            "images": [_transportImageFor(toId)],
            "basePrice": _transportPrice(mode, distance),
            "currency": "USD",
            "capacity": _transportCapacity(mode),
            "remainingCapacity": _transportCapacity(mode),
            "createdAt": FieldValue.serverTimestamp(),
          });
        }
      }
    }
    return result;
  }

  static Future<void> _commitSeedWrites(
    FirebaseFirestore db,
    List<_SeedWrite> writes,
  ) async {
    const maxBatchSize = 450;
    for (var i = 0; i < writes.length; i += maxBatchSize) {
      final batch = db.batch();
      final end =
          i + maxBatchSize > writes.length ? writes.length : i + maxBatchSize;
      for (final write in writes.sublist(i, end)) {
        batch.set(write.ref, write.data);
      }
      await batch.commit();
    }
  }

  static Future<void> _deleteCollection(
    CollectionReference<Map<String, dynamic>> collection,
  ) async {
    const maxBatchSize = 450;
    final snapshot = await collection.get();
    for (var i = 0; i < snapshot.docs.length; i += maxBatchSize) {
      final batch = collection.firestore.batch();
      final end =
          i + maxBatchSize > snapshot.docs.length
              ? snapshot.docs.length
              : i + maxBatchSize;
      for (final doc in snapshot.docs.sublist(i, end)) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }
  }

  static List<String> _transportModesFor(
    String fromId,
    String toId,
    double distanceKm,
  ) {
    final hasIsland = {
      fromId,
      toId,
    }.any((id) => id == "dest_kish" || id == "dest_qeshm");
    if (hasIsland) return const ["flight", "taxi"];
    if (distanceKm > 650) return const ["flight", "train"];
    if ({fromId, toId}.contains("dest_rasht")) {
      return const ["bus", "taxi"];
    }
    return const ["train", "taxi"];
  }

  static String _operatorFor(String mode, String fromId, String toId) {
    if (mode == "bus") return "Iran Peyma / Seiro Safar";
    if (mode == "taxi") return "Snapp / Intercity Taxi";
    if (mode == "train") {
      if ({fromId, toId}.contains("dest_tehran")) return "Raja Rail";
      return "Railways of the Islamic Republic of Iran";
    }
    if ({fromId, toId}.contains("dest_kish") ||
        {fromId, toId}.contains("dest_qeshm")) {
      return "Iran Air / Kish Air";
    }
    return "Iran Air / Mahan Air";
  }

  static String _transportNumber(
    String mode,
    String fromId,
    String toId,
    int index,
  ) {
    final fromCode = _routeCode(fromId);
    final toCode = _routeCode(toId);
    final number = 100 + fromCode.codeUnitAt(0) + toCode.codeUnitAt(0) + index;
    if (mode == "flight") return "ST-$fromCode$toCode-$number";
    if (mode == "train") return "TR-$fromCode$toCode-$number";
    return "$fromCode$toCode-$number";
  }

  static String _routeCode(String destinationId) {
    return switch (destinationId) {
      "dest_tehran" => "THR",
      "dest_hamedan" => "HDN",
      "dest_shiraz" => "SYZ",
      "dest_isfahan" => "IFN",
      "dest_yazd" => "YZD",
      "dest_qeshm" => "GSM",
      "dest_kish" => "KIH",
      "dest_rasht" => "RAS",
      _ => "IRN",
    };
  }

  static num _transportPrice(String mode, double distanceKm) {
    final base = switch (mode) {
      "bus" => 4 + distanceKm * 0.018,
      "train" => 6 + distanceKm * 0.026,
      "taxi" => 12 + distanceKm * 0.095,
      _ => 35 + distanceKm * 0.075,
    };
    return (base / 5).round() * 5;
  }

  static int _transportCapacity(String mode) {
    return switch (mode) {
      "bus" => 44,
      "train" => 80,
      "taxi" => 4,
      _ => 120,
    };
  }

  static double _durationHours(String mode, double distanceKm) {
    return switch (mode) {
      "bus" => (distanceKm / 70).clamp(2, 18).toDouble(),
      "train" => (distanceKm / 120).clamp(2, 14).toDouble(),
      "taxi" => (distanceKm / 80).clamp(1.5, 16).toDouble(),
      _ => (distanceKm / 600 + 1.5).clamp(1.5, 4).toDouble(),
    };
  }

  static String _transportImageFor(String destinationId) {
    return switch (destinationId) {
      "dest_tehran" => "images/transport_Tehran.jpg",
      "dest_hamedan" => "images/transport_Hamedan.jpg",
      "dest_shiraz" => "images/transport_Shiraz.jpg",
      "dest_isfahan" => "images/transport_Esfahan.jpg",
      "dest_yazd" => "images/transport_Yazd.jpg",
      "dest_qeshm" => "images/transport_Qeshm.jpg",
      "dest_kish" => "images/transport_Kish.jpg",
      "dest_rasht" => "images/transport_Rasht.jpg",
      _ => "images/pic6.jpg",
    };
  }

  static double _distanceKm(
    Map<String, dynamic> from,
    Map<String, dynamic> to,
  ) {
    final fromGeo = from["geo"] as Map<String, dynamic>;
    final toGeo = to["geo"] as Map<String, dynamic>;
    final latDiff = ((fromGeo["lat"] as num) - (toGeo["lat"] as num)).abs();
    final lngDiff = ((fromGeo["lng"] as num) - (toGeo["lng"] as num)).abs();
    return ((latDiff * 111) + (lngDiff * 75)).clamp(80, 1800).toDouble();
  }

  static String _slug(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp(r"[^a-z0-9]+"), "_")
        .replaceAll(RegExp(r"(^_|_$)"), "");
  }
}

class _SeedWrite {
  const _SeedWrite(this.ref, this.data);

  final DocumentReference<Map<String, dynamic>> ref;
  final Map<String, dynamic> data;
}
