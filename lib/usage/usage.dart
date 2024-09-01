import 'package:flutter/material.dart';
import 'package:flutter_application_1/apicalls.dart';
import 'package:flutter_application_1/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _linkController = TextEditingController();
  final ApiServices _apiServices = ApiServices();

void verifyLink() async {
  final String url = _linkController.text;

  if (url.isEmpty) {
    _showMessage("Please enter a URL.");
    return;
  }

  // Validate the URL format
  final Uri? uri = Uri.tryParse(url);
  if (uri == null || !uri.hasScheme) {
    _showMessage("Invalid URL format.");
    return;
  }

  try {
    final scanResult = await _apiServices.checkUrlVirusTotal(url);
    int positives = scanResult['positives'] ?? 0;

    String safetyMessage;
    bool isSafe = false;
    double safetyPercentage = 0.0;

    if (positives > 1) {
      safetyMessage = "Unsafe: The URL has been flagged by multiple sources.";
    } else if (positives == 1) {
      safetyPercentage = 80.0;
      safetyMessage = "Moderate: The URL has been flagged by one source. Safety: $safetyPercentage%";
      isSafe = true;
    } else {
      safetyPercentage = 100.0;
      safetyMessage = "Safe: The URL appears to be safe. Safety: $safetyPercentage%";
      isSafe = true;
    }

    // Show dialog with the result message and proceed option if safe
    await _showSafetyDialog(context, uri, safetyMessage, isSafe);

  } catch (e) {
    _showMessage("Error verifying URL: $e");
  }
}

Future<void> _showSafetyDialog(BuildContext context, Uri uri, String message, bool isSafe) async {
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
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  _showMessage("Could not launch $uri");
                }
              },
            ),
        ],
      );
    },
  );
}


  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Threat Detector',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _linkController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter URL',
                  hintText: 'https://example.com',
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: verifyLink,
              child: const Text('Verify'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Scan QR code'),
              onPressed: () async {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const ScanCodePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}







