# تقرير تنفيذ SEO — PharaTrip

تاريخ المراجعة: 2026-11-22

هذا التقرير يوضح ما تم تنفيذه داخل المشروع، وما كان موجودًا مسبقًا، وما يحتاج إلى إجراء خارج الكود.

## الحالة التنفيذية

| المجال | الحالة | التفاصيل |
|---|---|---|
| Keyword Research | جزئي | تم تحديد موضوع الموقع والوجهات من الكتالوج. لا يمكن استخراج حجم البحث أو صعوبة الكلمات بدقة بدون Google Keyword Planner أو Ahrefs/Semrush. |
| On-Page SEO | تم | تم ضبط العنوان والوصف وCanonical وOpen Graph وTwitter Cards، وإضافة عناوين ديناميكية لصفحات الرحلات. |
| Technical SEO | تم جزئيًا | تم تجهيز robots.txt وsitemap.xml وSchema وتوجيه `/` إلى `/home`. إعداد HTTPS وredirects يعتمد على الاستضافة. |
| Content SEO | جزئي | بيانات الرحلات الحالية تصلح كبداية، لكن لا توجد مدونة أو صفحات وجهات طويلة تستهدف كلمات بحث إضافية. |
| Internal Linking | موجود جزئيًا | روابط التنقل والرحلات موجودة من خلال التطبيق. يجب إضافة روابط نصية واضحة بين `/home` و`/explore` وصفحات الرحلات عند بناء صفحات المحتوى. |
| Backlinks | لم يبدأ | لا يمكن إنشاء روابط خارجية من داخل التطبيق. يلزم تنفيذ خطة Digital PR وشراكات ومحتوى قابل للمشاركة. |
| Mobile UX | موجود | التطبيق Flutter ومتجاوب، ويجب تأكيد النتيجة باختبار Lighthouse على النسخة المنشورة. |
| Schema Markup | تم | تمت إضافة Product Schema ديناميكي لصفحات الرحلات. Sitemap وWebPage metadata موجودان أيضًا. |
| Core Web Vitals | غير مقاس | يلزم رابط الإنتاج لتشغيل PageSpeed Insights وقياس LCP وCLS وINP فعليًا. |
| Analytics & Tracking | غير مكتمل | لم يتم العثور على GA4 أو Search Console verification داخل المشروع. يلزم Measurement ID وملكية النطاق. |

## ما كان موجودًا مسبقًا

- ملف `web/robots.txt` كان موجودًا، وكان يستبعد صفحات الحساب والحجز الحساسة.
- ملف `web/sitemap.xml` كان موجودًا ويضم صفحات الرحلات الخمس، لكنه كان يستخدم نطاقًا وهميًا.
- `SeoHead` كان موجودًا ويضبط title وdescription وcanonical وOpen Graph بشكل أساسي.
- `manifest.json` كان مضبوطًا باسم PharaTrip وألوان العلامة التجارية.
- صور الرحلات موجودة داخل `assets/images`.
- صفحات الرحلات ومساراتها موجودة داخل `TripCatalog` و`GoRouter`.

## ما تم إنجازه الآن

### تحديث إضافي

- إضافة `lang="en"` و`dir="ltr"` إلى HTML الأساسي.
- إضافة تعليمات Googlebot الخاصة بمعاينة الصور الكبيرة.
- توسيع Schema للصفحة الرئيسية إلى `Organization`.
- توسيع Schema لصفحة الاستكشاف إلى `CollectionPage`.
- إضافة صورة مطلقة وSKU إلى Product Schema للرحلات.
- تجهيز `SeoHead` لدعم `noindex` للصفحات الخاصة عند الحاجة.

- استبدال النطاق الوهمي في `robots.txt` و`sitemap.xml` بالنطاق:
  `https://pharatrip.com`
- إضافة الصفحة الرئيسية `/` إلى Sitemap.
- جعل `/` يعيد التوجيه إلى `/home`.
- تحسين وصف الموقع الأساسي.
- إصلاح روابط canonical وOpen Graph وTwitter لتكون مطلقة.
- إضافة `og:locale` و`og:image:alt`.
- إصلاح اسم التطبيق في Apple Web App من `bookhotel` إلى `PharaTrip`.
- جعل عنوان صفحة كل رحلة ديناميكيًا، مثل:
  `Giza Pyramids Tour in Egypt | PharaTrip`
- جعل وصف صفحة كل رحلة يتضمن الوجهة والمدة والسعر.
- إضافة Product Schema لكل رحلة، ويشمل الاسم والعلامة التجارية والسعر والعملة والتوفر.
- إضافة معاملات Schema إلى نسخة non-web حتى لا يحدث خطأ عند بناء Android/iOS.
- إزالة import غير مستخدم من ملف SEO الموحد.

## خريطة الكلمات المقترحة

هذه خريطة أولية مبنية على بيانات التطبيق، وليست بديلًا عن قياس حجم البحث:

| الصفحة | الكلمة الأساسية | نية البحث |
|---|---|---|
| `/home` | Egypt trips / رحلات مصر | اكتشاف وحجز |
| `/explore` | Egypt tours / رحلات سياحية في مصر | مقارنة الخيارات |
| `/trip/giza-pyramids` | Giza Pyramids tour | حجز رحلة محددة |
| `/trip/dahab-adventure` | Dahab trips | حجز رحلة محددة |
| `/trip/siwa-oasis` | Siwa Oasis tour | حجز رحلة محددة |
| `/trip/luxor-history` | Luxor history tour | حجز رحلة محددة |
| `/trip/red-sea-getaway` | Red Sea trips Egypt | حجز رحلة محددة |

## بنية محتوى مقترحة

1. صفحة `Egypt Tours` تحتوي على نبذة مفيدة، الوجهات، طريقة الحجز، الأسئلة الشائعة، وروابط الرحلات.
2. صفحة لكل وجهة: Cairo/Giza، Luxor، Siwa، Dahab، Hurghada.
3. مقالات داعمة:
   - أفضل أماكن الزيارة في مصر لأول مرة.
   - دليل رحلة الأهرامات من القاهرة.
   - أفضل وقت لزيارة سيوة.
   - برنامج رحلة الأقصر لمدة يومين.
   - دليل الغوص والأنشطة في دهب والبحر الأحمر.

## المتبقي خارج الكود

- تأكيد أن النطاق الحقيقي هو `pharatrip.com`; إذا كان مختلفًا يجب تغييره في `index.html` و`robots.txt` و`sitemap.xml` وSchema.
- تفعيل شهادة SSL وإجبار HTTPS من الاستضافة.
- ضبط redirect من HTTP إلى HTTPS ومن النطاق غير المفضل إلى النطاق المفضل.
- تفعيل fallback إلى `index.html` لجميع مسارات Flutter Web.
- إضافة الموقع إلى Google Search Console وإرسال `sitemap.xml`.
- إضافة Google Analytics 4 بعد توفير Measurement ID.
- تشغيل PageSpeed Insights وLighthouse على رابط الإنتاج.
- استخدام Google Keyword Planner أو Ahrefs/Semrush لإضافة حجم البحث وصعوبة الكلمات.
- إنشاء Google Business Profile فقط إذا كان للنشاط عنوان محلي حقيقي يستقبل العملاء.
- تنفيذ خطة Backlinks آمنة من مواقع سفر حقيقية، شركاء، أدلة محلية، وDigital PR.

## Checklist التنفيذ

- [x] robots.txt
- [x] sitemap.xml
- [x] canonical
- [x] Open Graph
- [x] Twitter Cards
- [x] عناوين ووصف صفحات الرحلات
- [x] Product Schema
- [x] توجيه الصفحة الرئيسية
- [x] استبعاد صفحات الحساب والحجز من الزحف
- [ ] تأكيد النطاق النهائي
- [ ] نشر الموقع عبر HTTPS
- [ ] إضافة Search Console
- [ ] إرسال Sitemap إلى Google
- [ ] إضافة GA4
- [ ] اختبار PageSpeed وCore Web Vitals
- [ ] مراجعة الصور وتحويل الكبير منها إلى WebP/AVIF
- [ ] إنشاء صفحات المحتوى والوجهات
- [ ] بناء روابط خارجية آمنة
