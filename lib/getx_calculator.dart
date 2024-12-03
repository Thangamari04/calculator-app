import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expressions/expressions.dart';

class GetXCalculatorController extends GetxController {
  var currentInput = ''.obs;
  var previousInput = ''.obs;

  void input(String value) {
    if (value == '%' && currentInput.isNotEmpty) {
      currentInput.value = (double.parse(currentInput.value) / 100).toString();
    } else {
      currentInput.value += value;
    }
  }

  void delete() {
    if (currentInput.isNotEmpty) {
      currentInput.value =
          currentInput.value.substring(0, currentInput.value.length - 1);
    }
  }

  void clear() {
    currentInput.value = '';
    previousInput.value = '';
  }

  void calculate() {
    if (currentInput.isNotEmpty) {
      try {
        String expressionString = currentInput.value
            .replaceAll('×', '*')
            .replaceAll('÷', '/')
            .replaceAll('%', '/100')
            .replaceAll(' ', '');
        final expression = Expression.parse(expressionString);
        final evaluator = ExpressionEvaluator();
        final result = evaluator.eval(expression, {});
        previousInput.value = currentInput.value;
        currentInput.value = result.toString();
      } catch (e) {
        currentInput.value = 'Error';
      }
    }
  }
}

class GetXCalculator extends StatelessWidget {
  const GetXCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GetXCalculatorController());
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: null,
        toolbarHeight: screenHeight * 0.15,
          //flexibleSpace: Padding(
            //padding: EdgeInsets.all(screenWidth * 0.02),
            //child: Align(
              //alignment: Alignment.topLeft,
              //child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTLS83XErb0zP7lBJnTQv9C2onf30pSb7PFgfO7G-0HRYv4THiKre-UvZ2k_0t0dUFDrAo&usqp=CAU',
              //height: screenHeight *0.1,
              //fit:BoxFit.contain,
              //),
            //),
          //),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(top: screenHeight*0.0),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(screenWidth * 0.1),
                      topRight: Radius.circular(screenWidth * 0.1),
                    ),
                  ),
           
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: Column(
                children: [
                  buildButtonRow(
                    ['C', '%', '⌫', '÷'],
                    [
                      Colors.grey[100]!,
                      Colors.grey[100]!,
                      Colors.grey[100]!,
                      Colors.orange[600]!
                    ],
                    controller,
                    context,
                  ),
                  buildButtonRow(
                    ['7', '8', '9', '×'],
                    [
                      Colors.deepPurple.shade50,
                      Colors.deepPurple.shade50,
                      Colors.deepPurple.shade50,
                      Colors.orange[600]!
                    ],
                    controller,
                    context,
                  ),
                  buildButtonRow(
                    ['4', '5', '6', '-'],
                    [
                      Colors.deepPurple.shade50,
                      Colors.deepPurple.shade50,
                      Colors.deepPurple.shade50,
                      Colors.orange[600]!
                    ],
                    controller,
                    context,
                  ),
                  buildButtonRow(
                    ['1', '2', '3', '+'],
                    [
                      Colors.deepPurple.shade50,
                      Colors.deepPurple.shade50,
                      Colors.deepPurple.shade50,
                      Colors.orange[600]!
                    ],
                    controller,
                    context,
                  ),
                  buildButtonRow(
                    ['.', '0', '00', '='],
                    [
                      Colors.deepPurple.shade50,
                      Colors.deepPurple.shade50,
                      Colors.deepPurple.shade50,
                      Colors.deepPurpleAccent[700]!,
                    ],
                    controller,
                    context,
                  ),
                ],
              ),
            ),
            Padding(
        
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Obx(() {
                  return Container(
            
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          controller.currentInput.value,
                          style: TextStyle(
                            fontSize: screenHeight * 0.05,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          controller.previousInput.value,
                          style: TextStyle(
                            fontSize: screenHeight * 0.025,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                }),
              ),
            
          ],
        ),
      ),
        ],
      ),
      ),
    ),
    );
  }

  Widget buildButtonRow(
      List<String> labels,
      List<Color> colors,
      GetXCalculatorController controller,
      BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: labels.asMap().entries.map((entry) {
        int index = entry.key;
        String label = entry.value;
        return buildButton(
          label,
          colors[index],
          () {
            if (label == 'C') {
              controller.clear();
            } else if (label == '⌫') {
              controller.delete();
            } else if (label == '=') {
              controller.calculate();
            } else {
              controller.input(label);
            }
          },
          context,
        );
      }).toList(),
    );
  }

  Widget buildButton(
      String label, Color color, VoidCallback onTap, BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    final buttonPadding = screenWidth * 0.05; // Adjust factor as needed

    return Padding(
      padding: EdgeInsets.all(buttonPadding * 0.2), // Spacing between buttons
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: const CircleBorder(),
          padding: EdgeInsets.all(buttonPadding), // Use calculated padding
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: screenWidth * 0.07, // Adjust font size dynamically
            fontWeight: FontWeight.bold,
            color: (label == '=' || label == '+' || label == '-' ||
                    label == '×' || label == '÷')
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    );
  }
}
