## A. Authentication

- gem "devise"
  - Setup Gemfile and run bundle install
  - Run "_rails generate devise:install"_ to setup devise
  - With exist User model, run "_rails generate migration AddDeviseFieldsToUsers"_

## B. Product related table define

```mermaid
erDiagram
  CATEGORIES {
    bigint id PK
    string name
    string slug UK
    text description
    string status
  }

  BRANDS {
    bigint id PK
    string name UK
    string slug UK
    text description
    string logo
    string status
  }

  CATEGORY_ATTRIBUTES {
    bigint id PK
    bigint category_id FK
    string name
    string label
    string data_type
    string unit
    boolean is_required
    boolean is_filterable
  }

  PRODUCTS {
    bigint id PK
    bigint category_id FK
    bigint brand_id FK
    string name
    string slug UK
    string sku UK
    string product_type
    text description
    decimal price
    decimal compare_at_price
    decimal cost_price
    string stock_status
    string status
  }

  PRODUCT_SPECIFICATIONS {
    bigint id PK
    bigint product_id FK
    bigint category_attribute_id FK
    string value_string
    decimal value_number
    boolean value_boolean
  }

  CATEGORIES ||--o{ CATEGORY_ATTRIBUTES : defines
  CATEGORIES ||--o{ PRODUCTS : categorizes
  BRANDS ||--o{ PRODUCTS : manufactures
  PRODUCTS ||--o{ PRODUCT_SPECIFICATIONS : has
  CATEGORY_ATTRIBUTES ||--o{ PRODUCT_SPECIFICATIONS : defines
```

Each product belongs to one category and one brand. Categories define attributes, and product specifications associate a product with a category attribute. The `(category_id, name)` pair on `category_attributes` and `(product_id, category_attribute_id)` pair on `product_specifications` are unique.

## C. Authorization

setup gem file + bundle install

bundle exec rails g pundit:install
