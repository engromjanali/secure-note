import 'package:secure_note/core/constants/all_enums.dart';
import 'package:secure_note/core/constants/default_values.dart';
import 'package:secure_note/core/constants/dimension_theme.dart';
import 'package:secure_note/core/extensions/ex_build_context.dart';
import 'package:secure_note/core/extensions/ex_date_time.dart';
import 'package:secure_note/core/extensions/ex_expanded.dart';
import 'package:secure_note/core/extensions/ex_padding.dart';
import 'package:secure_note/core/functions/f_call_back.dart';
import 'package:secure_note/core/functions/f_is_null.dart';
import 'package:secure_note/core/functions/f_loader.dart';
import 'package:secure_note/core/functions/f_printer.dart';
import 'package:secure_note/core/services/navigation_service.dart';
import 'package:secure_note/core/widgets/load_and_error/widgets/loading_widget.dart';
import 'package:secure_note/core/widgets/w_app_shimmer.dart';
import 'package:secure_note/core/widgets/w_dialog.dart';
import 'package:secure_note/core/widgets/w_dismisable.dart';
import 'package:secure_note/features/add/view/s_add.dart';
import 'package:secure_note/features/note/view/s_details.dart';
import 'package:secure_note/features/profile/view/secret/controller/c_passkey.dart';
import 'package:secure_note/features/profile/view/secret/controller/c_sceret.dart';
import 'package:secure_note/features/profile/view/secret/data/datasource/passkey/passkey_datasource_impl.dart';
import 'package:secure_note/features/profile/view/secret/data/datasource/secret_note/secret_note_datasource_impl.dart';
import 'package:secure_note/features/profile/view/secret/data/model/m_passkey.dart';
import 'package:secure_note/features/profile/view/secret/data/model/m_secret.dart';
import 'package:secure_note/features/profile/view/secret/data/model/m_secret_query.dart';
import 'package:secure_note/features/profile/view/secret/data/repository/passkey/passkey_repository_impl.dart';
import 'package:secure_note/features/profile/view/secret/data/repository/secret_note/secret_note_repository_impl.dart';
import 'package:secure_note/features/profile/view/secret/view/s_add_passkey.dart';
import 'package:secure_note/features/task/controller/c_task.dart';
import 'package:secure_note/features/task/data/datasource/task_datasource_impl.dart';
import 'package:secure_note/features/task/data/model/m_task.dart';
import 'package:secure_note/features/task/data/repository/task_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:power_state/power_state.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sliver_tools/sliver_tools.dart';

class WSecretSection extends StatefulWidget {
  Color? leadingColor;
  final String? title;
  // final List<MSecret>? items;
  final Function()? onTap;
  final bool asSliver;
  final Function()? loadNext;
  final Function()? loadPrevious;
  final Function((int, int))? removeCache;
  final bool isSecretNote;

  WSecretSection({
    super.key,
    this.title,
    this.leadingColor,
    this.onTap,
    this.asSliver = false,
    this.loadNext,
    this.loadPrevious,
    this.removeCache,
    this.isSecretNote = true,
  });

  @override
  State<WSecretSection> createState() => _WSecretSectionState();
}

class _WSecretSectionState extends State<WSecretSection> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create();
  double lastPosition = 0;
  ScrollDirection currentScrollDirection = ScrollDirection.reverse;
  CSecret cSecret = PowerVault.put(
    CSecret(SecretRepositoryImpl(SecretDatasourceImpl())),
  );
  CPasskey cPasskey = PowerVault.put(
    CPasskey(PasskeyRepositoryImpl(PasskeyDataSourceImpl())),
  );
  List<MSecret> secretItems = [];
  List<MPasskey> passkeyItems = [];

  @override
  void initState() {
    super.initState();

    callBackFunction(() {
      widget.isSecretNote
          ? cSecret!.fetchSpacificItem(
              // payload: MSQuery(),
            )
          : cPasskey!.fetchSpacificItem(
              // payload: MSQuery(),
            );
      initScrolling();
    });
  }

  @override
  void dispose() {
    printer("dispose secret section");
    if (widget.isSecretNote) {
      PowerVault.delete<CSecret>();
    } else {
      PowerVault.delete<CPasskey>();
    }
    super.dispose();
  }

  void initScrolling() {
    printer("initScrolling");
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
        // remove from end
        if (lastVisibleIndex >= 200 &&
            currentScrollDirection == ScrollDirection.reverse &&
            !(widget.isSecretNote
                ? cSecret!.isLoadingMore
                : cPasskey!.isLoadingMore)) {
          // remove from top,
          removeData(lastVIndex: lastVisibleIndex);
        }
        // remove form end
        if (firstVisibleIndex <= 10 &&
            (widget.isSecretNote ? secretItems.length : passkeyItems.length) >
                200 &&
            currentScrollDirection == ScrollDirection.forward &&
            !(widget.isSecretNote
                ? cSecret!.isLoadingMore
                : cPasskey!.isLoadingMore)) {
          // remove from end,
          removeData(lastVIndex: lastVisibleIndex, removeFormTop: false);
        }
        // load previous
        if (firstVisibleIndex <= 10 &&
            currentScrollDirection == ScrollDirection.forward &&
            !(widget.isSecretNote
                ? cSecret!.isLoadingMore
                : cPasskey!.isLoadingMore) &&
            (widget.isSecretNote
                ? cSecret!.hasMorePrev
                : cPasskey!.hasMorePrev)) {
          // add previous
          printer("call for load previous");
          if (widget.isSecretNote) {
            cSecret!.fetchSpacificItem(payload: MSQuery(isLoadNext: false));
          } else {
            cPasskey!.fetchSpacificItem(payload: MSQuery(isLoadNext: false));
          }
        }
        // load next
        if (lastVisibleIndex >=
                ((widget.isSecretNote
                        ? secretItems.length
                        : passkeyItems.length) -
                    11) &&
            currentScrollDirection == ScrollDirection.reverse &&
            !(widget.isSecretNote
                ? cSecret!.isLoadingMore
                : cPasskey!.isLoadingMore) &&
            (widget.isSecretNote
                ? cSecret!.hasMoreNext
                : cPasskey!.hasMoreNext)) {
          // load next
          printer("call for load next");
          widget.isSecretNote
              ? cSecret!.fetchSpacificItem(payload: MSQuery(isLoadNext: true))
              : cPasskey!.fetchSpacificItem(payload: MSQuery(isLoadNext: true));
        }
        // set scroll direction.
        double currentPosition = firstVisibleItem.itemLeadingEdge;
        if (currentPosition > lastPosition) {
          // printer("⬇️ Scrolling Forward");
          currentScrollDirection = ScrollDirection.forward;
        } else if (currentPosition < lastPosition) {
          // printer("⬆️ Scrolling Reverse");
          currentScrollDirection = ScrollDirection.reverse;
        }
        lastPosition = currentPosition;
      }
    });
  }

  Future<void> removeData({
    int? firstVIndex,
    int? lastVIndex,
    bool removeFormTop = true,
    int pageCount = 5,
  }) async {
    // using "jumpTo"
    if (!cSecret!.isLoadingMore) {
      widget.isSecretNote
          ? cSecret!.isLoadingMore = true
          : cPasskey!.isLoadingMore = true;
      if (removeFormTop) {
        printer("remove data from top");
        (widget.isSecretNote ? secretItems : passkeyItems).removeRange(
          0,
          (pageCount * PDefaultValues.limit),
        );

        widget.isSecretNote ? cSecret!.update() : cPasskey!.update();
        itemScrollController.jumpTo(
          index: lastVIndex! - (pageCount * PDefaultValues.limit),
          alignment: 1,
        );
        // set first or last element id
        if (widget.isSecretNote) {
          cSecret!.firstSId = cSecret!.secretList.first.id;
        } else {
          cPasskey!.firstSId = cPasskey!.passkeyList.first.id;
        }
        // set has more prev or not
        widget.isSecretNote
            ? cSecret!.hasMorePrev = true
            : cPasskey!.hasMorePrev = true;
      } else {
        printer("remove data from bottom/end");
        (widget.isSecretNote ? secretItems : passkeyItems).removeRange(
          (widget.isSecretNote ? secretItems.length : passkeyItems.length) -
              (pageCount * PDefaultValues.limit),
          (widget.isSecretNote ? secretItems.length : passkeyItems.length),
        );
        widget.isSecretNote ? cSecret!.update() : cPasskey!.update();
        // set first or last element id
        if (widget.isSecretNote) {
          cSecret!.lastSId = cSecret!.secretList.last.id;
        } else {
          cPasskey!.lastSId = cPasskey!.passkeyList.last.id;
        }
        // set has more next or not
        widget.isSecretNote
            ? cSecret!.hasMoreNext = true
            : cPasskey!.hasMoreNext = true;
      }
      // set flag
      widget.isSecretNote
          ? cSecret!.isLoadingMore = false
          : cPasskey!.isLoadingMore = false;
      widget.isSecretNote ? cSecret!.update() : cPasskey!.update();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSecretNote) {
      return PowerBuilder<CSecret>(
        builder: (_) {
          if (widget.isSecretNote) {
            secretItems = cSecret!.secretList;
          } else {
            passkeyItems = cPasskey!.passkeyList;
          }
          printer("rebuild ${secretItems.length}");
          return child();
        },
      );
    } else {
      return PowerBuilder<CPasskey>(
        builder: (_) {
          if (widget.isSecretNote) {
            secretItems = cSecret!.secretList;
          } else {
            passkeyItems = cPasskey!.passkeyList;
          }
          return child();
        },
      );
    }
  }

  Widget child() {
    return Column(
      children: [
        if (isNotNull(widget.title) &&
            (widget.isSecretNote ? secretItems : passkeyItems).isNotEmpty)
          header(context),
        if ((cPasskey.isLoadingMore || cSecret.isLoadingMore) &&
            (cPasskey.hasMorePrev || cSecret.hasMorePrev))
          ListView.builder(
            shrinkWrap: true,
            // controller: NeverScrollableScrollPhysics(),
            itemCount: 2,
            itemBuilder: (context, index) => WAppsShimmer().pB(value: 16),
          ),
        ScrollablePositionedList.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount:
              (widget.isSecretNote ? secretItems.length : passkeyItems.length) +
              1,
          itemBuilder: builder,
          itemScrollController: itemScrollController,
          scrollOffsetController: scrollOffsetController,
          itemPositionsListener: itemPositionsListener,
          scrollOffsetListener: scrollOffsetListener,
        ).expd(),
      ],
    ).pB().expd();
  }

  Widget builder(BuildContext context, int index) {
    Widget? prevChild;
    Widget? nextChild;
    // for previous loader
    if (index == 0 &&
        (cPasskey.isLoadingMore || cSecret.isLoadingMore) &&
        !(cPasskey.isLoadNext || cSecret.isLoadNext)) {
      prevChild = ListView.builder(
        padding: EdgeInsets.all(0),
        shrinkWrap: true,
        itemCount: 2,
        itemBuilder: (context, index) => WAppsShimmer().pB(value: 16),
      );
    }
    // next loader
    if (index ==
            (widget.isSecretNote ? secretItems.length : passkeyItems.length) &&
        (cPasskey.isLoadNext || cSecret.isLoadNext) &&
        (cPasskey.isLoadingMore || cSecret.isLoadingMore)) {
      printer("loading next");
      nextChild = ListView.builder(
        padding: EdgeInsets.all(0),
        shrinkWrap: true,
        itemCount: 2,
        itemBuilder: (context, index) => WAppsShimmer().pB(value: 16),
      );
    }
    String? dateTime;
    if (index <
        (widget.isSecretNote ? secretItems.length : passkeyItems.length)) {
      dateTime =
          (widget.isSecretNote
                  ? secretItems[index].createdAt
                  : passkeyItems[index].createdAt)
              ?.format(DateTimeFormattingExtension.formatDDMMMYYYY_I_HHMMA) ??
          PDefaultValues.noName;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isNotNull(prevChild)) prevChild!,
        if (index <
            (widget.isSecretNote ? secretItems.length : passkeyItems.length))
          WDismisable(
            withDismissable: false,
            isFromVault: true,
            taskState: TaskState.note,
            isSecretNote: widget.isSecretNote,
            leadingColor: widget.leadingColor,
            onTap: () {
              if (widget.isSecretNote) {
                SDetails(isFromVault: true, mSecret: secretItems[index]).push();
              } else {
                // show passkey
                SAPasskey(viewOnly: true, mPasskey: passkeyItems[index]).push();
              }
            },
            onAction: (actionType) {
              printer(actionType);
              onAction(actionType, index);
            },
            title: widget.isSecretNote
                ? secretItems[index].title
                : passkeyItems[index].title,
            subTitle: dateTime,
            mSecret: widget.isSecretNote ? secretItems[index] : null,
          ),
        if (isNotNull(nextChild)) nextChild!,
      ],
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
  void onAction(ActionType actionType, int index) {
    MSecret? mSecret;
    MPasskey? mPasskey;
    if (widget.isSecretNote) {
      mSecret = secretItems[index];
    } else {
      mPasskey = passkeyItems[index];
    }
    widget.isSecretNote
        ? secretItems.removeAt(index)
        : passkeyItems.removeAt(index);
    widget.isSecretNote ? cSecret!.update() : cPasskey!.update();
    if (actionType == ActionType.edit) {
      if (widget.isSecretNote) {
        // note
        SAdd(
          isEditPage: true,
          onlyNote: true,
          mSecret: mSecret,
          isSecret: true,
        ).push();
      } else {
        //passkey
        SAPasskey(isEdit: true, mPasskey: mPasskey).push();
      }
    } else if (actionType == ActionType.removeFromVault &&
        widget.isSecretNote) {
      CTask cTask = PowerVault.put(
        CTask(TaskRepositoryImpl(TaskDataSourceImpl())),
      );
      MTask payload = MTask(
        title: mSecret?.title,
        points: mSecret?.points,
        details: mSecret?.details,
        endAt: null,
        createdAt: mSecret?.createdAt,
        updatedAt: mSecret?.updatedAt,
        finishedAt: null,
      );
      cTask.addTask(payload);
      cSecret!.deleteSecret(mSecret!.id!);
      PowerVault.delete<CTask>();
    } else if (actionType == ActionType.delete) {
      // delete
      WDialog.show(
        title: "Confirm Delete?",
        content: "if you delete you will not avail to restore it again!",
        context: context,
        onConfirm: () {
          if (widget.isSecretNote) {
            cSecret!.deleteSecret(mSecret!.id!);
          } else {
            cPasskey!.deletePasskey(mPasskey!.id!);
          }
        },
      );
    }
  }
}
