import 'package:flutter/material.dart';
import 'package:tomat_in/api_service.dart';
import 'package:tomat_in/detailberat_matang.dart';
import 'package:tomat_in/detailberat_mentah.dart';
import 'package:tomat_in/detailberat_setengahmatang.dart';

class DetailRiwayatScreen extends StatefulWidget {
  final String Tanggal; // Properti untuk tanggal
  final String Kloter;

  const DetailRiwayatScreen(
      {Key? key, required this.Tanggal, required this.Kloter})
      : super(key: key);

  @override
  State<DetailRiwayatScreen> createState() => _DetailRiwayatScreenState();
}

class _DetailRiwayatScreenState extends State<DetailRiwayatScreen> {
  ApiService apiService = ApiService();
  Map<String, dynamic>? _riwayatData;
  Map<String, dynamic>? _riwayatData_keseluruhan;

  @override
  void initState() {
    super.initState();
    _fetchRiwayatDetail();
    _fetchRiwayatDetail_Keseluruhan();
  }

  Future<void> _fetchRiwayatDetail() async {
    final result =
        await apiService.getRiwayatDetailTomat(widget.Tanggal, widget.Kloter);
    if (result['status']) {
      setState(() {
        _riwayatData = result['data'];
      });
    } else {
      // Handle error
      print(result['message']);
    }
  }

  Future<void> _fetchRiwayatDetail_Keseluruhan() async {
    final result = await apiService.getRiwayatDetailTomat_keseluruhan(
        widget.Tanggal, widget.Kloter);
    if (result['status']) {
      setState(() {
        _riwayatData_keseluruhan = result['data'];
      });
    } else {
      // Handle error
      print(result['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Example status for demonstration

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Riwayat',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
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

              // Card 1 (Matang)
              // Main card widget with navigation
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Mengambil data yang akan dikirim
                    var matangData =
                        _riwayatData != null && _riwayatData!['Matang'] != null
                            ? _riwayatData!['Matang']
                            : null;

                    // Navigasi ke halaman detail sambil membawa data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailBeratMatangScreen(
                          tanggal: widget.Tanggal, // Kirim tanggal
                          kloter: widget.Kloter, // Kirim kloter
                          data: matangData, // Kirim data Matang
                        ),
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
                          'assets/images/tomato.png',
                          width: 90,
                          height: 90,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 1),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.2),
                                  border:
                                      Border.all(color: Colors.red, width: 2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Text(
                                  'Matang',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Jumlah Tomat: ${_riwayatData != null && _riwayatData!['Matang'] != null ? _riwayatData!['Matang']['jumlah_tomat'] ?? 0 : 0}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                               'Berat Tomat: ${_riwayatData != null && _riwayatData!['Matang'] != null ? (_riwayatData!['Matang']['total_berat']?.toDouble() ?? 0.0).toStringAsFixed(3) : '0.000'}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                'Rata Rata Berat: ${_riwayatData != null && _riwayatData!['Matang'] != null ? (_riwayatData!['Matang']['rata_rata_berat']?.toDouble() ?? 0.0).toStringAsFixed(3) : '0.000'}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Card 2 (Belum Matang)
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Mengambil data yang akan dikirim
                    var matangData =
                        _riwayatData != null && _riwayatData!['Matang'] != null
                            ? _riwayatData!['Matang']
                            : null;

                    // Navigasi ke halaman detail sambil membawa data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailBeratSetengahMatangScreen(
                          tanggal: widget.Tanggal, // Kirim tanggal
                          kloter: widget.Kloter, // Kirim kloter
                          data: matangData, // Kirim data Matang
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 120,
                    padding: const EdgeInsets.all(
                        10), // Adjusted padding to match "Segar"
                    margin: const EdgeInsets.symmetric(
                        vertical: 5), // Adjusted margin to match "Segar"
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.black, width: 2), // Add black border
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/setengahmatang.png',
                          width: 90,
                          height: 90,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 1),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.2),
                                  border: Border.all(
                                      color: Colors.orange, width: 2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Text(
                                  'Setengah Matang',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Jumlah Tomat: ${_riwayatData != null && _riwayatData!['Setengah Matang'] != null ? _riwayatData!['Setengah Matang']['jumlah_tomat'] ?? 0 : 0}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                'Berat Tomat: ${_riwayatData != null && _riwayatData!['Setengah Matang'] != null ? (_riwayatData!['Setengah Matang']['total_berat']?.toDouble() ?? 0.0).toStringAsFixed(3) : '0.000'}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                'Rata Rata Berat: ${_riwayatData != null && _riwayatData!['Setengah Matang'] != null ? (_riwayatData!['Setengah Matang']['rata_rata_berat']?.toDouble() ?? 0.0).toStringAsFixed(3) : '0.000'}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

// Card 3 (Busuk)
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Mengambil data yang akan dikirim
                    var matangData =
                        _riwayatData != null && _riwayatData!['Matang'] != null
                            ? _riwayatData!['Matang']
                            : null;

                    // Navigasi ke halaman detail sambil membawa data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailBeratMentahScreen(
                          tanggal: widget.Tanggal, // Kirim tanggal
                          kloter: widget.Kloter, // Kirim kloter
                          data: matangData, // Kirim data Matang
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 120,
                    padding: const EdgeInsets.all(
                        10), // Adjusted padding to match "Segar"
                    margin: const EdgeInsets.symmetric(
                        vertical: 5), // Adjusted margin to match "Segar"
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.black, width: 2), // Add black border
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/tomato_Belummatang.png',
                          width: 90,
                          height: 90,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 1),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.2),
                                  border:
                                      Border.all(color: Colors.green, width: 2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Text(
                                  'Mentah',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Jumlah Tomat: ${_riwayatData != null && _riwayatData!['Mentah'] != null ? _riwayatData!['Mentah']['jumlah_tomat'] ?? 0 : 0}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                'Berat Tomat: ${_riwayatData != null && _riwayatData!['Mentah'] != null ? (_riwayatData!['Mentah']['total_berat']?.toDouble() ?? 0.0).toStringAsFixed(3) : '0.000'}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                'Rata Rata Berat: ${_riwayatData != null && _riwayatData!['Mentah'] != null ? (_riwayatData!['Mentah']['rata_rata_berat']?.toDouble() ?? 0.0).toStringAsFixed(3) : '0.000'}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

// KEseluruhan
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 120,
                  padding: const EdgeInsets.all(
                      10), // Adjusted padding to match "Segar"
                  margin: const EdgeInsets.symmetric(
                      vertical: 5), // Adjusted margin to match "Segar"
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Colors.black, width: 2), // Add black border
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 1),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2),
                                border:
                                    Border.all(color: Colors.black, width: 2),
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
                              'Total Jumlah: ${_riwayatData_keseluruhan != null ? _riwayatData_keseluruhan!['total_jumlah_tomat'] ?? 0 : 0}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              'Total Berat: ${_riwayatData_keseluruhan != null ? (_riwayatData_keseluruhan!['total_berat']?.toDouble() ?? 0.0).toStringAsFixed(3) : 0.0} kg',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              'Rata-rata Berat: ${_riwayatData_keseluruhan != null ? (_riwayatData_keseluruhan!['rata_rata_berat']?.toDouble() ?? 0.0).toStringAsFixed(3) : 0.0} kg',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Reset Button
              const SizedBox(height: 10),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 40,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
