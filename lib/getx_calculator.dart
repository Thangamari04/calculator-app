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

    return Scaffold(
      appBar: AppBar(
        title: const Text('GetX Calculator'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
      
            Container(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  buildButtonRow(
                      ['C', '%', '⌫', '÷'],
                      [Colors.grey[300]!, Colors.grey[300]!, Colors.grey[300]!, Colors.orange],
                      controller),
                  buildButtonRow(
                      ['7', '8', '9', '×'],
                      [Colors.blue.shade50, Colors.blue.shade50, Colors.blue.shade50, Colors.orange],
                      controller),
                  buildButtonRow(
                      ['4', '5', '6', '-'],
                      [Colors.blue.shade50, Colors.blue.shade50, Colors.blue.shade50, Colors.orange],
                      controller),
                  buildButtonRow(
                      ['1', '2', '3', '+'],
                      [Colors.blue.shade50, Colors.blue.shade50, Colors.blue.shade50, Colors.orange],
                      controller),
                  buildButtonRow(
                      ['.', '0', '00', '='],
                      [Colors.blue.shade50, Colors.blue.shade50, Colors.blue.shade50, Colors.blue],
                      controller),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Obx(() {
                  return Container(
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          controller.currentInput.value,
                          style: const TextStyle(
                            fontSize: 36,
                            color: Colors.black,
                            
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          controller.previousInput.value,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtonRow(
      List<String> labels, List<Color> colors, GetXCalculatorController controller) {
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
        );
      }).toList(),
    );
  }

  Widget buildButton(String label, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: (label == '='||label == '+'||label == '-'||label == '×'||label == '÷') ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}