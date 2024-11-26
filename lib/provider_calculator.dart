import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expressions/expressions.dart';

class CalculatorProvider extends ChangeNotifier {
  String currentInput = '';
  String previousInput = '';

  void input(String value) {
    if (value == '%' && currentInput.isNotEmpty) {
      currentInput = (double.parse(currentInput) / 100).toString();
    } else {
      currentInput += value;
    }
    notifyListeners();
  }

  void delete() {
    if (currentInput.isNotEmpty) {
      currentInput = currentInput.substring(0, currentInput.length - 1);
      notifyListeners();
    }
  }

  void clear() {
    currentInput = '';
    previousInput = '';
    notifyListeners();
  }

  void calculate() {
    if (currentInput.isNotEmpty) {
      try {
        String expressionString = currentInput
            .replaceAll('×', '*')
            .replaceAll('÷', '/')
            .replaceAll('%', '/100')
            .replaceAll(' ', '');
        final expression = Expression.parse(expressionString);
        final evaluator = ExpressionEvaluator();
        final result = evaluator.eval(expression, {});
        previousInput = currentInput;
        currentInput = result.toString();
      } catch (e) {
        currentInput = 'Error';
      }
      notifyListeners();
    }
  }
}

class ProviderCalculator extends StatelessWidget {
  const ProviderCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Calculator'),
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
                  buildButtonRow(context, ['C', '%', '⌫', '÷'], [Colors.grey[300]!, Colors.grey[300]!, Colors.grey[300]!, Colors.orange]),
                  buildButtonRow(context, ['7', '8', '9', '×'], [Colors.blue.shade50, Colors.blue.shade50, Colors.blue.shade50, Colors.orange]),
                  buildButtonRow(context, ['4', '5', '6', '-'], [Colors.blue.shade50, Colors.blue.shade50, Colors.blue.shade50, Colors.orange]),
                  buildButtonRow(context, ['1', '2', '3', '+'], [Colors.blue.shade50, Colors.blue.shade50, Colors.blue.shade50, Colors.orange]),
                  buildButtonRow(context, ['.', '0', '00', '='], [Colors.blue.shade50, Colors.blue.shade50, Colors.blue.shade50, Colors.blue]),
                ],
              ),
            ),

            
            Expanded(
              child:Padding(padding: const EdgeInsets.all(16.0),
              child: Consumer<CalculatorProvider>(
                builder: (context, calculator, child) {
                  return Container(
                
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20.0),),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          calculator.currentInput,
                          style: const TextStyle(
                            fontSize: 36,
                            color:Colors.black,
                            
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          calculator.previousInput,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtonRow(BuildContext context, List<String> labels, List<Color> colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: labels.asMap().entries.map((entry) {
        int index = entry.key;
        String label = entry.value;
        return buildButton(
          context,
          label,
          colors[index],
          () {
            if (label == 'C') {
              context.read<CalculatorProvider>().clear();
            } else if (label == '⌫') {
              context.read<CalculatorProvider>().delete();
            } else if (label == '=') {
              context.read<CalculatorProvider>().calculate();
            } else {
              context.read<CalculatorProvider>().input(label);
            }
          },
        );
      }).toList(),
    );
  }

  Widget buildButton(BuildContext context, String label, Color color, VoidCallback onTap) {
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