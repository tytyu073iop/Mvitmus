import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:latlong2/latlong.dart';
import '../models/district.dart';
import '../models/museum.dart';
import '../models/exhibition.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('vitmus.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE districts (
        id INTEGER PRIMARY KEY,
        name_ru TEXT NOT NULL,
        name_en TEXT NOT NULL,
        name_be TEXT NOT NULL,
        center_lat REAL NOT NULL,
        center_lng REAL NOT NULL,
        polygon_json TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE museums (
        id INTEGER PRIMARY KEY,
        district_id INTEGER NOT NULL,
        name_ru TEXT NOT NULL,
        name_en TEXT NOT NULL,
        name_be TEXT NOT NULL,
        desc_ru TEXT NOT NULL,
        desc_en TEXT NOT NULL,
        desc_be TEXT NOT NULL,
        address_ru TEXT NOT NULL,
        address_en TEXT NOT NULL,
        address_be TEXT NOT NULL,
        lat REAL NOT NULL,
        lng REAL NOT NULL,
        FOREIGN KEY (district_id) REFERENCES districts(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE exhibitions (
        id INTEGER PRIMARY KEY,
        museum_id INTEGER NOT NULL,
        name_ru TEXT NOT NULL,
        name_en TEXT NOT NULL,
        name_be TEXT NOT NULL,
        desc_ru TEXT NOT NULL,
        desc_en TEXT NOT NULL,
        desc_be TEXT NOT NULL,
        start_date TEXT NOT NULL,
        end_date TEXT NOT NULL,
        price REAL NOT NULL,
        FOREIGN KEY (museum_id) REFERENCES museums(id)
      )
    ''');

    await _seedData(db);
  }

  Future<void> _seedData(Database db) async {
    final batch = db.batch();
    batch.insert('districts', {
      'id': 1,
      'name_ru': 'Железнодорожный район',
      'name_en': 'Zheleznodorozhny District',
      'name_be': 'Чыгуначны раён',
      'center_lat': 55.1904,
      'center_lng': 30.2049,
      'polygon_json':
          '[[55.210,30.170],[55.210,30.240],[55.170,30.240],[55.170,30.170]]',
    });
    batch.insert('districts', {
      'id': 2,
      'name_ru': 'Октябрьский район',
      'name_en': 'Oktyabrsky District',
      'name_be': 'Кастрычніцкі раён',
      'center_lat': 55.1880,
      'center_lng': 30.1950,
      'polygon_json':
          '[[55.200,30.160],[55.200,30.230],[55.160,30.230],[55.160,30.160]]',
    });
    batch.insert('districts', {
      'id': 3,
      'name_ru': 'Первомайский район',
      'name_en': 'Pervomaisky District',
      'name_be': 'Першамайскі раён',
      'center_lat': 55.1780,
      'center_lng': 30.2150,
      'polygon_json':
          '[[55.190,30.180],[55.190,30.250],[55.150,30.250],[55.150,30.180]]',
    });

    batch.insert('museums', {
      'id': 1,
      'district_id': 2,
      'name_ru': 'Художественный музей',
      'name_en': 'Vitebsk Art Museum',
      'name_be': 'Мастацкі музей',
      'desc_ru': 'Коллекция белорусского изобразительного искусства XVIII–XXI веков.',
      'desc_en': 'Collection of Belarusian fine art from the 18th to 21st centuries.',
      'desc_be': 'Калекцыя беларускага выяўленчага мастацтва XVIII–XXI стагоддзяў.',
      'address_ru': 'ул. Ленина, 32',
      'address_en': 'Lenina st., 32',
      'address_be': 'вул. Леніна, 32',
      'lat': 55.1925,
      'lng': 30.2030,
    });
    batch.insert('museums', {
      'id': 2,
      'district_id': 2,
      'name_ru': 'Музей Марка Шагала',
      'name_en': 'Marc Chagall Museum',
      'name_be': 'Музей Марка Шагала',
      'desc_ru': 'Мемориальный музей, посвящённый жизни и творчеству Марка Шагала.',
      'desc_en': 'Memorial museum dedicated to the life and work of Marc Chagall.',
      'desc_be': 'Мемарыяльны музей, прысвечаны жыццю і творчасці Марка Шагала.',
      'address_ru': 'ул. Покровская, 11',
      'address_en': 'Pokrovskaya st., 11',
      'address_be': 'вул. Пакроўская, 11',
      'lat': 55.1928,
      'lng': 30.1975,
    });
    batch.insert('museums', {
      'id': 3,
      'district_id': 2,
      'name_ru': 'Витебский областной краеведческий музей',
      'name_en': 'Vitebsk Regional Museum of Local Lore',
      'name_be': 'Віцебскі абласны краязнаўчы музей',
      'desc_ru': 'История, природа и культура Витебщины.',
      'desc_en': 'History, nature and culture of the Vitebsk region.',
      'desc_be': 'Гісторыя, прырода і культура Віцебшчыны.',
      'address_ru': 'ул. Ленина, 36',
      'address_en': 'Lenina st., 36',
      'address_be': 'вул. Леніна, 36',
      'lat': 55.1923,
      'lng': 30.2035,
    });
    batch.insert('museums', {
      'id': 4,
      'district_id': 2,
      'name_ru': 'Духовской круглик',
      'name_en': 'Dukhovsky Kruglik',
      'name_be': 'Духаўскі круглік',
      'desc_ru': 'Музей истории Витебска в восстановленной башне.',
      'desc_en': 'A museum of Vitebsk history located in a reconstructed tower.',
      'desc_be': 'Музей гісторыі Віцебска ў адноўленай вежы.',
      'address_ru': 'ул. Замковая, 1',
      'address_en': 'Zamkovaya st., 1',
      'address_be': 'вул. Замкавая, 1',
      'lat': 55.1945,
      'lng': 30.2040,
    });
    batch.insert('museums', {
      'id': 5,
      'district_id': 1,
      'name_ru': 'Музей-усадьба И.Е. Репина «Здравнёво»',
      'name_en': "Repin Estate Museum 'Zdravnevo'",
      'name_be': 'Сядзіба І.Я. Рэпіна «Здраўнёва»',
      'desc_ru': 'Усадьба великого русского художника Ильи Репина под Витебском.',
      'desc_en': 'The estate of Ilya Repin, a great Russian painter, near Vitebsk.',
      'desc_be': 'Сядзіба вялікага рускага мастака Іллі Рэпіна пад Віцебскам.',
      'address_ru': 'д. Здравнёво, 17 км от Витебска',
      'address_en': 'Zdravnevo village, 17 km from Vitebsk',
      'address_be': 'в. Здраўнёва, 17 км ад Віцебска',
      'lat': 55.2500,
      'lng': 30.2500,
    });
    batch.insert('museums', {
      'id': 6,
      'district_id': 3,
      'name_ru': 'Музей истории Витебского художественного училища',
      'name_en': 'Museum of Vitebsk Art School',
      'name_be': 'Музей гісторыі Віцебскай мастацкай вучэльні',
      'desc_ru': 'История Витебского народного художественного училища (1918–1923).',
      'desc_en': 'The history of the Vitebsk People\'s Art School (1918–1923).',
      'desc_be': 'Гісторыя Віцебскага народнага мастацкага вучылішча (1918–1923).',
      'address_ru': 'ул. Марка Шагала, 5а',
      'address_en': 'Marka Shagala st., 5a',
      'address_be': 'вул. Марка Шагала, 5а',
      'lat': 55.1910,
      'lng': 30.1860,
    });
    batch.insert('museums', {
      'id': 7,
      'district_id': 2,
      'name_ru': 'Дом-музей Марка Шагала',
      'name_en': 'Marc Chagall House-Museum',
      'name_be': 'Дом-музей Марка Шагала',
      'desc_ru': 'Дом, в котором жил Марк Шагал со своей семьёй.',
      'desc_en': 'The house where Marc Chagall lived with his family.',
      'desc_be': 'Дом, у якім жыў Марк Шагал са сваёй сям\'ёй.',
      'address_ru': 'ул. Покровская, 29',
      'address_en': 'Pokrovskaya st., 29',
      'address_be': 'вул. Пакроўская, 29',
      'lat': 55.1935,
      'lng': 30.1960,
    });
    batch.insert('museums', {
      'id': 8,
      'district_id': 3,
      'name_ru': 'Центр современного искусства',
      'name_en': 'Vitebsk Center of Contemporary Art',
      'name_be': 'Цэнтр сучаснага мастацтва',
      'desc_ru': 'Выставки и инсталляции современного искусства.',
      'desc_en': 'Modern art exhibitions and installations.',
      'desc_be': 'Выставы і інсталяцыі сучаснага мастацтва.',
      'address_ru': 'ул. Покровская, 9',
      'address_en': 'Pokrovskaya st., 9',
      'address_be': 'вул. Пакроўская, 9',
      'lat': 55.1925,
      'lng': 30.1985,
    });
    batch.insert('museums', {
      'id': 9,
      'district_id': 1,
      'name_ru': 'Музей-усадьба «Крынки»',
      'name_en': 'Krynki Museum-Estate',
      'name_be': 'Музей-сядзіба «Крынкі»',
      'desc_ru': 'Этнографический комплекс с традиционной белорусской архитектурой.',
      'desc_en': 'An ethnographic complex with traditional Belarusian architecture.',
      'desc_be': 'Этнаграфічны комплекс з традыцыйнай беларускай архітэктурай.',
      'address_ru': 'д. Крынки',
      'address_en': 'Krynki village',
      'address_be': 'в. Крынкі',
      'lat': 55.2200,
      'lng': 30.3100,
    });

    batch.insert('exhibitions', {
      'id': 1,
      'museum_id': 1,
      'name_ru': 'Постоянная экспозиция',
      'name_en': 'Permanent Exhibition',
      'name_be': 'Пастаянная экспазіцыя',
      'desc_ru': 'Основная коллекция музея.',
      'desc_en': 'The main collection of the museum.',
      'desc_be': 'Асноўная калекцыя музея.',
      'start_date': '2024-01-01',
      'end_date': '2026-12-31',
      'price': 8.0,
    });
    batch.insert('exhibitions', {
      'id': 2,
      'museum_id': 2,
      'name_ru': 'Постоянная экспозиция',
      'name_en': 'Permanent Exhibition',
      'name_be': 'Пастаянная экспазіцыя',
      'desc_ru': 'Основная коллекция музея.',
      'desc_en': 'The main collection of the museum.',
      'desc_be': 'Асноўная калекцыя музея.',
      'start_date': '2024-01-01',
      'end_date': '2026-12-31',
      'price': 10.0,
    });
    batch.insert('exhibitions', {
      'id': 3,
      'museum_id': 3,
      'name_ru': 'Постоянная экспозиция',
      'name_en': 'Permanent Exhibition',
      'name_be': 'Пастаянная экспазіцыя',
      'desc_ru': 'Основная коллекция музея.',
      'desc_en': 'The main collection of the museum.',
      'desc_be': 'Асноўная калекцыя музея.',
      'start_date': '2024-01-01',
      'end_date': '2026-12-31',
      'price': 6.0,
    });
    batch.insert('exhibitions', {
      'id': 4,
      'museum_id': 4,
      'name_ru': 'Экспозиция истории Витебска',
      'name_en': 'Vitebsk History Exhibition',
      'name_be': 'Экспазіцыя гісторыі Віцебска',
      'desc_ru': 'История города от древности до наших дней.',
      'desc_en': 'City history from ancient times to the present day.',
      'desc_be': 'Гісторыя горада ад старажытнасці да нашых дзён.',
      'start_date': '2024-05-01',
      'end_date': '2026-10-01',
      'price': 5.0,
    });
    batch.insert('exhibitions', {
      'id': 5,
      'museum_id': 5,
      'name_ru': 'Жизнь и творчество И.Е. Репина',
      'name_en': 'Life and Work of Ilya Repin',
      'name_be': 'Жыццё і творчасць І.Я. Рэпіна',
      'desc_ru': 'Сезонная выставка, посвящённая великому художнику.',
      'desc_en': 'A seasonal exhibition dedicated to the great painter.',
      'desc_be': 'Сезонная выстава, прысвечаная вялікаму мастаку.',
      'start_date': '2026-05-01',
      'end_date': '2026-09-30',
      'price': 7.0,
    });
    batch.insert('exhibitions', {
      'id': 6,
      'museum_id': 6,
      'name_ru': 'Постоянная экспозиция',
      'name_en': 'Permanent Exhibition',
      'name_be': 'Пастаянная экспазіцыя',
      'desc_ru': 'История Витебского народного художественного училища.',
      'desc_en': 'History of the Vitebsk People\'s Art School.',
      'desc_be': 'Гісторыя Віцебскага народнага мастацкага вучылішча.',
      'start_date': '2024-01-01',
      'end_date': '2026-12-31',
      'price': 5.0,
    });
    batch.insert('exhibitions', {
      'id': 7,
      'museum_id': 7,
      'name_ru': 'Мемориальная экспозиция',
      'name_en': 'Memorial Exhibition',
      'name_be': 'Мемарыяльная экспазіцыя',
      'desc_ru': 'Личные вещи и документы семьи Шагала.',
      'desc_en': 'Personal belongings and documents of the Chagall family.',
      'desc_be': 'Асабістыя рэчы і дакументы сям\'і Шагала.',
      'start_date': '2024-01-01',
      'end_date': '2026-12-31',
      'price': 10.0,
    });
    batch.insert('exhibitions', {
      'id': 8,
      'museum_id': 8,
      'name_ru': 'Современное искусство Беларуси',
      'name_en': 'Contemporary Art of Belarus',
      'name_be': 'Сучаснае мастацтва Беларусі',
      'desc_ru': 'Работы современных белорусских художников.',
      'desc_en': 'Works by contemporary Belarusian artists.',
      'desc_be': 'Работы сучасных беларускіх мастакоў.',
      'start_date': '2026-06-01',
      'end_date': '2026-12-31',
      'price': 4.0,
    });
    batch.insert('exhibitions', {
      'id': 9,
      'museum_id': 9,
      'name_ru': 'Этнографическая экспозиция',
      'name_en': 'Ethnographic Exhibition',
      'name_be': 'Этнаграфічная экспазіцыя',
      'desc_ru': 'Традиционный быт и культура белорусов.',
      'desc_en': 'Traditional Belarusian life and culture.',
      'desc_be': 'Традыцыйны побыт і культура беларусаў.',
      'start_date': '2024-01-01',
      'end_date': '2026-12-31',
      'price': 0.0,
    });
    await batch.commit();
  }

  Future<List<District>> getDistricts() async {
    final db = await database;
    final maps = await db.query('districts');
    return maps.map((map) {
      final center =
          LatLng(map['center_lat'] as double, map['center_lng'] as double);
      final polyJson = map['polygon_json'] as String;
      final polyList = (jsonDecode(polyJson) as List).map((p) {
        final arr = p as List;
        return LatLng(arr[0] as double, arr[1] as double);
      }).toList();
      return District(
        id: map['id'] as int,
        nameRu: map['name_ru'] as String,
        nameEn: map['name_en'] as String,
        nameBe: map['name_be'] as String,
        center: center,
        polygon: polyList,
      );
    }).toList();
  }

  Future<List<Museum>> getMuseumsByDistrict(int districtId) async {
    final db = await database;
    final maps = await db.query('museums',
        where: 'district_id = ?', whereArgs: [districtId]);
    return maps.map((map) {
      return Museum(
        id: map['id'] as int,
        districtId: map['district_id'] as int,
        nameRu: map['name_ru'] as String,
        nameEn: map['name_en'] as String,
        nameBe: map['name_be'] as String,
        descRu: map['desc_ru'] as String,
        descEn: map['desc_en'] as String,
        descBe: map['desc_be'] as String,
        addressRu: map['address_ru'] as String,
        addressEn: map['address_en'] as String,
        addressBe: map['address_be'] as String,
        location: LatLng(map['lat'] as double, map['lng'] as double),
      );
    }).toList();
  }

  Future<List<Exhibition>> getExhibitionsByMuseum(int museumId) async {
    final db = await database;
    final maps = await db.query('exhibitions',
        where: 'museum_id = ?', whereArgs: [museumId]);
    return maps.map((map) {
      return Exhibition(
        id: map['id'] as int,
        museumId: map['museum_id'] as int,
        nameRu: map['name_ru'] as String,
        nameEn: map['name_en'] as String,
        nameBe: map['name_be'] as String,
        descRu: map['desc_ru'] as String,
        descEn: map['desc_en'] as String,
        descBe: map['desc_be'] as String,
        startDate: map['start_date'] as String,
        endDate: map['end_date'] as String,
        price: map['price'] as double,
      );
    }).toList();
  }

  Future<void> close() async {
    final db = await database;
    db.close();
    _database = null;
  }
}
