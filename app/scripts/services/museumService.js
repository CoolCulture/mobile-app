'use strict';

angular.module('coolCultureApp')
  .service('MuseumService', function MuseumService() {
    var museums = [ {id: '1',
                      name: 'American Museum of Natural History',
                      address: '200 Central Park West',
                      phoneNumber: '212-595-9533',
                      hours: '10AM-5:45PM M-S',
                      imageUrl: '/images/sample_museum.jpg',
                      borough: 'Manhattan',
                      subwayLines:
                        ['B', 'C', '1'],
                      category: 'History'},
                      {id: '2',
                      name: 'The Anne Frank Center USA',
                      address: '44 Park Pl.',
                      phoneNumber: '212-431-7993',
                      hours: 'Tue-Sat: 10AM-5PM',
                      imageUrl: '/images/sample_museum.jpg',
                      borough: 'Manhattan',
                      subwayLines: 
                        ['A', 'C', 'E', 'R', '2', '3', '4', '5'],
                      category: 'History'},
                      {id: '3',
                      name: 'Center for Architecture',
                      address: '536 LaGuardia Pl',
                      phoneNumber: '212-683-0023',
                      hours: 'M-F 9AM-8PM, Sat 11AM-5PM',
                      imageUrl: '/images/sample_museum.jpg',
                      borough: 'Manhattan',
                      subwayLines:
                        ['A', 'C', 'E', 'B', 'D', 'F', 'M', '6'],
                      category: 'Art'},
                      {id: '4',
                      name: 'Intrepid Sea, Air, and Space Museum',
                      address: 'Pier 86, W. 46th St',
                      phoneNumber: '212-245-0072',
                      hours: 'M-F 10AM-5PM, Sa-Su 10AM-6PM',
                      imageUrl: '/images/sample_museum.jpg',
                      borough: 'Manhattan',
                      subwayLines:
                        ['A', 'C', 'E', 'N', 'Q', 'R', 'S', '1', '2', '3', '7'],
                      category: 'Science'},
                      {id: '5',
                      name: 'The Metropolitan Museum of Art',
                      address: '1000 Fifth Ave',
                      phoneNumber: '212-535-7710',
                      hours: 'Su-Th 10AM-5:30PM, Fri-Sat 10AM-9PM',
                      imageUrl: '/images/sample_museum.jpg',
                      borough: 'Manhattan',
                      subwayLine: 
                        ['4', '5', '6'],
                      category: 'Art'},
                      {id: '6',
                      name: 'Brooklyn Historical Society',
                      address: '128 Pierrepont St.',
                      phoneNumber: '718-222-4111',
                      hours: 'Wed-Fri 12PM-5PM, Sat 10AM-5PM',
                      imageUrl: '/images/sample_museum.jpg',
                      borough: 'Brooklyn',
                      subwayLines:
                        ['A', 'F', 'R', '2', '3', '4', '5'],
                      category: 'History'},
                      {id: '7',
                      name: 'Lefferts Historic House',
                      address: '452 Flatbush Ave. In Park.',
                      phoneNumber: '718-789-2822',
                      hours: 'May-June: Thu-Sun 12PM-PM, July-August: Thu-Sun: 12PM-6PM, April-November: Check Website',
                      imageUrl: '/images/sample_museum.jpg',
                      borough: 'Brooklyn',
                      subwayLines:
                        ['B', 'Q', 'S'],
                      category: 'History'},
                      {id: '8',
                      name: 'Museum of Contemporary African Disaporan Arts',
                      address: '80 Hanson Pl.',
                      phoneNumber: '718-230-0492',
                      hours: 'Wed, Fri, Sat 12PM-7PM, Thu 12PM-8PM, Sun 12PM-6PM',
                      imageUrl: '/images/sample_museum.jpg',
                      borough: 'Brooklyn',
                      subwayLines:
                        ['C', 'B', 'D', 'Q', 'R', 'G', '2', '3', '4', '5'],
                      category: 'Art'},
                      {id: '9',
                      name: 'New York Transit Museum',
                      address: 'Boreum Pl. at Schermerhorn St',
                      phoneNumber: '718-694-1600',
                      hours: 'Tue-Fri 10AM-4PM, Sat-Sun 11AM-5PM',
                      imageUrl: '/images/sample_museum.jpg',
                      borough: 'Brooklyn',
                      subwayLines:
                        ['A', 'C', 'F', 'R', 'G', '2', '3', '4' , '5'],
                      category: 'History'},
                      {id: '10',
                      name: 'Van Cortlandt House Museum',
                      address: 'Van Cortlandt Park (Broadway & W 246th St)',
                      phoneNumber: '718-543-3344',
                      hours: 'March-October: Tue-Sat 9AM-5:30PM, November-April: Tue-Sun 9AM-5:30PM',
                      imageUrl: '/images/sample_museum.jpg',
                      borough: 'Brooklyn',
                      subwayLines:
                        ['1', 'A'],
                      category: 'History'},
                      {id: '11',
                      name: 'MOMA PS1',
                      address: '22-25 Jackson Ave',
                      phoneNumber: '718-784-2084',
                      hours: 'Thur-Mon 12PM-6PM',
                      imageUrl: '/images/sample_museum.jpg',
                      borough: 'Queens',
                      subwayLines:
                        ['E', 'M', 'G', '7'],
                      category: 'Art'}
                      ];
    return  {
      requestAllMuseums : function() {
            return museums;
          },
      requestMuseum : function(id) {
            var requestedMuseum = {};
            museums.forEach(function(museum) {
                if(museum.id == id) {
                  requestedMuseum = museum;
                }
              });
            return requestedMuseum;
          }
    };
  });
