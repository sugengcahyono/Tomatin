import 'package:flutter/material.dart';

class DetailRiwayatScreen extends StatelessWidget {
  final String id;

  const DetailRiwayatScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example status for demonstration
    String status = "Aktif";

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
                        Icons.confirmation_number,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'ID: $id',
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
                          status,
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
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 120,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Colors.black, width: 2), // Add black border
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
                            const Text(
                              'Jumlah Tomat: 10',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const Text(
                              'Total Berat: 0,020 Kg',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const Text(
                              'Rata-rata Berat: 0,002 Kg',
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

              // Card 2 (Belum Matang)
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
                                border:
                                    Border.all(color: Colors.orange, width: 2),
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
                            const Text(
                              'Jumlah Tomat: 5',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const Text(
                              'Berat Tomat: 0,010 Kg',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const Text(
                              'Rata-rata Berat: 0,002 Kg',
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

// Card 3 (Busuk)
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
                            const Text(
                              'Jumlah Tomat: 2',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const Text(
                              'Berat Tomat: 0,005 Kg',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const Text(
                              'Rata-rata Berat: 0,0025 Kg',
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
                            const Text(
                              'Jumlah Keseluruhan: 2',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const Text(
                              'Berat Keseluruhan: 0,005 Kg',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const Text(
                              'Rata-rata Berat: 0,0025 Kg',
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
