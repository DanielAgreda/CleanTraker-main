import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/route_address_model.dart';
import '../models/user_model.dart';
import 'tracker_repository.dart';

/// Implementación con Firebase.
///
/// - Autenticación: Firebase Auth (correo + contraseña). Firebase guarda la
///   contraseña hasheada (scrypt); nunca se almacena en Firestore.
/// - Firestore:
///   - `users/{uid}`: { email, createdAt, address: {...} }
///   - `routes/{id}`: las 3 direcciones de las rutas de los camiones.
class FirebaseTrackerRepository implements TrackerRepository {
  FirebaseTrackerRepository({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _db.collection('users').doc(uid);

  @override
  Future<UserModel> register(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final firebaseUser = cred.user!;
      await _userDoc(firebaseUser.uid).set({
        'email': firebaseUser.email,
        'createdAt': FieldValue.serverTimestamp(),
        'address': null,
      });
      return UserModel.fromAuth(id: firebaseUser.uid, email: firebaseUser.email ?? email.trim());
    } on FirebaseAuthException catch (e) {
      throw Exception(_authMessage(e));
    }
  }

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final firebaseUser = cred.user!;
      return UserModel.fromAuth(id: firebaseUser.uid, email: firebaseUser.email ?? email.trim());
    } on FirebaseAuthException catch (e) {
      throw Exception(_authMessage(e));
    }
  }

  @override
  Future<void> logout() => _auth.signOut();

  @override
  Future<UserModel?> getCurrentUser() async {
    // Al arrancar, Firebase restaura la sesión de forma asíncrona.
    final firebaseUser = await _auth.authStateChanges().first;
    if (firebaseUser == null) return null;
    return UserModel.fromAuth(id: firebaseUser.uid, email: firebaseUser.email ?? '');
  }

  @override
  Future<List<RouteAddressModel>> searchAddresses(String query) async {
    final snapshot = await _db.collection('routes').orderBy('order').get();
    final routes = snapshot.docs
        .map((doc) => RouteAddressModel.fromMap({...doc.data(), 'id': doc.id}))
        .toList();

    final q = query.trim().toLowerCase();
    if (q.isEmpty) return routes;

    final matches = routes
        .where((a) => a.street.toLowerCase().contains(q) || a.zone.toLowerCase().contains(q))
        .toList();
    if (matches.isNotEmpty) return matches;

    // Dirección que no coincide con ninguna ruta: se permite guardarla tal cual.
    return [
      RouteAddressModel(
        id: 'custom',
        street: query.trim(),
        zone: 'Bogotá, Colombia',
        distanceKm: '2,4 km',
        estimatedMinutes: 12,
        scheduleInfo: 'Por confirmar',
      ),
    ];
  }

  @override
  Future<void> saveUserAddress(String userId, RouteAddressModel address) {
    return _userDoc(userId).set({'address': address.toMap()}, SetOptions(merge: true));
  }

  @override
  Future<RouteAddressModel?> getUserAddress(String userId) async {
    final doc = await _userDoc(userId).get();
    final address = doc.data()?['address'];
    if (address is! Map<String, dynamic>) return null;
    return RouteAddressModel.fromMap(address);
  }

  String _authMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Este correo ya está registrado';
      case 'invalid-email':
        return 'Ingresa un correo electrónico válido';
      case 'weak-password':
        return 'La contraseña es muy débil';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Correo o contraseña incorrectos';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta más tarde';
      case 'network-request-failed':
        return 'Sin conexión. Revisa tu internet';
      default:
        return e.message ?? 'Ocurrió un error de autenticación';
    }
  }
}
