import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk menampilkan tanggal format lokal
// import 'package:fl_chart/fl_chart.dart'; // Pastikan untuk mengimpor fl_chart
import 'api_service.dart';

class beranda extends StatefulWidget {
  // Use PascalCase for class names
  beranda({Key? key}) : super(key: key);

  @override
  State<beranda> createState() => _berandaState();
}

class _berandaState extends State<beranda> {
  final ApiService apiService = ApiService();
  late Stream<Map<String, dynamic>> berat_bulan;
  late Stream<Map<String, dynamic>> berat_kemarin;
  // late Future<Map<String, dynamic>> berat_hariini;
  late Stream<Map<String, dynamic>> berat_hariini;
  late Stream<Map<String, dynamic>> berat_realtime;

  @override
  void initState() {
    super.initState();
    berat_bulan = apiService.getBeratTomatBulanIni(); // bulan
    berat_kemarin = apiService.getBeratTomatKemarin(); // kemarin
    berat_hariini = apiService.getBeratTomatHariIni(); // hari ini
    berat_realtime = apiService.getBeratTomatRealTime(); // hari ini
  }

  void _resetKloter(BuildContext context) async {
    // Tampilkan dialog konfirmasi sebelum reset kloter
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Reset'),
        content: const Text('Apakah Anda yakin ingin mereset kloter?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Pilihan batal
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Pilihan lanjut
            child: const Text('Ya, Reset'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Jika pengguna mengonfirmasi, lanjutkan dengan reset kloter
      ApiService apiService = ApiService();

      final response = await apiService.getLatestKloter();

      if (response['status'] == 'success') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Reset Berhasil'),
            content: Text('Kloter baru: ${response['kloter']}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${response['message']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mendapatkan tanggal hari ini
    String formattedDate = DateFormat('dd MMMM yyyy').format(DateTime.now());

    // Mendapatkan jam saat ini
    int currentHour = DateTime.now().hour;
    String greeting;

    // Menentukan ucapan berdasarkan jam
    if (currentHour < 12) {
      greeting = 'Pagi,'; // Ucapan untuk pagi
    } else if (currentHour < 17) {
      greeting = 'Siang,'; // Ucapan untuk siang
    } else if (currentHour < 19) {
      greeting = 'Sore,'; // Ucapan untuk sore
    } else {
      greeting = 'Malam,'; // Ucapan untuk malam
    }

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFB71C1C),
                Colors.white,
              ], // Warna merah ke putih
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            // Ensure scrolling
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20), // Spasi atas
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        greeting, // Ucapan otomatis berdasarkan jam
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 0),
                      Text(
                        'Selamat Datang di Tomat.In!', // Mengganti teks
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  'Dapatkan solusi terbaik untuk memilah kematangan tomat Anda disini',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                // Menampilkan tanggal
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(
                          0.7), // Latar belakang dengan transparansi
                      borderRadius:
                          BorderRadius.circular(10), // Sudut melingkar
                    ),
                    padding: const EdgeInsets.all(10), // Ruang dalam
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Colors
                              .red, // Mengubah warna ikon agar lebih kontras
                        ),
                        const SizedBox(width: 8),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors
                                .black, // Mengubah warna teks agar lebih kontras
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10), // Spasi antara konten
                // card 1 (Matang)
                // card 1 (Matang)

                StreamBuilder<Map<String, dynamic>>(
                  stream: berat_realtime, // Stream untuk berat
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (snapshot.hasData) {
                      var data = snapshot.data!['data'] ?? {};

                      var firstDateKey =
                          data.keys.isNotEmpty ? data.keys.first : null;
                      if (firstDateKey == null) {
                        return Center(child: Text("No data available."));
                      }

                      var kloterData = data[firstDateKey]?['kloter'] ?? {};

                      var kategoriBerat = {
                        "Matang": 0.0,
                        "Setengah Matang": 0.0,
                        "Mentah": 0.0,
                      };

                      kloterData.forEach((_, kloter) {
                        var kategori = kloter['kategori'] ?? {};
                        kategori.forEach((key, value) {
                          if (kategoriBerat.containsKey(key)) {
                            kategoriBerat[key] =
                                (kategoriBerat[key]! + (value ?? 0.0));
                          }
                        });
                      });

                      var beratMatang_realtime =
                          kategoriBerat["Matang"]!.toStringAsFixed(3);
                      var beratSetengahMatang_realltime =
                          kategoriBerat["Setengah Matang"]!.toStringAsFixed(3);
                      var beratMentah_realtime =
                          kategoriBerat["Mentah"]!.toStringAsFixed(3);

                      return Column(
                        children: [
                          buildCard(
                            context,
                            title: "Matang",
                            weight: beratMatang_realtime,
                            imagePath: 'assets/images/tomato.png',
                            color: Colors.red,
                          ),
                          buildCard(
                            context,
                            title: "Setengah Matang",
                            weight: beratSetengahMatang_realltime,
                            imagePath: 'assets/images/setengahmatang.png',
                            color: Colors.orange,
                          ),
                          buildCard(
                            context,
                            title: "Mentah",
                            weight: beratMentah_realtime,
                            imagePath: 'assets/images/tomato_Belummatang.png',
                            color: Colors.green,
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                _resetKloter(context); // Fungsi Reset
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 5,
                              ),
                              child: const Text(
                                'Reset',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return Center(child: Text("No data available."));
                  },
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        'Statistik', // Mengganti teks
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(
                          0.7), // Latar belakang dengan transparansi
                      borderRadius:
                          BorderRadius.circular(10), // Sudut melingkar
                    ),
                    padding: const EdgeInsets.all(10), // Ruang dalam
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Colors
                              .red, // Mengubah warna ikon agar lebih kontras
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Hari Ini',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors
                                .black, // Mengubah warna teks agar lebih kontras
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                StreamBuilder<Map<String, dynamic>>(
                  stream: berat_hariini, // The stream for today’s weight
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (snapshot.hasData) {
                      // Extracting data for display
                      var data = snapshot.data!;
                      var beratData = data["berat_tomat_harian"] as List;

                      var beratMatang_bulan = beratData.firstWhere(
                        (element) => element["nama_kategori"] == "Matang",
                        orElse: () => {"total_berat": "0.000"},
                      )["total_berat"];

                      var beratSetengahMatang_bulan = beratData.firstWhere(
                        (element) =>
                            element["nama_kategori"] == "Setengah Matang",
                        orElse: () => {"total_berat": "0.000"},
                      )["total_berat"];

                      var beratMentah_bulan = beratData.firstWhere(
                        (element) => element["nama_kategori"] == "Mentah",
                        orElse: () => {"total_berat": "0.000"},
                      )["total_berat"];

                      return Column(
                        children: [
                          const SizedBox(height: 1),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Ripe
                                buildWeightCard(
                                  'Matang',
                                  beratMatang_bulan.toString(),
                                  Colors.red,
                                  titleWeightSpacing:
                                      25, // Custom spacing for this card
                                  weightKgSpacing:
                                      8, // Custom spacing for this card
                                ),
                                // Semi-Ripe
                                buildWeightCard(
                                  'Setengah Matang',
                                  beratSetengahMatang_bulan.toString(),
                                  Colors.orange,
                                  titleWeightSpacing:
                                      5, // Custom spacing for this card
                                  weightKgSpacing:
                                      10, // Custom spacing for this card
                                ),
                                // Unripe
                                buildWeightCard(
                                  'Mentah',
                                  beratMentah_bulan.toString(),
                                  Colors.green,
                                  titleWeightSpacing:
                                      25, // Custom spacing for this card
                                  weightKgSpacing:
                                      12, // Custom spacing for this card
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }

                    return Container(); // Return an empty container if none of the above conditions match
                  },
                ),

                // Dua Card di bawah
                const SizedBox(height: 5),

                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(
                          0.7), // Latar belakang dengan transparansi
                      borderRadius:
                          BorderRadius.circular(10), // Sudut melingkar
                    ),
                    padding: const EdgeInsets.all(10), // Ruang dalam
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Colors
                              .red, // Mengubah warna ikon agar lebih kontras
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Kemarin',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors
                                .black, // Mengubah warna teks agar lebih kontras
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                StreamBuilder<Map<String, dynamic>>(
                  stream: berat_kemarin, // The stream for today’s weight
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (snapshot.hasData) {
                      // Extracting data for display
                      var data = snapshot.data!;
                      var beratData = data["berat_tomat_kemarin"] as List;

                      var beratMatang_bulan = beratData.firstWhere(
                        (element) => element["nama_kategori"] == "Matang",
                        orElse: () => {"total_berat": "0.000"},
                      )["total_berat"];

                      var beratSetengahMatang_bulan = beratData.firstWhere(
                        (element) =>
                            element["nama_kategori"] == "Setengah Matang",
                        orElse: () => {"total_berat": "0.000"},
                      )["total_berat"];

                      var beratMentah_bulan = beratData.firstWhere(
                        (element) => element["nama_kategori"] == "Mentah",
                        orElse: () => {"total_berat": "0.000"},
                      )["total_berat"];

                      return Column(
                        children: [
                          const SizedBox(height: 1),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Ripe
                                buildWeightCard(
                                  'Matang',
                                  beratMatang_bulan.toString(),
                                  Colors.red,
                                  titleWeightSpacing:
                                      25, // Custom spacing for this card
                                  weightKgSpacing:
                                      8, // Custom spacing for this card
                                ),
                                // Semi-Ripe
                                buildWeightCard(
                                  'Setengah Matang',
                                  beratSetengahMatang_bulan.toString(),
                                  Colors.orange,
                                  titleWeightSpacing:
                                      5, // Custom spacing for this card
                                  weightKgSpacing:
                                      10, // Custom spacing for this card
                                ),
                                // Unripe
                                buildWeightCard(
                                  'Mentah',
                                  beratMentah_bulan.toString(),
                                  Colors.green,
                                  titleWeightSpacing:
                                      25, // Custom spacing for this card
                                  weightKgSpacing:
                                      12, // Custom spacing for this card
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }

                    return Container(); // Return an empty container if none of the above conditions match
                  },
                ),

                const SizedBox(height: 5),

                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(
                          0.7), // Latar belakang dengan transparansi
                      borderRadius:
                          BorderRadius.circular(10), // Sudut melingkar
                    ),
                    padding: const EdgeInsets.all(10), // Ruang dalam
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Colors
                              .red, // Mengubah warna ikon agar lebih kontras
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Bulan Ini ',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors
                                .black, // Mengubah warna teks agar lebih kontras
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                StreamBuilder<Map<String, dynamic>>(
                  stream: berat_bulan, // The stream for today’s weight
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (snapshot.hasData) {
                      // Extracting data for display
                      var data = snapshot.data!;
                      var beratData = data["berat_tomat_bulan_ini"] as List;

                      var beratMatang_bulan = beratData.firstWhere(
                        (element) => element["nama_kategori"] == "Matang",
                        orElse: () => {"total_berat": "0.000"},
                      )["total_berat"];

                      var beratSetengahMatang_bulan = beratData.firstWhere(
                        (element) =>
                            element["nama_kategori"] == "Setengah Matang",
                        orElse: () => {"total_berat": "0.000"},
                      )["total_berat"];

                      var beratMentah_bulan = beratData.firstWhere(
                        (element) => element["nama_kategori"] == "Mentah",
                        orElse: () => {"total_berat": "0.000"},
                      )["total_berat"];

                      return Column(
                        children: [
                          const SizedBox(height: 1),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Ripe
                                buildWeightCard(
                                  'Matang',
                                  beratMatang_bulan.toString(),
                                  Colors.red,
                                  titleWeightSpacing:
                                      25, // Custom spacing for this card
                                  weightKgSpacing:
                                      8, // Custom spacing for this card
                                ),
                                // Semi-Ripe
                                buildWeightCard(
                                  'Setengah Matang',
                                  beratSetengahMatang_bulan.toString(),
                                  Colors.orange,
                                  titleWeightSpacing:
                                      5, // Custom spacing for this card
                                  weightKgSpacing:
                                      10, // Custom spacing for this card
                                ),
                                // Unripe
                                buildWeightCard(
                                  'Mentah',
                                  beratMentah_bulan.toString(),
                                  Colors.green,
                                  titleWeightSpacing:
                                      25, // Custom spacing for this card
                                  weightKgSpacing:
                                      12, // Custom spacing for this card
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }

                    return Container(); // Return an empty container if none of the above conditions match
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCard(BuildContext context,
      {required String title,
      required String weight,
      required String imagePath,
      required Color color}) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 120,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(vertical: 3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    border: Border.all(color: color, width: 2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$weight gr',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Image.asset(
              imagePath,
              width: 90,
              height: 90,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildWeightCard(String title, String weight, Color color,
      {double titleWeightSpacing = 10, double weightKgSpacing = 10}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: 150,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              border: Border.all(color: color, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          SizedBox(
              height:
                  titleWeightSpacing), // Custom spacing between title and weight

          Text(
            weight,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.visible,
            maxLines: 1,
          ),

          SizedBox(
              height:
                  weightKgSpacing), // Custom spacing between weight and 'Kg' text

          const Text(
            'Kg',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
