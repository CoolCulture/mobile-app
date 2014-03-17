'use strict';

angular.module('coolCultureApp')
  .controller('MuseumListCtrl', function($scope, $modal, MuseumService) {
    $scope.museums = MuseumService.requestAllMuseums();
    $scope.museumFilters = {
    	category: "",
    	borough: "",
    	subwayLine: ""
    };

    $scope.openFilterModal = function() {
    	var modalInstance = $modal.open({
    		templateUrl: 'filters.html',
	    	controller: function ($scope, $modalInstance, museumFilters) {
	    		$scope.museumFilters = museumFilters;
	    		$scope.ok = function () {
	    			$modalInstance.close();
	    		};
	    	},
	    	resolve: {
	    		museumFilters: function () {
	    			return $scope.museumFilters;
	    		}
	    	}
    	});
    };
    
  });
