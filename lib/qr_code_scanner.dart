import 'package:flutter/material.dart';
import 'package:flutter_application_1/usage/usage.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_application_1/apicalls.dart';
import 'package:url_launcher/url_launcher.dart';  // Import url_launcher

class ScanCodePage extends StatefulWidget {
  const ScanCodePage({super.key});

  @override
  State<ScanCodePage> createState() => _ScanCodePageState();
}

class _ScanCodePageState extends State<ScanCodePage> {
  final ApiServices _apiServices = ApiServices();
  String _scanResultMessage = "Scan a QR code to verify the URL.";

  void _checkUrlSafety(String url) async {
    try {
      int positives = await _apiServices.checkQrCodeUrl(url);

      String message;
      if (positives > 2) {
        message = "The URL is unsafe. Proceed with caution.";
      } else if (positives == 1) {
        message = "The URL is moderately safe.";
      } else {
        message = "The URL is safe.";
        
        // Attempt to launch the URL
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        } else {
          throw 'Could not launch $url';
        }
      }

      setState(() {
        _scanResultMessage = message;
      });

    } catch (e) {
      setState(() {
        _scanResultMessage = "Error verifying URL: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        actions: [
          ElevatedButton(
            onPressed: () {
              // Restart scanning by pushing a new instance of ScanCodePage
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const ScanCodePage()),
              );
            },
            child: const Text('Rescan'),
          ),
          ElevatedButton(
            onPressed: () {
              // Restart scanning by pushing a new instance of ScanCodePage
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomeView()),
              );
            },
            child: const Text('LinkChecker'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: MobileScannerController(
                detectionSpeed: DetectionSpeed.noDuplicates,
                returnImage: true,
              ),
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  final url = barcode.rawValue ?? "";
                  if (url.isNotEmpty) {
                    _checkUrlSafety(url);  // Pass the scanned URL to the VirusTotal check
                  }
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _scanResultMessage,
              style: const TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}









