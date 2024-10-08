import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServices {
  final String virusTotalApiKey = 'gg';

  // Function to check URL with VirusTotal
  Future<Map<String, dynamic>> checkUrlVirusTotal(String url) async {
    final urlScanUri = Uri.https('www.virustotal.com', '/vtapi/v2/url/scan');
    final urlReportUri = Uri.https('www.virustotal.com', '/vtapi/v2/url/report');
    
    // Step 1: Submit the URL to VirusTotal for scanning
    final scanResponse = await http.post(
      urlScanUri,
      body: {
        'apikey': virusTotalApiKey,
        'url': url,
      },
    );

    if (scanResponse.statusCode == 200) {
      final scanResult = jsonDecode(scanResponse.body);
      final resource = scanResult['resource'];

      // Step 2: Get the scan report for the URL
      final reportResponse = await http.post(
        urlReportUri,
        body: {
          'apikey': virusTotalApiKey,
          'resource': resource,
        },
      );

      if (reportResponse.statusCode == 200) {
        return jsonDecode(reportResponse.body);
      } else {
        throw Exception('Failed to retrieve the report from VirusTotal');
      }
    } else {
      throw Exception('Failed to scan the URL with VirusTotal');
    }
  }

  Future<int> checkQrCodeUrl(String url) async {
    final urlScanReport = Uri.https('www.virustotal.com', '/vtapi/v2/url/report');
    final response = await http.post(urlScanReport, body: {
      'apikey': virusTotalApiKey,
      'resource': url,
    });

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result['positives'] ?? 0;  // Return the number of positives
    } else {
      throw Exception('Failed to check URL with VirusTotal');
    }
  }
}







