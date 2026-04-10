import 'package:cloud_firestore/cloud_firestore.dart';

enum GirisTipi { google, apple, email }

class Kullanici {
  final String id;
  final String ad;
  final String email;
  final String? fotograf;
  final GirisTipi girisTipi;
  final DateTime olusturmaTarihi;

  const Kullanici({
    required this.id,
    required this.ad,
    required this.email,
    this.fotograf,
    required this.girisTipi,
    required this.olusturmaTarihi,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'ad': ad,
    'email': email,
    'fotograf': fotograf,
    'girisTipi': girisTipi.name,
    'olusturmaTarihi': Timestamp.fromDate(olusturmaTarihi),
  };

  factory Kullanici.fromMap(Map<String, dynamic> m) => Kullanici(
    id: m['id'] as String,
    ad: m['ad'] as String,
    email: m['email'] as String,
    fotograf: m['fotograf'] as String?,
    girisTipi: GirisTipi.values.firstWhere(
      (g) => g.name == m['girisTipi'],
      orElse: () => GirisTipi.email,
    ),
    olusturmaTarihi: (m['olusturmaTarihi'] as Timestamp).toDate(),
  );
}
