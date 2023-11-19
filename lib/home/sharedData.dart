
String getStatusForRoute(int id,List<Map> my_requests) {
  for (var request in my_requests) {
    if (request.keys.first == id) {
      return request[id];
    }
  }
  return 'not requested'; // Default status if not found
}

class sharedData {
  List<Map> availble_routes = [
    {'driver':'Ahmed','from':'asu','to':'Nasr city','price':'50','car':'GTR','availble_seats':4,'time':'12:00','date':'1/12/2022','id':1},
    {'driver':'Hassan','from':'asu','to':'rehab','price':'80','car':'Skoda','availble_seats':1,'time':'2:00','date':'12/02/2022','id':4},
    {'driver':'Ahmed','from':'asu','to':'Maadi','price':'100','car':'toyota','availble_seats':2,'time':'1:00','date':'12/04/2022','id':3},
  ];
  List<Map> my_requests = [
    {1:'pending'},
    {4:'accepted'},
    {3:'rejected'},
  ];
  List<Map> my_finished_requests = [
    {1:'finished'},
    {4:'finished'},
    {3:'finished'},
  ];
}