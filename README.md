# 🌿 Plant Disease Detection App

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![TFLite](https://img.shields.io/badge/TensorFlow_Lite-FF6F00?style=for-the-badge&logo=tensorflow&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20Web-green?style=for-the-badge)

یک اپلیکیشن موبایل هوشمند برای **تشخیص بیماری گیاهان** با استفاده از یادگیری ماشین درون‌برنامه‌ای

</div>

---

## 📋 فهرست مطالب

- [درباره پروژه](#درباره-پروژه)
- [ویژگی‌ها](#ویژگیها)
- [تکنولوژی‌ها](#تکنولوژیها)
- [ساختار پروژه](#ساختار-پروژه)
- [پیش‌نیازها](#پیشنیازها)
- [نصب و راه‌اندازی](#نصب-و-راهاندازی)
- [اجرای پروژه](#اجرای-پروژه)
- [نحوه استفاده](#نحوه-استفاده)
- [مدل هوش مصنوعی](#مدل-هوش-مصنوعی)
- [مشارکت در توسعه](#مشارکت-در-توسعه)

---

## 📖 درباره پروژه

**Plant Disease Detection App** یک اپلیکیشن Flutter است که با استفاده از مدل یادگیری عمیق TensorFlow Lite، بیماری‌های گیاهی را از روی تصاویر تشخیص می‌دهد. کاربر می‌تواند عکسی از گیاه مشکوک بگیرد یا از گالری انتخاب کند و اپ به‌صورت آفلاین نتیجه تشخیص را نمایش می‌دهد.

این پروژه در محیط **Firebase Studio** توسعه یافته و از قابلیت‌های پیشرفته Material Design 3 بهره می‌برد.

---

## ✨ ویژگی‌ها

- 📷 **انتخاب تصویر** از دوربین یا گالری گوشی
- 🤖 **تشخیص آفلاین** بیماری گیاه با مدل TFLite داخلی
- ⚡ **پردازش سریع** بدون نیاز به اینترنت
- 🎨 **رابط کاربری مدرن** با Material Design 3
- 🌙 **پشتیبانی از حالت تاریک/روشن**
- 📱 **پشتیبانی از Android و Web**

---

## 🛠 تکنولوژی‌ها

| ابزار | نسخه | توضیح |
|-------|-------|--------|
| [Flutter](https://flutter.dev/) | ≥3.x | فریم‌ورک UI چندسکویی |
| [Dart](https://dart.dev/) | ^3.9.0 | زبان برنامه‌نویسی |
| [tflite_flutter](https://pub.dev/packages/tflite_flutter) | ^0.12.1 | اجرای مدل TensorFlow Lite |
| [image_picker](https://pub.dev/packages/image_picker) | ^1.2.1 | دسترسی به دوربین و گالری |
| [image](https://pub.dev/packages/image) | ^4.7.2 | پردازش و تغییر اندازه تصاویر |

---

## 📁 ساختار پروژه

```
flutter_app/
├── lib/                         # کد اصلی Dart
│   └── main.dart                # نقطه ورود اپلیکیشن
├── assets/
│   └── plant_disease_model_float16.tflite   # مدل TFLite
├── android/                     # فایل‌های پروژه Android
├── web/                         # فایل‌های پروژه Web
├── test/                        # تست‌های واحد
├── .idx/                        # تنظیمات Firebase Studio
├── pubspec.yaml                 # وابستگی‌های پروژه
└── GEMINI.md                    # راهنمای توسعه با AI
```

---

## ✅ پیش‌نیازها

- [Flutter SDK](https://docs.flutter.dev/get-started/install) نسخه 3.x به بالا
- [Dart SDK](https://dart.dev/get-dart) نسخه 3.9.0 به بالا
- [Android Studio](https://developer.android.com/studio) یا [VS Code](https://code.visualstudio.com/) با پلاگین Flutter
- دستگاه Android یا شبیه‌ساز (برای اجرای موبایل)

بررسی نصب Flutter:
```bash
flutter doctor
```

---

## 🚀 نصب و راه‌اندازی

### ۱. کلون کردن پروژه

```bash
git clone https://github.com/yasin6452/flutter_app.git
cd flutter_app
```

### ۲. نصب وابستگی‌ها

```bash
flutter pub get
```

### ۳. بررسی دسترسی به asset

مطمئن شوید فایل مدل در مسیر زیر وجود دارد:

```
assets/plant_disease_model_float16.tflite
```

---

## ▶️ اجرای پروژه

### اجرا روی Android

```bash
# اتصال دستگاه یا راه‌اندازی شبیه‌ساز
flutter run
```

### اجرا روی Web

```bash
flutter run -d chrome
```

### ساخت APK

```bash
flutter build apk --release
```

فایل APK در مسیر زیر قرار می‌گیرد:
```
build/app/outputs/flutter-apk/app-release.apk
```

---

## 📱 نحوه استفاده

1. اپ را باز کنید
2. دکمه **انتخاب تصویر** را بزنید
3. عکس را از **دوربین** بگیرید یا از **گالری** انتخاب کنید
4. اپ تصویر را پردازش کرده و **نوع بیماری** را نمایش می‌دهد
5. نتیجه به‌صورت **آفلاین** و فوری ظاهر می‌شود

---

## 🤖 مدل هوش مصنوعی

مدل استفاده‌شده یک شبکه عصبی کانولوشنی (CNN) است که به فرمت **TFLite Float16** تبدیل شده تا روی دستگاه‌های موبایل با سرعت بالا اجرا شود.

- **فایل مدل:** `plant_disease_model_float16.tflite`
- **فرمت:** TensorFlow Lite (Float16)
- **اجرا:** کاملاً آفلاین، درون دستگاه
- **کتابخانه:** `tflite_flutter ^0.12.1`

---

## 🤝 مشارکت در توسعه

برای مشارکت در پروژه:

1. ریپو را Fork کنید
2. یک Branch جدید بسازید: `git checkout -b feature/نام-ویژگی`
3. تغییرات خود را Commit کنید: `git commit -m "feat: توضیح تغییرات"`
4. Branch خود را Push کنید: `git push origin feature/نام-ویژگی`
5. یک Pull Request باز کنید

---

## 📄 لایسنس

این پروژه تحت لایسنس MIT منتشر شده است.

---

<div align="center">
  ساخته‌شده با 💚 برای کمک به کشاورزان و علاقه‌مندان به گیاهان
</div>
