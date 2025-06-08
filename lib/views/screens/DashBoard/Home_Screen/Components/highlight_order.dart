import 'package:flutter/material.dart';

import '../../../../../services/theme.dart';

class HighlightOrder extends StatefulWidget {
  const HighlightOrder({super.key});

  @override
  State<HighlightOrder> createState() => _HighlightOrderState();
}

class _HighlightOrderState extends State<HighlightOrder> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) {
        return SizedBox(
          width: 10,
        );
      },
      scrollDirection: Axis.horizontal,
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          width: 350,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade400)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      padding: EdgeInsets.symmetric(
                          horizontal:  10, vertical:  5),
                      decoration: BoxDecoration(
                        color: Colors.green,
                      ),
                      child: Text(
                        "On Time",
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      )),
                  Text(
                    "Mon,28 Apr 2025,02:31 Pm",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                      fontSize: 10
                        ),
                  ),
                  Text("Track Now",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700, color: Colors.red))
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ORD00065",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                      Row(
                        children: [
                          Text(
                            "Books | ",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(),
                          ),
                          Text(
                            "Out For PickUp",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: Color(0xffbba14f),
                                    fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Icon(
                        Icons.phone_in_talk_outlined,
                        color: Colors.white,
                        size: 20,
                      ))
                ],
              ),
              Divider(
                height: 15,
                color: Colors.grey[300],
              ),
              Row(
                children: [
                  Text(
                    "Estimate Delivery time: ",
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                  Text(
                    "28 Apr 2025,07:31 PM",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: 10,
                        color: Color(0xffbba14f),
                        fontWeight: FontWeight.w600),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
