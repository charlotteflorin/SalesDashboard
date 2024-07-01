sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'dashboard/test/integration/FirstJourney',
		'dashboard/test/integration/pages/SalesAnalysisList',
		'dashboard/test/integration/pages/SalesAnalysisObjectPage'
    ],
    function(JourneyRunner, opaJourney, SalesAnalysisList, SalesAnalysisObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('dashboard') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheSalesAnalysisList: SalesAnalysisList,
					onTheSalesAnalysisObjectPage: SalesAnalysisObjectPage
                }
            },
            opaJourney.run
        );
    }
);