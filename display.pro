pro display
  file='D:\can_tmr.img'
  
  openr,lun,file,/get_lun;读取影像
  data = bytarr(640,400,6)
  readu,lun,data
  free_lun,lun
  
  oWin = obj_new('idlgrWindow',dimension = [640,400])
  oView = obj_new('idlgrView',Viewplane_rest = [0,0,640,400])
  oModel = obj_new('idlgrModel')
  ;bsq;(640,400,6)
  ;bil;(640,6,400)
  ;bip;(6,640,400)
  
  ;转换格式(维数转换)
  data = transpose(data,[2,0,1]);bsq->bip
  
  oimage = obj_new('idlgrImage',data = data[[3,2,1],*,*])
  oModel->add,oImage
  oView->add,oModel
  oWin->add,oView
  help,data
end