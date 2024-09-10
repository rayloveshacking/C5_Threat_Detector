import 'package:flutter/material.dart';
import 'package:flutter_application_1/apicalls.dart';
import 'package:flutter_application_1/blocked_urls.dart';
import 'package:flutter_application_1/qr_code_scanner.dart';
import 'package:flutter_application_1/scam_or_not_game.dart';
import 'package:flutter_application_1/history.dart';
import 'package:flutter_application_1/news.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  final TextEditingController _linkController = TextEditingController();
  final ApiServices _apiServices = ApiServices();

  // Static variables to persist data across widget rebuilds
  static final List<String> _blockedUrls = [];
  static final List<ScanHistoryItem> _scanHistory = [];
  static bool _dialogShown = false; // Use a static variable to track the dialog state

  @override
  void initState() {
    super.initState();
    // Show the dialog once when the HomeView is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_dialogShown) {
        _showFakeLinkDialog();
        _dialogShown = true; // Set to true after showing the dialog
      }
    });
  }

  void _showFakeLinkDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Beware of Fake Links!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('images/fake.png'),
              const SizedBox(height: 20),
              const Text(
                'In the example, the myuniversity.edu/renewal URL was changed to myuniversity.edurenewal.com. Similarities between the two addresses offer the impression of a secure link, making the recipient less aware that an attack is taking place.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Got it!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
        safetyMessage = "Moderate: The URL has been flagged by one source. Safety: $safetyPercentage%";
        isSafe = true;
      } else {
        safetyPercentage = 100.0;
        safetyMessage = "Safe: The URL appears to be safe. Safety: $safetyPercentage%";
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
      if (e.toString().contains('limit exceeded')) {
        _showMessage("Please try again later as the api only allow 4 requests per min.");
      } else {
        _showMessage("Please try again later as the api only allow 4 requests per min.");
      }
    }
  }

  void _saveToHistory(String url, bool isSafe) {
    setState(() {
      _scanHistory.add(ScanHistoryItem(url: url, isSafe: isSafe, timestamp: DateTime.now()));
    });
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
                  if (!_scanHistory.any((item) => item.url == uri.toString())) {
                    _saveToHistory(uri.toString(), true);
                  }
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
        title: const Text('C5 Threat Detector', style: TextStyle(
          color: Colors.white
        )),
        backgroundColor: const Color.fromARGB(255, 72, 78, 67),
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.block),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => BlockedUrlsPage(blockedUrls: _blockedUrls)),
              );
            },
          ),
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ScanHistoryPage(scanHistory: _scanHistory)),
              );
            },
          ),
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.article),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ScamNewsPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[200], // Light gray background
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: _linkController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Enter the link to verify',
                    hintText: 'https://example.com',
                    prefixIcon: const Icon(Icons.link),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: verifyLink,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700], // Red button background
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
                  minimumSize: const Size(200, 50), // Ensures all buttons have the same size
                ),
                child: const Text(
                  'Verify your Link',
                  style: TextStyle(
                    color: Colors.white, // White text color
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('-OR-', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ScanCodePage(blockedUrls: _blockedUrls, scanHistory: _scanHistory)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700], // Red button background
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
                  minimumSize: const Size(200, 50), // Ensures all buttons have the same size
                ),
                child: const Text(
                  'Scan QR Code',
                  style: TextStyle(
                    color: Colors.white, // White text color
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('-OR-', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ScamOrNotGame()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700], // Red button background
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
                  minimumSize: const Size(200, 50), // Ensures all buttons have the same size
                ),
                child: const Text(
                  'Play Game',
                  style: TextStyle(
                    color: Colors.white, // White text color
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
