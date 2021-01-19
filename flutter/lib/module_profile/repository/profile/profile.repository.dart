import 'package:c4d/consts/urls.dart';
import 'package:c4d/module_auth/service/auth_service/auth_service.dart';
import 'package:c4d/module_network/http_client/http_client.dart';
import 'package:c4d/module_profile/request/branch/create_branch_request.dart';
import 'package:c4d/module_profile/request/profile/profile_request.dart';
import 'package:c4d/module_profile/response/create_branch_response.dart';
import 'package:c4d/module_profile/response/get_branches_response.dart';
import 'package:c4d/module_profile/response/get_records_response.dart';
import 'package:inject/inject.dart';

@provide
class ProfileRepository {
  final ApiClient _apiClient;
  final AuthService _authService;

  ProfileRepository(
    this._apiClient,
    this._authService,
  );

  Future<bool> createProfile(ProfileRequest profileRequest) async {
    var token = await _authService.getToken();
    dynamic response = await _apiClient.post(
      Urls.PROFILE,
      profileRequest.toJson(),
      headers: {'Authorization': 'Bearer ' + token},
    );

    if (response['status_code'] == '201') return true;

    return false;
  }

  Future<Branch> createBranch(
      CreateBranchRequest createBranch) async {
    var token = await _authService.getToken();
    dynamic response = await _apiClient.post(
      Urls.BRANCH,
      createBranch.toJson(),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response == null) return null;

    return CreateBranchResponse.fromJson(response).data;
  }

  Future<Branch> getMyBranches() async {
    var token = await _authService.getToken();
    dynamic response = await _apiClient.get(
      Urls.BRANCH,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response == null) return null;

    return GetBranchesResponse.fromJson(response).data.last;
  }

  Future<List<ActivityRecord>> getUserActivityLog() async {
    var token = await _authService.getToken();
    dynamic response = await _apiClient.get(
      Urls.LOG_API,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response == null) return null;

    return GetRecordsResponse.fromJson(response).data;
  }
}