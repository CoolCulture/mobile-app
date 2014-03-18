'use strict';

angular.module('coolCultureApp')
  .controller('MuseumListCtrl', function($scope, $modal, MuseumService) {
    $scope.museums = MuseumService.requestAllMuseums();
    $scope.museumFilters = {
    	category: "",
    	borough: "",
    	subwayLine: ""
    };

    $scope.resetFilters = function() {
		$scope.museumFilters.category = "";
		$scope.museumFilters.borough = "";
    };

    $scope.openFilterModal = function() {
    	var modalInstance = $modal.open({
    		templateUrl: 'filters.html',
	    	controller: ['$scope', '$modalInstance', 'museumFilters', function ($scope, $modalInstance, museumFilters) {
	    		$scope.museumFilters = museumFilters;
	    		$scope.ok = function () {
	    			$modalInstance.close();
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
