using { sales as db } from '../db/schema';


service SalesService {
   entity Products as projection on db.Products;
        annotate Products with @odata.draft.enabled ;
        
   entity Regions as projection on db.Regions;
   annotate Regions with @odata.draft.enabled ;
    entity Sales as projection on db.Sales;
    annotate Sales with @odata.draft.enabled ;
    entity Customers as projection on db.Customers;
    annotate Customers with @odata.draft.enabled ;
   

   @readonly 
   entity SalesAnalysis 
   @(restrict:[
    {
        grant: ['READ'],
        to: ['SalesManager']
    }
   ])
   as select from db.Sales{

        *,
        cast (substring(createdAt,1,10) as Date) as createdAt,
        case
           when substring(salesDate, 6, 2) in ('01', '02', '03') then cast(concat(substring(salesDate, 1, 4), '-03-01') as Date) 
            when substring(salesDate, 6, 2) in ('04', '05', '06') then cast(concat(substring(salesDate, 1, 4), '-06-01') as Date) 
            when substring(salesDate, 6, 2) in ('07', '08', '09') then cast(concat(substring(salesDate, 1, 4), '-09-01') as Date) 
            when substring(salesDate, 6, 2) in ('10', '11', '12') then cast(concat(substring(salesDate, 1, 4), '-12-01') as Date)
        end as formattedDate: Date,
        substring(salesDate,1,4) as salesyear:String,
        substring(salesDate,6,2) as salesmonth:String,
        product.namepro as productName,
        product.category as productCategory,
        customer.namecust as customerName,
        product.price as price,
        product.price*quantity as revenue : Decimal(15,2),
        region.name as regionName:String,
        product.region.name as productionRegion:String,
        case
            when product.region.name <> region.name then 'abroad'
            else 'inland'
        end as isSoldOutsideProductionRegion: String,
        
   } where (
    (year(CURRENT_DATE) - year(salesDate)) * 12 +
    (month(CURRENT_DATE) - month(salesDate))
) <= 12;
}    
    
// Fix ambiguity in Sales.products association ensuring it points to Sales
extend SalesService.Sales with @cds.redirection.target;


