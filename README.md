# ⏰ Onboarding Alarm App (Flutter)

A cleanly structured Flutter application that guides users through onboarding, requests location permissions, and sets personalized alarms based on sunset timing — complete with local notifications and persistent scheduling.

---

## 📱 Features

- ✅ Beautiful 3-screen onboarding flow
- 🌍 Location access with real-time address detection
- ⏰ Alarm creation using date-time picker
- 🔔 Local notifications (with follow-up reminder)
- 📦 Clean architecture with modular widgets & services
- 📲 Android 13+ notification permission support

---

## 📸 Screenshots

| Onboarding | Location Access | Alarm List |
|-----------|----------------|------------|
| ![screen1](assets/screens/screen1.png) | ![screen2](assets/screens/screen2.png) | ![screen3](assets/screens/screen3.png) |

> Add screenshots in `assets/screens/` folder and link them here

---

## 🧱 Folder Structure


<img width="441" height="215" alt="image" src="https://github.com/user-attachments/assets/01f6039d-e835-43d7-9e76-08493f6109d6" />


**
---

## ⚙️ Packages Used

| Package | Usage |
|--------|-------|
| [`geolocator`](https://pub.dev/packages/geolocator) | Fetch current GPS location |
| [`geocoding`](https://pub.dev/packages/geocoding) | Convert lat/long to address |
| [`permission_handler`](https://pub.dev/packages/permission_handler) | Handle location & notification permissions |
| [`flutter_local_notifications`](https://pub.dev/packages/flutter_local_notifications) | Schedule alarms & reminders |
| [`omni_datetime_picker`](https://pub.dev/packages/omni_datetime_picker) | Beautiful date/time picker |

---

## 🚀 Getting Started

```bash
git clone https://github.com/your-username/onboarding-alarm-app.git
cd onboarding-alarm-app
flutter pub get
flutter run
**
Android Setup
Make sure the following permissions are in AndroidManifest.xml:

<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>



🧪 Demo Video
https://www.loom.com/share/60809634c5ce4cee817356331b001776?t=84&sid=a4203457-716e-4b53-95f4-ce7d7765ff91






