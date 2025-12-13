import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secure_note/core/constants/all_enums.dart';
import 'package:secure_note/core/constants/colors.dart';
import 'package:secure_note/core/constants/default_values.dart';
import 'package:secure_note/core/constants/dimension_theme.dart';
import 'package:secure_note/core/constants/keys.dart';
import 'package:secure_note/core/data/local/db_local.dart';
import 'package:secure_note/core/extensions/ex_build_context.dart';
import 'package:secure_note/core/extensions/ex_date_time.dart';
import 'package:secure_note/core/extensions/ex_duration.dart';
import 'package:secure_note/core/extensions/ex_expanded.dart';
import 'package:secure_note/core/extensions/ex_padding.dart';
import 'package:secure_note/core/functions/f_call_back.dart';
import 'package:secure_note/core/functions/f_encrypt_decrypt.dart';
import 'package:secure_note/core/functions/f_is_null.dart';
import 'package:secure_note/core/functions/f_printer.dart';
import 'package:secure_note/core/functions/f_snackbar.dart';
import 'package:secure_note/core/services/flutter_secure_service.dart';
import 'package:secure_note/core/services/navigation_service.dart';
import 'package:secure_note/core/services/secret_service.dart';
import 'package:secure_note/core/widgets/w_dialog.dart';
import 'package:secure_note/core/widgets/w_dismisable.dart';
import 'package:secure_note/features/add/view/s_add.dart';
import 'package:secure_note/features/note/view/s_details.dart';
import 'package:secure_note/features/profile/controllers/c_profile.dart';
import 'package:secure_note/features/profile/view/secret/controller/c_sceret.dart';
import 'package:secure_note/features/profile/view/secret/data/datasource/passkey/passkey_datasource_impl.dart';
import 'package:secure_note/features/profile/view/secret/data/datasource/secret_note/secret_note_datasource_impl.dart';
import 'package:secure_note/features/profile/view/secret/data/model/m_secret.dart';
import 'package:secure_note/features/profile/view/secret/data/repository/secret_note/secret_note_repository_impl.dart';
import 'package:secure_note/features/profile/view/secret/view/s_secondary_auth.dart';
import 'package:secure_note/features/task/controller/c_task.dart';
import 'package:secure_note/features/task/data/model/m_query.dart';
import 'package:secure_note/features/task/data/model/m_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:power_state/power_state.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sliver_tools/sliver_tools.dart';

class WTaskSection extends StatefulWidget {
  Color? leadingColor;
  final String? title;
  final Function()? onTap;
  final TaskState taskState;
  final bool asSliver;
  final Function()? loadNext;
  final Function()? loadPrevious;
  final Function((int, int))? removeCache;

  WTaskSection({
    super.key,
    this.title,
    this.leadingColor,
    this.onTap,
    required this.taskState,
    this.asSliver = false,
    this.loadNext,
    this.loadPrevious,
    this.removeCache,
  }) {
    leadingColor =
        leadingColor ??
        ((taskState == TaskState.pending)
            ? PColors.pendingColor
            : taskState == TaskState.timeOut
            ? PColors.timeoutColor
            : taskState == TaskState.completed
            ? PColors.completedColor
            : null);
  }

  @override
  State<WTaskSection> createState() => _WTaskSectionState();
}

class _WTaskSectionState extends State<WTaskSection> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create();
  double lastPosition = 0;
  ScrollDirection currentScrollDirection = ScrollDirection.reverse;
  CTask cTask = PowerVault.find<CTask>();
  List<MTask> items = [];

  @override
  void initState() {
    super.initState();
    callBackFunction(() {
      if (!widget.asSliver) {
        printer("value-");
        cTask.fetchSpacificItem(payload: MQuery(taskState: widget.taskState));
        initScrolling();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initScrolling() {
    // List<MTask>
    // items = widget.taskState == TaskState.pending
    //     ? cTask.pendingList
    //     : widget.taskState == TaskState.timeOut
    //     ? cTask.timeOutList
    //     : widget.taskState == TaskState.completed
    //     ? cTask.completedList
    //     : cTask.noteList;

    // 🔹 Listen to item positions (which items are visible)
    itemPositionsListener.itemPositions.addListener(() {
      final positions = itemPositionsListener.itemPositions.value;

      // Print all visible indexes
      // debugPrint("Visible indexes: ${positions.map((e) => e.index)}");

      if (positions.isNotEmpty) {
        final firstVisibleItem = positions.reduce(
          (a, b) => a.itemLeadingEdge < b.itemLeadingEdge ? a : b,
        );
        final lastVisibleItem = positions.reduce(
          (a, b) => a.itemTrailingEdge > b.itemTrailingEdge ? a : b,
        );
        final int lastVisibleIndex = lastVisibleItem.index;
        final int firstVisibleIndex = firstVisibleItem.index;
        if (lastVisibleIndex >= 200 &&
            currentScrollDirection == ScrollDirection.reverse &&
            !cTask.isLoadingMore) {
          // remove from top,
          removeData(lastVIndex: lastVisibleIndex);
        }
        if (firstVisibleIndex <= 10 &&
            items.length > 200 &&
            currentScrollDirection == ScrollDirection.forward &&
            !cTask.isLoadingMore) {
          // remove from end,
          removeData(lastVIndex: lastVisibleIndex, removeFormTop: false);
        }
        if (firstVisibleIndex <= 10 &&
            currentScrollDirection == ScrollDirection.forward &&
            !cTask.isLoadingMore &&
            cTask.hasMorePrev) {
          // add previous
          printer("call for load previous");
          cTask.fetchSpacificItem(
            payload: MQuery(taskState: widget.taskState, isLoadNext: false),
          );
        }
        if (lastVisibleIndex >= items.length - 11 &&
            currentScrollDirection == ScrollDirection.reverse &&
            !cTask.isLoadingMore &&
            cTask.hasMoreNext) {
          // load next
          printer("call for load next");
          cTask.fetchSpacificItem(payload: MQuery(taskState: widget.taskState));
        }
        // set scroll direction.
        double currentPosition = firstVisibleItem.itemLeadingEdge;
        if (currentPosition > lastPosition) {
          printer("⬇️ Scrolling Forward");
          currentScrollDirection = ScrollDirection.forward;
        } else if (currentPosition < lastPosition) {
          printer("⬆️ Scrolling Reverse");
          currentScrollDirection = ScrollDirection.reverse;
        }
        lastPosition = currentPosition;
      }
    });
  }

  Future<void> removeData({
    // int? firstVIndex,
    int? lastVIndex,
    bool removeFormTop = true,
    int pageCount = 5,
  }) async {
    // using "jumpTo"
    if (!cTask.isLoadingMore) {
      cTask.isLoadingMore = true;
      if (removeFormTop) {
        printer("remove data from top");
        items.removeRange(0, (pageCount * cTask.limit));
        cTask.update();
        itemScrollController.jumpTo(
          index: lastVIndex! - (pageCount * cTask.limit),
          alignment: 1,
        );
        cTask.firstPage += pageCount;
      } else {
        printer("remove data from bottom/end");
        items.removeRange(
          items.length - (pageCount * cTask.limit),
          items.length,
        );
        cTask.update();
        cTask.lastPage -= pageCount;
        cTask.hasMoreNext = true;
      }
      cTask.isLoadingMore = false;
      cTask.update();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PowerBuilder<CTask>(
      builder: (cTask) {
        // printer("length length ${items.length}");
        // printer("length first ${cTask.firstPage}");
        // printer("length last ${cTask.lastPage}");
        // printer("${items[0].endAt}");
        // cTask.isLoadingMore = false;

        items = items = widget.taskState == TaskState.pending
            ? cTask.pendingList
            : widget.taskState == TaskState.timeOut
            ? cTask.timeOutList
            : widget.taskState == TaskState.completed
            ? cTask.completedList
            : cTask.noteList;
        return widget.asSliver
            ? SliverPadding(
                padding: EdgeInsets.only(bottom: 10.h),
                sliver: MultiSliver(
                  children: [
                    if (isNotNull(widget.title) && items.isNotEmpty)
                      SliverToBoxAdapter(child: header(context)),
                    SliverList.builder(
                      itemBuilder: builder,
                      itemCount: items!.length,
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  if (isNotNull(widget.title) && items.isNotEmpty)
                    header(context),
                  ScrollablePositionedList.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: builder,
                    itemScrollController: itemScrollController,
                    scrollOffsetController: scrollOffsetController,
                    itemPositionsListener: itemPositionsListener,
                    scrollOffsetListener: scrollOffsetListener,
                  ).expd(),
                ],
              ).pB().expd();
      },
    );
  }

  Widget builder(context, index) {
    String dateTime =
        items[index].createdAt?.format(
          DateTimeFormattingExtension.formatDDMMMYYYY_I_HHMMA,
        ) ??
        PDefaultValues.noName;

    String status = widget.taskState == TaskState.pending
        ? items[index].endAt?.difference(DateTime.timestamp()).as_XX_XX_XX ??
              PDefaultValues.noName
        : (widget.taskState == TaskState.completed)
        ? "Completed"
        : "Time-Out";
    return items.length == index
        ? CircularProgressIndicator()
        : WDismisable(
            isFromVault: false,
            taskState: widget.taskState,
            leadingColor: widget.leadingColor,
            onTap: () {
              SDetails(isTask: true, mtask: items[index]).push();
            },
            onAction: (actionType) {
              onAction(actionType, index);
            },
            title: items[index].title,
            subTitle:
                "$dateTime ${widget.taskState == TaskState.note ? "" : "| $status"}",
            mTask: items[index],
          );
  }

  Widget header(BuildContext context) => Row(
    spacing: PTheme.spaceX,
    children: [
      Icon(
        Icons.circle,
        color: widget.leadingColor,
        size: context.textTheme?.titleSmall?.fontSize,
      ),
      Text(
        widget.title!,
        style: context.textTheme?.titleSmall?.copyWith(
          color: widget.leadingColor,
        ),
        overflow: TextOverflow.ellipsis,
      ).pR().expd(),
      GestureDetector(
        onTap: widget.onTap,
        child: Row(
          children: [
            Text(
              "See All",
              style: context.textTheme?.titleSmall?.copyWith(
                color: context.button?.primary,
              ),
            ),
            Icon(Icons.arrow_right),
          ],
        ),
      ),
    ],
  );
  void onAction(ActionType actionType, int index) async {
    MTask mTask = items[index];
    items.removeAt(index);
    cTask.update();
    if (actionType == ActionType.edit) {
      SAdd(
        isEditPage: true,
        onlyNote: widget.taskState == TaskState.note,
        mTask: mTask,
      ).push();
    } else if (actionType == ActionType.keepInVault) {
      CSecret cSecret = PowerVault.put(
        CSecret(SecretRepositoryImpl(SecretDatasourceImpl())),
      );
      MSecret payload = MSecret(
        id: DateTime.timestamp().timestamp,
        title: mTask.title,
        points: mTask.points,
        details: mTask.details,
        createdAt: mTask.createdAt,
        updatedAt: mTask.updatedAt,
      );
      CProfile cProfile = PowerVault.find<CProfile>();
      SecretService secretService = SecretService();
      if (cProfile.isSigned) {
        // at first init secrest service
        String? secondaryAuthKey = await FSSService().getString(
          "secondaryAuthKey",
        );
        if (isNull(secondaryAuthKey)) {
          // at first set secondary auth key
          // first signin, or new device sign in
          showSnackBar(
            "At First Set Secondary Authentication key",
            snackBarType: SnackBarType.warning,
          );
          FirebaseFirestore.instance
              .collection(PKeys.users)
              .doc(cProfile.uid)
              .collection(PKeys.eKey)
              .doc(PKeys.eKey)
              .get()
              .then((DocumentSnapshot snapshot) {
                final data = snapshot.data();
                if (isNotNull(data) &&
                    isNotNull(
                      (data as Map<String, dynamic>)["secondaryAuthKey"],
                    )) {
                  // key found in server
                  // so set key in local storage
                  printer(
                    "key found in server so set key in local storage ${data["secondaryAuthKey"]}",
                  );
                  SSAuth(
                    isSetkey: true,
                    serverSecondaryAuthKey: data["secondaryAuthKey"],
                  ).push();
                } else {
                  // key not found in server so set key
                  printer("key not found in server so set key");
                  SSAuth(isSetkey: true).push();
                }
              })
              .onError((e, l) {});
          return;
        }
        await secretService.init(secondaryAuthKey!);
        await cSecret.addSecret(payload);
        cTask.deleteTask(mTask.id!);
        PowerVault.delete<CSecret>();
      } else {
        showSnackBar("Please Sign-In", snackBarType: SnackBarType.warning);
      }
    } else if (actionType == ActionType.markAsComplete) {
      Map<String, dynamic> data = mTask.toMap();
      data.update(
        DBHelper.finishedAt,
        (value) => DateTime.timestamp().toIso8601String(),
      );
      MTask payload = MTask.fromMap(data);
      printer(payload.toMap());
      cTask.updateTask(payload);
    } else if (actionType == ActionType.setAsPending) {
      // set as pending
      Map<String, dynamic> data = Map.from(mTask.toMap());
      data.remove(DBHelper.finishedAt);
      MTask payload = MTask.fromMap(data);
      printer(payload.toMap());
      cTask.updateTask(payload);
    } else if (actionType == ActionType.delete) {
      // delete
      WDialog.show(
        title: "Confirm Delete?",
        content: "if you delete you will not avail to restore it again!",
        context: context,
        onConfirm: () {
          cTask.deleteTask(mTask.id!);
        },
      );
    }
  }
}
