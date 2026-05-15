import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';

class DashboardService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> getDashboard() async {
    final response = await _apiClient.get(
      '${ApiConstants.baseUrl}/dashboard',
    );

    return response['data'];
  }
}