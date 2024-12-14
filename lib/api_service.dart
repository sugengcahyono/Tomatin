import 'dart:convert';
import 'package:http/http.dart' as http;

// Ganti baseUrl dengan URL server API Anda
const String baseUrl = "http://192.168.140.156/tomatin_server/tomatin_api";

class ApiService {

// GET REALTIME BERAT
  Stream<Map<String, dynamic>> getBeratTomatRealTime() async* {
    final String url = "$baseUrl/get_realtime_berat.php";
    
    while (true) { // Infinite loop to keep the Stream open for real-time updates
      try {
        // Send GET request to fetch the data
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final data = json.decode(response.body) as Map<String, dynamic>;

          if (data["status"] == "success") {
            yield data; // Emit the data if response is successful
          } else {
            // Return default zero values if the status is not "success"
            yield {
              "status": "success",
              "berat_tomat_harian": [
                {"nama_kategori": "Matang", "total_berat": "0.000"},
                {"nama_kategori": "Setengah Matang", "total_berat": "0.000"},
                {"nama_kategori": "Mentah", "total_berat": "0.000"},
              ]
            };
          }
        } else {
          // Handle response failure and return default values
          yield {
            "status": "success",
            "berat_tomat_harian": [
              {"nama_kategori": "Matang", "total_berat": "0.000"},
              {"nama_kategori": "Setengah Matang", "total_berat": "0.000"},
              {"nama_kategori": "Mentah", "total_berat": "0.000"},
            ]
          };
        }
      } catch (e) {
        // Handle any errors (network, parsing, etc.) and return default zero values
        yield {
          "status": "success",
          "berat_tomat_harian": [
            {"nama_kategori": "Matang", "total_berat": "0.000"},
            {"nama_kategori": "Setengah Matang", "total_berat": "0.000"},
            {"nama_kategori": "Mentah", "total_berat": "0.000"},
          ]
        };
      }
      
      // Delay before fetching the data again (every 2 seconds in this case)
      await Future.delayed(Duration(seconds: 2));
    }
  }

  // RESET KLOTER
  Future<Map<String, dynamic>> getLatestKloter() async {
  final String url = "$baseUrl/reset_button.php"; // Sesuaikan endpoint

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;

      if (data["status"] == "success") {
        return data; // Kembalikan data terbaru
      } else {
        // Kembalikan default jika status bukan success
        return {
          "status": "error",
          "message": "Kloter sebelumnya kosong.",
          "kloter": 0 // Default kloter jika gagal
        };
      }
    } else {
      // Kembalikan default jika response gagal
      return {
        "status": "error",
        "message": "Gagal mendapatkan data. Kode Status: ${response.statusCode}",
        "kloter": 0
      };
    }
  } catch (e) {
    // Tangani error lain dengan mengembalikan nilai default
    return {
      "status": "error",
      "message": "Terjadi kesalahan: $e",
      "kloter": 0
    };
  }
}


  // GET TOMAT BULAN
Stream<Map<String, dynamic>> getBeratTomatBulanIni() async* {
  final String url = "$baseUrl/get_datatomat_bulan.php";
  
  while (true) { // Infinite loop to keep the Stream open for real-time updates
    try {
      // Call the API with GET method
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        if (data["status"] == "success") {
          yield data; // Emit the data if response is successful
        } else {
          // Return default zero values if the status is not "success"
          yield {
            "status": "success",
            "berat_tomat_bulan_ini": [
              {"nama_kategori": "Matang", "total_berat": "0.000"},
              {"nama_kategori": "Setengah Matang", "total_berat": "0.000"},
              {"nama_kategori": "Mentah", "total_berat": "0.000"},
            ]
          };
        }
      } else {
        yield {
          "status": "success",
          "berat_tomat_harian": [
            {"nama_kategori": "Matang", "total_berat": "0.000"},
            {"nama_kategori": "Setengah Matang", "total_berat": "0.000"},
            {"nama_kategori": "Mentah", "total_berat": "0.000"},
          ]
        };
      }
    } catch (e) {
      // Handle any other errors by returning default zero values
      yield {
        "status": "success",
        "berat_tomat_harian": [
          {"nama_kategori": "Matang", "total_berat": "0.000"},
          {"nama_kategori": "Setengah Matang", "total_berat": "0.000"},
          {"nama_kategori": "Mentah", "total_berat": "0.000"},
        ]
      };
    }
    
    await Future.delayed(Duration(seconds: 2)); // Fetch data every 5 seconds
  }
}
  

  // GET TOMAT KEMARIN
Stream<Map<String, dynamic>> getBeratTomatKemarin() async* {
  final String url = "$baseUrl/get_datatomat_kemarin.php";
  
  while (true) { // Infinite loop to keep the Stream open for real-time updates
    try {
      // Call the API with GET method
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        if (data["status"] == "success") {
          yield data; // Emit the data if response is successful
        } else {
          // Return default zero values if the status is not "success"
          yield {
            "status": "success",
            "berat_tomat_kemarin": [
              {"nama_kategori": "Matang", "total_berat": "0.000"},
              {"nama_kategori": "Setengah Matang", "total_berat": "0.000"},
              {"nama_kategori": "Mentah", "total_berat": "0.000"},
            ]
          };
        }
      } else {
        yield {
          "status": "success",
          "berat_tomat_harian": [
            {"nama_kategori": "Matang", "total_berat": "0.000"},
            {"nama_kategori": "Setengah Matang", "total_berat": "0.000"},
            {"nama_kategori": "Mentah", "total_berat": "0.000"},
          ]
        };
      }
    } catch (e) {
      // Handle any other errors by returning default zero values
      yield {
        "status": "success",
        "berat_tomat_harian": [
          {"nama_kategori": "Matang", "total_berat": "0.000"},
          {"nama_kategori": "Setengah Matang", "total_berat": "0.000"},
          {"nama_kategori": "Mentah", "total_berat": "0.000"},
        ]
      };
    }
    
    await Future.delayed(Duration(seconds: 2)); // Fetch data every 5 seconds
  }
}


  // GET TOMAT HARI INI
  Stream<Map<String, dynamic>> getBeratTomatHariIni() async* {
  final String url = "$baseUrl/get_datatomat_hariini.php";
  
  while (true) { // Infinite loop to keep the Stream open for real-time updates
    try {
      // Call the API with GET method
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        if (data["status"] == "success") {
          yield data; // Emit the data if response is successful
        } else {
          // Return default zero values if the status is not "success"
          yield {
            "status": "success",
            "berat_tomat_harian": [
              {"nama_kategori": "Matang", "total_berat": "0.000"},
              {"nama_kategori": "Setengah Matang", "total_berat": "0.000"},
              {"nama_kategori": "Mentah", "total_berat": "0.000"},
            ]
          };
        }
      } else {
        yield {
          "status": "success",
          "berat_tomat_harian": [
            {"nama_kategori": "Matang", "total_berat": "0.000"},
            {"nama_kategori": "Setengah Matang", "total_berat": "0.000"},
            {"nama_kategori": "Mentah", "total_berat": "0.000"},
          ]
        };
      }
    } catch (e) {
      // Handle any other errors by returning default zero values
      yield {
        "status": "success",
        "berat_tomat_harian": [
          {"nama_kategori": "Matang", "total_berat": "0.000"},
          {"nama_kategori": "Setengah Matang", "total_berat": "0.000"},
          {"nama_kategori": "Mentah", "total_berat": "0.000"},
        ]
      };
    }
    
    await Future.delayed(Duration(seconds: 2)); // Fetch data every 5 seconds
  }
}

 // GET RIWAYAT BERAT TOTAL
Future<Map<String, dynamic>> get_totalberatriwayat(String mulaiDari, String hingga) async {
  final url = Uri.parse("$baseUrl/get_totalberat_tanggal.php"); // Path ke file PHP

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "mulai_dari": mulaiDari,
        "hingga": hingga,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["status"] == "success") {
        return {"status": true, "data": data["data"]};
      } else {
        return {"status": false, "message": data["message"]};
      }
    } else {
      return {"status": false, "message": "Failed to fetch data"};
    }
  } catch (e) {
    return {"status": false, "message": "Error: $e"};
  }
}

// GET RIWAYAT KLOTER
 Future<Map<String, dynamic>> get_totalberatriwayat_kloter(String mulaiDari, String hingga) async {
    final url = Uri.parse("$baseUrl/get_totalberat_tanggal_kloter.php"); // Path ke file PHP

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "mulai_dari": mulaiDari,
          "hingga": hingga,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          "status": data["status"] == "success",
          "message": data["message"],
          "data": data["data"], // Pastikan ini sesuai dengan format JSON yang baru
        };
      } else {
        return {"status": false, "message": "Failed to fetch data"};
      }
    } catch (e) {
      return {"status": false, "message": "Error: $e"};
    }
}

// GET DETAIL RIWAYAT
Future<Map<String, dynamic>> getRiwayatDetailTomat(String Tanggal, String Kloter) async {
  final url = Uri.parse("$baseUrl/get_detailriwayat.php"); // Path ke file PHP

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "tanggal": Tanggal, // Parameter input untuk tanggal
        "kloter": Kloter,   // Parameter input untuk kloter
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["status"] == "success") {
        return {"status": true, "data": data["data"]};
      } else {
        return {"status": false, "message": data["message"]};
      }
    } else {
      return {"status": false, "message": "Failed to fetch data"};
    }
  } catch (e) {
    return {"status": false, "message": "Error: $e"};
  }

}

// DETAIL RIWAYAT KESELURUHAN
Future<Map<String, dynamic>> getRiwayatDetailTomat_keseluruhan(String Tanggal, String Kloter) async {
  final url = Uri.parse("$baseUrl/get_detailriwayat_totalberat.php"); // Path ke file PHP

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "tanggal": Tanggal, // Parameter input untuk tanggal
        "kloter": Kloter,   // Parameter input untuk kloter
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["status"] == "success") {
        return {"status": true, "data": data["data"]};
      } else {
        return {"status": false, "message": data["message"]};
      }
    } else {
      return {"status": false, "message": "Failed to fetch data"};
    }
  } catch (e) {
    return {"status": false, "message": "Error: $e"};
  }

}

Future<Map<String, dynamic>> getRiwayatDetailTomat_Pcs(
      String tanggal, String kloter, String kategori) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get_detailtomat_pcs.php'), // Sesuaikan dengan path API Anda
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'tanggal': tanggal,
        'kloter': kloter,
        'kategori': kategori,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load tomatoes: ${response.reasonPhrase}');
    }
  }
}






