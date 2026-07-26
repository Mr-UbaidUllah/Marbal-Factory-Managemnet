import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';

class QuoteFormSection extends StatelessWidget {
  const QuoteFormSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 80),
      color: AppColors.lightGray.withOpacity(0.3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side: Text and Info
          Expanded(
            flex: 1,
            child: FadeInLeft(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "GET A QUOTE",
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.gold,
                      letterSpacing: 4,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Start Your Luxury\nJourney With Us",
                    style: AppTextStyles.h2.copyWith(fontSize: 48, fontWeight: FontWeight.w800, height: 1.2),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Whether it's a dream home, a luxury hotel, or a commercial landmark, we provide the finest stone solutions tailored to your vision.",
                    style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary, height: 1.6),
                  ),
                  const SizedBox(height: 50),
                  _buildContactInfo(Icons.phone, "Call Us", "+971 4 123 4567"),
                  const SizedBox(height: 20),
                  _buildContactInfo(Icons.email, "Email Us", "sales@alammarble.com"),
                  const SizedBox(height: 20),
                  _buildContactInfo(Icons.location_on, "Visit Factory", "Plot 123, Industrial Area, Dubai, UAE"),
                ],
              ),
            ),
          ),
          const SizedBox(width: 100),
          // Right side: Form
          Expanded(
            flex: 1,
            child: FadeInRight(
              child: Container(
                padding: const EdgeInsets.all(50),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 40,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(label: "Full Name", hint: "Enter your name"),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: _buildTextField(label: "Email Address", hint: "example@mail.com")),
                        const SizedBox(width: 20),
                        Expanded(child: _buildTextField(label: "Phone Number", hint: "+971 50 000 0000")),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: _buildTextField(label: "City", hint: "Dubai")),
                        const SizedBox(width: 20),
                        Expanded(child: _buildTextField(label: "Product of Interest", hint: "e.g. Italian Marble")),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(label: "Estimated Quantity (sqm)", hint: "e.g. 500"),
                    const SizedBox(height: 20),
                    _buildTextField(label: "Message", hint: "Tell us about your project...", maxLines: 4),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          "Submit Request",
                          style: AppTextStyles.button.copyWith(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.label.copyWith(fontWeight: FontWeight.bold)),
            Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({required String label, required String hint, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodySmall,
            filled: true,
            fillColor: AppColors.lightGray.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}
