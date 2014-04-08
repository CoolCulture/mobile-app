'use strict';

angular.module('coolCultureApp')
  .controller('MuseumListCtrl', function($scope, $modal, MuseumService) {

    MuseumService.requestAllMuseums().success(function(data){
        $scope.museums = data;
    });

    $scope.museumFilters = {
    	categories: [],
    	boroughs: [],
    	admissionType: []
        };

    $scope.openFilterModal = function() {
    	$modal.open({
    		templateUrl: 'filters.html',
	    	controller: ['$scope', '$modalInstance', 'museumFilters', function ($scope, $modalInstance, museumFilters) {
	    		$scope.museumFilters = museumFilters;
	    		$scope.ok = function () {
	    			$modalInstance.close();
	    		};
	    		$scope.cancel = function() {
	    			$scope.museumFilters.boroughs = [];
	    			$scope.museumFilters.categories = [];
	    			$scope.museumFilters.admissionType = [];
	    			$modalInstance.close();
	    		};
	    		$scope.addToFilter = function(filterType, filter) {
	    			var indexOfFilter = $scope.museumFilters[filterType].indexOf(filter);
			    	if (indexOfFilter === -1){
			    		$scope.museumFilters[filterType].push(filter);
			    	}	else {
			    		$scope.museumFilters[filterType].splice(indexOfFilter, 1);
			    	}
			    };
	    	}],
	    	resolve: {
	    		museumFilters: function () {
	    			return $scope.museumFilters;
	    		}
	    	}
    	});
    };

  });
