'use strict';

angular.module('coolCultureApp')
	.filter('museumAdmissionFilter', function (){
		return function(museumList, filterAdmissions) {
			if (filterAdmissions.length > 0) {
				var filteredMuseums = [];

				angular.forEach(museumList, function(museum) {
					if ((filterAdmissions.indexOf('Free') !== -1 && museum.freeAdmission) || 
							(filterAdmissions.indexOf('Suggested Donation') !== -1 && museum.suggestedDonation)) {
						filteredMuseums.push(museum);
					}
				}, filteredMuseums);

				return filteredMuseums;
			} else {
				return museumList;
			}
		};
	});