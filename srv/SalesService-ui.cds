using SalesService as service from './SalesService';

annotate service.SalesAnalysis with {
    ID      @ID: 'ID';
    salesyear @title: 'Year';
    salesmonth @title: 'Month';
    productName @title : 'Product';
    productCategory @title: 'Category';
    revenue @title : 'Revenue';
    regionName @title: 'Region';
    price @title : 'Price';
    isSoldOutsideProductionRegion @title: 'Products sold outside product region';
    formattedDate @title : 'Quartal'

};


annotate service.SalesAnalysis with @(
    Aggregation.ApplySupported : {
        Rollup: #None,
        PropertyRestrictions:true,
        GroupableProperties: [
            salesyear,
            salesmonth,
            productName,
            productCategory,
            revenue,
            regionName,
            price,
            isSoldOutsideProductionRegion,
            createdAt,
            formattedDate,
            productionRegion,
            quantity
        ],

        AggregatableProperties:[
            {
                Property: revenue,
            },
            {
                Property: salesyear,
            },
            {
                Property: ID,
            },
            {
                Property:quantity,
            },
           
           
        ]
    }
);


 annotate service.SalesAnalysis with @(
    Analytics.AggregatedProperties : [
        {
            Name                 : 'totalRevenue',
            AggregationMethod    : 'sum',
            AggregatableProperty : 'revenue',
            ![@Common.Label]     : 'Total Revenue'
        },
    
       
    ],
);

//Analytical Table

annotate service.SalesAnalysis with @(
     Common.SemanticKey  : [ID],
    UI.LineItem : {
        $value : [
            {
                $Type               : 'UI.DataField',
                Value               : productName,
                ![@UI.Importance]   : #High,
            },
             {
                $Type               : 'UI.DataField',
                Value               : productCategory,
                ![@UI.Importance]   : #High,
            },
            {
                $Type               : 'UI.DataField',
                Value               : revenue,
                ![@UI.Importance]   : #High,
            },
            {
                $Type               : 'UI.DataField',
                Value               : regionName,
                Label               : 'Sales Location',
                ![@UI.Importance]   : #High,
            },
            {
                $Type               : 'UI.DataField',
                Value               : productionRegion,
                Label               : 'Production Location',
                ![@UI.Importance]   : #High,
            },
          
        ],
    }
);


// Main Bar Diagram

annotate service.SalesAnalysis with @(
    UI.Chart : {
        Title : 'Revenue',
        ChartType : #Column,
        Measures :  [totalRevenue],
        Dimensions : [productName],
        MeasureAttributes   : [{
                $Type   : 'UI.ChartMeasureAttributeType',
                Measure : totalRevenue,
                Role    : #Axis1
        }],
        DimensionAttributes : [
            {
                $Type     : 'UI.ChartDimensionAttributeType',
                Dimension : salesyear,
                Role      : #Category
            },
            
        ],
    },
);


//Visual Filter
// Filter for top products
annotate SalesService.SalesAnalysis with @(
    UI.PresentationVariant #pvTopProducts : {
        SortOrder : [
            {
                $Type : 'Common.SortOrderType',
                Property : totalRevenue,
                Descending : true
            },
        ],
        Visualizations : [
            '@UI.Chart#chartTopProducts'
        ]
    },
    UI.SelectionVariant #svTopProducts : {
        SelectOptions : [
            {
                $Type : 'UI.SelectOptionType',
                PropertyName : totalRevenue,
                Ranges : [
                    {
                        $Type : 'UI.SelectionRangeType',
                        Sign : #I,
                        Option : #GE,
                        Low : 0,
                    },
                ],
            },
        ],
    },
    UI.Chart #chartTopProducts : {
        $Type : 'UI.ChartDefinitionType',
        ChartType : #Bar,
        Dimensions : [
            productName
        ],
        DimensionAttributes : [
            {
                $Type : 'UI.ChartDimensionAttributeType',
                Dimension : productName,
                Role : #Category
            }
        ],
        Measures : [
            totalRevenue
        ],
        MeasureAttributes : [
            {
                $Type : 'UI.ChartMeasureAttributeType',
                Measure : totalRevenue,
                Role : #Axis1,
                DataPoint : '@UI.DataPoint#dpTopProducts',
            }
        ]
    },
    UI.DataPoint #dpTopProducts : {
        Value       : revenue,
        Title       : 'Total Revenue'
    },
) {
    productName @(
        Common.ValueList #vlTopProducts: {
            Label : 'Product Name',
            CollectionPath : 'SalesAnalysis',
            SearchSupported : true,
            PresentationVariantQualifier : 'pvTopProducts',
            SelectionVariantQualifier : 'svTopProducts',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : productName,
                    ValueListProperty : 'productName'
                },
            ]
        }
    );
};

// Second visual filter for top regions
annotate SalesService.SalesAnalysis with @(
    UI.Chart #chartTopRegions : {
        $Type : 'UI.ChartDefinitionType',
        ChartType : #Bar,
        Title : 'Top Regions',
        Dimensions : [
            regionName,
        ],
        DimensionAttributes : [
            {
                $Type : 'UI.ChartDimensionAttributeType',
                Dimension : regionName,
                Role : #Category,
            },
        ],
        Measures : [
            totalRevenue,
        ],
        MeasureAttributes : [
            {
                $Type : 'UI.ChartMeasureAttributeType',
                Measure : totalRevenue,
                Role : #Axis1,
                DataPoint : '@UI.DataPoint#dpTopRegions',
            },
        ],
    },
    UI.PresentationVariant #pvTopRegions : {
        SortOrder : [
            {
                $Type : 'Common.SortOrderType',
                Property : totalRevenue,
                Descending : true
            },
        ],
        Visualizations : [
            '@UI.Chart#chartTopRegions'
        ]
    },
    UI.SelectionVariant #svTopRegions : {
        SelectOptions : [
            {
                $Type : 'UI.SelectOptionType',
                PropertyName : totalRevenue,
                Ranges : [
                    {
                        $Type : 'UI.SelectionRangeType',
                        Sign : #I,
                        Option : #GE,
                        Low : 0,
                    },
                ],
            },
        ],
    },
    UI.DataPoint #dpTopRegions : {
        Value       : revenue,
        Title       : 'Total Revenue'
    },
) {
    regionName @(
        Common.ValueList #vlTopRegions: {
            Label : 'Region Name',
            CollectionPath : 'SalesAnalysis',
            SearchSupported : true,
            PresentationVariantQualifier : 'pvTopRegions',
            SelectionVariantQualifier : 'svTopRegions',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : regionName,
                    ValueListProperty : 'regionName'
                },
            ]
        }
    );
};

//revenue trend filter
annotate SalesService.SalesAnalysis with @(
    UI.PresentationVariant #pvRevenueTrend : {
        Text : 'RevenueTrendPV',
        SortOrder : [
            {
                $Type : 'Common.SortOrderType',
                Property : formattedDate,
                Descending : false,
            },
        ],
        Visualizations : [
            '@UI.Chart#chartRevenueTrend',
        ],
    },
    UI.Chart #chartRevenueTrend : {
        $Type : 'UI.ChartDefinitionType',
        ChartType : #Line,
        Title : 'Revenue Trend',
        Dimensions : [
            formattedDate,
        ],
        DimensionAttributes : [
            {
                $Type : 'UI.ChartDimensionAttributeType',
                Dimension : formattedDate,
                Role : #Category,
            },
        ],
        Measures : [
            totalRevenue,
        ],
        MeasureAttributes : [
            {
                $Type : 'UI.ChartMeasureAttributeType',
                Measure : revenue,
                Role : #Axis1,
             DataPoint:' @UI.DataPoint#dpRevenueTrend'
            },
        ],
    },
    UI.DataPoint #dpRevenueTrend : {
        Value       : formattedDate,
        Title       : 'Creation Date'
    },
) {
    formattedDate @(
        Common.ValueList #vlRevenueTrend: {
            Label : 'Creation Date',
            CollectionPath : 'SalesAnalysis',
            SearchSupported : true,
            PresentationVariantQualifier : 'pvRevenueTrend',
            Parameters : [
                   {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : formattedDate,
                    ValueListProperty : 'formattedDate'
                }
            ]
        }
    );
};


