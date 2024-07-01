sap.ui.define(["sap/ui/test/opaQunit"], function (opaTest) {
  "use strict";

  var Journey = {
    run: function () {
      QUnit.module("First journey");

      opaTest("Start application", function (Given, When, Then) {
        Given.iStartMyApp();

        Then.onTheSalesAnalysisList.iSeeThisPage();
      });

      opaTest(
        "Check if visual Filter is visible",
        function (Given, When, Then) {
          Then.onTheSalesAnalysisList.iShouldSeeVisualFilter();
        }
      );

      opaTest(
        "Check if Table loads and has expected number of rows",
        function (Given, When, Then) {
          Then.onTheSalesAnalysisList.onTable().iCheckRows(10);
        }
      );

      opaTest("Navigate to ObjectPage", function (Given, When, Then) {
        // Note: this test will fail if the ListReport page doesn't show any data

        When.onTheSalesAnalysisList.onFilterBar().iExecuteSearch();

        Then.onTheSalesAnalysisList.onTable().iCheckRows();

        When.onTheSalesAnalysisList.onTable().iPressRow(0);
        Then.onTheSalesAnalysisObjectPage.iSeeThisPage();
      });

      opaTest("Teardown", function (Given, When, Then) {
        // Cleanup
        Given.iTearDownMyApp();
      });
    },
  };

  return Journey;
});
