import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // For formatting the timestamp
import 'package:url_launcher/url_launcher.dart';  // Import url_launcher

// Model for storing each scan history item
class ScanHistoryItem {
  final String url;
  final bool isSafe;
  final DateTime timestamp;

  ScanHistoryItem({required this.url, required this.isSafe, required this.timestamp});
}

// Page to display the scan history
class ScanHistoryPage extends StatelessWidget {
  final List<ScanHistoryItem> scanHistory;

  const ScanHistoryPage({required this.scanHistory, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan History'),
      ),
      body: scanHistory.isEmpty
          ? const Center(
              child: Text('No scan history available.'),
            )
          : ListView.builder(
              itemCount: scanHistory.length,
              itemBuilder: (context, index) {
                final item = scanHistory[index];
                return ListTile(
                  title: Text(
                    item.url,
                    style: TextStyle(
                      color: item.isSafe ? Colors.blue : Colors.grey, // Use grey color for unsafe links
                      decoration:
                          item.isSafe ? TextDecoration.underline : TextDecoration.none, // Underline only safe links
                    ),
                  ),
                  subtitle: Text(
                    'Result: ${item.isSafe ? 'Safe' : 'Unsafe'}\nScanned at: ${DateFormat('yyyy-MM-dd – kk:mm').format(item.timestamp)}',
                  ),
                  trailing: item.isSafe
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : const Icon(Icons.warning, color: Colors.red),
                  onTap: () async {
                    if (item.isSafe) {
                      final Uri uri = Uri.parse(item.url);
                      if (await canLaunch(uri.toString())) {
                        await launch(uri.toString(), forceSafariVC: false, forceWebView: false);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Could not launch ${item.url}")),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("This URL is unsafe and cannot be opened.")),
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}




