import 'package:flutter/material.dart';
import 'package:factory_management/shared/widgets/placeholder_page.dart';

// ProductsPage is now in features/products/presentation/pages/products_page.dart

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});
  @override
  Widget build(BuildContext context) => const PlaceholderPage(title: 'Categories', description: 'Organize products into categories and subcategories.');
}

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});
  @override
  Widget build(BuildContext context) => const PlaceholderPage(title: 'Inventory', description: 'Track stock levels, slabs, and warehouse locations.');
}

class QuotationsPage extends StatelessWidget {
  const QuotationsPage({super.key});
  @override
  Widget build(BuildContext context) => const PlaceholderPage(title: 'Quotations', description: 'Manage customer price quotes and estimates.');
}

class CustomersPage extends StatelessWidget {
  const CustomersPage({super.key});
  @override
  Widget build(BuildContext context) => const PlaceholderPage(title: 'Customers', description: 'View and manage customer profiles and history.');
}

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});
  @override
  Widget build(BuildContext context) => const PlaceholderPage(title: 'Orders', description: 'Process and track sales orders and deliveries.');
}

class EmployeesPage extends StatelessWidget {
  const EmployeesPage({super.key});
  @override
  Widget build(BuildContext context) => const PlaceholderPage(title: 'Employees', description: 'Manage staff accounts, roles, and permissions.');
}

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});
  @override
  Widget build(BuildContext context) => const PlaceholderPage(title: 'Analytics', description: 'Detailed insights into business performance.');
}

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});
  @override
  Widget build(BuildContext context) => const PlaceholderPage(title: 'Reports', description: 'Generate and export business reports.');
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  @override
  Widget build(BuildContext context) => const PlaceholderPage(title: 'Notifications', description: 'System alerts and user notifications.');
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) => const PlaceholderPage(title: 'Settings', description: 'Configure system preferences and factory details.');
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) => const PlaceholderPage(title: 'Profile', description: 'Manage your personal account settings.');
}
