import 'package:flutter/material.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/features/authentication/presentation/widgets/login_form.dart';
import 'package:factory_management/features/authentication/presentation/widgets/login_hero.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.05, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 1024;
    final isTablet = size.width >= 600 && size.width < 1024;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Expanded(
              child: isDesktop
                  ? Row(
                      children: [
                        const Expanded(flex: 11, child: LoginHero()),
                        Expanded(
                          flex: 9,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: const LoginForm(),
                          ),
                        ),
                      ],
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: isTablet ? 400 : 300,
                            width: double.infinity,
                            child: const LoginHero(),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: const LoginForm(),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            const LoginFooter(),
          ],
        ),
      ),
    );
  }
}

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
      color: Colors.white,
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 24,
        runSpacing: 12,
        children: [
          Text(
            '© ${DateTime.now().year} Alam Marble & Granite Factory. All rights reserved.',
            style: AppTextStyles.bodySmall,
          ),
          _FooterLink(label: 'Privacy Policy', onTap: () {}),
          _FooterLink(label: 'Terms of Service', onTap: () {}),
          Text(
            'Version 1.0.0',
            style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FooterLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
