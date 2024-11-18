import 'package:flutter/material.dart';
import 'package:tomat_in/api_service.dart';

class DetailBeratMatangScreen extends StatefulWidget {
  final String tanggal; // Menerima tanggal
  final String kloter; // Menerima kloter
  final Map<String, dynamic>? data; // Menerima data

  const DetailBeratMatangScreen(
      {Key? key,
      required this.tanggal,
      required this.kloter,
      required this.data})
      : super(key: key);

  @override
  State<DetailBeratMatangScreen> createState() =>
      _DetailBeratMatangScreenState();
}

class _DetailBeratMatangScreenState extends State<DetailBeratMatangScreen> {
  ApiService apiService = ApiService();
  Map<String, dynamic>? _riwayatData;
  List<Map<String, dynamic>> _riwayatData_pcs = [];

  @override
  void initState() {
    super.initState();
    _fetchRiwayatDetail();
    _fetchRiwayatDetail_Pcs();
  }

  Future<void> _fetchRiwayatDetail() async {
    final result =
        await apiService.getRiwayatDetailTomat(widget.tanggal, widget.kloter);
    if (result['status']) {
      setState(() {
        _riwayatData = result['data'];
      });
    } else {
      // Handle error
      print(result['message']);
    }
  }

  Future<void> _fetchRiwayatDetail_Pcs() async {
    final result = await apiService.getRiwayatDetailTomat_Pcs(
        widget.tanggal,
        widget.kloter,
        'Matang'); // Sesuaikan dengan kategori yang ingin ditampilkan
    if (result['status'] == 'success') {
      setState(() {
        _riwayatData_pcs = List<Map<String, dynamic>>.from(result['data']);
      });
    } else {
      // Tampilkan pesan kesalahan jika ada
      print(result['message']);
    }
  }

  // Sample data for tomato weights

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Berat',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section for 'Matang' status and 'Aktif' ID
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
                      Icons.confirmation_number,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${widget.tanggal}',
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
                        'Kloter ${widget.kloter}',
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

            // Card for "Matang" status with details
            Center(
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => DetailBeratMatangScreen(),
                  //   ),
                  // );
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
                                border: Border.all(color: Colors.red, width: 2),
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

            const SizedBox(height: 10),

            // Header for the tomato weight list
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.red[300],
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'ID Tomat',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Berat (Kg)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 5),
            // List of individual tomato weights
            Expanded(
              child: ListView.builder(
                itemCount: _riwayatData_pcs.length,
                itemBuilder: (context, index) {
                  final tomato = _riwayatData_pcs[index];

                  return Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          tomato['id_tomat']?.toString() ??
                              'Unknown', // Convert to String
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${(tomato['berat_tomat'] ?? 0.0).toStringAsFixed(3)} Kg',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
