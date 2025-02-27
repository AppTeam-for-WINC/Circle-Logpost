import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/facade/group_member_schedule_facade.dart';

import '../../../data/interface/i_group_schedule_repository.dart';

import '../../../data/repository/database/group_schedule_repository.dart';

import '../../entity/user_profile.dart';
import '../../interface/group_schedule/i_group_schedule_delete_use_case.dart';


final groupScheduleDeleteUseCaseProvider =
    Provider<IGroupScheduleDeleteUseCase>((ref) {
  final memberScheduleUseCase = ref.read(groupMemberScheduleFacadeProvider);
  final scheduleRepository = ref.read(groupScheduleRepositoryProvider);

  return GroupScheduleDeleteUseCase(
    memberScheduleUseCase: memberScheduleUseCase,
    scheduleRepository: scheduleRepository,
  );
});

class GroupScheduleDeleteUseCase implements IGroupScheduleDeleteUseCase {
  const GroupScheduleDeleteUseCase({
    required this.memberScheduleUseCase,
    required this.scheduleRepository,
  });

  final GroupMemberScheduleFacade memberScheduleUseCase;
  final IGroupScheduleRepository scheduleRepository;

  @override
  Future<void> deleteSchedule(
    List<UserProfile?> groupMemberList,
    String groupScheduleId,
  ) async {
    try {
      await _attemptToDelete(groupMemberList, groupScheduleId);
    } on FirebaseException catch (e) {
      throw Exception('Error: failed to delete group schedule. ${e.message}');
    }
  }

  Future<void> _attemptToDelete(
    List<UserProfile?> groupMemberList,
    String groupScheduleId,
  ) async {
    await _deleteAllMemberSchedule(
      groupMemberList,
      groupScheduleId,
    );
    await _deleteGroupSchedule(groupScheduleId);
  }

  Future<void> _deleteAllMemberSchedule(
    List<UserProfile?> groupMemberList,
    String groupScheduleId,
  ) async {
    await memberScheduleUseCase.deleteAllMemberSchedule(
      groupMemberList,
      groupScheduleId,
    );
  }

  Future<void> _deleteGroupSchedule(String groupScheduleId) async {
    try {
      await scheduleRepository.deleteSchedule(groupScheduleId);
    } on FirebaseException catch (e) {
      throw Exception('Error: failed to delete group schedule. ${e.message}');
    }
  }
}
