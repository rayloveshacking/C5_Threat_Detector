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
        title: const Text('Blocked URLs'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Enter URL to block',
                hintText: 'https://example.com',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addBlockedUrl,
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
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeBlockedUrl(url),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showRecommendationDialog,
              child: const Text('Need more control?'),
            ),
          ],
        ),
      ),
    );
  }
}



