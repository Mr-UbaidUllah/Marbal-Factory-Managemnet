import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/features/website/presentation/bloc/website_bloc.dart';
import 'package:factory_management/features/website/presentation/bloc/website_event.dart';
import 'package:factory_management/features/website/presentation/bloc/website_state.dart';

class QuoteFormSection extends StatefulWidget {
  const QuoteFormSection({super.key});

  @override
  State<QuoteFormSection> createState() => _QuoteFormSectionState();
}

class _QuoteFormSectionState extends State<QuoteFormSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _productController = TextEditingController();
  final _quantityController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _productController.dispose();
    _quantityController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<WebsiteBloc>().add(
            SubmitQuoteEvent({
              'name': _nameController.text,
              'email': _emailController.text,
              'phone': _phoneController.text,
              'city': _cityController.text,
              'product': _productController.text,
              'quantity': _quantityController.text,
              'message': _messageController.text,
            }),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WebsiteBloc, WebsiteState>(
      listenWhen: (previous, current) =>
          previous.isQuoteSuccess != current.isQuoteSuccess ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.isQuoteSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Quote request submitted successfully!')),
          );
          _formKey.currentState!.reset();
        } else if (state.errorMessage != null && !state.isQuoteSubmitting) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      child: Container(
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField(
                          label: "Full Name",
                          hint: "Enter your name",
                          controller: _nameController,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                label: "Email Address",
                                hint: "example@mail.com",
                                controller: _emailController,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _buildTextField(
                                label: "Phone Number",
                                hint: "+971 50 000 0000",
                                controller: _phoneController,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                label: "City",
                                hint: "Dubai",
                                controller: _cityController,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _buildTextField(
                                label: "Product of Interest",
                                hint: "e.g. Italian Marble",
                                controller: _productController,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          label: "Estimated Quantity (sqm)",
                          hint: "e.g. 500",
                          controller: _quantityController,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          label: "Message",
                          hint: "Tell us about your project...",
                          maxLines: 4,
                          controller: _messageController,
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: BlocBuilder<WebsiteBloc, WebsiteState>(
                            builder: (context, state) {
                              return ElevatedButton(
                                onPressed: state.isQuoteSubmitting ? null : _submitForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(vertical: 24),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: state.isQuoteSubmitting
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : Text(
                                        "Submit Request",
                                        style: AppTextStyles.button.copyWith(fontSize: 16),
                                      ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
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
