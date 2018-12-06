pro testClass
  file='D:\can_tmr.img'
  openr,lun,file,/get_lun;读取影像
  data = bytarr(640,400,6)
  readu,lun,data
  free_lun,lun
  ;计算NDVI
  ndvi = 1.0*(data[*,*,3]-data[*,*,2])/(data[*,*,3]+data[*,*,2])
  
  ndvi = ndvi>(-1)
  ndvi = ndvi< 1
  
  ;分类1
  idx1 = where(ndvi lt (0.1))
  ndvi[idx1]=0
  help,idx1
  idx2 = where(ndvi gt 0.1 and ndvi le 0.2)
  ndvi[idx2]=100
  idx3 = where(ndvi gt 0.2)
  ndvi[idx3]=200
  
  ;分类2
  idx1 = (ndvi lt -0.1)*150
  idx2 = (ndvi gt -0.1 and ndvi le 0.1)*200
  idx3 = (ndvi gt 0.1)*250
  ndvi = idx1+idx2+idx3
  
  
  tv,ndvi
end