class MahasiswaModel {
  final int? nim;
  final String name;
  final String email;
  final String jurusan;

  MahasiswaModel({
    this.nim,
    required this.name,
    required this.email,
    required this.jurusan,
  });

  // Konversi dari Map ke objek MahasiswaModel
  factory MahasiswaModel.fromMap(Map<String, dynamic> map) {
    return MahasiswaModel(
      nim: map['nim'],
      name: map['name'],
      email: map['email'],
      jurusan: map['jurusan'],
    );
  }

  // Konversi dari objek MahasiswaModel ke Map
  Map<String, dynamic> toMap() {
    return {
      'nim': nim,
      'name': name,
      'email': email,
      'jurusan': jurusan,
    };
  }
}
