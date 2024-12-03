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
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: null,
        toolbarHeight: screenHeight * 0.15,
        //flexibleSpace: Padding(
          //padding: EdgeInsets.all( screenWidth * 0.03),
          //child: Align(
            //alignment: Alignment.topLeft,
            //child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTLS83XErb0zP7lBJnTQv9C2onf30pSb7PFgfO7G-0HRYv4THiKre-UvZ2k_0t0dUFDrAo&usqp=CAU',
            //height: screenHeight * 0.04,
            //fit:BoxFit.cover,
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
                      buildButtonRow(context, ['C', '%', '⌫', '÷'], [Colors.grey[100]!, Colors.grey[100]!, Colors.grey[100]!, Colors.orange[600]!]),
                      buildButtonRow(context, ['7', '8', '9', '×'], [Colors.deepPurple.shade50, Colors.deepPurple.shade50, Colors.deepPurple.shade50, Colors.orange[600]!]),
                      buildButtonRow(context, ['4', '5', '6', '-'], [Colors.deepPurple.shade50, Colors.deepPurple.shade50, Colors.deepPurple.shade50, Colors.orange[600]!]),
                      buildButtonRow(context, ['1', '2', '3', '+'], [Colors.deepPurple.shade50, Colors.deepPurple.shade50, Colors.deepPurple.shade50, Colors.orange[600]!]),
                      buildButtonRow(context, ['.', '0', '00', '='], [Colors.deepPurple.shade50, Colors.deepPurple.shade50, Colors.deepPurple.shade50, Colors.deepPurpleAccent[700]!]),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Consumer<CalculatorProvider>(
                    builder: (context, calculator, child) {
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
                              calculator.currentInput,
                              style: TextStyle(
                                fontSize: screenHeight * 0.05,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              calculator.previousInput,
                              style: TextStyle(
                                fontSize: screenHeight * 0.025,
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
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

  Widget buildButtonRow(BuildContext context, List<String> labels, List<Color> colors) {
    final screenWidth = MediaQuery.of(context).size.width;

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
          screenWidth, // Pass screenWidth to buildButton
        );
      }).toList(),
    );
  }

  Widget buildButton(BuildContext context, String label, Color color, VoidCallback onTap, double screenWidth) {
    final buttonPadding = screenWidth * 0.05;

    return Padding(
      padding: EdgeInsets.all(buttonPadding * 0.2),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: const CircleBorder(),
          padding: EdgeInsets.all(buttonPadding),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: screenWidth * 0.07,
            fontWeight: FontWeight.bold,
            color: (label == '=' || label == '+' || label == '-' || label == '×' || label == '÷') ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CalculatorProvider(),
      child: const MaterialApp(
        home: ProviderCalculator(),
      ),
    ),
  );
}

