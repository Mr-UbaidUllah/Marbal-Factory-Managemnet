import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:factory_management/core/di/injection.dart';
import 'package:factory_management/features/website/presentation/bloc/website_bloc.dart';
import 'package:factory_management/features/website/presentation/bloc/website_event.dart';
import 'package:factory_management/features/website/presentation/widgets/website_navbar.dart';
import 'package:factory_management/features/website/presentation/widgets/website_hero.dart';
import 'package:factory_management/features/website/presentation/widgets/category_section.dart';
import 'package:factory_management/features/website/presentation/widgets/featured_products.dart';
import 'package:factory_management/features/website/presentation/widgets/why_choose_us.dart';
import 'package:factory_management/features/website/presentation/widgets/project_showcase.dart';
import 'package:factory_management/features/website/presentation/widgets/testimonials.dart';
import 'package:factory_management/features/website/presentation/widgets/quote_form.dart';
import 'package:factory_management/features/website/presentation/widgets/website_footer.dart';

class WebsiteHomePage extends StatefulWidget {
  const WebsiteHomePage({super.key});

  @override
  State<WebsiteHomePage> createState() => _WebsiteHomePageState();
}

class _WebsiteHomePageState extends State<WebsiteHomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 50 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (_scrollController.offset <= 50 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<WebsiteBloc>()..add(GetFeaturedProductsEvent()),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: WebsiteNavbar(isScrolled: _isScrolled),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              const WebsiteHero(),
              const CategorySection(),
              const WhyChooseUs(),
              const FeaturedProducts(),
              const ProjectShowcase(),
              const TestimonialsSection(),
              const QuoteFormSection(),
              const WebsiteFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
