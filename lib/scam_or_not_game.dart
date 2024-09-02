import 'package:flutter/material.dart';
import 'dart:math';

class ScamOrNotGame extends StatefulWidget {
  const ScamOrNotGame({super.key});

  @override
  _ScamOrNotGameState createState() => _ScamOrNotGameState();
}

class _ScamOrNotGameState extends State<ScamOrNotGame> {
  final List<Map<String, String>> _allUrls = [];  // Stores URLs, hints, explanations
  List<Map<String, String>> _currentLevelUrls = [];  // Stores URLs for the current level
  int _currentLevel = 0;
  int _currentIndex = 0;
  int _score = 0;
  String _feedbackMessage = '';
  String _hintMessage = '';
  String _rank = 'Novice'; // Initial rank

  @override
  void initState() {
    super.initState();
    _generateAllUrls();  // Generate all the URLs, hints, and explanations
    _startNewLevel();    // Start the first level
  }

  void _generateAllUrls() {
    _allUrls.addAll([
      {
    'url': 'https://www.google-support.com',
    'hint': 'Does this domain look official? Google rarely uses support-specific domains.',
    'explanation': 'Google-support.com is a phishing site attempting to mimic Google’s support pages.',
    'isScam': 'true',
  },
  {
    'url': 'https://accounts.google.com',
    'hint': 'Look for trusted domains, especially with company names.',
    'explanation': 'Accounts.google.com is the legitimate URL used for managing Google accounts.',
    'isScam': 'false',
  },
  // Level 2 URLs
  {
    'url': 'https://www.amazon-secure-login.com',
    'hint': 'Pay attention to extra words like "secure" in the domain.',
    'explanation': 'Amazon-secure-login.com is a fake site designed to steal Amazon login credentials.',
    'isScam': 'true',
  },
  {
    'url': 'https://www.amazon.com/ap/signin',
    'hint': 'Look for official domains with straightforward URLs.',
    'explanation': 'Amazon.com/ap/signin is the legitimate sign-in page for Amazon users.',
    'isScam': 'false',
  },
  // Level 3 URLs
  {
    'url': 'https://update-paypal.com',
    'hint': 'Check if the URL is truly PayPal’s official domain.',
    'explanation': 'Update-paypal.com is a phishing site designed to trick users into providing their PayPal credentials.',
    'isScam': 'true',
  },
  {
    'url': 'https://www.paypal.com/myaccount/settings',
    'hint': 'Official domains usually lead to safe URLs.',
    'explanation': 'Paypal.com/myaccount/settings is the legitimate page for managing your PayPal settings.',
    'isScam': 'false',
  },
  // Level 4 URLs
  {
    'url': 'https://facebook-security-alert.com',
    'hint': 'Be cautious of URLs with extra words like "security" or "alert."',
    'explanation': 'Facebook-security-alert.com is a phishing site pretending to be a security alert from Facebook.',
    'isScam': 'true',
  },
  {
    'url': 'https://www.facebook.com/security',
    'hint': 'Look for well-known domains with simple paths.',
    'explanation': 'Facebook.com/security is the legitimate URL for Facebook’s security settings.',
    'isScam': 'false',
  },
  // Level 5 URLs
  {
    'url': 'https://icloud-accountverify.com',
    'hint': 'Watch out for domains asking to verify accounts—especially with unusual extensions.',
    'explanation': 'Icloud-accountverify.com is a phishing site designed to steal Apple ID credentials.',
    'isScam': 'true',
  },
  {
    'url': 'https://appleid.apple.com',
    'hint': 'Official Apple URLs are usually simple and easy to recognize.',
    'explanation': 'Appleid.apple.com is the legitimate site for managing your Apple ID.',
    'isScam': 'false',
  },
  // Level 6 URLs
  {
    'url': 'https://www.linkedin-support.net',
    'hint': '',
    'explanation': 'Linkedin-support.net is a phishing site mimicking LinkedIn’s support page.',
    'isScam': 'true',
  },
  {
    'url': 'https://www.linkedin.com/help',
    'hint': '',
    'explanation': 'Linkedin.com/help is the legitimate help center for LinkedIn users.',
    'isScam': 'false',
  },
  // Level 7 URLs
  {
    'url': 'https://www.chasebank-login.com',
    'hint': '',
    'explanation': 'Chasebank-login.com is a phishing site designed to steal Chase Bank login credentials.',
    'isScam': 'true',
  },
  {
    'url': 'https://secure01b.chase.com',
    'hint': '',
    'explanation': 'Secure01b.chase.com is a legitimate URL used by Chase Bank for secure login.',
    'isScam': 'false',
  },
  // Level 8 URLs
  {
    'url': 'https://www.microsoft365-security.com',
    'hint': '',
    'explanation': 'Microsoft365-security.com is a phishing site targeting Microsoft 365 users.',
    'isScam': 'true',
  },
  {
    'url': 'https://login.microsoftonline.com',
    'hint': '',
    'explanation': 'Login.microsoftonline.com is a legitimate Microsoft URL used for signing into Microsoft services.',
    'isScam': 'false',
  },
  // Level 9 URLs
  {
    'url': 'https://www.netflix-account-verify.com',
    'hint': '',
    'explanation': 'Netflix-account-verify.com is a phishing site designed to steal Netflix login credentials.',
    'isScam': 'true',
  },
  {
    'url': 'https://www.netflix.com/Login',
    'hint': '',
    'explanation': 'Netflix.com/Login is the official login page for Netflix users.',
    'isScam': 'false',
  },
  // Level 10 URLs
  {
    'url': 'https://www.appleidverification.net',
    'hint': '',
    'explanation': 'Appleidverification.net is a phishing site attempting to steal Apple ID credentials.',
    'isScam': 'true',
  },
  {
    'url': 'https://iforgot.apple.com',
    'hint': '',
    'explanation': 'Iforgot.apple.com is the official site for recovering your Apple ID password.',
    'isScam': 'false',
  },
  // Level 11 URLs
  {
    'url': 'https://www.amazon-account-verification.com',
    'hint': '',
    'explanation': 'Amazon-account-verification.com is a phishing site targeting Amazon users.',
    'isScam': 'true',
  },
  {
    'url': 'https://www.amazon.com/gp/css/homepage.html',
    'hint': '',
    'explanation': 'Amazon.com/gp/css/homepage.html is the official page for managing your Amazon account.',
    'isScam': 'false',
  },
  // Level 12 URLs
  {
    'url': 'https://www.outlook-security-alert.com',
    'hint': '',
    'explanation': 'Outlook-security-alert.com is a phishing site designed to steal Outlook login credentials.',
    'isScam': 'true',
  },
  {
    'url': 'https://outlook.live.com/owa/',
    'hint': '',
    'explanation': 'Outlook.live.com/owa/ is the official webmail service provided by Microsoft for Outlook users.',
    'isScam': 'false',
  },
  // Level 13 URLs
  {
    'url': 'https://www.paypal-signin.net',
    'hint': '',
    'explanation': 'Paypal-signin.net is a phishing site pretending to be PayPal’s login page.',
    'isScam': 'true',
  },
  {
    'url': 'https://www.paypal.com/signin',
    'hint': '',
    'explanation': 'Paypal.com/signin is the legitimate login page for PayPal.',
    'isScam': 'false',
  },
  // Level 14 URLs
  {
    'url': 'https://www.bbcnews-update.com',
    'hint': '',
    'explanation': 'Bbcnews-update.com is a fake site designed to mimic BBC News and spread misinformation.',
    'isScam': 'true',
  },
  {
    'url': 'https://www.bbc.com/news',
    'hint': '',
    'explanation': 'Bbc.com/news is the official news site of the British Broadcasting Corporation (BBC).',
    'isScam': 'false',
  },
  // Level 15 URLs
  {
    'url': 'https://www.bankofamerica-account.com',
    'hint': '',
    'explanation': 'Bankofamerica-account.com is a phishing site that attempts to steal Bank of America login credentials.',
    'isScam': 'true',
  },
  {
    'url': 'https://secure.bankofamerica.com',
    'hint': '',
    'explanation': 'Secure.bankofamerica.com is the legitimate URL used for secure login to Bank of America.',
    'isScam': 'false',
  },
  // Level 16 URLs
  {
    'url': 'https://www.instagram-verification.net',
    'hint': '',
    'explanation': 'Instagram-verification.net is a phishing site designed to steal Instagram login credentials.',
    'isScam': 'true',
  },
  {
    'url': 'https://www.instagram.com/accounts/login/',
    'hint': '',
    'explanation': 'Instagram.com/accounts/login/ is the official login page for Instagram users.',
    'isScam': 'false',
  },
  // Level 17 URLs
  {
    'url': 'https://www.netflix-security-alert.com',
    'hint': '',
    'explanation': 'Netflix-security-alert.com is a phishing site targeting Netflix users.',
    'isScam': 'true',
  },
  {
    'url': 'https://www.netflix.com/security',
    'hint': '',
    'explanation': 'Netflix.com/security is the legitimate page for Netflix’s security settings.',
    'isScam': 'false',
  },
  // Level 18 URLs
  {
    'url': 'https://www.dropbox-account-verification.com',
    'hint': '',
    'explanation': 'Dropbox-account-verification.com is a phishing site attempting to steal Dropbox login credentials.',
    'isScam': 'true',
  },
  {
    'url': 'https://www.dropbox.com/login',
    'hint': '',
    'explanation': 'Dropbox.com/login is the official login page for Dropbox users.',
    'isScam': 'false',
  },
  // Level 19 URLs
  {
    'url': 'https://www.google-photos-login.com',
    'hint': '',
    'explanation': 'Google-photos-login.com is a phishing site designed to steal Google account credentials.',
    'isScam': 'true',
  },
  {
    'url': 'https://photos.google.com',
    'hint': '',
    'explanation': 'Photos.google.com is the legitimate site for accessing Google Photos.',
    'isScam': 'false',
  },
  // Level 20 URLs
  {
    'url': 'https://www.adobeid-verification.com',
    'hint': '',
    'explanation': 'Adobeid-verification.com is a phishing site pretending to be Adobe’s login page.',
    'isScam': 'true',
  },
  {
    'url': 'https://account.adobe.com',
    'hint': '',
    'explanation': 'Account.adobe.com is the official page for managing your Adobe ID.',
    'isScam': 'false',
  },
  // Level 21 URLs
  {
    'url': 'https://www.apple-verify.net',
    'hint': '',
    'explanation': 'Apple-verify.net is a phishing site trying to steal Apple ID credentials by mimicking Apple’s verification process.',
    'isScam': 'true',
  },
  {
    'url': 'https://appleid.apple.com/account/manage',
    'hint': '',
    'explanation': 'Appleid.apple.com/account/manage is the legitimate page for managing your Apple ID.',
    'isScam': 'false',
  },
  // Level 22 URLs
  {
    'url': 'https://www.paypal-billing-update.com',
    'hint': '',
    'explanation': 'Paypal-billing-update.com is a phishing site attempting to steal PayPal login credentials by requesting billing updates.',
    'isScam': 'true',
  },
  {
    'url': 'https://www.paypal.com/myaccount/autosweep',
    'hint': '',
    'explanation': 'Paypal.com/myaccount/autosweep is a legitimate page within PayPal’s site for managing account settings.',
    'isScam': 'false',
  },
  // Level 23 URLs
  {
    'url': 'https://www.secure-amazon-login.com',
    'hint': '',
    'explanation': 'Secure-amazon-login.com is a phishing site designed to steal Amazon login credentials by mimicking Amazon’s login page.',
    'isScam': 'true',
  },
  {
    'url': 'https://www.amazon.com/ap/handle-buying',
    'hint': '',
    'explanation': 'Amazon.com/ap/handle-buying is a legitimate page on Amazon’s website related to purchase management.',
    'isScam': 'false',
  },
  // Level 24 URLs
  {
    'url': 'https://www.microsoft-accountsecurity.net',
    'hint': '',
    'explanation': 'Microsoft-accountsecurity.net is a phishing site that attempts to steal Microsoft login credentials by mimicking Microsoft’s account security page.',
    'isScam': 'true',
  },
  {
    'url': 'https://account.microsoft.com/security',
    'hint': '',
    'explanation': 'Account.microsoft.com/security is the legitimate page for managing your Microsoft account’s security settings.',
    'isScam': 'false',
  },
  // Level 25 URLs
  {
    'url': 'https://www.netflixsecure-login.com',
    'hint': '',
    'explanation': 'Netflixsecure-login.com is a phishing site that mimics Netflix’s login page to steal login credentials.',
    'isScam': 'true',
  },
  {
    'url': 'https://www.netflix.com/browse',
    'hint': '',
    'explanation': 'Netflix.com/browse is the legitimate page for browsing Netflix’s streaming content.',
    'isScam': 'false',
  },
  // Level 26 URLs
  {
    'url': 'https://www.bankofamerica-update.com',
    'hint': '',
    'explanation': 'Bankofamerica-update.com is a phishing site that attempts to steal Bank of America login credentials by mimicking an account update page.',
    'isScam': 'true',
  },
  {
    'url': 'https://secure.bankofamerica.com/myaccounts/signin',
    'hint': '',
    'explanation': 'Secure.bankofamerica.com/myaccounts/signin is the legitimate login page for Bank of America customers.',
    'isScam': 'false',
  },
  // Level 27 URLs
  {
    'url': 'https://www.facebook-update-verify.com',
    'hint': '',
    'explanation': 'Facebook-update-verify.com is a phishing site designed to steal Facebook login credentials by pretending to be a security verification.',
    'isScam': 'true',
  },
  {
    'url': 'https://www.facebook.com/settings',
    'hint': '',
    'explanation': 'Facebook.com/settings is the legitimate page for managing your Facebook account settings.',
    'isScam': 'false',
  },
  // Level 28 URLs
  {
    'url': 'https://www.gmail-security-checkup.com',
    'hint': '',
    'explanation': 'Gmail-security-checkup.com is a phishing site attempting to steal Gmail login credentials by mimicking Google’s security checkup process.',
    'isScam': 'true',
  },
  {
    'url': 'https://myaccount.google.com/security-checkup',
    'hint': '',
    'explanation': 'Myaccount.google.com/security-checkup is the legitimate page for checking and managing your Google account security.',
    'isScam': 'false',
  },
  // Level 29 URLs
  {
    'url': 'https://www.amazon-verify-identity.com',
    'hint': '',
    'explanation': 'Amazon-verify-identity.com is a phishing site that mimics Amazon’s identity verification page to steal login credentials.',
    'isScam': 'true',
  },
  {
    'url': 'https://www.amazon.com/gp/help/customer/account-issues',
    'hint': '',
    'explanation': 'Amazon.com/gp/help/customer/account-issues is a legitimate Amazon help page addressing account-related issues.',
    'isScam': 'false',
  },
  // Level 30 URLs
  {
    'url': 'https://www.microsoft-security-check.com',
    'hint': '',
    'explanation': 'Microsoft-security-check.com is a phishing site attempting to steal Microsoft login credentials by mimicking a security check page.',
    'isScam': 'true',
  },
  {
    'url': 'https://account.microsoft.com/devices',
    'hint': '',
    'explanation': 'Account.microsoft.com/devices is the legitimate page for managing devices linked to your Microsoft account.',
    'isScam': 'false',
  },
  // Level 31 URLs
  {
    'url': 'https://www.paypal-activity-check.com',
    'hint': '',
    'explanation': 'Paypal-activity-check.com is a phishing site designed to steal PayPal login credentials by mimicking an activity check page.',
    'isScam': 'true',
  },
  {
    'url': 'https://www.paypal.com/myaccount/summary',
    'hint': '',
    'explanation': 'Paypal.com/myaccount/summary is the legitimate page for viewing your PayPal account summary.',
    'isScam': 'false',
  },
  // Level 32 URLs
  {
    'url': 'https://www.netflix-securebilling.com',
    'hint': '',
    'explanation': 'Netflix-securebilling.com is a phishing site attempting to steal Netflix login credentials by pretending to be a billing page.',
    'isScam': 'true',
  },
  {
    'url': 'https://www.netflix.com/youraccount',
    'hint': '',
    'explanation': 'Netflix.com/youraccount is the legitimate page for managing your Netflix account.',
    'isScam': 'false',
  },
  // Level 33 URLs
  {
    'url': 'https://www.amazon-order-update.com',
    'hint': '',
    'explanation': 'Amazon-order-update.com is a phishing site designed to steal Amazon login credentials by mimicking an order update page.',
    'isScam': 'true',
  },
  {
    'url': 'https://www.amazon.com/gp/your-account/order-history',
    'hint': '',
    'explanation': 'Amazon.com/gp/your-account/order-history is the legitimate page for viewing your Amazon order history.',
    'isScam': 'false',
  },
  // Level 34 URLs
  {
    'url': 'https://www.bankofamerica-securitycheck.com',
    'hint': '',
    'explanation': 'Bankofamerica-securitycheck.com is a phishing site attempting to steal Bank of America login credentials by pretending to be a security check page.',
    'isScam': 'true',
  },
  {
    'url': 'https://secure.bankofamerica.com/security-center/overview.go',
    'hint': '',
    'explanation': 'Secure.bankofamerica.com/security-center/overview.go is the legitimate security center page for Bank of America customers.',
    'isScam': 'false',
  },
  // Level 35 URLs
  {
    'url': 'https://www.facebook-identityverify.com',
    'hint': '',
    'explanation': 'Facebook-identityverify.com is a phishing site designed to steal Facebook login credentials by mimicking an identity verification page.',
    'isScam': 'true',
  },
  {
    'url': 'https://www.facebook.com/security/2fac/settings',
    'hint': '',
    'explanation': 'Facebook.com/security/2fac/settings is the legitimate page for managing two-factor authentication on Facebook.',
    'isScam': 'false',
  },
  // Level 36 URLs
  {
    'url': 'https://www.instagram-security-update.com',
    'hint': '',
    'explanation': 'Instagram-security-update.com is a phishing site designed to steal Instagram login credentials by pretending to be a security update page.',
    'isScam': 'true',
  },
  {
    'url': 'https://www.instagram.com/security/settings',
    'hint': '',
    'explanation': 'Instagram.com/security/settings is the legitimate page for managing your Instagram security settings.',
    'isScam': 'false',
  },
  // Level 37 URLs
  {
    'url': 'https://www.google-drive-secure.com',
    'hint': '',
    'explanation': 'Google-drive-secure.com is a phishing site designed to steal Google Drive login credentials by mimicking a secure login page.',
    'isScam': 'true',
  },
  {
    'url': 'https://drive.google.com/drive/my-drive',
    'hint': '',
    'explanation': 'Drive.google.com/drive/my-drive is the legitimate page for accessing your Google Drive files.',
    'isScam': 'false',
  },
  // Level 38 URLs
  {
    'url': 'https://www.dropbox-activitycheck.com',
    'hint': '',
    'explanation': 'Dropbox-activitycheck.com is a phishing site attempting to steal Dropbox login credentials by mimicking an activity check page.',
    'isScam': 'true',
  },
  {
    'url': 'https://www.dropbox.com/account/activity',
    'hint': '',
    'explanation': 'Dropbox.com/account/activity is the legitimate page for viewing your Dropbox account activity.',
    'isScam': 'false',
  },
  // Level 39 URLs
  {
    'url': 'https://www.linkedin-identityverification.com',
    'hint': '',
    'explanation': 'Linkedin-identityverification.com is a phishing site designed to steal LinkedIn login credentials by mimicking an identity verification page.',
    'isScam': 'true',
  },
  {
    'url': 'https://www.linkedin.com/settings/',
    'hint': '',
    'explanation': 'LinkedIn.com/settings is the legitimate page for managing your LinkedIn account settings.',
    'isScam': 'false',
  },
  // Level 40 URLs
  {
    'url': 'https://www.microsoft-loginverify.com',
    'hint': '',
    'explanation': 'Microsoft-loginverify.com is a phishing site attempting to steal Microsoft login credentials by pretending to be a verification page.',
    'isScam': 'true',
  },
  {
    'url': 'https://login.microsoftonline.com/verify',
    'hint': '',
    'explanation': 'Login.microsoftonline.com/verify is the legitimate page used by Microsoft for account verification.',
    'isScam': 'false',
  }
      // Add your URLs here with isScam, hint, and explanation keys
    ]);
  }

  void _startNewLevel() {
    _currentLevel++;
    _currentIndex = 0;
    _currentLevelUrls = _allUrls.sublist(0, min(_allUrls.length, 2)); // Get URLs for the level
    _allUrls.shuffle(); // Shuffle URLs to ensure a different order each time
    _updateHint();
  }

  void _checkAnswer(bool userSaidScam) async {
    final currentUrl = _currentLevelUrls[_currentIndex]['url']!;
    final isScam = _currentLevelUrls[_currentIndex]['isScam'] == 'true';

    if (userSaidScam == isScam) {
      setState(() {
        _score += 10; // Reward 10 points for each correct answer
        _feedbackMessage = 'Correct! +10 Points';
        _updateRank(); // Update rank based on score
      });
    } else {
      setState(() {
        _feedbackMessage =
            'Wrong! That URL is ${isScam ? 'a Scam' : 'Real'}.';
        _feedbackMessage += '\n' + _currentLevelUrls[_currentIndex]['explanation']!;
      });
    }

    _nextUrl();
  }

  void _nextUrl() {
    setState(() {
      if (_currentIndex < _currentLevelUrls.length - 1) {
        _currentIndex++;
        _updateHint();
      } else {
        if (_currentLevel < 40) {
          _startNewLevel();
          _feedbackMessage = 'Level Up! You\'re now on Level $_currentLevel';
        } else {
          _feedbackMessage = 'Game Over! Your total score: $_score\nYour Rank: $_rank';
        }
      }
    });
  }

  void _updateRank() {
    if (_score <= 100) {
      _rank = 'Novice';
    } else if (_score <= 200) {
      _rank = 'Intermediate';
    } else if (_score <= 300) {
      _rank = 'Pro';
    } else if (_score <= 400) {
      _rank = 'Expert';
    } else if (_score <= 500) {
      _rank = 'Master';
    } else {
      _rank = 'Legend';
    }
  }

  void _updateHint() {
    if (_currentLevel <= 5) {  // Provide hints only in the first 5 levels
      _hintMessage = _currentLevelUrls[_currentIndex]['hint']!;
    } else {
      _hintMessage = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fake or Real Game',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 72, 78, 67),
      ),
      body: Container(
        color: Colors.grey[200], // Light gray background to match the theme
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Is this URL fake or real? (Level $_currentLevel)',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Text(
              _currentLevelUrls[_currentIndex]['url']!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.blue),
            ),
            if (_hintMessage.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                'Hint: $_hintMessage',
                style: const TextStyle(fontSize: 16, color: Colors.green),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _checkAnswer(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700], // Red button background
                foregroundColor: Colors.white, // White text color
              ),
              child: const Text('Fake'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _checkAnswer(false),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700], // Green button background
                foregroundColor: Colors.white, // White text color
              ),
              child: const Text('Real'),
            ),
            const SizedBox(height: 20),
            Text(
              _feedbackMessage,
              style: const TextStyle(fontSize: 18, color: Colors.red),
            ),
            const SizedBox(height: 20),
            Text(
              'Score: $_score',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Rank: $_rank',
              style: const TextStyle(fontSize: 18, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}






