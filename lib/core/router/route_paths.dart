class RoutePaths {
  // Auth
  static const String login = '/login';

  // Customer / Public
  static const String home = '/';
  static const String customerProducts = '/products';
  static const String productDetails = '/products/:id';
  static const String customerCategories = '/categories';
  static const String gallery = '/gallery';
  static const String about = '/about';
  static const String contact = '/contact';
  static const String quoteRequest = '/quote-request';

  // Dashboard
  static const String dashboard = '/dashboard';
  static const String dashboardOverview = 'overview'; // Relative to /dashboard
  static const String dashboardProducts = 'products';
  static const String addProduct = 'add';
  static const String editProduct = 'edit/:id';
  static const String dashboardProductDetails = ':id';

  static const String dashboardCategories = 'categories';
  
  // Inventory
  static const String inventory = 'inventory';
  static const String inventoryDetails = 'inventory/:id';
  static const String inventoryHistory = 'inventory/history';
  static const String inventoryLowStock = 'inventory/low-stock';
  static const String inventoryOutOfStock = 'inventory/out-of-stock';

  static const String quotations = 'quotations';
  static const String customers = 'customers';
  static const String orders = 'orders';
  static const String employees = 'employees';
  static const String analytics = 'analytics';
  static const String reports = 'reports';
  static const String notifications = 'notifications';
  static const String settings = 'settings';
  static const String profile = 'profile';
  
  // Error
  static const String error = '/error';
}
