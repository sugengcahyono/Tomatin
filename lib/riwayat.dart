import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tomat_in/detailriwayat.dart'; // For date formatting

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({Key? key}) : super(key: key);

  @override
  _RiwayatScreenState createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  DateTime _startDate = DateTime(2024, 10, 1); // Default start date
  DateTime _endDate = DateTime(2024, 10, 21); // Default end date

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != (isStartDate ? _startDate : _endDate)) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  // Dummy data for transactions
  final List<Map<String, dynamic>> _transactions = [
    {
      'id': 'IP10.085856212953',
      'saldoAwal': '91.258',
      'harga': '10.650',
      'saldoAkhir': '80.608',
      'status': 'Sukses',
      'time': '17:58:51',
      'statusColor': Colors.green,
    },
    {
      'id': 'IP5.085708150181',
      'saldoAwal': '96.908',
      'harga': '5.650',
      'saldoAkhir': '91.258',
      'status': 'Sukses',
      'time': '12:17:09',
      'statusColor': Colors.green,
    },
    {
      'id': 'IN20.085604630494',
      'saldoAwal': '116.858',
      'harga': '19.950',
      'saldoAkhir': '96.608',
      'status': 'Sukses',
      'time': '17:57:31',
      'statusColor': Colors.green,
    },
    {
      'id': 'IP11.087634827343',
      'saldoAwal': '80.000',
      'harga': '33.750',
      'saldoAkhir': '46.250',
      'status': 'Gagal',
      'time': '19:12:45',
      'statusColor': Colors.red,
    },
  ];

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
            // Top section with date pickers
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: _buildDateCard(
                        context, 'Mulai dari', startFormatted, true),
                  ),
                  const SizedBox(width: 3), // Memberi jarak antara kedua card
                  Expanded(
                    child:
                        _buildDateCard(context, 'Hingga', endFormatted, false),
                  ),
                ],
              ),
            ),
            // Kategori cards
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: // Menggunakan _buildCategoryCard dengan warna yang berbeda untuk tiap kategori
                    // Menggunakan _buildCategoryCard dengan warna border dan warna teks yang berbeda
                    Row(
                  children: [
                    _buildCategoryCard('Matang', '10 kg', Colors.red,
                        Colors.black), // Border hijau, teks hitam
                    _buildCategoryCard('Setengah Matang', '5 kg', Colors.orange,
                        Colors.black), // Border oranye, teks biru
                    _buildCategoryCard('Mentah', '2 kg', Colors.green,
                        Colors.black), // Border merah, teks ungu
                  ],
                )),

            const SizedBox(height: 20),
            // Search bar

            // Scrollable list of transactions
            // Scrollable list of transactions
            Expanded(
              child: Column(
                children: [
                  // Pembatas estetik berwarna merah
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0), // Memberi jarak dari pinggir
                    child: Container(
                      height: 2, // Tinggi pembatas
                      color: Colors.red, // Warna merah untuk pembatas
                    ),
                  ),
                  const SizedBox(
                      height:
                          10), // Memberi jarak antara pembatas dan daftar transaksi

                  // Daftar transaksi yang bisa discroll
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = _transactions[index];
                        return Column(
                          children: [
                            _buildTransactionEntry(
                              context,
                              transaction['id'],
                              transaction['saldoAwal'],
                              transaction['harga'],
                              transaction['saldoAkhir'],
                              transaction['status'],
                              // transaction['statusColor'],
                              // transaction['time'],
                            ),
                            const SizedBox(
                                height: 10), // Mengatur jarak antar card
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Date card widget
  // Date card widget
  Widget _buildDateCard(
      BuildContext context, String title, String date, bool isStartDate) {
    return GestureDetector(
      onTap: () => _selectDate(context, isStartDate),
      child: Card(
        elevation: 4,
        color: Colors.white, // Menetapkan latar belakang menjadi putih
        shape: RoundedRectangleBorder(
          side: const BorderSide(
              color: Colors.black, width: 2), // Warna dan ketebalan border
          borderRadius: BorderRadius.circular(10), // Membuat sudut melengkung
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

  // Category card widget
  // Category card widget
  // Fungsi untuk membangun Card kategori dengan warna border yang berbeda
  // Fungsi untuk membangun Card kategori dengan warna border dan warna teks yang berbeda
  Widget _buildCategoryCard(
      String title, String weight, Color borderColor, Color textColor) {
    return Expanded(
      child: Card(
        elevation: 5,
        color: Colors.white, // Latar belakang card tetap putih
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: borderColor,
              width: 2), // Warna border sesuai dengan kategori
          borderRadius: BorderRadius.circular(10), // Membuat sudut melengkung
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align content to the left
            children: [
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: textColor), // Warna teks sesuai kategori
              ),
              const SizedBox(
                  height: 8), // Menambahkan jarak antara title dan weight
              Text(weight, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  // Transaction entry widget
// Transaction entry widget


Widget _buildTransactionEntry(
  BuildContext context,
  String id,
  String saldoAwal,
  String harga,
  String saldoAkhir,
  String time,
) {
  return GestureDetector(
    onTap: () {
      // Navigasi ke halaman detail riwayat saat kartu diklik
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailRiwayatScreen(id: id),
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
            // Baris atas dengan ID dan waktu transaksi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(id, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(time, style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),

            // Bagian untuk tiga kartu kategori (Saldo Awal, Harga, Saldo Akhir)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Card Saldo Awal
                _buildCategorycard1('Matang', saldoAwal, Colors.black, Colors.red),

                // Card Harga
                _buildCategorycard1('Setengah Matang', harga, Colors.black, Colors.orange),

                // Card Saldo Akhir
                _buildCategorycard1('Mentah', saldoAkhir, Colors.black, Colors.green),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

// Fungsi untuk membuat kartu kategori dengan desain yang dapat disesuaikan
Widget _buildCategorycard1(
    String title, String weight, Color borderColor, Color textColor) {
  return Expanded(
    child: Card(
      elevation: 5,
      color: Colors.white, // Latar belakang card tetap putih
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: borderColor, width: 2), // Warna border sesuai dengan kategori
        borderRadius: BorderRadius.circular(10), // Membuat sudut melengkung
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align content to the left
          children: [
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: textColor), // Warna teks sesuai kategori
            ),
            const SizedBox(height: 8), // Menambahkan jarak antara title dan weight
            Text(weight, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    ),
  );
}
}