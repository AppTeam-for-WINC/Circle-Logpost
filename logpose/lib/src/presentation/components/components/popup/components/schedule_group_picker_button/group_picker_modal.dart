import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../domain/model/group_and_id_model.dart';

import '../../../../../../domain/providers/group/group/fetch_group_and_id_list_provider.dart';
import '../../../../../../domain/providers/group/group/selected_group_name_provider.dart';

import '../../../../../../domain/usecase/facade/group_facade.dart';

import '../../../../../notifiers/group_schedule_notifier.dart';

class GroupPickerModal extends ConsumerStatefulWidget {
  const GroupPickerModal({super.key, required this.groupIdList});
  final List<String> groupIdList;
  @override
  ConsumerState createState() => _GroupPickerModalState();
}

class _GroupPickerModalState extends ConsumerState<GroupPickerModal> {
  @override
  void initState() {
    super.initState();
    // 選択肢が1つしかない場合、自動的にその選択肢を選択。
    if (widget.groupIdList.length == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final id = widget.groupIdList[0];
        _setGroupId(id);
        await _setGroupName();
      });
    }
  }

  void _setGroupId(String id) {
    ref.read(groupScheduleNotifierProvider(null).notifier).setGroupId(id);
  }

  Future<void> _setGroupName() async {
    final groupFacade = ref.read(groupFacadeProvider);

    final groupIdList =
        await groupFacade.fetchGroupAndIdList(widget.groupIdList);

    ref.read(selectedGroupNameProvider.notifier).state =
        groupIdList[0].groupProfile.name;
  }

  @override
  Widget build(BuildContext context) {
    final groupIdList = widget.groupIdList;

    return Container(
      height: 200,
      width: 360,
      margin: const EdgeInsets.only(
        bottom: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(36),
      ),
      child: Center(
        child: Column(
          children: [
            _AsyncGroupWithIdList(groupIdList: groupIdList),
            const _CloseButton(),
          ],
        ),
      ),
    );
  }
}

class _AsyncGroupWithIdList extends ConsumerStatefulWidget {
  const _AsyncGroupWithIdList({required this.groupIdList});
  final List<String> groupIdList;

  @override
  ConsumerState createState() => _AsyncGroupWithIdListState();
}

class _AsyncGroupWithIdListState extends ConsumerState<_AsyncGroupWithIdList> {
  void _onSelectedItemChanged(List<GroupAndId> data, int index) {
    final id = data[index].groupId;
    final name = data[index].groupProfile.name;
    ref.watch(groupScheduleNotifierProvider(null).notifier).setGroupId(id);
    ref.watch(selectedGroupNameProvider.notifier).state = name;
  }

  @override
  Widget build(BuildContext context) {
    final groupIdList = widget.groupIdList;

    final asyncGroupAndIdList =
        ref.watch(fetchGroupAndIdListProvider(groupIdList));

    return asyncGroupAndIdList.when(
      data: (data) {
        return SizedBox(
          height: 150,
          child: CupertinoPicker(
            itemExtent: 40,
            onSelectedItemChanged: (int index) =>
                _onSelectedItemChanged(data, index),
            children: data
                .map(
                  (groupWithId) =>
                      Center(child: Text(groupWithId.groupProfile.name)),
                )
                .toList(),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => Text('$error'),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton();

  void _onPressed(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: const Text('Close'),
      onPressed: () => _onPressed(context),
    );
  }
}
