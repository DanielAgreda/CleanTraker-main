import 'package:flutter/material.dart';
import '../../data/models/route_address_model.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/tracker_repository.dart';

class TrackerProvider extends ChangeNotifier {
  final TrackerRepository _repository;

  UserModel? _currentUser;
  RouteAddressModel? _selectedAddress;
  List<RouteAddressModel> _searchResults = [];
  bool _isLoading = false;
  String? _errorMessage;

  TrackerProvider(this._repository) {
    _init();
  }

  UserModel? get currentUser => _currentUser;
  RouteAddressModel? get selectedAddress => _selectedAddress;
  List<RouteAddressModel> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentUser = await _repository.getCurrentUser();
      if (_currentUser != null) {
        _selectedAddress = await _repository.getUserAddress(_currentUser!.id);
        _searchResults = await _repository.searchAddresses('');
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _currentUser = await _repository.login(email, password);
      _selectedAddress = await _repository.getUserAddress(_currentUser!.id);
      _searchResults = await _repository.searchAddresses('');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _currentUser = await _repository.register(email, password);
      _searchResults = await _repository.searchAddresses('');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    _currentUser = null;
    _selectedAddress = null;
    _searchResults = [];
    notifyListeners();
  }

  Future<void> searchAddress(String query) async {
    _searchResults = await _repository.searchAddresses(query);
    notifyListeners();
  }

  Future<void> selectAndSaveAddress(RouteAddressModel address) async {
    if (_currentUser == null) return;
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.saveUserAddress(_currentUser!.id, address);
      _selectedAddress = address;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
