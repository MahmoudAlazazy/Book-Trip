ت اللي# PharaTrip — Architecture TODO

> هذا الملف هو المرجع التنفيذي الأساسي للمشروع. أي تغيير في الـ architecture أو الـ flow يجب أن ينعكس هنا أولًا.

## قواعد ثابتة

- [x] استخدام Flutter + Riverpod مع تنظيم Feature-first و Clean Layers.
- [ ] الواجهة الحالية English LTR، مع تجهيز localization لإضافة العربية لاحقًا.
- [ ] استخدام REST API من خلال Dio و Repository؛ لا توجد API calls داخل الـ screens.
- [ ] الـ screens تقرأ الـ providers فقط وتعرض الحالات باستخدام `AsyncValue.when(...)`.
- [ ] منطق الأعمال داخل Controllers، والـ API داخل Repositories.
- [ ] الـ onboarding يظهر مرة واحدة فقط عبر `SharedPreferences`.
- [ ] مسار الحجز full-screen خارج Bottom Navigation: Details → Transport → Payment → Confirmed.
- [ ] بعد التأكيد نستخدم `context.go` حتى لا يعود زر الرجوع إلى شاشة الدفع.
- [ ] Cash on Delivery يتجاوز بوابة الدفع ويؤكد الحجز بحالة `pending`.

## المرحلة 0 — الأساسيات

- [ ] مراجعة `pubspec.yaml` وإضافة الحزم المطلوبة:
  - [ ] `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`
  - [ ] `go_router`
  - [ ] `dio`
  - [ ] `freezed_annotation`, `freezed`, `json_annotation`, `json_serializable`
  - [ ] `flutter_secure_storage`, `shared_preferences`
  - [ ] `google_sign_in`, `sign_in_with_apple`
  - [ ] `google_maps_flutter`, `cached_network_image`, `pinput`, `intl`
- [x] إنشاء `lib/app.dart` و `lib/main.dart`.
- [x] إعداد Theme موحد: الألوان، Typography، teal gradient، و MaterialApp.router.
- [x] إضافة localization structure مع بقاء اللغة الافتراضية English.

## المرحلة 1 — Core

- [x] إنشاء `core/router/routes.dart` لتعريف أسماء ومسارات الـ routes.
- [x] إنشاء `core/router/app_router.dart` باستخدام GoRouter كبداية.
- [ ] إنشاء Auth Guard يعتمد على session و onboarding flag.
- [ ] إنشاء `core/network/dio_client.dart`.
- [ ] إنشاء `core/network/auth_interceptor.dart`:
  - [ ] إضافة access token للطلبات.
  - [ ] عند 401 تنفيذ refresh مرة واحدة وإعادة الطلب.
  - [ ] عند فشل refresh تنفيذ logout تلقائيًا.
- [ ] إنشاء `api_exception.dart` وتوحيد تحويل أخطاء الشبكة.
- [ ] إنشاء `secure_storage.dart` للتوكنات و `prefs.dart` للـ onboarding.
- [ ] إنشاء shared widgets:
  - [ ] `primary_button.dart`
  - [ ] `app_text_field.dart`
  - [ ] `social_buttons.dart`
  - [ ] `trip_card.dart`
  - [ ] `status_chip.dart`
  - [ ] `async_value_view.dart`
  - [ ] `bottom_nav_shell.dart`
- [ ] إضافة validators و formatters و extensions داخل `core/utils`.

## المرحلة 2 — Navigation و Flow

- [ ] Splash → Onboarding لأول مرة.
- [ ] Splash → Login عند عدم وجود session.
- [ ] Splash → Home عند وجود session صالح.
- [x] تعريف routes الأساسية الحالية: `/splash`, `/onboarding`, `/login`, `/home`, `/my-trips`, `/favorites`, `/profile`.
- [x] تعريف Bottom Nav: `/home`, `/my-trips`, `/favorites`, `/profile`.
- [ ] تعريف full-screen routes: `/trip/:id`, `/booking/transport`, `/booking/payment`, `/booking/confirmed/:id`, `/track/:bookingId`.
- [ ] اختبار redirect مع حالات loading / logged out / logged in.

## المرحلة 3 — Authentication

- [ ] إنشاء auth data layer: API، models، repository implementation.
- [ ] إنشاء domain contracts: `AuthRepository` و `User`.
- [ ] إنشاء `authControllerProvider` كـ `AsyncNotifier<User?>` للجلسة.
- [ ] تنفيذ `loginControllerProvider` و Sign In.
- [ ] تنفيذ Google و Apple Sign In.
- [ ] تنفيذ `signupControllerProvider` وإنشاء الحساب.
- [ ] تنفيذ Verify Phone عبر OTP.
- [ ] إضافة resend timer داخل `otpControllerProvider` (45 ثانية).
- [ ] تنفيذ Forgot Password و Reset Password.
- [ ] تنفيذ logout ومسح بيانات الجلسة.

## المرحلة 4 — Trips و Favorites

- [x] إنشاء trips data/domain/presentation layers.
- [x] إنشاء `Trip` model.
- [ ] تنفيذ `tripFilterProvider` للبحث و All/Day/Multi-Day/Nature.
- [ ] تنفيذ `tripsProvider` المراقب للفلاتر.
- [ ] تنفيذ `tripDetailsProvider(id)`.
- [x] تنفيذ Available Trips و Trip Details.
- [ ] تنفيذ `favoritesProvider` مع optimistic update و rollback عند الفشل.
- [ ] تنفيذ Favorites screen أو إخفاؤها مؤقتًا إذا لم يكتمل تصميمها.

## المرحلة 5 — Booking و Payment

- [ ] إنشاء booking data/domain/presentation layers.
- [ ] إنشاء `Booking` و `TransportOption`.
- [ ] تنفيذ `bookingDraftProvider` لحفظ trip، transport، seats، payment method.
- [ ] حساب السعر الكلي داخل draft: transport price × seats.
- [ ] تنفيذ Transport screen (Bus / Minibus / Van والمقاعد المتاحة).
- [ ] تنفيذ Payment screen.
- [ ] تنفيذ `bookingControllerProvider` وإرسال الحجز.
- [ ] تعطيل Pay Now أثناء loading لمنع الحجز المكرر.
- [ ] تنفيذ card/Fawry عبر `POST /payments/intent`.
- [ ] تنفيذ Cash on Delivery مباشرةً إلى Confirmed بحالة `pending`.
- [ ] تنفيذ Booking Confirmed مع View My Trip و Back to Home.
- [ ] حفظ رقم الهاتف الدولي أثناء التسجيل وربطه بالمستخدم الحالي.
- [ ] بعد تأكيد الحجز إرسال رسالة SMS تحتوي Booking ID وتفاصيل الرحلة إلى رقم المستخدم.
- [ ] إضافة endpoint الإرسال إلى الـ backend مثل `POST /notifications/sms`؛ لا تضع مفاتيح SMS داخل التطبيق.
- [ ] تحديد مزود SMS المطلوب (Twilio / Vonage / Vodafone SMS أو API المشروع).
- [ ] تنفيذ `bookingDraftProvider.reset()` بعد التأكيد.

## المرحلة 6 — My Trips و Tracking

- [ ] تنفيذ `myTripsProvider(status)` لتبويبات Upcoming / Past / Canceled.
- [ ] تنفيذ My Trips screen.
- [ ] تنفيذ `trackingProvider(bookingId)` كـ StreamProvider family.
- [ ] البدء بـ polling كل 10–15 ثانية.
- [ ] عرض الخريطة والحالات: On the Way → Arriving → Arrived.
- [ ] إبقاء طبقة tracking قابلة للاستبدال بـ WebSocket لاحقًا.

## المرحلة 7 — Profile و الصفحات المساندة

- [x] تنفيذ Profile screen.
- [ ] ربط My Trips و Favorites من Profile.
- [x] Notifications.
- [ ] Payment Methods.
- [x] Settings.
- [x] Help & Support.
- [ ] تحديد ما إذا كانت الصفحات غير الموجودة في التصميم ستُنفذ أو تُخفى مؤقتًا.

## API Contract المطلوب

- [ ] `POST /auth/login`
- [ ] `POST /auth/register`
- [ ] `POST /auth/social`
- [ ] `POST /auth/verify-otp`
- [ ] `POST /auth/resend-otp`
- [ ] `POST /auth/forgot-password`
- [ ] `POST /auth/refresh`
- [ ] `POST /auth/logout`
- [ ] `GET /trips?type=&q=&page=` و `GET /trips/:id`
- [ ] Favorites: `POST/DELETE /favorites/:tripId` و `GET /favorites`
- [ ] `GET /trips/:id/transport`
- [ ] `POST /bookings`
- [ ] `GET /bookings?status=upcoming|past|canceled`
- [ ] `GET /bookings/:id/tracking`
- [ ] `POST /payments/intent`

## Quality Checklist قبل كل Merge

- [ ] `dart format .`
- [x] `flutter analyze`
- [x] `flutter test`
- [ ] التأكد أن كل screen لا يحتوي API call أو business logic.
- [ ] التأكد من حالات loading / error / empty / data لكل provider.
- [ ] التأكد من عدم تكرار الحجز أثناء الطلب.
- [ ] اختبار auth guard و logout و token refresh.
- [ ] اختبار كل مسارات الحجز، خصوصًا Cash on Delivery.
- [ ] تحديث هذا الملف عند إكمال أي بند أو تغيير قرار معماري.

## قرار البدء

- [ ] اختيار نقطة البداية: Theme + Shared Widgets.
- [ ] بعد اكتمالها الانتقال إلى Auth.
- [ ] ثم Router + Dio + Auth Interceptor.
- [ ] ثم مسار الحجز الكامل.
