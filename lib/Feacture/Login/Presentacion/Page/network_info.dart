import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkInfo {
  static final NetworkInfo _instance = NetworkInfo._internal();
  factory NetworkInfo() => _instance;
  NetworkInfo._internal();

  Future<bool> isConnected() async {
    try {
      // Verifica si hay alguna red conectada (wifi o datos móviles)
      final connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        print('No estás conectado a ninguna red');
        return false;
      }

      // Verifica si esa red realmente tiene acceso a Internet
      final hasInternetAccess = await InternetConnectionChecker().hasConnection;

      if (hasInternetAccess) {
        print('Conexión a Internet confirmada');
      } else {
        print('Estás conectado a una red pero sin acceso a Internet');
      }

      return hasInternetAccess;
    } catch (e) {
      print('Error verificando la conexión: $e');
      return false;
    }
  }
}
