import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServices {
  final String virusTotalApiKey = '6a069caa09d1300a5b47aae22ec907668e171600b98c11cdf7fa1956ccf32fa0';

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
}



