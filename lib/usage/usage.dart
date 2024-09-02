import 'package:flutter/material.dart';
import 'package:flutter_application_1/apicalls.dart';
import 'package:flutter_application_1/blocked_urls.dart';
import 'package:flutter_application_1/qr_code_scanner.dart';
import 'package:flutter_application_1/scam_or_not_game.dart';
import 'package:flutter_application_1/history.dart';
import 'package:flutter_application_1/news.dart';  // Import ScamNewsPage
import 'package:url_launcher/url_launcher.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _linkController = TextEditingController();
  final ApiServices _apiServices = ApiServices();
  final List<String> _blockedUrls = []; // In-memory list of blocked URLs
  final List<ScanHistoryItem> _scanHistory = [];  // To store scan history

  void verifyLink() async {
    final String url = _linkController.text;

    if (url.isEmpty) {
      _showMessage("Please enter a URL.");
      return;
    }

    if (_blockedUrls.contains(url)) {
      _showMessage("This URL is blocked and cannot be opened.");
      return;
    }

    // Continue with the existing URL verification logic
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
        _blockedUrls.add(url);
      }

      // Show dialog with the result message and proceed option if safe
      await _showSafetyDialog(context, Uri.parse(url), safetyMessage, isSafe);
    } catch (e) {
      _showMessage("Error verifying URL: $e");
    }
  }

  void _saveToHistory(String url, bool isSafe) {
    setState(() {
      _scanHistory.add(ScanHistoryItem(url: url, isSafe: isSafe, timestamp: DateTime.now()));
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
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('C5'),
        actions: [
          IconButton(
            icon: const Icon(Icons.block),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => BlockedUrlsPage(blockedUrls: _blockedUrls)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ScanHistoryPage(scanHistory: _scanHistory)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.article),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ScamNewsPage()),
              );
            },
          ),
        ],
      ),
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
              child: const Text('Verify URL'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ScanCodePage(blockedUrls: _blockedUrls, scanHistory: _scanHistory)),
                );
              },
              child: const Text('Scan QR Code'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ScamOrNotGame()),
                );
              },
              child: const Text('Play Fake or Real'),
            ),
          ],
        ),
      ),
    );
  }
}















