import 'package:ecommerce_flutter_admin/models/categories_model.dart';
import 'package:ecommerce_flutter_admin/services/assets_manager.dart';
import 'package:flutter/material.dart';

class AppConstans {
  static const String imageUrl =
      'https://i.ibb.co/8r1Ny2n/20-Nike-Air-Force-1-07.png';

  static List<String> bannerImages = [
    AssetsManager.slide1,
    AssetsManager.slide2,
    AssetsManager.slide3,
    AssetsManager.slide4,
    AssetsManager.slide5,
    AssetsManager.slide6,
    AssetsManager.slide7,
  ];
  static List<CategoriesModel> categoriesList2 = [
    CategoriesModel(
      id: "Computer",
      name: "Computer",
      image: AssetsManager.computer,
    ),
    CategoriesModel(
      id: "Books",
      name: "Books",
      image: AssetsManager.file,
    ),
    CategoriesModel(
      id: "Flower",
      name: "Flower",
      image: AssetsManager.flower,
    ),
    CategoriesModel(
      id: "Mobile Phone",
      name: "Mobile Phone",
      image: AssetsManager.mobilephone,
    ),
    CategoriesModel(
      id: "Shoes",
      name: "Shoes",
      image: AssetsManager.shoes3,
    ),
    CategoriesModel(
      id: "T-short",
      name: "T-short",
      image: AssetsManager.tshort,
    ),
    CategoriesModel(
      id: "Watch",
      name: "Watch",
      image: AssetsManager.watch,
    ),
  ];

  static List<String> categoriesList = [
    'Cameras',
    'Shoes',
    'books',
    'Audio',
    'Gaming',
    'TVs',
    'Wearables'
  ];

  static List<DropdownMenuItem<String>>? get categoriesDropDownList {
    List<DropdownMenuItem<String>>? menuItem =
        List<DropdownMenuItem<String>>.generate(
            categoriesList.length,
            (index) => DropdownMenuItem(
                  child: Text(categoriesList[index]),
                  value: categoriesList[index],
                ));
                return menuItem;
  }
}
