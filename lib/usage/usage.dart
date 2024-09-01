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
  String _resultMessage = "Enter a URL to verify.";

  void verifyLink() async {
    final String url = _linkController.text;
    
    if (url.isEmpty) {
      setState(() {
        _resultMessage = "Please enter a URL.";
      });
      return;
    }

    // Validate the URL format
    final Uri? uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) {
      setState(() {
        _resultMessage = "Invalid URL format.";
      });
      return;
    }

    try {
      final scanResult = await _apiServices.checkUrlVirusTotal(url);
      int positives = scanResult['positives'] ?? 0;

      String safetyMessage;
      if (positives > 2) {
        safetyMessage = "Unsafe: The URL has been flagged by multiple sources.";
      } else if (positives == 1) {
        safetyMessage = "Moderate: The URL has been flagged by one source.";
      } else {
        safetyMessage = "Safe: The URL appears to be safe.";
        
        // Launch URL outside of setState
        bool canLaunch = await canLaunchUrl(uri);
        if (canLaunch) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          throw 'Could not launch $url';
        }
      }

      // Update the result message
      setState(() {
        _resultMessage = safetyMessage;
      });

    } catch (e) {
      setState(() {
        _resultMessage = "Error verifying URL: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_resultMessage),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
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
                ),
                ElevatedButton(
                  onPressed: verifyLink,
                  child: const Text('Verify'),
                ),
              ],
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



