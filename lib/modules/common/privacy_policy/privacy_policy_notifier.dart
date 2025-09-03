import 'package:community_app/core/base/base_notifier.dart';

class PrivacyPolicyNotifier extends BaseChangeNotifier {
  final List<Map<String, dynamic>> privacyPolicy = [
    {
      "title": "Privacy Policy",
      "content": [
        "Effective Date: [Insert Date]",
        "Xception (“we,” “our,” or “us”) values your privacy. This Privacy Policy explains how we collect, use, disclose, and protect your personal information when you use our mobile application and related jobs (the “App”). By using our App, you agree to the practices described in this Privacy Policy."
      ],
    },
    {
      "title": "1. Information We Collect",
      "content": [
        "We collect the following types of information:",
        "a. Personal Information",
        " • Name, email address, phone number, address",
        " • Login credentials (if applicable)",
        "b. Identification Documents",
        " • Trade license details",
        " • Emirates ID details (for verification purposes)",
        "c. Automatically Collected Information",
        " • Device information (model, OS, unique device identifiers)",
        " • App usage data and analytics (via Firebase Analytics)",
        " • IP address and log information",
        "d. Children’s Data",
        "Our App may be used by children under the supervision of parents/guardians. We do not knowingly collect personal data from children without parental consent."
      ],
    },
    {
      "title": "2. How We Use Your Information",
      "content": [
        "We use your data to:",
        " • Provide, operate, and improve our jobs",
        " • Verify identity and validate vendor/customer details",
        " • Send important updates, notifications, and alerts (via Firebase Messaging)",
        " • Improve app experience using analytics",
        " • Comply with legal and regulatory requirements"
      ],
    },
    {
      "title": "3. Sharing Your Information",
      "content": [
        "We do not sell your personal data.",
        "We may share your data with:",
        "• Third-party service providers: Firebase (push notifications & analytics)",
        "• PayTabs (for payment processing if added later)",
        "• Government authorities if required by law or for legal compliance"
      ],
    },
    {
      "title": "4. Data Retention",
      "content": [
        "We retain your data only as long as necessary for:",
        " • Providing our jobs",
        " • Legal and regulatory obligations",
        " • Resolving disputes",
        "When data is no longer needed, we will securely delete or anonymize it."
      ],
    },
    {
      "title": "5. Your Rights",
      "content": [
        "Depending on your location (including UAE and GDPR jurisdictions), you may have the right to:",
        " • Access, correct, or delete your personal data",
        " • Object to processing or request data portability",
        " • Withdraw consent at any time (if applicable)",
        "To exercise these rights, contact us at sana.xception@gmail.com."
      ],
    },
    {
      "title": "6. Children’s Privacy",
      "content": [
        "We encourage parents and guardians to monitor their children’s app usage. If we discover we have collected personal data from a child without proper consent, we will take steps to delete it."
      ],
    },
    {
      "title": "7. Cookies & Tracking",
      "content": [
        "We may use cookies or similar technologies for analytics and service improvement. You can disable cookies via device settings, but some features may not work properly."
      ],
    },
    {
      "title": "8. International Data Transfers",
      "content": [
        "Although we currently operate in the UAE, your data may be stored or processed on servers located outside your country. We ensure appropriate safeguards for such transfers."
      ],
    },
    {
      "title": "9. Security",
      "content": [
        "We implement reasonable measures to protect your information, including encryption and secure storage. However, no method of transmission over the Internet is 100% secure."
      ],
    },
    {
      "title": "10. Changes to This Policy",
      "content": [
        "We may update this Privacy Policy from time to time. Any changes will be posted here with the updated “Effective Date.”"
      ],
    },
    {
      "title": "11. Contact Us",
      "content": [
        "If you have any questions or requests regarding this Privacy Policy, please contact:",
        "Sanaullah Khan",
        "Email: XXXXXXXX"
      ],
    },
  ];
}