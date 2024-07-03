import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEEE, MMMM d').format(DateTime.now());

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 25,
        right: 25,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formattedDate,
                style:const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'CaviarDreams',
                ),
              ),
              const SizedBox(height: 5,),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                    "My plants,",
                    style: TextStyle(
                      fontSize: 23,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'CaviarDreams',
                    ),
                  ),

                  Text(
                    "how are you today?",
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'CaviarDreams',
                    ),
                  ),
                ],
              ),

            ],
          ),
          CircleAvatar(
            child: Image.asset(
              'assets/images/logo_ispm.png',
              fit: BoxFit.cover,
            ),
          )
        ],
      ),
    );
  }
}
