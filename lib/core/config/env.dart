enum Environment {
  dev,
  staging,
  prod,
}

class Env {
  static Environment current = Environment.dev;

  static String get baseUrl {
    switch (current) {
      case Environment.dev:
        return 'https://api.dev.marblefactory.com';
      case Environment.staging:
        return 'https://api.staging.marblefactory.com';
      case Environment.prod:
        return 'https://api.marblefactory.com';
    }
  }
}
