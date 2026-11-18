# CleanTracker - Frontend Flutter (Arquitectura Desacoplada para Supabase)

Implementación fiel de las pantallas de CleanTracker con paleta Menta (`#DDF7F6`), Crema (`#F6F6D5`) y Verde Bosque (`#183635`).

## Backend: Firebase (monolito)
- **Contrato (`lib/data/repositories/tracker_repository.dart`)**: autenticación, búsqueda de rutas y dirección del usuario.
- **Implementación (`lib/data/repositories/firebase_tracker_repository.dart`)**: Firebase Auth (correo + contraseña, hash gestionado por Firebase) y Cloud Firestore.
- **Modelo de datos**
  - `users/{uid}`: `email`, `createdAt`, `address` (dirección elegida por el usuario).
  - `routes/{id}`: las 3 direcciones de rutas de camiones (`street`, `zone`, `distanceKm`, `estimatedMinutes`, `scheduleInfo`, `order`).
- **Reglas**: `firestore.rules` (cada usuario solo accede a su documento; `routes` es de solo lectura).

## Puesta en marcha
1. Crear un proyecto en [Firebase Console](https://console.firebase.google.com) y activar **Authentication → Correo/contraseña** y **Firestore Database**.
2. `npm i -g firebase-tools` y `dart pub global activate flutterfire_cli`.
3. `firebase login` y, en esta carpeta, `flutterfire configure` (sobrescribe `lib/firebase_options.dart`).
4. `firebase deploy --only firestore:rules`.
5. Cargar las 3 rutas: editar y ejecutar `tool/seed_routes.mjs` (o crear los documentos en `routes` desde la consola).
6. `flutter run -d chrome`.
