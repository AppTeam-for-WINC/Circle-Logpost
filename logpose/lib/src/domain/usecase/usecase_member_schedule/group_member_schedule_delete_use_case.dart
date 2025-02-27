import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/interface/i_group_member_schedule_repository.dart';
import '../../../data/repository/database/member_schedule_repository.dart';

import '../../entity/user_profile.dart';

import '../../interface/group_member_schedule/i_group_member_schedule_delete_use_case.dart';
import '../../interface/group_member_schedule/i_group_member_schedule_id_use_case.dart';
import '../../interface/group_membership/i_group_member_id_use_case.dart';
import '../../interface/user/i_user_id_use_case.dart';
import '../usecase_group_membership/group_member_id_use_case.dart';
import '../usecase_user/user_id_use_case.dart';
import 'group_member_schedule_id_use_case.dart';

final groupMemberScheduleDeleteUseCaseProvider =
    Provider<IGroupMemberScheduleDeleteUseCase>((ref) {
  final userIdUseCase = ref.read(userIdUseCaseProvider);
  final groupMemberIdUseCase = ref.read(groupMemberIdUseCaseProvider);
  final memberScheduleIdUseCase =
      ref.read(groupMemberScheduleIdUseCaseProvider);
  final memberScheduleRepository =
      ref.read(groupMemberScheduleRepositoryProvider);

  return GroupMemberScheduleDeleteUseCase(
    ref: ref,
    userIdUseCase: userIdUseCase,
    groupMemberIdUseCase: groupMemberIdUseCase,
    memberScheduleIdUseCase: memberScheduleIdUseCase,
    memberScheduleRepository: memberScheduleRepository,
  );
});

class GroupMemberScheduleDeleteUseCase
    implements IGroupMemberScheduleDeleteUseCase {
  const GroupMemberScheduleDeleteUseCase({
    required this.ref,
    required this.userIdUseCase,
    required this.groupMemberIdUseCase,
    required this.memberScheduleIdUseCase,
    required this.memberScheduleRepository,
  });

  final Ref ref;
  final IUserIdUseCase userIdUseCase;
  final IGroupMemberIdUseCase groupMemberIdUseCase;
  final IGroupMemberScheduleIdUseCase memberScheduleIdUseCase;
  final IGroupMemberScheduleRepository memberScheduleRepository;

  @override
  Future<void> deleteAllMemberSchedule(
    List<UserProfile?> groupMemberList,
    String groupScheduleId,
  ) async {
    await Future.wait(
      groupMemberList.map((member) async {
        return _attemptToDeleteAllMemberSchedule(
          member,
          groupScheduleId,
        );
      }),
    );
  }

  @override
  Future<void> deleteMemberSchedule(String memberScheduleId) async {
    try {
      await memberScheduleRepository.deleteMemberSchedule(memberScheduleId);
    } on FirebaseException catch (e) {
      throw Exception('Error: failed to delete member schedule. ${e.message}');
    }
  }

  Future<void> _attemptToDeleteAllMemberSchedule(
    UserProfile? member,
    String groupScheduleId,
  ) async {
    if (member == null) {
      debugPrint('Member is not existed.');
      return;
    }

    final memberScheduleId = await _executeToFetchMemberScheduleId(
      member.accountId,
      groupScheduleId,
    );
    if (memberScheduleId == null) {
      return;
    }

    await deleteMemberSchedule(memberScheduleId);
  }

  Future<String?> _executeToFetchMemberScheduleId(
    String accountId,
    String groupScheduleId,
  ) async {
    try {
      return await _attemptToFetchMemberScheduleId(accountId, groupScheduleId);
    } on Exception catch (e) {
      throw Exception('Error: failed to read schedule ID and User ID. $e');
    }
  }

  Future<String?> _attemptToFetchMemberScheduleId(
    String accountId,
    String groupScheduleId,
  ) async {
    final userDocId = await fetchUserDocIdWithAccountId(accountId);
    return _fetchMemberScheduleId(
      groupScheduleId,
      userDocId,
    );
  }

  Future<String> fetchUserDocIdWithAccountId(String accountId) async {
    return userIdUseCase.fetchUserDocIdWithAccountId(accountId);
  }

  Future<String?> _fetchMemberScheduleId(
    String groupScheduleId,
    String userDocId,
  ) async {
    return memberScheduleIdUseCase.fetchMemberScheduleId(
      groupScheduleId,
      userDocId,
    );
  }

  @override
  Future<void> deleteSchedulesForMemberInGroup(String membershipId) async {
    final userId = await _fetchUserIdWithMembershipId(membershipId);
    await _deleteMemberScheduleList(userId);
  }

  Future<String> _fetchUserIdWithMembershipId(String membershipId) async {
    return groupMemberIdUseCase.fetchUserIdWithMembershipId(membershipId);
  }

  Future<void> _deleteMemberScheduleList(String userId) async {
    final memberScheduleIdList =
        await _fetchMemberScheduleIdListWithUserId(userId);

    if (memberScheduleIdList == null) {
      return;
    }

    await memberScheduleIdList.map(deleteMemberSchedule);
  }

  Future<List<String>?> _fetchMemberScheduleIdListWithUserId(
    String userId,
  ) async {
    return await memberScheduleIdUseCase
        .fetchMemberScheduleIdListWithUserId(userId);
  }
}
