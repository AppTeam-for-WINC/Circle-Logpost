import '../entity/user_profile.dart';

class GroupIdAndScheduleIdAndMemberList {
  GroupIdAndScheduleIdAndMemberList({
    required this.groupId,
    required this.groupScheduleId,
    required this.groupMemberList,
  });

  final String groupId;
  final String? groupScheduleId;
  final List<UserProfile?> groupMemberList;
}
