import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tomat_in/api_service.dart';
import 'package:tomat_in/detailriwayat.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({Key? key}) : super(key: key);

  @override
  _RiwayatScreenState createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  ApiService apiService = ApiService();
  Map<String, dynamic>? riwayatData;
  List<dynamic>? riwayatDatatotal;

  // untuk total berat
  Future<void> _fetchRiwayat() async {
    String mulaiDari = DateFormat('yyyy-MM-dd').format(_startDate);
    String hingga = DateFormat('yyyy-MM-dd').format(_endDate);
    var response = await apiService.get_totalberatriwayat(mulaiDari, hingga);

    if (response["status"]) {
      // Assuming response["data"] is a List
      setState(() {
        riwayatData = response["data"]; // Set data directly
      });
    } else {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response["message"] ?? "Error fetching data")),
      );
    }
  }

  // untuk list card
  Future<void> _fetchData() async {
    final result = await apiService.get_totalberatriwayat_kloter(
      DateFormat('yyyy-MM-dd').format(_startDate),
      DateFormat('yyyy-MM-dd').format(_endDate),
    );

    if (result['status']) {
      setState(() {
        riwayatData = result['data'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          if (picked.isBefore(_endDate)) {
            _startDate = picked;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("Tanggal mulai harus sebelum tanggal akhir")),
            );
          }
        } else {
          if (picked.isAfter(_startDate)) {
            _endDate = picked;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("Tanggal akhir harus setelah tanggal mulai")),
            );
          }
        }
      });
      // Fetch data after selecting date
      _fetchData();
      _fetchRiwayat();
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData(); // Fetch data when the page loads
    _fetchRiwayat();
  }

  @override
  Widget build(BuildContext context) {
    String startFormatted = DateFormat('d MMM yyyy').format(_startDate);
    String endFormatted = DateFormat('d MMM yyyy').format(_endDate);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Riwayat',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: _buildDateCard(
                      context,
                      'Mulai dari',
                      startFormatted,
                      true,
                    ),
                  ),
                  const SizedBox(
                      width: 10), // Adjusted width for better spacing
                  Expanded(
                    child: _buildDateCard(
                      context,
                      'Hingga',
                      endFormatted,
                      false,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: riwayatData != null
                  ? _buildCategoryCards()
                  : const Center(child: CircularProgressIndicator()),
            ),
            const SizedBox(height: 20),
            // Red separator line
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 2,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 10),
            // Transaction list
            Expanded(
              child: riwayatData == null
                  ? const Center(
                      child:
                          CircularProgressIndicator()) // Show loading indicator
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: riwayatData!.length,
                      itemBuilder: (context, index) {
                        // Reverse the order by accessing the keys in reverse
                        final tanggalSortir = riwayatData!.keys
                            .toList()
                            .reversed
                            .elementAt(index); // Get the date in reverse order
                        final kloterData = riwayatData![tanggalSortir]['kloter']
                            as Map<String, dynamic>;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Display sorting date
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                DateFormat('d MMM yyyy')
                                    .format(DateTime.parse(tanggalSortir)),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            // Display kloter data
                            ...kloterData.entries.map((entry) {
                              final kloter = entry.key;
                              final kategori = entry.value['kategori']
                                  as Map<String, dynamic>;

                              double totalBeratMatang =
                                  (kategori['Matang'] ?? 0.0).toDouble();
                              double totalBeratMentah =
                                  (kategori['Mentah'] ?? 0.0).toDouble();
                              double totalBeratSetengahMatang =
                                  (kategori['Setengah Matang'] ?? 0.0)
                                      .toDouble();

                              return _buildTransactionEntry(
                                context,
                                kloter,
                                totalBeratMatang,
                                totalBeratMentah,
                                totalBeratSetengahMatang,
                                tanggalSortir, // Pass the sorting date
                              );
                            }).toList(),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCard(
      BuildContext context, String title, String date, bool isStartDate) {
    return GestureDetector(
      onTap: () => _selectDate(context, isStartDate),
      child: Card(
        elevation: 4,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              Text(date, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard_berat(
      String title, String weight, Color borderColor, Color textColor) {
    return Expanded(
      child: Card(
        elevation: 5,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: textColor),
              ),
              const SizedBox(height: 8),
              Text(weight, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCards() {
    // Initialize totalWeights map with 0 as the default value for each category
    Map<String, double> totalWeights = {
      "Matang": 0.0,
      "Setengah Matang": 0.0,
      "Mentah": 0.0,
    };

    // Check if riwayatData is not null and not empty
    if (riwayatDatatotal != null && riwayatDatatotal!.isNotEmpty) {
      // Iterate over the items in the "data" list
      for (var item in riwayatDatatotal!) {
        if (item is Map<String, dynamic> &&
            item['nama_kategori'] != null &&
            item['total_berat'] != null) {
          totalWeights[item['nama_kategori']] =
              (totalWeights[item['nama_kategori']] ?? 0) + item['total_berat'];
        }
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildCategoryCard_berat(
            'Matang',
            '${(totalWeights["Matang"] ?? 0).toStringAsFixed(5)} kg',
            Colors.red,
            Colors.black),
        _buildCategoryCard_berat(
            'Setengah Matang',
            '${(totalWeights["Setengah Matang"] ?? 0).toStringAsFixed(5)} kg',
            Colors.orange,
            Colors.black),
        _buildCategoryCard_berat(
            'Mentah',
            '${(totalWeights["Mentah"] ?? 0).toStringAsFixed(5)} kg',
            Colors.green,
            Colors.black),
      ],
    );
  }

  Widget _buildTransactionEntry(
    BuildContext context,
    String kloter,
    double totalBeratMatang,
    double totalBeratMentah,
    double totalBeratSetengahMatang,
    String tanggalSortir,
  ) {
    // Ambil waktu tanggal_sortir dari data riwayat
    final String? tanggalDanWaktuSortir =
        riwayatData![tanggalSortir]['tanggal_sortir'];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailRiwayatScreen(id: kloter),
          ),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.green, width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tampilkan tanggal dan waktu sortir
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('HH:mm:ss')
                        .format(DateTime.parse(tanggalDanWaktuSortir!)),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    "Kloter: $kloter",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Display each category in its own container
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCategoryCard(
                      "Tomat Matang", totalBeratMatang, Colors.red),
                  _buildCategoryCard("Setengah Matang",
                      totalBeratSetengahMatang, Colors.orange),
                  _buildCategoryCard(
                      "Tomat Mentah", totalBeratMentah, Colors.green),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String label, double weight, Color color) {
    return Container(
      width: 100, // Adjust width as needed
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            "${weight.toStringAsFixed(1)} Kg",
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
