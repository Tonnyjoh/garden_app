import 'package:flutter/material.dart';

class ExpenseIncomeData extends StatefulWidget {
  const ExpenseIncomeData({super.key});

  @override
  State<ExpenseIncomeData> createState() => _ExpenseIncomeDataState();
}

class _ExpenseIncomeDataState extends State<ExpenseIncomeData> {
  final List itemList = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  String? selectedValue = "August";

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Expanded(
      child: SizedBox(
        height: screenHeight * 0.25, // Adjusting the height dynamically
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: expenseIncomeContainer(
                      context,
                      Icons.arrow_upward,
                      "Expense",
                      4100.00,
                      const Color.fromRGBO(158, 235, 71, 1),
                      Colors.white,
                      screenWidth,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: expenseIncomeContainer(
                      context,
                      Icons.arrow_downward,
                      "Income",
                      2100.00,
                      Colors.white,
                      const Color.fromRGBO(158, 235, 71, 1),
                      screenWidth,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                      Text(
                        "Day",
                        style: TextStyle(
                          color: Color.fromRGBO(158, 235, 71, 1),
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "Week",
                        style: TextStyle(
                          color: Color.fromARGB(255, 244, 227, 38),
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "Month",
                        style: TextStyle(
                          color: Colors.pink,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: 28,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: selectedValue,
                        dropdownColor: Colors.white,
                        items: itemList.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 31, 30, 30),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue = newValue;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget expenseIncomeContainer(BuildContext context, IconData icon,
      String text, double price, Color color, Color textColor, double screenWidth) {
    return Container(
      height: 50,
      width: screenWidth * 0.4, // Adjusting the width to be responsive
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              icon,
              color: textColor,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                ),
              ),
              Text(
                "\$$price",
                style: TextStyle(
                  color: textColor,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}