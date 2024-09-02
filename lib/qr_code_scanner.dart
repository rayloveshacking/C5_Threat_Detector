import 'package:flutter/material.dart';
import 'package:flutter_application_1/usage/usage.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_application_1/apicalls.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_application_1/history.dart';

class ScanCodePage extends StatefulWidget {
  final List<String> blockedUrls;
  final List<ScanHistoryItem> scanHistory;

  const ScanCodePage({required this.blockedUrls, required this.scanHistory, super.key});

  @override
  State<ScanCodePage> createState() => _ScanCodePageState();
}

class _ScanCodePageState extends State<ScanCodePage> {
  final ApiServices _apiServices = ApiServices();
  String _scanResultMessage = "Scan a QR code to verify the URL.";

  void _checkUrlSafety(String url) async {
    if (widget.blockedUrls.contains(url)) {
      setState(() {
        _scanResultMessage = "This URL is blocked and cannot be opened.";
      });
      return;
    }

    try {
      int positives = await _apiServices.checkQrCodeUrl(url);

      String safetyMessage;
      bool isSafe = false;
      double safetyPercentage = 0.0;

      if (positives > 1) {
        safetyMessage = "Unsafe: The URL has been flagged by multiple sources.";
      } else if (positives == 1) {
        safetyPercentage = 80.0;
        safetyMessage =
            "Moderate: The URL has been flagged by one source. Safety: $safetyPercentage%";
        isSafe = true;
      } else {
        safetyPercentage = 100.0;
        safetyMessage =
            "Safe: The URL appears to be safe. Safety: $safetyPercentage%";
        isSafe = true;
      }

      // Save to history
      _saveToHistory(url, isSafe);

      if (!isSafe) {
        // Add to blocked URLs if unsafe
        widget.blockedUrls.add(url);
      }

      await _showSafetyDialog(context, Uri.parse(url), safetyMessage, isSafe);
    } catch (e) {
      setState(() {
        _scanResultMessage = "Error verifying URL: $e";
      });
    }
  }

  void _saveToHistory(String url, bool isSafe) {
    setState(() {
      widget.scanHistory.add(ScanHistoryItem(url: url, isSafe: isSafe, timestamp: DateTime.now()));
    });
  }

  Future<void> _showSafetyDialog(
      BuildContext context, Uri uri, String message, bool isSafe) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('URL Safety Check'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            if (isSafe)
              TextButton(
                child: Text('Proceed to ${uri.toString()}'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  if (await canLaunch(uri.toString())) {
                    await launch(uri.toString(), forceSafariVC: false, forceWebView: false);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Could not launch $uri")),
                    );
                  }
                },
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back arrow
        title: const Text(
          'Scan QR Code',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 72, 78, 67),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) =>
                        ScanCodePage(blockedUrls: widget.blockedUrls, scanHistory: widget.scanHistory)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent, // Makes button background transparent
              foregroundColor: Colors.red, // Changes the text color to red
              elevation: 0, // Removes the shadow/elevation
            ),
            child: const Text('Rescan'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => const HomeView()), // Pass the blockedUrls to HomeView if needed
                (Route<dynamic> route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent, // Makes button background transparent
              foregroundColor: Colors.red, // Changes the text color to red
              elevation: 0, // Removes the shadow/elevation
            ),
            child: const Text('LinkChecker'),
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[200], // Light gray background to match HomeView
        child: Column(
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
                      _checkUrlSafety(url); // Pass the scanned URL to the VirusTotal check
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
      ),
    );
  }
}


















