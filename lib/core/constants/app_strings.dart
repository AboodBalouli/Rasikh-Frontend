/// Comprehensive app strings with Arabic and English translations
class AppStrings {
  static String languageCode = 'ar';

  static final Map<String, Map<String, String>> _localizedValues = {
    'ar': {
      // App branding
      'appName': 'راسخ',
      'rasikh': 'راسخ',

      // Common actions
      'cancel': 'إلغاء',
      'confirm': 'تأكيد',
      'save': 'حفظ',
      'delete': 'حذف',
      'edit': 'تعديل',
      'add': 'إضافة',
      'done': 'تم',
      'next': 'التالي',
      'back': 'رجوع',
      'close': 'إغلاق',
      'retry': 'إعادة المحاولة',
      'loading': 'جاري التحميل...',
      'search': 'بحث',
      'submit': 'إرسال',
      'ok': 'موافق',
      'yes': 'نعم',
      'no': 'لا',

      // Auth strings
      'login': 'تسجيل الدخول',
      'logout': 'تسجيل الخروج',
      'register': 'إنشاء حساب',
      'signUp': 'إنشاء حساب',
      'signIn': 'تسجيل الدخول',
      'signInToYourAccount': 'تسجيل الدخول إلى حسابك',
      'createAccount': 'إنشاء حساب جديد',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'confirmPassword': 'تأكيد كلمة المرور',
      'forgotPassword': 'نسيت كلمة المرور؟',
      'resetPassword': 'إعادة تعيين كلمة المرور',
      'firstName': 'الاسم الأول',
      'lastName': 'اسم العائلة',
      'phone': 'رقم الهاتف',
      'enterEmail': 'أدخل بريدك الإلكتروني',
      'enterPassword': 'أدخل كلمة المرور',
      'pleaseEnterEmailAddress': 'يرجى إدخال البريد الإلكتروني',
      'pleaseEnterPassword': 'يرجى إدخال كلمة المرور',
      'invalidEmailAddress': 'البريد الإلكتروني غير صالح',
      'passwordTooShort': 'كلمة المرور قصيرة جداً',
      'passwordsDontMatch': 'كلمتا المرور غير متطابقتين',
      'dontHaveAccount': 'لا تملك حساب؟',
      'alreadyHaveAccount': 'لديك حساب بالفعل؟',
      'loginSuccessful': 'تم تسجيل الدخول بنجاح',
      'registerSuccessful': 'تم إنشاء الحساب بنجاح',

      // Navigation & Pages
      'home': 'الرئيسية',
      'profile': 'الملف الشخصي',
      'settings': 'الإعدادات',
      'notifications': 'الإشعارات',
      'orders': 'الطلبات',
      'myOrders': 'طلباتي',
      'cart': 'السلة',
      'favorites': 'المفضلات',
      'wishlist': 'قائمة الأمنيات',
      'categories': 'التصنيفات',
      'stores': 'المتاجر',
      'products': 'المنتجات',
      'myProducts': 'منتجاتي',

      // Store
      'store': 'متجر',
      'storeDescription': 'وصف قصير عن المتجر',
      'aboutStore': 'عن المتجر',
      'storeFullDescription':
          'متجر يوفر لك أفضل المنتجات المصنوعة بحب وبجودة عالية. نحن نؤمن بأن التسوق يجب أن يكون تجربة ممتعة وسهلة للجميع.',
      'storeInfo': 'معلومات المتجر',
      'storeAddress': '123 Main Street, City Center, Country',
      'seller': 'البائع',
      'sellerDescription':
          'البائع هو شخص شغوف بتقديم أفضل المنتجات لعملائه. مع سنوات من الخبرة في المجال، يضمن البائع جودة وخدمة ممتازة.',

      // Cart & Checkout
      'yourCart': 'سلتك',
      'emptyCart': 'سلتك فارغة',
      'emptyWishlist': 'القائمة المفضلة فارغة',
      'addToCart': 'أضف إلى السلة',
      'removeFromCart': 'إزالة من السلة',
      'totalAmount': 'المبلغ الإجمالي',
      'subtotal': 'المجموع الفرعي',
      'total': 'المجموع',
      'proceedToCheckout': 'تابع للدفع',
      'checkout': 'الدفع',
      'addMore': 'اضف المزيد',
      'items': 'عناصر',
      'quantity': 'الكمية',
      'price': 'السعر',

      // Payment
      'payVia': 'الدفع من خلال',
      'cash': 'نقداً',
      'wallet': 'محفظة راسخ',
      'addNewCard': 'إضافة بطاقة جديدة',
      'paymentSummary': 'ملخص الدفع',
      'paymentMethod': 'طريقة الدفع',

      // Orders
      'orderPlaced': 'تم الطلب',
      'executeOrder': 'تنفيذ الطلب',
      'placeOrder': 'تنفيذ الطلب',
      'orderDetails': 'تفاصيل الطلب',
      'orderStatus': 'حالة الطلب',
      'pending': 'قيد الانتظار',
      'processing': 'قيد المعالجة',
      'shipped': 'تم الشحن',
      'delivered': 'تم التوصيل',
      'cancelled': 'ملغي',
      'specialOrders': 'طلبات خاصة',

      // Products
      'searchHint': 'ابحث عن منتج...',
      'productDescriptionPlaceholder': 'وصف للمنتج',
      'handmadeNote': 'هذا المنتج مصنوع يدويا يحتاج من 4 - 5 أيام',
      'productDescription': 'وصف المنتج',
      'productName': 'اسم المنتج',
      'productPrice': 'سعر المنتج',
      'addProduct': 'إضافة منتج',
      'editProduct': 'تعديل المنتج',
      'deleteProduct': 'حذف المنتج',

      // Notes
      'notes': 'ملاحظات إضافية',
      'writeNote': 'دون ملاحظتك',
      'noteHint': 'اكتب ملاحظتك هنا...',
      'tellUs': 'اخبرنا ماذا تريد',
      'additionalNotes': 'ملاحظات إضافية',

      // Messages
      'confirmClose': 'تأكيد الإغلاق قبل الإضافة إلى السلة',
      'chatOnWhatsApp': 'تواصل عبر واتساب',
      'noDataAvailable': 'لا توجد بيانات',
      'errorOccurred': 'حدث خطأ',
      'tryAgain': 'حاول مرة أخرى',
      'success': 'نجاح',
      'error': 'خطأ',
      'warning': 'تحذير',

      // Settings & Language
      'language': 'اللغة',
      'arabic': 'العربية',
      'english': 'English',
      'chooseLanguage': 'اختر اللغة',
      'darkMode': 'الوضع الداكن',
      'lightMode': 'الوضع الفاتح',
      'appSettings': 'إعدادات التطبيق',
      'accountSettings': 'إعدادات الحساب',
      'privacyPolicy': 'سياسة الخصوصية',
      'termsOfService': 'شروط الخدمة',
      'aboutApp': 'عن التطبيق',
      'contactUs': 'اتصل بنا',
      'help': 'المساعدة',
      'version': 'الإصدار',

      // Organization
      'organization': 'الجمعية',
      'organizations': 'الجمعيات',
      'aboutOrganization': 'نبذة عن الجمعية',
      'joinOrganization': 'انضم للجمعية',
      'createOrganization': 'إنشاء جمعية',

      // Misc
      'currency': 'دينار',
      'jd': 'د.أ',
      'viewAll': 'عرض الكل',
      'seeMore': 'عرض المزيد',
      'seeLess': 'عرض أقل',
      'filter': 'تصفية',
      'sort': 'ترتيب',
      'share': 'مشاركة',
      'copy': 'نسخ',
      'refresh': 'تحديث',

      // Settings Page specific
      'profileSettings': 'اعدادات الملف الشخصي',
      'tapToAccessSettings': 'انقر للوصول إلى الإعدادات',
      'doYouWantToLogout': 'هل تود تسجيل الخروج؟',
      'youWillBeLoggedOut': 'سيتم تسجيل خروجك من الحساب',
      'languageAppliedImmediately': 'سيتم تطبيق اللغة فوراً عند الاختيار',
      'languageChangedToArabic': 'تم تغيير اللغة للعربية',
      'languageChangedToEnglish': 'Language changed to English',

      // Password Settings
      'currentPassword': 'كلمة المرور الحالية',
      'newPassword': 'كلمة المرور الجديدة',
      'confirmNewPassword': 'تأكيد كلمة المرور الجديدة',
      'passwordsDoNotMatch': 'كلمات المرور غير متطابقة',
      'passwordMustBe8Chars': 'كلمة المرور يجب أن تكون 8 أحرف على الأقل',
      'passwordContainsInvalidChars':
          'كلمة المرور تحتوي على أحرف غير مسموحة (* & ^ # ! - % \$)',
      'passwordChangedSuccessfully': 'تم تغيير كلمة المرور بنجاح',
      'passwordMustBe5Chars': 'لا يجب ان تقل كلمة المرور عن 5',
      'specialCharsNotAllowed': 'الرموز غير مسموحة (- * % ^ # ,)',

      // Navigation labels
      'account': 'الحساب',

      // Guest dialogs
      'youNeedAccount': 'يجب ان يكون لديك حساب',

      // Cart & Shop
      'letsFillCart': 'يلا عبي السله',
      'shopNow': 'تسوق الآن',
      'discoverStores': 'اكتشف المتاجر',

      // Guest Page
      'myAccount': 'حسابي',
      'helloGuest': 'اهلا ضيف',
      'welcome': 'اهلا!',
      'loginOrCreateAccount':
          'سجل دخول أو انشئ حساب للحصول على تجربة اكثر تخصيصا',
      'fromHere': 'من هنا',
      'tapForMore': 'انقر للمزيد',

      // Common messages
      'noData': 'لا توجد بيانات',

      // Cart dialogs
      'startNewCart': 'بدء سلة جديدة ؟',
      'startNewCartMessage': 'عند بدء طلب جديد , ستتم ازالة المشتريات السابقة',
      'confirmStart': 'تأكيد البدء',

      // Wishlist
      'failedToUpdateWishlist': 'فشل تحديث المفضلة',

      // Admin & Product visibility
      'hidden': 'مخفي',
      'sales': 'مبيعات',

      // Orders
      'noOrdersYet': 'لا يوجد طلبات حتى الان',
      'startShoppingNow': 'ابدأ التسوق الآن واستمتع بأفضل المنتجات',
      'browseProducts': 'تصفح المنتجات',
    },
    'en': {
      // App branding
      'appName': 'Rasikh',
      'rasikh': 'Rasikh',

      // Common actions
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'add': 'Add',
      'done': 'Done',
      'next': 'Next',
      'back': 'Back',
      'close': 'Close',
      'retry': 'Retry',
      'loading': 'Loading...',
      'search': 'Search',
      'submit': 'Submit',
      'ok': 'OK',
      'yes': 'Yes',
      'no': 'No',

      // Auth strings
      'login': 'Login',
      'logout': 'Logout',
      'register': 'Register',
      'signUp': 'Sign Up',
      'signIn': 'Sign In',
      'signInToYourAccount': 'Sign in to your account',
      'createAccount': 'Create Account',
      'email': 'Email',
      'password': 'Password',
      'confirmPassword': 'Confirm Password',
      'forgotPassword': 'Forgot Password?',
      'resetPassword': 'Reset Password',
      'firstName': 'First Name',
      'lastName': 'Last Name',
      'phone': 'Phone Number',
      'enterEmail': 'Enter your email',
      'enterPassword': 'Enter your password',
      'pleaseEnterEmailAddress': 'Please enter email address',
      'pleaseEnterPassword': 'Please enter password',
      'invalidEmailAddress': 'Invalid email address',
      'passwordTooShort': 'Password is too short',
      'passwordsDontMatch': 'Passwords do not match',
      'dontHaveAccount': "Don't have an account?",
      'alreadyHaveAccount': 'Already have an account?',
      'loginSuccessful': 'Login successful',
      'registerSuccessful': 'Registration successful',

      // Navigation & Pages
      'home': 'Home',
      'profile': 'Profile',
      'settings': 'Settings',
      'notifications': 'Notifications',
      'orders': 'Orders',
      'myOrders': 'My Orders',
      'cart': 'Cart',
      'favorites': 'Favorites',
      'wishlist': 'Wishlist',
      'categories': 'Categories',
      'stores': 'Stores',
      'products': 'Products',
      'myProducts': 'My Products',

      // Store
      'store': 'Store',
      'storeDescription': 'Short description about the store',
      'aboutStore': 'About Store',
      'storeFullDescription':
          'A store that provides you with the best products made with love and high quality. We believe shopping should be a fun and easy experience for everyone.',
      'storeInfo': 'Store Info',
      'storeAddress': '123 Main Street, City Center, Country',
      'seller': 'Seller',
      'sellerDescription':
          'The seller is passionate about providing the best products to their customers. With years of experience in the field, the seller guarantees excellent quality and service.',

      // Cart & Checkout
      'yourCart': 'Your Cart',
      'emptyCart': 'Your cart is empty',
      'emptyWishlist': 'Your wishlist is empty',
      'addToCart': 'Add to Cart',
      'removeFromCart': 'Remove from Cart',
      'totalAmount': 'Total Amount',
      'subtotal': 'Subtotal',
      'total': 'Total',
      'proceedToCheckout': 'Proceed to Checkout',
      'checkout': 'Checkout',
      'addMore': 'Add More',
      'items': 'Items',
      'quantity': 'Quantity',
      'price': 'Price',

      // Payment
      'payVia': 'Pay Via',
      'cash': 'Cash',
      'wallet': 'Rasikh Wallet',
      'addNewCard': 'Add New Card',
      'paymentSummary': 'Payment Summary',
      'paymentMethod': 'Payment Method',

      // Orders
      'orderPlaced': 'Order Placed',
      'executeOrder': 'Place Order',
      'placeOrder': 'Place Order',
      'orderDetails': 'Order Details',
      'orderStatus': 'Order Status',
      'pending': 'Pending',
      'processing': 'Processing',
      'shipped': 'Shipped',
      'delivered': 'Delivered',
      'cancelled': 'Cancelled',
      'specialOrders': 'Special Orders',

      // Products
      'searchHint': 'Search for a product...',
      'productDescriptionPlaceholder': 'Product description',
      'handmadeNote': 'This product is handmade and takes 4-5 days',
      'productDescription': 'Product Description',
      'productName': 'Product Name',
      'productPrice': 'Product Price',
      'addProduct': 'Add Product',
      'editProduct': 'Edit Product',
      'deleteProduct': 'Delete Product',

      // Notes
      'notes': 'Additional Notes',
      'writeNote': 'Write your note',
      'noteHint': 'Write your note here...',
      'tellUs': 'Tell us what you want',
      'additionalNotes': 'Additional Notes',

      // Messages
      'confirmClose': 'Confirm close before adding to cart',
      'chatOnWhatsApp': 'Chat on WhatsApp',
      'noDataAvailable': 'No data available',
      'errorOccurred': 'An error occurred',
      'tryAgain': 'Try again',
      'success': 'Success',
      'error': 'Error',
      'warning': 'Warning',

      // Settings & Language
      'language': 'Language',
      'arabic': 'Arabic',
      'english': 'English',
      'chooseLanguage': 'Choose Language',
      'darkMode': 'Dark Mode',
      'lightMode': 'Light Mode',
      'appSettings': 'App Settings',
      'accountSettings': 'Account Settings',
      'privacyPolicy': 'Privacy Policy',
      'termsOfService': 'Terms of Service',
      'aboutApp': 'About App',
      'contactUs': 'Contact Us',
      'help': 'Help',
      'version': 'Version',

      // Organization
      'organization': 'Organization',
      'organizations': 'Organizations',
      'aboutOrganization': 'About Organization',
      'joinOrganization': 'Join Organization',
      'createOrganization': 'Create Organization',

      // Misc
      'currency': 'JD',
      'jd': 'JD',
      'viewAll': 'View All',
      'seeMore': 'See More',
      'seeLess': 'See Less',
      'filter': 'Filter',
      'sort': 'Sort',
      'share': 'Share',
      'copy': 'Copy',
      'refresh': 'Refresh',

      // Settings Page specific
      'profileSettings': 'Profile Settings',
      'tapToAccessSettings': 'Tap to access settings',
      'doYouWantToLogout': 'Do you want to logout?',
      'youWillBeLoggedOut': 'You will be logged out of your account',
      'languageAppliedImmediately':
          'Language will be applied immediately on selection',
      'languageChangedToArabic': 'تم تغيير اللغة للعربية',
      'languageChangedToEnglish': 'Language changed to English',

      // Password Settings
      'currentPassword': 'Current Password',
      'newPassword': 'New Password',
      'confirmNewPassword': 'Confirm New Password',
      'passwordsDoNotMatch': 'Passwords do not match',
      'passwordMustBe8Chars': 'Password must be at least 8 characters',
      'passwordContainsInvalidChars':
          'Password contains invalid characters (* & ^ # ! - % \$)',
      'passwordChangedSuccessfully': 'Password changed successfully',
      'passwordMustBe5Chars': 'Password must be at least 5 characters',
      'specialCharsNotAllowed': 'Special characters not allowed (- * % ^ # ,)',

      // Navigation labels
      'account': 'Account',

      // Guest dialogs
      'youNeedAccount': 'You need an account',

      // Cart & Shop
      'letsFillCart': 'Let\'s fill it up',
      'shopNow': 'Shop Now',
      'discoverStores': 'Discover Stores',

      // Guest Page
      'myAccount': 'My Account',
      'helloGuest': 'Hello Guest',
      'welcome': 'Welcome!',
      'loginOrCreateAccount':
          'Log in or create an account for a more personalized experience',
      'fromHere': 'From Here',
      'tapForMore': 'Tap for more',

      // Common messages
      'noData': 'No data available',

      // Cart dialogs
      'startNewCart': 'Start a new cart?',
      'startNewCartMessage':
          'When starting a new order, previous items will be removed',
      'confirmStart': 'Confirm Start',

      // Wishlist
      'failedToUpdateWishlist': 'Failed to update wishlist',

      // Admin & Product visibility
      'hidden': 'Hidden',
      'sales': 'sales',

      // Orders
      'noOrdersYet': 'No orders yet',
      'noPreviousOrders': 'No previous orders',
      'ordersWillAppearHere': 'Your completed orders will appear here.',
      'startShoppingNow': 'Start shopping now and enjoy the best products',
      'browseProducts': 'Browse Products',
    },
  };

  /// Get localized string by key
  static String _get(String key) {
    final translations = _localizedValues[languageCode];
    if (translations == null) return key;
    return translations[key] ?? _localizedValues['en']?[key] ?? key;
  }

  /// Get string with fallback
  static String get(String key) => _get(key);

  // ============ STATIC GETTERS FOR BACKWARDS COMPATIBILITY ============

  // App branding
  static String get appName => _get('appName');
  static String get rasikh => _get('rasikh');

  // Common actions
  static String get cancel => _get('cancel');
  static String get confirm => _get('confirm');
  static String get save => _get('save');
  static String get delete => _get('delete');
  static String get edit => _get('edit');
  static String get add => _get('add');
  static String get done => _get('done');
  static String get next => _get('next');
  static String get back => _get('back');
  static String get close => _get('close');
  static String get retry => _get('retry');
  static String get loading => _get('loading');
  static String get search => _get('search');
  static String get submit => _get('submit');
  static String get ok => _get('ok');
  static String get yes => _get('yes');
  static String get no => _get('no');

  // Auth
  static String get login => _get('login');
  static String get logout => _get('logout');
  static String get register => _get('register');
  static String get signUp => _get('signUp');
  static String get signIn => _get('signIn');
  static String get signInToYourAccount => _get('signInToYourAccount');
  static String get createAccount => _get('createAccount');
  static String get email => _get('email');
  static String get password => _get('password');
  static String get confirmPassword => _get('confirmPassword');
  static String get forgotPassword => _get('forgotPassword');
  static String get resetPassword => _get('resetPassword');
  static String get firstName => _get('firstName');
  static String get lastName => _get('lastName');
  static String get phone => _get('phone');
  static String get enterEmail => _get('enterEmail');
  static String get enterPassword => _get('enterPassword');
  static String get pleaseEnterEmailAddress => _get('pleaseEnterEmailAddress');
  static String get pleaseEnterPassword => _get('pleaseEnterPassword');
  static String get invalidEmailAddress => _get('invalidEmailAddress');
  static String get passwordTooShort => _get('passwordTooShort');
  static String get passwordsDontMatch => _get('passwordsDontMatch');
  static String get dontHaveAccount => _get('dontHaveAccount');
  static String get alreadyHaveAccount => _get('alreadyHaveAccount');
  static String get loginSuccessful => _get('loginSuccessful');
  static String get registerSuccessful => _get('registerSuccessful');

  // Navigation
  static String get home => _get('home');
  static String get profile => _get('profile');
  static String get settings => _get('settings');
  static String get notifications => _get('notifications');
  static String get orders => _get('orders');
  static String get myOrders => _get('myOrders');
  static String get cart => _get('cart');
  static String get favorites => _get('favorites');
  static String get wishlist => _get('wishlist');
  static String get categories => _get('categories');
  static String get stores => _get('stores');
  static String get products => _get('products');
  static String get myProducts => _get('myProducts');

  // Store
  static String get store => _get('store');
  static String get storeDescription => _get('storeDescription');
  static String get aboutStore => _get('aboutStore');
  static String get storeFullDescription => _get('storeFullDescription');
  static String get storeInfo => _get('storeInfo');
  static String get storeAddress => _get('storeAddress');
  static String get seller => _get('seller');
  static String get sellerDescription => _get('sellerDescription');

  // Cart & Checkout
  static String get yourCart => _get('yourCart');
  static String get emptyCart => _get('emptyCart');
  static String get emptyWishlist => _get('emptyWishlist');
  static String get addToCart => _get('addToCart');
  static String get removeFromCart => _get('removeFromCart');
  static String get totalAmount => _get('totalAmount');
  static String get subtotal => _get('subtotal');
  static String get total => _get('total');
  static String get proceedToCheckout => _get('proceedToCheckout');
  static String get checkout => _get('checkout');
  static String get addMore => _get('addMore');
  static String get items => _get('items');
  static String get quantity => _get('quantity');
  static String get price => _get('price');

  // Payment
  static String get payVia => _get('payVia');
  static String get cash => _get('cash');
  static String get wallet => _get('wallet');
  static String get addNewCard => _get('addNewCard');
  static String get paymentSummary => _get('paymentSummary');
  static String get paymentMethod => _get('paymentMethod');

  // Orders
  static String get orderPlaced => _get('orderPlaced');
  static String get executeOrder => _get('executeOrder');
  static String get placeOrder => _get('placeOrder');
  static String get orderDetails => _get('orderDetails');
  static String get orderStatus => _get('orderStatus');
  static String get pending => _get('pending');
  static String get processing => _get('processing');
  static String get shipped => _get('shipped');
  static String get delivered => _get('delivered');
  static String get cancelled => _get('cancelled');
  static String get specialOrders => _get('specialOrders');

  // Products
  static String get searchHint => _get('searchHint');
  static String get productDescriptionPlaceholder =>
      _get('productDescriptionPlaceholder');
  static String get handmadeNote => _get('handmadeNote');
  static String get productDescription => _get('productDescription');
  static String get productName => _get('productName');
  static String get productPrice => _get('productPrice');
  static String get addProduct => _get('addProduct');
  static String get editProduct => _get('editProduct');
  static String get deleteProduct => _get('deleteProduct');

  // Notes
  static String get notes => _get('notes');
  static String get writeNote => _get('writeNote');
  static String get noteHint => _get('noteHint');
  static String get tellUs => _get('tellUs');
  static String get additionalNotes => _get('additionalNotes');

  // Messages
  static String get confirmClose => _get('confirmClose');
  static String get chatOnWhatsApp => _get('chatOnWhatsApp');
  static String get noDataAvailable => _get('noDataAvailable');
  static String get errorOccurred => _get('errorOccurred');
  static String get tryAgain => _get('tryAgain');
  static String get success => _get('success');
  static String get error => _get('error');
  static String get warning => _get('warning');

  // Settings
  static String get language => _get('language');
  static String get arabic => _get('arabic');
  static String get english => _get('english');
  static String get chooseLanguage => _get('chooseLanguage');
  static String get darkMode => _get('darkMode');
  static String get lightMode => _get('lightMode');
  static String get appSettings => _get('appSettings');
  static String get accountSettings => _get('accountSettings');
  static String get privacyPolicy => _get('privacyPolicy');
  static String get termsOfService => _get('termsOfService');
  static String get aboutApp => _get('aboutApp');
  static String get contactUs => _get('contactUs');
  static String get help => _get('help');
  static String get version => _get('version');

  // Organization
  static String get organization => _get('organization');
  static String get organizations => _get('organizations');
  static String get aboutOrganization => _get('aboutOrganization');
  static String get joinOrganization => _get('joinOrganization');
  static String get createOrganization => _get('createOrganization');

  // Misc
  static String get currency => _get('currency');
  static String get jd => _get('jd');
  static String get viewAll => _get('viewAll');
  static String get seeMore => _get('seeMore');
  static String get seeLess => _get('seeLess');
  static String get filter => _get('filter');
  static String get sort => _get('sort');
  static String get share => _get('share');
  static String get copy => _get('copy');
  static String get refresh => _get('refresh');

  // Legacy aliases for backwards compatibility
  static String get storeTitle => store;
  static String get cartTitle => cart;
  static String get wishlistTitle => favorites;
  static String get writeNoteHint => noteHint;
  static String get tellUsWhatYouWant => tellUs;
  static String get rasikhWallet => wallet;

  // Settings Page specific
  static String get profileSettings => _get('profileSettings');
  static String get tapToAccessSettings => _get('tapToAccessSettings');
  static String get doYouWantToLogout => _get('doYouWantToLogout');
  static String get youWillBeLoggedOut => _get('youWillBeLoggedOut');
  static String get languageAppliedImmediately =>
      _get('languageAppliedImmediately');
  static String get languageChangedToArabic => _get('languageChangedToArabic');
  static String get languageChangedToEnglish =>
      _get('languageChangedToEnglish');

  // Password Settings
  static String get currentPassword => _get('currentPassword');
  static String get newPassword => _get('newPassword');
  static String get confirmNewPassword => _get('confirmNewPassword');
  static String get passwordsDoNotMatch => _get('passwordsDoNotMatch');
  static String get passwordMustBe8Chars => _get('passwordMustBe8Chars');
  static String get passwordContainsInvalidChars =>
      _get('passwordContainsInvalidChars');
  static String get passwordChangedSuccessfully =>
      _get('passwordChangedSuccessfully');
  static String get passwordMustBe5Chars => _get('passwordMustBe5Chars');
  static String get specialCharsNotAllowed => _get('specialCharsNotAllowed');

  // Navigation labels
  static String get account => _get('account');

  // Guest dialogs
  static String get youNeedAccount => _get('youNeedAccount');

  // Cart & Shop
  static String get letsFillCart => _get('letsFillCart');
  static String get shopNow => _get('shopNow');
  static String get discoverStores => _get('discoverStores');

  // Guest Page
  static String get myAccount => _get('myAccount');
  static String get helloGuest => _get('helloGuest');
  static String get welcome => _get('welcome');
  static String get loginOrCreateAccount => _get('loginOrCreateAccount');
  static String get fromHere => _get('fromHere');
  static String get tapForMore => _get('tapForMore');

  // Common messages
  static String get noData => _get('noData');

  // Cart dialogs
  static String get startNewCart => _get('startNewCart');
  static String get startNewCartMessage => _get('startNewCartMessage');
  static String get confirmStart => _get('confirmStart');

  // Wishlist
  static String get failedToUpdateWishlist => _get('failedToUpdateWishlist');

  // Admin & Product visibility
  static String get hidden => _get('hidden');
  static String get sales => _get('sales');

  // Orders
  static String get noOrdersYet => _get('noOrdersYet');
  static String get noPreviousOrders => _get('noPreviousOrders');
  static String get ordersWillAppearHere => _get('ordersWillAppearHere');
  static String get startShoppingNow => _get('startShoppingNow');
  static String get browseProducts => _get('browseProducts');
}
