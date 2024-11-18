import 'package:flutter/material.dart';
import 'package:tomat_in/detailberat_matang.dart';
import 'package:tomat_in/detailberat_mentah.dart';
import 'package:tomat_in/detailberat_setengahmatang.dart';
import 'package:tomat_in/api_service.dart'; // Ensure you import your API service file

class DetailRiwayatScreen extends StatefulWidget {
  final String Tanggal; // Properti untuk tanggal
  final String Kloter;
  

  const DetailRiwayatScreen({Key? key, required this.Tanggal, required this.Kloter}) 
      : super(key: key);

  @override
  State<DetailRiwayatScreen> createState() => _DetailRiwayatScreenState();
}

class _DetailRiwayatScreenState extends State<DetailRiwayatScreen> {
  Map<String, dynamic>? riwayatData; // To store the fetched data
  bool isLoading = true; // To manage loading state
  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchRiwayatDetail(); // Fetch data on initialization
  }

  Future<void> fetchRiwayatDetail() async {
    final response = await apiService.getRiwayatDetailTomat(widget.Tanggal, widget.Kloter);
    if (response["status"] == true) {
      setState(() {
        riwayatData = response["data"];
        isLoading = false; // Update loading state
      });
    } else {
      // Handle error scenario
      setState(() {
        isLoading = false; // Update loading state
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response["message"] ?? "Failed to load data")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Riwayat',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading 
          ? Center(child: CircularProgressIndicator()) // Show loader while fetching
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ID section
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(
                              Icons.date_range,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${widget.Tanggal}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'Kloter ${widget.Kloter}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Display fetched data
                    if (riwayatData != null) ...[
                      // Card 1 (Matang)
                      buildTomatCard("Matang", riwayatData!['matang'] ?? {}),
                      const SizedBox(height: 10),
                      // Card 2 (Setengah Matang)
                      buildTomatCard("Setengah Matang", riwayatData!['setengah_matang'] ?? {}),
                      const SizedBox(height: 10),
                      // Card 3 (Mentah)
                      buildTomatCard("Mentah", riwayatData!['mentah'] ?? {}),
                      const SizedBox(height: 10),
                      // Keseluruhan
                      buildKeseluruhanCard(riwayatData!['keseluruhan'] ?? {}),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildTomatCard(String status, Map<String, dynamic> data) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => (status == "Matang") ? DetailBeratMatangScreen() :
                (status == "Setengah Matang") ? DetailBeratSetengahMatangScreen() :
                DetailBeratMentahScreen(), // Navigate to the respective detail page
            ),
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 120,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Row(
            children: [
              Image.asset(
                'assets/images/${status.toLowerCase()}.png',
                width: 90,
                height: 90,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        border: Border.all(color: Colors.red, width: 2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        status,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Jumlah Tomat: ${data['jumlah'] ?? 0}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Total Berat: ${data['total_berat'] ?? 0} Kg',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Rata-rata Berat: ${data['rata_rata_berat'] ?? 0} Kg',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildKeseluruhanCard(Map<String, dynamic> data) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 120,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/images/alltomate1.png',
              width: 90,
              height: 90,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      'Keseluruhan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Jumlah Keseluruhan: ${data['jumlah'] ?? 0}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Berat Keseluruhan: ${data['total_berat'] ?? 0} Kg',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Rata-rata Berat: ${data['rata_rata_berat'] ?? 0} Kg',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
