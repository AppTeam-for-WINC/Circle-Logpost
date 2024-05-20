import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repository/database/group_schedule_repository.dart';

import '../../entity/group_schedule.dart';

import '../../interface/i_group_schedule_repository.dart';

final groupScheduleUseCaseProvider = Provider<GroupScheduleUseCase>((ref) {
  final scheduleRepository = ref.read(groupScheduleRepositoryProvider);
  return GroupScheduleUseCase(scheduleRepository: scheduleRepository);
});

class GroupScheduleUseCase {
  const GroupScheduleUseCase({required this.scheduleRepository});

  final IGroupScheduleRepository scheduleRepository;

  Future<GroupSchedule> fetchGroupSchedule(String groupScheduleId) async {
    return scheduleRepository.fetchGroupSchedule(groupScheduleId);
  }
}
