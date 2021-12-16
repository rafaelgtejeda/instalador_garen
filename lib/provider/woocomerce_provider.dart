import 'package:flutter/material.dart';
import 'package:garen/models/customer_woocommerce_model.dart';
import 'package:garen/models/products_woocommerce_model.dart';
import 'package:garen/servicos/woocomerce_servico.dart';

enum LoadMoreStatus {INITIAL, LOADING, STABLE}

class WoocommerceProvider with ChangeNotifier {
  
  WoocommerceService _woocommerceService;

  List<CustomerModel> _customerList;
  List<ProductModel> _productsList;

  int pageSize = 8;

  List<ProductModel> get allProducts => _productsList; 
  List<CustomerModel> get allCustomer => _customerList;

  double get totalRecords => _productsList.length.toDouble();

  LoadMoreStatus _loadMoreStatus = LoadMoreStatus.STABLE;
  getLoadMoreStatus() => _loadMoreStatus;

  WoocommerceProvider() {
    resetStream();
  }

  void resetStream() {    
   _woocommerceService = new WoocommerceService();    
    setLoadingState(LoadMoreStatus.INITIAL);
   _productsList = null;  
   _customerList = null;
  }

  setLoadingState(LoadMoreStatus loadMoreStatus){
    _loadMoreStatus = loadMoreStatus;
  } 

  fetchProducts(
    pageNumber, {      
      String strSearch,
         int categoryId,      
      String sortOrder = "asc",
      String sortBy
    }    
  ) async {

    List<ProductModel> itemModel = await _woocommerceService.getProducts(
      strSearch: strSearch,
      pageNumber: pageNumber,
      pageSize: this.pageSize,
      categoryId: categoryId,
      sortOrder: sortOrder,
      sortBy: sortBy,
    );

    if (_productsList== null){
      _productsList = new List<ProductModel>.empty(growable: true);
    }

    if(itemModel.length > 0){
      _productsList.addAll(itemModel);
    }

    setLoadingState(LoadMoreStatus.STABLE);
    
    notifyListeners();

  } 

  fetchCustomers(
    pageNumber, {      
      String strSearch,
         int categoryId,      
      String sortOrder = "asc",
      String sortBy
    }    
  ) async {

    List<CustomerModel> itemModelCustomers = await _woocommerceService.getCustomers(
      strSearch: strSearch,
      pageNumber: pageNumber,
      pageSize: this.pageSize,
      categoryId: categoryId,
      sortOrder: sortOrder,
      sortBy: sortBy,
    );

    if (_customerList== null){
      _productsList = new List<ProductModel>.empty(growable: true);
    }

    if(itemModelCustomers.length > 0){
      _customerList.addAll(itemModelCustomers);
    }

    setLoadingState(LoadMoreStatus.STABLE);
    
    notifyListeners();

  }
  
}