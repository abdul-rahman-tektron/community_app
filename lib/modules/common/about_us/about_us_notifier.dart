import 'package:community_app/core/base/base_notifier.dart';

class AboutUsNotifier extends BaseChangeNotifier {
  final List<Map<String, dynamic>> privacyPolicy = [
    {
      "title": "About Us - Xception Technologies LLC",
      "content": [
        "Effective Date: [Insert Date]",
        "Xception Technologies LLC, based in the UAE, is a trailblazing technology company dedicated to transforming property management by resolving property-related issues with speed, transparency, and innovation. We specialize in delivering end-to-end solutions for villa maintenance, issue resolution, and community management, designed to meet the needs of residents, property owners, and developers. Our mission is to streamline property issue resolution through AI-powered tools, smart platforms, and community-focused technologies. We tackle daily property challenges—such as maintenance requests, repairs, and operational inefficiencies—ensuring swift resolutions, full visibility for tenants and owners, and long-term client relationships built on trust."
      ],
    },
    {
      "title": "Why Choose Us?",
      "content": [
    "•	Rapid Issue Resolution: We prioritize quick, effective solutions to property maintenance and operational challenges."
    "•	Innovative Technology: Our AI-driven systems and smart platforms provide real-time updates and seamless issue tracking."
    "•	Transparency First: We ensure tenants and owners have clear visibility into every step of the resolution process."
    "•	Lasting Relationships: Our reliable, client-centric approach fosters strong, enduring partnerships."
      ],
    },
    {
      "title": "Our Vision",
      "content": [
    "To lead property management by delivering technology-driven solutions that resolve issues efficiently, enhance transparency, and create thriving communities. Xception Technologies LLC — Innovating Today for Smarter Communities Tomorrow."
      ],
    }
  ];
}