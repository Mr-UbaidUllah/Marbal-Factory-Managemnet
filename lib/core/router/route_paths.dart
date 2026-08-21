class RoutePaths {
  // Public Routes
  static const String home = '/';
  static const String login = '/login';
  static const String about = '/about';
  static const String contact = '/contact';
  static const String products = '/products';
  static const String productDetails = '/products/:id';
  static const String categories = '/categories';
  static const String categoryDetails = '/categories/:id';
  static const String projects = '/projects';
  static const String projectDetails = '/projects/:id';
  static const String quoteRequest = '/quote-request';
  static const String publicQuoteDetails = '/quotes/:id';

  // Dashboard Routes
  static const String dashboard = '/dashboard';
  static const String dashboardOverview = 'overview';
  static const String dashboardProducts = 'products';
  static const String addProduct = 'add';
  static const String editProduct = 'edit/:id';
  static const String dashboardProductDetails = 'details/:id';
  
  static const String dashboardCategories = 'categories';
  static const String inventory = 'inventory';
  static const String quotations = 'quotations';
  static const String quoteDetails = 'quotations/:id';
  static const String quoteReview = 'quotations/:id/review';
  static const String quoteRespond = 'quotations/:id/respond';
  
  static const String customers = 'customers';
  static const String orders = 'orders';
  static const String orderDetails = 'orders/:id';
  static const String orderEdit = 'orders/:id/edit';
  static const String orderInvoice = 'orders/:id/invoice';

  static const String employees = 'employees';
  static const String analytics = 'analytics';
  static const String reports = 'reports';
  static const String notifications = 'notifications';
  static const String settings = 'settings';
  static const String profile = 'profile';
}
