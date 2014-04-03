'use strict';

angular.module('coolCultureApp')
	.filter('museumBoroughFilter', function (){
		return function(museumList, filterBoroughs) {
			if (filterBoroughs.length > 0) {
				var filteredMuseums = [];

				angular.forEach(museumList, function(museum) {
					if (filterBoroughs.indexOf(museum.borough) !== -1) {
						filteredMuseums.push(museum);
					}
				}, filteredMuseums);

				return filteredMuseums;
			} else {
				return museumList;
			}
		};
	});