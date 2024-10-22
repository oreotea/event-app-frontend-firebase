import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static final apiKey = dotenv.env['API_KEY'];
  static final authDomain = dotenv.env['AUTH_DOMAIN'];
  static final projectId = dotenv.env['PROJECT_ID'];
  static final storageBucket = dotenv.env['STORAGE_BUCKET'];
  static final messagingSenderId = dotenv.env['MESSAGING_SENDER_ID'];
  static final appId = dotenv.env['APP_ID'];
}
