import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/user_profile.dart';

import '../../domain/model/group_id_and_schedule_id_and_member_list_model.dart';
import '../../domain/model/group_schedule_and_id_model.dart';

import '../controllers/group/group_deletion_controller.dart';

import '../navigations/group_setting_navigation_trailing_bar_dialog_navigator.dart';

import '../providers/group/members/listen_group_member_profile_list.dart';
import '../providers/group/schedule/listen_all_group_schedule_and_id_list_provider.dart';

class GroupSettingNavigationTrailingBarDialogHandler {
  GroupSettingNavigationTrailingBarDialogHandler(
    this.context,
    this.ref,
    this.groupId,
  );

  final BuildContext context;
  final WidgetRef ref;
  final String groupId;

  Future<void> handleToDelete() async {
    await _executeToDelete(context, groupId);
    await _moveToPage();
  }

  Future<void> _executeToDelete(BuildContext context, String groupId) async {
    final memberList = await _fetchMemberProfileList();
    final groupScheduleAndIdList = await _fetchGroupScheduleAndIdList();
    await _executeToDeleteGroup(groupScheduleAndIdList, groupId, memberList);
  }

  Future<List<UserProfile?>> _fetchMemberProfileList() async {
    return await ref.read(listenGroupMemberProfileListProvider(groupId).future);
  }

  Future<List<GroupScheduleAndId?>> _fetchGroupScheduleAndIdList() async {
    return await ref
        .watch(listenAllGroupScheduleAndIdListProvider(groupId).future);
  }

  Future<void> _executeToDeleteGroup(
    List<GroupScheduleAndId?> groupScheduleList,
    String groupId,
    List<UserProfile?> memberList,
  ) async {
    try {
      await _attemptToDelete(groupScheduleList, groupId, memberList);
    } on Exception catch (e) {
      debugPrint('Error: failed to delete group. $e');
    }
  }

  Future<void> _attemptToDelete(
    List<GroupScheduleAndId?> groupScheduleList,
    String groupId,
    List<UserProfile?> memberList,
  ) async {
    if (groupScheduleList.isEmpty) {
      await _deleteGroup(groupId, null, memberList);
    } else {
      await Future.wait(
        groupScheduleList.map((data) async {
          if (data != null) {
            await _deleteGroup(groupId, data.groupScheduleId, memberList);
          }
        }),
      );
    }
  }

  Future<void> _deleteGroup(
    String groupId,
    String? groupScheduleId,
    List<UserProfile?> memberList,
  ) async {
    final deleteController = ref.read(groupDeletionControllerProvider);
    final groupData = GroupIdAndScheduleIdAndMemberList(
      groupId: groupId,
      groupScheduleId: groupScheduleId,
      groupMemberList: memberList,
    );
    await deleteController.deleteGroup(groupData);
  }

  Future<void> _moveToPage() async {
    if (context.mounted) {
      final navigator =
          GroupSettingNavigationTrailingBarDialogNavigator(context);
      await navigator.moveToPage();
    }
  }
}
