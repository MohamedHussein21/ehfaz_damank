import 'package:flutter/material.dart';

class PersonalInformationSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function()? onTap;
  const PersonalInformationSection(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Colors.grey,
                  size: 15,
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Divider(
              thickness: 0.4,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
