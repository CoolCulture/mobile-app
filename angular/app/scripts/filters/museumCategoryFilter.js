'use strict';

angular.module('coolCultureApp')
	.filter('museumCategoryFilter', function (){
		return function(museumList, filterCategories) {
			if (filterCategories.length > 0) {
				var filteredMuseums = [];

				angular.forEach(museumList, function(museum) {
					var inCategories = false;

					angular.forEach(museum.categories, function(category) {
						if (filterCategories.indexOf(category) !== -1) {
							inCategories = true;
							return;
						}
					}, inCategories)

					if (inCategories === true) {
						filteredMuseums.push(museum);
					}
				}, filteredMuseums)

				return filteredMuseums;
			} else {
				return museumList;
			}
		};
	});