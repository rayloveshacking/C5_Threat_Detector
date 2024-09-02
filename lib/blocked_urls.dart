import 'package:flutter/material.dart';

class BlockedUrlsPage extends StatefulWidget {
  final List<String> blockedUrls;

  const BlockedUrlsPage({required this.blockedUrls, super.key});

  @override
  _BlockedUrlsPageState createState() => _BlockedUrlsPageState();
}

class _BlockedUrlsPageState extends State<BlockedUrlsPage> {
  final TextEditingController _urlController = TextEditingController();

  void _addBlockedUrl() {
    final url = _urlController.text;
    if (url.isNotEmpty) {
      setState(() {
        widget.blockedUrls.add(url);
        _urlController.clear();
      });
    }
  }

  void _removeBlockedUrl(String url) {
    setState(() {
      widget.blockedUrls.remove(url);
    });
  }

  void _showRecommendationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Recommendation'),
          content: const Text(
            'For more powerful URL blocking across your entire device, consider using dedicated apps like "AppBlock" or "Mobicip". These apps offer advanced features to manage and block content across all apps and browsers on your device.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
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
        title: const Text(
          'Blocked URLs',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 72, 78, 67),
      ),
      body: Container(
        color: Colors.grey[200], // Light gray background to match the theme
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'Enter URL to block',
                hintText: 'https://example.com',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addBlockedUrl,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700], // Red button background
                foregroundColor: Colors.white, // White text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Add URL'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: widget.blockedUrls.length,
                itemBuilder: (context, index) {
                  final url = widget.blockedUrls[index];
                  return ListTile(
                    title: Text(url),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeBlockedUrl(url),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showRecommendationDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700], // Green button background
                foregroundColor: Colors.white, // White text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Need more control?'),
            ),
          ],
        ),
      ),
    );
  }
}




