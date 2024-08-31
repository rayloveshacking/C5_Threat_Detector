import 'package:flutter/material.dart';
import 'package:flutter_application_1/apicalls.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _linkController = TextEditingController();
  final ApiServices _apiServices = ApiServices();
  String _resultMessage = "Enter a URL to verify.";
  Map<String, dynamic>? _scanResult;

  void verifyLink() async {
    final String url = _linkController.text;
    if (url.isEmpty) {
      setState(() {
        _resultMessage = "Please enter a URL.";
      });
      return;
    }
    try {
      final scanResult = await _apiServices.checkUrlVirusTotal(url);
      setState(() {
        _scanResult = scanResult;
        _resultMessage = "Scan completed. Check the details below.";
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
            _scanResult != null
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _scanResult!.length,
                      itemBuilder: (context, index) {
                        String key = _scanResult!.keys.elementAt(index);
                        return ListTile(
                          title: Text('$key: ${_scanResult![key]}'),
                        );
                      },
                    ),
                  )
                : const Text('No result'),
            ElevatedButton(
              child: const Text('Scan QR code'),
              onPressed: () {
                // Implement QR Code scanning if needed
              },
            ),
          ],
        ),
      ),
    );
  }
}

