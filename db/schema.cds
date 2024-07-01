using {managed} from '@sap/cds/common';

namespace sales;

entity Products : managed {
    key ID : Integer;
    namepro  : String(100);
    category : String(100);
    price : Decimal(10,2);
    region : Association to Regions;
    sales : Association to many Sales on sales.product = $self;
}

entity Regions : managed {
    key ID : Integer;
    name : String(100);
    code : String(3);
    products : Association to many Products on products.region = $self;
    sales : Association to many Sales on sales.region = $self;
}

entity Sales : managed {
    key ID : Integer;
    product : Association to Products;
    customer : Association to Customers;
    region : Association to Regions; 
    quantity : Decimal(15, 2);
    salesDate : DateTime;
}

entity Customers : managed {
    key ID : Integer;
    namecust : String(100);
    email : String(100);
    phone : String(30);
    sales : Association to many Sales on sales.customer = $self;
}
