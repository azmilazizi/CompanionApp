import '../../app/locator.dart';
import '../../models/community.dart';
import '../rest_service.dart';

class CommunityRestService {
  final RestService _rest = locator<RestService>();

  Future<Community> getCommunity(String id) async {
    final json = await _rest.get('community/$id');
    return Community.fromJson(json);
  }

  Future<List<Community>> getCommunities() async {
    final jsonList = await _rest.get('community/all');
    if (jsonList is List)
      return jsonList.map((json) => Community.fromJson(json)).toList();
    return [];
  }

  Future<List<Community>> getCommunitiesForUser(String id) async {
    final jsonList = await _rest.get('user/$id/communities');
    if (jsonList is List)
      return jsonList.map((json) => Community.fromJson(json)).toList();
    return [];
  }

  Future createCommunity(Community community) async {
    final json = await _rest.post('community', data: community.toJson());
    return Community.fromJson(json);
  }

  Future updateCommunity(
    String id, {
    String photoUrl,
    String headerPhotoUrl,
    String description,
    List<String> tags,
    List<String> posts,
    List<String> companions,
    List<String> admins,
  }) async {
    Map<String, dynamic> data = Map();
    ({
      'photoUrl': photoUrl,
      'headerPhotoUrl': headerPhotoUrl,
      'description': description,
      'tags': tags,
      'posts': posts,
      'companions': companions,
      'admins': admins,
    }).forEach((key, value) {
      if (value != null) data[key] = value;
    });

    final json = await _rest.patch('community/$id', data: data);
    return Community.fromJson(json);
  }

  Future deleteCommunity(String id) async {
    await _rest.delete('community/$id');
  }
}
