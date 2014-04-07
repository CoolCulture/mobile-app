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
	    			$modalInstance.close();
	    		};
	    		$scope.addCategory = function(category) {
	    			var indexOfCategory = $scope.museumFilters.categories.indexOf(category);
			    	if (indexOfCategory === -1){
			    		$scope.museumFilters.categories.push(category);
			    	}	else {
			    		$scope.museumFilters.categories.splice(indexOfCategory, 1);
			    	}
			    };
			    $scope.addBorough = function(borough) {
	    			var indexOfBorough = $scope.museumFilters.boroughs.indexOf(borough);
			    	if (indexOfBorough === -1){
			    		$scope.museumFilters.boroughs.push(borough);
			    	}	else {
			    		$scope.museumFilters.boroughs.splice(indexOfBorough, 1);
			    	}
			    };
			    $scope.addAdmissionType = function(admissionType) {
			    	var indexOfAdmissionType = $scope.museumFilters.admissionType.indexOf(admissionType);
			    	if (indexOfAdmissionType === -1){
			    		$scope.museumFilters.admissionType.push(admissionType);
			    	}	else {
			    		$scope.museumFilters.admissionType.splice(indexOfAdmissionType, 1);
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
