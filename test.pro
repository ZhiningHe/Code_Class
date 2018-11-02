

pro test
 
 arr = make_array(300,300,value=0)
 arr[0:99,0:99]=150
 arr[0:99,100:199]=75
 arr[100:199,0:99]=175
 arr[100:199,100:199]=100
 arr[100:199,200:299]=25
 arr[200:299,0:99]=200
 arr[200:299,100:199]=125
 arr[200:299,200:299]=50
 
 idx1 = where(arr eq 150)
 idx2 = where(arr eq 75)
 idx3 = where(arr eq 0)
 idx4 = where(arr eq 175)
 idx5 = where(arr eq 100)
 idx6 = where(arr eq 25)
 idx7 = where(arr eq 200)
 idx8 = where(arr eq 125)
 idx9 = where(arr eq 50)
 
 arr[idx1] = 150;
 arr[idx2] = 75;
 arr[idx3] = 0;
 arr[idx4] = 175;
 arr[idx5] = 100;
 arr[idx6] = 25;
 arr[idx7] = 200;
 arr[idx8] = 125;
 arr[idx9] = 50;
 arr1 = rot(arr,135)
 expand,arr1,150,450,arr2 ;缩放
 
;tv,arr
;tv,arr1
;tv,arr2
 
idx0 = where(arr eq 125,complement = res)
arr2[idx0] = 0
arr2[res] = 255

tv,arr2
 
 end
 