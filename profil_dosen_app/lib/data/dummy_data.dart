import 'dart:math';
import '../models/dosen_model.dart';

// PASTIKAN MAP INI LENGKAP DENGAN FAKULTAS KEDOKTERAN
final Map<String, List<String>> jurusanPerFakultas = {
  'Sains dan Teknologi': ['Informatika', 'Sistem Informasi', 'Biologi', 'Matematika'],
  'Syariah': ['Hukum Ekonomi Syariah', 'Perbankan Syariah', 'Manajemen Zakat'],
  'Teknik': ['Teknik Sipil', 'Teknik Mesin', 'Teknik Elektro', 'Arsitektur'],
  'Kedokteran': ['Pendidikan Dokter', 'Farmasi', 'Ilmu Keperawatan', 'Gizi'],
};

// Daftar data lain untuk di-random (tetap sama)
const List<String> _namaPria = ['Budi', 'Joko', 'Agus', 'Eko', 'Rudi', 'Hendra', 'Dedi', 'Yusuf', 'Imran', 'Fajar'];
const List<String> _namaWanita = ['Siti', 'Ani', 'Dewi', 'Rina', 'Fitri', 'Lina', 'Maya', 'Eka', 'Wati', 'Putri'];
const List<String> _namaBelakang = ['Santoso', 'Wijaya', 'Hartono', 'Susilo', 'Pratama', 'Nugroho', 'Kusuma', 'Lestari', 'Wahyuni', 'Utami'];
const List<String> _gelarDepan = ['Prof. Dr. Ir.', 'Dr.', ''];
const List<String> _gelarBelakang = ['M.Eng', 'M.Kom', 'S.Si., M.Sc', 'S.H., M.H.', 'S.T., M.T.', 'S.Ked., Sp.A'];
const List<String> _statusAkademik = ['Aktif Mengajar', 'Cuti Studi', 'Tugas Belajar'];
const List<String> _jabatanAkademik = ['Guru Besar', 'Lektor Kepala', 'Lektor', 'Asisten Ahli'];
const List<String> _golongan = ['IV/e', 'IV/d', 'IV/c', 'IV/b', 'IV/a', 'III/d', 'III/c'];

List<Dosen> generateDummyDosen() {
  final List<Dosen> dosenList = [];
  final Random random = Random();

  jurusanPerFakultas.forEach((fakultas, jurusanList) {
    for (int i = 0; i < 15; i++) {
      bool isPria = random.nextBool();
      String namaDepan = isPria ? _namaPria[random.nextInt(_namaPria.length)] : _namaWanita[random.nextInt(_namaWanita.length)];
      String namaLengkap =
          '${_gelarDepan[random.nextInt(_gelarDepan.length)]} $namaDepan ${_namaBelakang[random.nextInt(_namaBelakang.length)]}, ${_gelarBelakang[random.nextInt(_gelarBelakang.length)]}'
              .trim();
      
      String nipUnik = '19${random.nextInt(40) + 60}0${random.nextInt(10)}${random.nextInt(30)+1}199${random.nextInt(10)}20${random.nextInt(10)}${random.nextInt(10)}';

      String fotoUrl;
      if (isPria) {
        fotoUrl = 'assets/dosenpria.png';
      } else {
        if (fakultas == 'Syariah') {
          fotoUrl = 'assets/dosenhijab.png';
        } else {
          fotoUrl = 'assets/dosenwanita.png';
        }
      }

      dosenList.add(Dosen(
        nama: namaLengkap,
        nip: nipUnik,
        fakultas: fakultas,
        jurusan: jurusanList[random.nextInt(jurusanList.length)],
        status: _statusAkademik[random.nextInt(_statusAkademik.length)],
        email: '${namaDepan.toLowerCase()}.${_namaBelakang[random.nextInt(_namaBelakang.length)].toLowerCase()}@teknomaju.ac.id',
        fotoUrl: fotoUrl,
        tempatLahir: 'Jakarta',
        tanggalLahir: '${random.nextInt(28) + 1} Januari 19${random.nextInt(40) + 60}',
        jenisKelamin: isPria ? 'Laki-laki' : 'Perempuan',
        jabatanAkademik: _jabatanAkademik[random.nextInt(_jabatanAkademik.length)],
        golonganPangkat: _golongan[random.nextInt(_golongan.length)],
        agama: 'Islam',
      ));
    }
  });

  return dosenList;
}