# This project has a page which will search through a list of products based on the product title, description, tags, price and the origin of country.

Following are the features of this project:
* Full text search is available to search the products.
* Products can be filtered by country of origin.
* Products can be filtered by price “less than, equal to or greater than.”.
* **Sort by Relevance** is also available. Title matches will have a boost of 2x (i.e. Products with the keyword in the title will appear higher in the results when sorting by relevance.)
* Sort the products by newest i.e. most recent on top is available as a feature.
* Sort the products by highest price is available.
* Sort the products by lowest price is available.

# This project is developed in Ruby on Rails framework with the following tech set:
* Ruby 2.6.3
* Rails 5.1.7
* Postgres as a database.
* **SOLR** is used for full text search and it is used to boost the products by **2x**.
* Rspec is used as a testing framework. **Model** and **Controller** test cases are written.
* **Project is deployed to AWS EC2 instance on the [URL](http://3.135.1.228:3000/).**

**Working demo of the project: https://drive.google.com/file/d/18qakFiMtgrBst_CXojoPfwcH4wZr8p_F/view**

![Alt Text](https://res.cloudinary.com/dao3qkzzg/image/upload/v1580047162/produt_search_demo_akklhs.gif)
