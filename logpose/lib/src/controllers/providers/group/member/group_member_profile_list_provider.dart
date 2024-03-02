import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/user/user.dart';
import '../../../../services/database/group_membership_controller.dart';

/// Group membership users controller.
final watchGroupMembershipProfileListProvider =
    StreamProvider.family<List<UserProfile?>, String>((ref, groupId) async* {
  final memebershipProfilesStream =
      GroupMembershipController.readAllRoleByProfileWithGroupId(
    groupId,
    'membership',
  );

  await for (final membershipProfileList in memebershipProfilesStream) {
    final membershipProfileStream =
        membershipProfileList.map((membershipProfile) {
      if (membershipProfile == null) {
        return null;
      }
      return membershipProfile;
    }).toList();
    yield membershipProfileStream;
  }
});
