import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'ProductList.dart';

void main() {
  runApp(const MainApp());
}

final productAnimDuration = 1.seconds;

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with TickerProviderStateMixin {
  late final controller = AnimationController(vsync: this);
  late final cartController = AnimationController(vsync: this);
  late final manager = AddToCartAnimationManager(controller);

  @override
  void dispose() {
    controller.dispose();
    manager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.indigo.shade200,
        floatingActionButton: CartButton(
          key: manager.cartKey,
        )
            .animate(
              controller: cartController,
              autoPlay: false,
              onComplete: (controller) {
                controller.reset();
              },
            )
            .moveY(
              begin: 0,
              end: -20,
              delay: 200.ms,
              duration: 500.ms,
            )
            .shake(),
        body: Stack(
          children: [
            ProductList(
              manager: manager,
            ),
            ListenableBuilder(
              listenable: manager.productSize,
              builder: (context, _) {
                return SizedBox(
                  width: manager.productSize.value.width,
                  height: manager.productSize.value.height,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Colors.indigo.shade400,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 7),
                            blurRadius: 29,
                          )
                        ]),
                  )
                      .animate(
                        autoPlay: false,
                        controller: controller,
                      )
                      .scale(
                        duration: productAnimDuration * 0.8,
                        begin: Offset(1, 1),
                        end: Offset.zero,
                        alignment: Alignment.bottomRight,
                        delay: productAnimDuration * 0.2,
                      ),
                )
                    .animate(
                        autoPlay: false,
                        controller: controller,
                        onComplete: (controller) {
                          controller.reset();
                          manager.reset();
                          cartController.forward();
                        })
                    .followPath(
                      duration: productAnimDuration,
                      path: manager.path,
                      curve: Curves.easeInOutCubic,
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AddToCartAnimationManager {
  AddToCartAnimationManager(this.controller);
  final AnimationController controller;
  final productKeys = List.generate(23, (index) => GlobalKey());
  final cartKey = GlobalKey();
  var productSize = ValueNotifier(Size(0, 0));
  var productPosition = Offset.zero;
  var path = Path();

  void dispose() {
    productSize.dispose();
  }

  void reset() {
    productSize.value = Size.zero;
    productPosition = Offset.zero;
    path = Path();
  }

  void runAnimation(int index) {
    final productContext = productKeys[index].currentContext!;
    // get position of cart button
    final cartPosition =
        (cartKey.currentContext!.findRenderObject() as RenderBox)
            .localToGlobal(Offset.zero);
    final cartBottomRight =
        cartKey.currentContext!.size!.bottomRight(cartPosition);
    // get position of product image
    productPosition = (productContext.findRenderObject() as RenderBox)
        .localToGlobal(Offset.zero);
    // get size of product image
    productSize.value = productContext.size!;
    // create path object
    path = Path()
      ..moveTo(productPosition.dx, productPosition.dy)
      ..lineTo(200, 200)
      ..relativeLineTo(-20, -20)
      ..lineTo(
        cartBottomRight.dx - productSize.value.width - 5,
        cartBottomRight.dy - productSize.value.height - 5,
      );
    // Trigger animation
    controller.forward();
  }
}
