import '../models/route_address_model.dart';
import '../models/user_model.dart';

/// CONTRATO ABSTRACTO DEL BACKEND
/// Implementada por FirebaseTrackerRepository (Firebase Auth + Firestore).
abstract class TrackerRepository {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String email, String password);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();

  /// Búsqueda de direcciones / autocompletado de rutas
  Future<List<RouteAddressModel>> searchAddresses(String query);

  /// Guardar y leer la dirección asignada al usuario
  Future<void> saveUserAddress(String userId, RouteAddressModel address);
  Future<RouteAddressModel?> getUserAddress(String userId);
}
