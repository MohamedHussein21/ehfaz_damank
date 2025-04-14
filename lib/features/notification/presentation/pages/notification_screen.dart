import 'package:ahfaz_damanak/core/utils/color_mange.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/notification_cubit.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationCubit()..getNotification(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "notification".tr(),
            style: TextStyle(color: ColorManger.blackColor),
          ),
        ),
        body: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotificationLoaded) {
              final notifications = state.notificationModel;
              if (notifications.isEmpty) {
                return Center(
                  child: Text(
                    "no notifications found".tr(),
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }
              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          notification.body,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.right,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // Align(
                        //   alignment: Alignment.topRight,
                        //   child: Image.asset(
                        //     notification.isRead
                        //         ? IconsAssets.notificationDone
                        //         : IconsAssets.notificationNotDone,
                        //     height: 20,
                        //     width: 20,
                        //   ),
                        // ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is NotificationError) {
              return Center(
                child: Text(
                  "some error occurred while loading notifications".tr(),
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
