import 'dart:developer';

import 'package:ecommerce_flutter_admin/provider/product_provider.dart';
import 'package:ecommerce_flutter_admin/screens/editorUploadProduct.dart';
import 'package:ecommerce_flutter_admin/widget/subtitle_text.dart';
import 'package:ecommerce_flutter_admin/widget/title_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({
    super.key,
    required this.productId,
  });

  final String productId;
  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final productsProvider = Provider.of<ProductProvider>(context);
    final getCurrProduct = productsProvider.findByProId(widget.productId);

    return getCurrProduct == null
        ? SizedBox.shrink()
        : Padding(
            padding: EdgeInsets.all(0.0),
            child: GestureDetector(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return EditorUploadProductScreen(
                      productModel: getCurrProduct,
                    );
                  },
                  ),
                );
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: FancyShimmerImage(
                      imageUrl: getCurrProduct.productImage,
                      height: size.height * 0.2,
                      width: size.height * 0.2,
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Row(
                      children: [
                        Flexible(
                            flex: 5,
                            child: TitleTextWidget(
                              label: getCurrProduct.productTitle,
                              fontSize: 18,
                            )),
                        Flexible(
                            flex: 2,
                            child: TitleTextWidget(
                              label: getCurrProduct.productTitle,
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 6.0,
                  ),
                  Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            flex: 1,
                            child: SubTitleTextWidget(
                              label: getCurrProduct.productPrice,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            )),
                        Flexible(
                            child: Material(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.lightBlue,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12.0),
                            onTap: () {},
                            splashColor: Colors.grey,
                            child: Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Icon(Icons.check),
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  )
                ],
              ),
            ),
          );
  }
}
