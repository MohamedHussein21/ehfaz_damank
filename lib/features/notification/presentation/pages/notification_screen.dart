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
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: ColorManger.blackColor),
            onPressed: () => Navigator.pop(context),
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
                    final order = notification.order;

                    return Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.notifications,
                                  color: Theme.of(context).primaryColor),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  notification.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (order != null) ...[
                            Text(
                              "${"order_name".tr()}: ${order.name}",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "${"order_expiry".tr()}: ${order.damanDate}",
                              style: TextStyle(color: Colors.red),
                            ),
                          ] else ...[
                            Text(
                              notification.body,
                              style: Theme.of(context).textTheme.bodyLarge,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ]
                        ],
                      ),
                    );
                  });
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
