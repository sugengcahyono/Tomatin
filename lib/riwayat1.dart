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
      // Ambil data setelah memilih tanggal
      _fetchData();
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData(); // Ambil data saat halaman dimuat
  }

  @override
  Widget build(BuildContext context) {
    String startFormatted = DateFormat('d MMM yyyy').format(_startDate);
    String endFormatted = DateFormat('d MMM yyyy').format(_endDate);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Riwayat',
              style: TextStyle(fontWeight: FontWeight.bold)),
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
                        context, 'Mulai dari', startFormatted, true),
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child:
                        _buildDateCard(context, 'Hingga', endFormatted, false),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: riwayatData == null
                  ? const Center(
                      child: CircularProgressIndicator()) // Menampilkan loading
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: riwayatData!.length,
                      itemBuilder: (context, index) {
                        final tanggalSortir = riwayatData!.keys
                            .elementAt(index); // Ambil tanggal sortir
                        final kloterData = riwayatData![tanggalSortir]['kloter']
                            as Map<String, dynamic>;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Menampilkan tanggal sortir
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                "Tanggal Sortir: ${DateFormat('d MMM yyyy').format(DateTime.parse(tanggalSortir))}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            // Menampilkan data kloter
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

  Widget _buildTransactionEntry(BuildContext context, String kloter, double totalBeratMatang, double totalBeratMentah, double totalBeratSetengahMatang, String tanggalSortir) {
    return GestureDetector(
        onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailRiwayatScreen(id: kloter), // Ganti dengan argumen yang sesuai
                ),
            );
        },
        child: Card(
            elevation: 3,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text("Kloter: $kloter", style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text("Tanggal Sortir: ${DateFormat('d MMM yyyy').format(DateTime.parse(tanggalSortir))}", style: const TextStyle(fontSize: 14)), // Display sorting date
                        const SizedBox(height: 8),
                        Text("Total Berat Matang: ${totalBeratMatang.toStringAsFixed(2)} kg"),
                        Text("Total Berat Mentah: ${totalBeratMentah.toStringAsFixed(2)} kg"),
                        Text("Total Berat Setengah Matang: ${totalBeratSetengahMatang.toStringAsFixed(2)} kg"),
                    ],
                ),
            ),
        ),
    );
  }
}
