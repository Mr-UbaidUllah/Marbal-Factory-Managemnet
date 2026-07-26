import 'package:flutter/material.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';

class WebsiteFooter extends StatelessWidget {
  const WebsiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 80, left: 80, right: 80, bottom: 40),
      color: AppColors.darkGray,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company Info
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ALAM MARBLE",
                      style: AppTextStyles.h2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      "Leading manufacturer and supplier of premium natural stones. Crafting luxury in every stone for over two decades.",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.6),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        _buildSocialIcon(Icons.facebook),
                        const SizedBox(width: 15),
                        _buildSocialIcon(Icons.camera_alt_outlined),
                        const SizedBox(width: 15),
                        _buildSocialIcon(Icons.business_outlined),
                        const SizedBox(width: 15),
                        _buildSocialIcon(Icons.play_arrow),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 60),
              // Quick Links
              _buildFooterColumn(
                "Quick Links",
                ["Home", "Products", "Categories", "Projects", "About Us", "Contact"],
              ),
              const SizedBox(width: 40),
              // Categories
              _buildFooterColumn(
                "Categories",
                ["Marble", "Granite", "Onyx", "Quartz", "Travertine", "Tiles"],
              ),
              const SizedBox(width: 40),
              // Newsletter
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Newsletter",
                      style: AppTextStyles.h3.copyWith(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      "Subscribe to receive updates on our latest collections and projects.",
                      style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withOpacity(0.6)),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Your Email",
                              hintStyle: AppTextStyles.bodySmall.copyWith(color: Colors.white.withOpacity(0.3)),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.05),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                          ),
                          child: const Icon(Icons.send, size: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 80),
          const Divider(color: Colors.white10),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "© 2024 Alam Marble & Granite Factory. All Rights Reserved.",
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withOpacity(0.4)),
              ),
              Row(
                children: [
                  _buildFooterBottomLink("Privacy Policy"),
                  const SizedBox(width: 20),
                  _buildFooterBottomLink("Terms of Service"),
                  const SizedBox(width: 20),
                  _buildFooterBottomLink("Sitemap"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildFooterColumn(String title, List<String> links) {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.h3.copyWith(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 25),
          ...links.map((link) => Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text(
                  link,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildFooterBottomLink(String title) {
    return Text(
      title,
      style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withOpacity(0.4)),
    );
  }
}
