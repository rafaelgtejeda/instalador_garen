import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:garen/models/categoria_woocommerce_model.dart';
import 'package:garen/models/customer_woocommerce_model.dart';
import 'package:garen/models/products_woocommerce_model.dart';
import 'package:garen/utils/config.dart';
import 'package:http/http.dart' as http;

class WoocommerceService {

  Future<List<ProductModel>> getProducts({
    int pageNumber,
    int pageSize,
    String strSearch,
    String tagName,
    int categoryId,
    String sortBy,
    String sortOrder,
    String attribute,
    int attribute_term
  }) async{

    var client = http.Client();
   
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
      };

       Map<String, String> queryString = {
        'consumer_key': Config.key,
        'consumer_secret': Config.secret,
      };  
      
      if(strSearch != null){
        queryString["search"] = strSearch.toString();
      }

      if(sortBy != null){
        queryString["orderBy"] = sortBy.toString();
      }

      if(sortOrder != null){
        queryString["order"] = sortOrder.toString();
      }

      if(categoryId != null){
        queryString["category"] = categoryId.toString();
      }

      if(attribute != null){
        queryString["attribute"] = attribute.toString();
      }

      if(attribute_term != null){
        queryString["attribute_term"] = attribute_term.toString();
      }
      
      queryString["per_page"] = pageSize.toString();
      queryString["page"] = pageNumber.toString();  

      try{      

      var url = new Uri.https(
        Config.url, 
        Config.prefix + Config.productsUrl,
        queryString
      );

      var response = await client.get(url, headers: requestHeaders);

      if (response.statusCode == 200) {
        return productsFromJson(json.decode(response.body));
      }else {
        return null;
      }

      } finally {
        client.close();
      }
  }

  Future<List<CustomerModel>> getCustomers({
    int pageNumber,
    int pageSize,
    String strSearch,
    String tagName,
    int categoryId,
    String sortBy,
    String sortOrder,
    String attribute,
    int attribute_term
  }) async{

    var client = http.Client();
   
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
      };

       Map<String, String> queryString = {
        'consumer_key': Config.key,
        'consumer_secret': Config.secret,
      };  
      
      if(strSearch != null){
        queryString["search"] = strSearch.toString();
      }

      if(sortBy != null){
        queryString["orderBy"] = sortBy.toString();
      }

      if(sortOrder != null){
        queryString["order"] = sortOrder.toString();
      }

      if(categoryId != null){
        queryString["category"] = categoryId.toString();
      }

      if(attribute != null){
        queryString["attribute"] = attribute.toString();
      }

      if(attribute_term != null){
        queryString["attribute_term"] = attribute_term.toString();
      }
      
      queryString["per_page"] = pageSize.toString();
      queryString["page"] = pageNumber.toString();  

      try{      

      var url = new Uri.https(
        Config.url, 
        Config.prefix + Config.customerUrl,
        queryString
      );


      var response = await client.get(url, headers: requestHeaders);

      if (response.statusCode == 200) {
        return customersFromJson(json.decode(response.body));
      }else {
        return null;
      }

      } finally {
        client.close();
      }
  }

  Future<List<ProductModel>> getCustomer({int pageNumber, int pageSize,String strSearch,String tagName, String categoryId, String sortBy, String sortOrder = "asc", String attribute, int attributeTerm }) async{

    List<ProductModel> data = new List<ProductModel>();

    try {

      String parameter = "";

      if ( strSearch != null ) {
        parameter += "&search=$strSearch";
      }

      if ( pageSize != null ) {
        parameter += "&per_page=$pageSize";
      }
      
      if ( pageNumber != null ) {
        parameter += "&page=$pageNumber";
      }

      if ( tagName != null ) {
        parameter += "&category=$tagName";
      }

      if ( tagName != null ) {
        parameter += "&atribute=$tagName";
      }

      if ( categoryId != null ) {
        parameter += "&category=$categoryId";
      }

      if ( sortBy != null ) {
        parameter += "&orderBy=$sortBy";
      }

      if ( sortOrder != null ) {
        parameter += "&order=$sortOrder";
      }
      
      if ( attribute != null ) {
        parameter += "&attribute=$attribute";
      }

      if ( attributeTerm != null ) {
        parameter += "&attribute_term=$attributeTerm";
      }

             String url = Config.url + 
                          Config.customerUrl + 
         "?consumer_key=${Config.key}" +
      "&consumer_secret=${Config.secret}" +
          "&${parameter.toString()}";

      var response = await Dio()
      
      .get(

        url,

        options: new Options(
          
          headers: {

            HttpHeaders.contentTypeHeader: "application/json",

          },

        ),

      );

      if (response.statusCode == 200) {

        data = (response.data as List).map(

          (i) => ProductModel.fromJson(i)

        )

        .toList();

      }

    } catch (e) {

      print(e.response);

    }

    return data;

  }

}

