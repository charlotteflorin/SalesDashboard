sap.ui.define(
  [
    "sap/fe/test/ListReport",
    "sap/ui/test/Opa5",
    "sap/ui/test/matchers/AggregationFilled",
  ],
  function (ListReport, Opa5, AggregationFilled) {
    "use strict";

    var sViewName = "SalesAnalysisList";
    var sTableId =
      "dashboard::SalesAnalysisList--fe::table::SalesAnalysis::LineItem";

    var CustomPageDefinitions = {
      actions: {},
      assertions: {
        iShouldSeeTheTableWithEntries: function () {
          return this.waitFor({
            id: sTableId,
            viewName: sViewName,
            matchers: new AggregationFilled({
              name: "items",
            }),
            success: function () {
              Opa5.assert.ok(
                true,
                "The table has the expected number of items"
              );
            },
            errorMessage:
              "The table does not have the expected number of items",
          });
        },

        iShouldSeeVisualFilter: function () {
          return this.waitFor({
            controlType: "sap.m.Title",
            properties: {
              visible: true,
              text: "Total Revenue by Quartal",
            },
            success: function () {
              Opa5.assert.ok(
                true,
                "The custom visual filter is visible and enabled"
              );
            },
            errorMessage:
              "The custom visual filter could not be found or is not enabled!",
          });
        },
      },
    };

    return new ListReport(
      {
        appId: "dashboard",
        componentId: "SalesAnalysisList",
        contextPath: "/SalesAnalysis",
      },
      CustomPageDefinitions
    );
  }
);
