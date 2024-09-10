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
class ScanHistoryPage extends StatefulWidget {
  final List<ScanHistoryItem> scanHistory;

  const ScanHistoryPage({required this.scanHistory, super.key});

  @override
  _ScanHistoryPageState createState() => _ScanHistoryPageState();
}

class _ScanHistoryPageState extends State<ScanHistoryPage> {
  void _deleteHistoryItem(int index) {
    setState(() {
      widget.scanHistory.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan History'),
      ),
      body: widget.scanHistory.isEmpty
          ? const Center(
              child: Text('No scan history available.'),
            )
          : ListView.builder(
              itemCount: widget.scanHistory.length,
              itemBuilder: (context, index) {
                final item = widget.scanHistory[index];
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteHistoryItem(index);
                        },
                      ),
                      if (item.isSafe)
                        IconButton(
                          icon: const Icon(Icons.check_circle, color: Colors.green),
                          onPressed: () async {
                            final Uri uri = Uri.parse(item.url);
                            if (await canLaunch(uri.toString())) {
                              await launch(uri.toString(), forceSafariVC: false, forceWebView: false);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Could not launch ${item.url}")),
                              );
                            }
                          },
                        ),
                      if (!item.isSafe)
                        IconButton(
                          icon: const Icon(Icons.warning, color: Colors.red),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("This URL is unsafe and cannot be opened.")),
                            );
                          },
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
