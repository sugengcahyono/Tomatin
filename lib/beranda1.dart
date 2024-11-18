import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'api_service.dart'; // Ensure you import your ApiService file

class Beranda extends StatefulWidget {
  const Beranda({Key? key}) : super(key: key);

  @override
  _BerandaState createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  final ApiService apiService = ApiService();
  late Future<Map<String, dynamic>> dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = apiService.getBeratTomatBulanIni(); // Fetch data when the widget is created
  }

  @override
  Widget build(BuildContext context) {
    // Format the current date
    String formattedDate = DateFormat('dd MMMM yyyy').format(DateTime.now());
    int currentHour = DateTime.now().hour;
    String greeting;

    // Determine greeting based on the hour
    if (currentHour < 12) {
      greeting = 'Pagi,';
    } else if (currentHour < 17) {
      greeting = 'Siang,';
    } else if (currentHour < 19) {
      greeting = 'Sore,';
    } else {
      greeting = 'Malam,';
    }

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFB71C1C),
                Colors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        greeting,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 0),
                      Text(
                        'Selamat Datang di Tomat.In!',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Dapatkan solusi terbaik untuk memilah kematangan tomat Anda disini',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                // Display the current date
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(formattedDate, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Statistics section header
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'Statistik',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),

                // Fetch and display the weight data
                FutureBuilder<Map<String, dynamic>>(
                  future: dataFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (snapshot.hasData) {
                      // Extracting data for display
                      var data = snapshot.data!;
                      var beratData = data["berat_tomat_bulan_ini"] as List;

                      var beratMatang = beratData.firstWhere(
                        (element) => element["nama_kategori"] == "Matang",
                        orElse: () => {"total_berat": "0.000"},
                      )["total_berat"];

                      var beratSetengahMatang = beratData.firstWhere(
                        (element) => element["nama_kategori"] == "Setengah Matang",
                        orElse: () => {"total_berat": "0.000"},
                      )["total_berat"];

                      var beratMentah = beratData.firstWhere(
                        (element) => element["nama_kategori"] == "Mentah",
                        orElse: () => {"total_berat": "0.000"},
                      )["total_berat"];

                      return Column(
                        children: [
                          const SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Ripe
                                buildWeightCard('Matang', beratMatang.toString(), Colors.red),
                                // Semi-Ripe
                                buildWeightCard('Setengah Matang', beratSetengahMatang.toString(), Colors.orange),
                                // Unripe
                                buildWeightCard('Mentah', beratMentah.toString(), Colors.green),
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

  // Widget to build each weight card
  Widget buildWeightCard(String title, String weight, Color color) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: 150,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5),
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
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 23),
          Text(
            weight,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Kg',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
