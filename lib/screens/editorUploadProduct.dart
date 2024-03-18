import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:ecommerce_flutter_admin/constans/app_constans.dart';
import 'package:ecommerce_flutter_admin/constans/validator.dart';
import 'package:ecommerce_flutter_admin/models/product_model.dart';
import 'package:ecommerce_flutter_admin/services/assets_manager.dart';
import 'package:ecommerce_flutter_admin/services/myapp_functions.dart';
import 'package:ecommerce_flutter_admin/widget/loader_manager.dart';
import 'package:ecommerce_flutter_admin/widget/subtitle_text.dart';
import 'package:ecommerce_flutter_admin/widget/title_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class EditorUploadProductScreen extends StatefulWidget {
  static const routName = "/EditorUploadProductScreen";

  const EditorUploadProductScreen({super.key, this.productModel});
  final ProductModel? productModel;

  @override
  State<EditorUploadProductScreen> createState() => _EditorUploadProductScreenState();
}

class _EditorUploadProductScreenState extends State<EditorUploadProductScreen> {
  final _formKey = GlobalKey<FormState>();
  XFile? _pickedImage;
  late TextEditingController  _titleController, _priceController, _descriptionController,
  _quanttiyContoller;
  String? _categoryValue;
  bool isEditing = false;
  String? productNetworkImage;
  String? productImageUrl;
  bool _isLoading =false;

  @override
  void initState() {
    if (widget.productModel != null) {
      isEditing = true;
      productNetworkImage = widget.productModel!.productImage;
      _categoryValue = widget.productModel!.productCategory;
    }

    _titleController =
        TextEditingController(text: widget.productModel?.productTitle);
    _priceController =
        TextEditingController(text: widget.productModel?.productPrice);
    _descriptionController =
        TextEditingController(text: widget.productModel?.productDescription);
    _quanttiyContoller =
        TextEditingController(text: widget.productModel?.productQuantity);

    super.initState();
  }

    @override
    void dispose(){
      _titleController.dispose();
      _priceController.dispose();
      _descriptionController.dispose();
      _quanttiyContoller.dispose();

      super.dispose();
    }
    void removePickedImage(){
      setState(() {
        _pickedImage= null;
        productNetworkImage =null;
      });
    }

    void clearForm(){
      _titleController.clear();
      _priceController.clear();
      _descriptionController.clear();
      _quanttiyContoller.clear();
      removePickedImage();
    }

    Future<void> _addProduct() async{
      if(_pickedImage == null){
        MyAppFunctions.showErrorOrWaningDialog(
            context: context, subtitle: "Plaese add image", fct: (){},

        );
        return;
      }
      final isValid  = _formKey.currentState!.validate();
      FocusScope.of(context).unfocus();
      if(isValid){

        try{
          setState(() {
            _isLoading =true;
          });

          final ref = FirebaseStorage.instance.ref()
              .child("productImages")
              .child("${_titleController.text}.jpg");
          await ref.putFile(File(_pickedImage!.path));
          productImageUrl = await ref.getDownloadURL();

          final productId=Uuid().v4();
          await FirebaseFirestore.instance.collection("products").doc(productId).set({
            'productId': productId,
            'productTitle': _titleController.text,
            'productPrice': _priceController.text,
            'productCategory': _categoryValue,
            'productDescription': _descriptionController.text,
            'productImage': productImageUrl,
            'productQuantity': _quanttiyContoller.text,
            'createdAt': Timestamp.now(),

          });
          Fluttertoast.showToast(msg: "Product has beed added Success", textColor: Colors.red);
          if(!mounted) return;
          MyAppFunctions.showErrorOrWaningDialog(
              context: context,
              subtitle: "Clear Form ? ",
              fct: (){
                clearForm();
              });


        } on FirebaseException catch (error){
          await MyAppFunctions.showErrorOrWaningDialog(
              context: context,
              subtitle: error.message.toString(),
              fct: (){}
          );
        } catch (error) {
          await MyAppFunctions.showErrorOrWaningDialog(
              context: context,
              subtitle: error.toString(),
              fct: (){}
          );
        }
        finally {
          setState(() {
            _isLoading=false;
          });
        }
    }

    }

    Future<void> _editProduct() async{

      final isValid  = _formKey.currentState!.validate();
      FocusScope.of(context).unfocus();

      if(_pickedImage == null){
        MyAppFunctions.showErrorOrWaningDialog(
          context: context, subtitle: "Plaese add image", fct: (){},

        );
        return;
      }

      if(isValid){}


    }


    Future<void> localImagePicker() async {
      final ImagePicker picker = ImagePicker();
      await MyAppFunctions.ImagePickerDialog(
        context: context,
        cameraFCT: () async {
          _pickedImage = await picker.pickImage(source: ImageSource.camera);
          setState(() {});
        },
        galleryFCT: () async {
          _pickedImage = await picker.pickImage(source: ImageSource.gallery);
          setState(() {});
        },
        removeFCT: () {
          setState(() {
            _pickedImage = null;
          });
        },
      );
    }




  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return  GestureDetector(
           onTap: (){
              FocusScope.of(context).unfocus();
          },
      child: Scaffold(
        bottomSheet: SizedBox(
          height: kBottomNavigationBarHeight +10,
          child: Material(
            color:Theme.of(context).scaffoldBackgroundColor,
            child: (
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(

                    onPressed: (){},
                    icon: const Icon(Icons.clear),
                    label: const Text("Clear"),

                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(14),
                    backgroundColor: Colors.amber
                  ),

                ),
                ElevatedButton.icon(

                  onPressed: (){
                    if(isEditing){
                      _editProduct();

                    }
                    else{
                      _addProduct();
                    }
                  },
                  icon: const Icon(Icons.clear),
                  label:  Text(isEditing ? "Save Product" : "Add Product" ),

                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(14),
                  ),

                ),
              ],
            )
            ),
          ),
        ),

        appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              onPressed: (){
                if(Navigator.canPop(context)){
                  Navigator.pop(context);
                }
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 20,
              ),
            ),
            title:  TitleTextWidget(label: isEditing ? "Edit Product" : "New Product")
        ),

        body: LoadingManager(isLoading: _isLoading, child:  SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),



                if(isEditing && productNetworkImage !=null)...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      productNetworkImage!,
                      height: size.width* 0.7,
                      alignment: Alignment.center,

                    ),
                  )
          ]
                else if(_pickedImage ==null) ...[
                  SizedBox(
                    width: size.width *0.4 +10,
                    height:size.width *0.4,
                    child: DottedBorder(
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.image,
                              size: 80,
                              color: Colors.amber,
                            ),
                            TextButton(onPressed: (){
                              localImagePicker();
                            }, child: const Text("Select image") )
                          ],
                        ),
                      ),
                    ),
                  )
                ]
                else...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(
                        _pickedImage!.path
                      ),
                      height: size.width* 0.5,
                      alignment: Alignment.center,
                    ),
                  )

                  ],
                if(_pickedImage !=null || productNetworkImage !=null)...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(onPressed: ()
                          {
                            localImagePicker();
                          },
                          child: const Text("Select image")),
                      TextButton(onPressed: ()
                      {
                        removePickedImage();
                      },
                          child: const Text("Remove Image", style: TextStyle(color:Colors.red),)),



                    ],
                  )


                ],

                /////////////
/////////////   Dropdown
                /////////////

                DropdownButton(
                    items: AppConstans.categoriesDropDownList,
                    value: _categoryValue,
                    hint: const Text("Choese a category"),
                    onChanged: (String? value){
                      setState(() {
                        _categoryValue=value;
                      });
                    }

                ),


                const SizedBox(
                  height: 20,
                ),

                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        child:Form(
                              key:_formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _titleController,
                                    key: const ValueKey('Title'),
                                    maxLength: 80,
                                    minLines: 1,
                                    maxLines: 2,
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.newline,
                                    decoration: const InputDecoration(
                                      hintText: "Product title",
                                    ),
                                    validator: (value){
                                      return MyValidators.uploadProdText(
                                        value: value,
                                        toBeReturnedString: "Plaese Enter a valid title"
                                      );
                                    },

                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                          flex:1,
                                           child:  TextFormField(
                                            controller: _priceController,
                                            key: const ValueKey('Price \$'),

                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              hintText: "Price",
                                              prefix:  SubTitleTextWidget(label: "\$  ",
                                                color: Colors.blue,
                                                fontSize: 15,
                                              )
                                            ),
                                            validator: (value){
                                              return MyValidators.uploadProdText(
                                                  value: value,
                                                  toBeReturnedString: "Plaese Enter a missing"
                                              );
                                            },

                                          ),




                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        flex:1,
                                        child:  TextFormField(
                                          controller: _quanttiyContoller,
                                          key: const ValueKey('Quantity'),

                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.newline,
                                          decoration: const InputDecoration(
                                              hintText: "Quantity",
                                              prefix:  SubTitleTextWidget(label: "QTY : ",
                                                color: Colors.blue,
                                                fontSize: 15,
                                              )
                                          ),
                                          validator: (value){
                                            return MyValidators.uploadProdText(
                                                value: value,
                                                toBeReturnedString: "Quantity is missed"
                                            );
                                          },

                                        ),




                                      ),

                                    ],
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),

                                  TextFormField(
                                    controller: _descriptionController,
                                    key: const ValueKey('Description'),
                                    minLines: 5,
                                    maxLines: 8,
                                    maxLength: 1000,
                                    keyboardType: TextInputType.multiline,
                                    decoration: const InputDecoration(
                                      hintText: "Product title",
                                    ),
                                    validator: (value){
                                      return MyValidators.uploadProdText(
                                          value: value,
                                          toBeReturnedString: "Desciprion is problem"
                                      );
                                    },

                                  ),

                                  const SizedBox(
                                    height: kBottomNavigationBarHeight+10
                                  ),

                                ],

                              ),




                )




                )





              ],
            ),
          ),
        ),


      ),
      ),



    );

  }
}
