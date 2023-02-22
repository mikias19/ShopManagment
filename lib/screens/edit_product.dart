import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';
import '../provider/product.dart';

class EditProduct extends StatefulWidget {
  static const routeName = '/Edit-product';

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final pricefocusnode = FocusNode();
  final descriptonFocusNode = FocusNode();
  final imageController = TextEditingController();
  final imageUrlFocus = FocusNode();
  final form = GlobalKey<FormState>();
  var existingProduct =
      Product(id: '', title: '', price: 0, imageUrl: '', description: "");
  var initValues = {
    "title": "",
    "price": '',
    "description": '',
  };
  bool isInit = true;

  bool isLoading = false;
  @override
  void didChangeDependencies() {
    if (isInit) {
      String? proid = ModalRoute.of(context)?.settings.arguments as String?;
      if (proid != null) {
        existingProduct = Provider.of<Products>(context).findbyid(proid);
        initValues = {
          'title': existingProduct.title,
          "price": existingProduct.price.toString(),
          'description': existingProduct.description,
        };
        imageController.text = existingProduct.imageUrl;
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    imageUrlFocus.addListener(updateUrl);
    super.initState();
  }

  void updateUrl() {
    if (!imageUrlFocus.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    imageUrlFocus.removeListener(() {
      updateUrl;
    });
    pricefocusnode.dispose();
    descriptonFocusNode.dispose();
    imageController.dispose();
    imageUrlFocus.dispose();
    super.dispose();
  }

  void onSave() async {
    final isValid = form.currentState!.validate();
    if (!isValid) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    form.currentState?.save();
    print(existingProduct.id);
    print(existingProduct.title);
    print(existingProduct.description);
    print(existingProduct.price);
    print(existingProduct.id);
    if (existingProduct.id.isNotEmpty) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(existingProduct.id, existingProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .AddProducts(existingProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('error has occured '),
            content: Text(error.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: const Text('Okay'),
              )
            ],
          ),
        );
        // } finally {
        //   Navigator.of(context).pop();
        //   setState(() {
        //     isLoading = false;
        //   });
        // }
      }
    }
    Navigator.of(context).pop();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit product'),
        actions: [
          IconButton(
              onPressed: () {
                onSave();
              },
              icon: const Icon(Icons.save))
        ],
      ),
      // ignore: prefer_const_constructors
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: form,
                child: ListView(children: [
                  TextFormField(
                    initialValue: initValues['title'],
                    decoration: const InputDecoration(labelText: "Title"),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(pricefocusnode);
                    },
                    onSaved: (newValue) {
                      existingProduct = Product(
                          id: existingProduct.id,
                          isFavorite: existingProduct.isFavorite,
                          title: newValue!,
                          price: 0,
                          description: '',
                          imageUrl: '');
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'The value an not be empty!';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: initValues['price'],
                    decoration: const InputDecoration(labelText: "Price"),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: pricefocusnode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(descriptonFocusNode);
                    },
                    onSaved: (newValue) {
                      existingProduct = Product(
                          id: existingProduct.id,
                          isFavorite: existingProduct.isFavorite,
                          title: existingProduct.title,
                          price: double.parse(newValue!),
                          description: '',
                          imageUrl: '');
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the price.';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter valid price.';
                      }
                      if (double.parse(value) <= 0) {
                        return 'Price must grater than zero.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: initValues['description'],
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    focusNode: descriptonFocusNode,
                    onSaved: (newValue) {
                      existingProduct = Product(
                          id: existingProduct.id,
                          isFavorite: existingProduct.isFavorite,
                          title: existingProduct.title,
                          price: existingProduct.price,
                          description: newValue!,
                          imageUrl: '');
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the description.';
                      }
                      if (value.length < 10) {
                        return 'description must atleast 10 character';
                      }

                      return null;
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 110,
                        height: 110,
                        margin: const EdgeInsets.only(top: 8, right: 10),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                        ),
                        child: FittedBox(
                            child: imageController.text.isEmpty
                                ? const Text('Enetr a URL')
                                : Image.network(
                                    imageController.text,
                                    fit: BoxFit.cover,
                                  )),
                      ),
                      Expanded(
                        child: TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Image Url'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: imageController,
                            focusNode: imageUrlFocus,
                            onFieldSubmitted: (_) {
                              onSave();
                            },
                            onSaved: (newValue) {
                              existingProduct = Product(
                                  id: existingProduct.id,
                                  isFavorite: existingProduct.isFavorite,
                                  title: existingProduct.title,
                                  price: existingProduct.price,
                                  description: existingProduct.description,
                                  imageUrl: newValue!);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the Url.';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter valid url.';
                              }
                              // if (!value.endsWith('.png') &&
                              //     !value.endsWith('.jpg') &&
                              //     !value.endsWith('.jpgs')) {
                              //   return 'Price must grater than zero.';
                              // }
                              return null;
                            }),
                      )
                    ],
                  )
                ]),
              ),
            ),
    );
  }
}
