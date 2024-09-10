import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';  // Ensure this is imported

class ScamNewsPage extends StatelessWidget {
  const ScamNewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> newsArticles = [
      {
        'title': 'Unverified apps have been installed around 900,000 times during the past 6 months',
        'date': 'September 2, 2024',
        'content':
            'Despite efforts by the authorities and private sector, Android users in Singapore still made nearly 900,000 attempts to install high-risk apps that could have led to their devices being infected with malware, said tech giant Google on Thursday (Aug 15).',
        'url': 'https://www.channelnewsasia.com/singapore/android-users-install-malware-unverified-apps-google-fund-anti-scam-4550026'
      },
      {
        'title': 'Man nearly loses 250,000 Singaporean Dollars to scammers impersonating bank staff, police officer',
        'date': 'June 14, 2024',
        'content':
            'SINGAPORE: A man came close to losing 250,000 Singaporean Dollars (US185,000) after falling prey to scammers posing as a bank staff member and a police officer.',
        'url': 'https://www.channelnewsasia.com/singapore/scams-police-officer-bank-staff-impersonation-money-recovered-bank-account-details-4411281'
      },
      {
        'title': 'Government SMSes will come from single gov.sg sender ID to guard against scams',
        'date': 'June 13, 2024',
        'content':
            'SINGAPORE: From Jul 1, SMSes from government agencies will come from a single sender ID known as gov.sg, instead of the individual organisations. ',
        'url': 'https://www.channelnewsasia.com/singapore/sms-gov-sg-government-agencies-impersonation-scams-july-1-4404736'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Latest Threat News'),
      ),
      body: ListView.builder(
        itemCount: newsArticles.length,
        itemBuilder: (context, index) {
          final article = newsArticles[index];
          return Card(
            margin: const EdgeInsets.all(10.0),
            child: ListTile(
              title: Text(
                article['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${article['date']}\n${article['content']}',
                style: const TextStyle(height: 1.5),
              ),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () async {
                final Uri uri = Uri.parse(article['url']!);
                if (await canLaunch(uri.toString())) {
                  await launch(uri.toString(), forceSafariVC: false, forceWebView: false);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Could not launch ${article['url']}")),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}

