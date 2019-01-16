pro SLCoffoff
  tlb = widget_base(xsize = 800,ysize = 400, tlb_frame_attr = 1, title = 'SLC-offoff') ;创建基础容器

  base1 = widget_base(tlb,xsize = 300,ysize = 350, xoffset = 25,yoffset = 25,frame = 1)  ;创建base1
  draw = widget_draw(base1,xsize = 280,ysize = 340,xoffset = 10,yoffset = 5)

  base2 = widget_base(tlb,xsize = 425,ysize = 300,xoffset = 350,yoffset = 25,frame = 1)  ;创建base2

  labeIn1 = widget_label(base2,value = 'Input Restored Image File',xoffset =10,yoffset = 10)  ;添加文字
  textIn1 = widget_text(base2,xsize = 35,ysize = 1,xoffset = 10, yoffset = 35,uname = 'textIn1')  ;添加文本框
  btnOpen1 = widget_button(base2, value = 'Open', xsize = 70, ysize = 25, xoffset = 350, yoffset = 35,uname = 'buttonIn1') ;创建Open按钮

  labeIn2 = widget_label(base2,value = 'Input Image Restoration File',xoffset =10,yoffset = 120)  ;添加文字
  textIn2 = widget_text(base2,xsize = 35,ysize = 1,xoffset = 10, yoffset = 145,uname = 'textIn2')  ;添加文本框
  btnOpen2 = widget_button(base2, value = 'Open', xsize = 70, ysize = 25, xoffset = 350, yoffset = 145,uname = 'buttonIn2') ;创建Open按钮

  labeIn3 = widget_label(base2,value = 'Open Output File',xoffset =10,yoffset = 230)  ;添加文字
  textIn3 = widget_text(base2,xsize = 35,ysize = 1,xoffset = 10, yoffset = 255,uname = 'textout')  ;添加文本框
  btnOutput = widget_button(base2, value = 'Choose', xsize = 70, ysize = 25, xoffset = 350, yoffset = 255,uname = 'buttonOut') ;创建Next按钮


  ok = widget_button(tlb,value = 'OK',xsize = 100,ysize = 30,xoffset = 450,yoffset = 350,uname = 'buttonOK') ;创建ok按钮
  cancel = widget_button(tlb, value = 'Cancel',xsize = 100,ysize = 30, xoffset = 650, yoffset = 350) ;创建取消按钮

  widget_control, tlb, /realize  ;显示容器
  widget_control, draw, get_value = win  ;获取图像控件的窗口ID
  widget_control, tlb, set_uvalue = win  ;保存图像控件的窗口ID
  xmanager, 'SLCoffoff', tlb, /no_block ;在定义tlb的函数中添加事件获取语句
end

pro SLCoffoff_event,ev ;ev是点击鼠标的操作
  textIn1 = widget_info(ev.top,find_by_uname = 'textIn1');获取文本框ID，通过uname查找
  textIn2 = widget_info(ev.top,find_by_uname = 'textIn2')
  textout = widget_info(ev.top, find_by_uname = 'textout')
  uname = widget_info(ev.id,/uname);获取触发事件的控件的uname

  case uname of
    'buttonIn1':begin
      forward_function envi_get_data
      fileIn = dialog_pickfile(/read);打开文本对话框
      widget_control,textIn1,set_value = fileIn;修改文本框内容
      ENVI,/restore_base_save_files
      ENVI_Batch_Init;初始化ENVI二次开发模式
      widget_control,textIn1,get_value = fileIn;获取文本对话框
      ENVI_OPEN_FILE,fileIn,R_FID=fid;打开ENVI支持文件格式
      ENVI_FILE_QUERY,fid,dims=dims,nb=nb,ns=ns,nl=nl,wl=wl;查找数据文件信息
      data=fltarr(ns,nl,nb)
      print,nb;输出波段数
      for i=0,nb-1 do begin
        temp=ENVI_GET_DATA(FID=fid,DIMS=dims,POS=i)
        data[*,*,i]=temp
      endfor   
        image=data[*, *, [2, 1, 0]]
        image= congrid(image,280,340,3)
        widget_control,ev.top,get_uvalue=win
        wset,win
        tvscl,image,true=3,/order
  end

  'buttonIn2':begin
      forward_function envi_get_data
      fileIn = dialog_pickfile(/read);打开文本对话框
      widget_control,textIn2,set_value = fileIn;修改文本框内容
      ENVI,/restore_base_save_files
      ENVI_Batch_Init;初始化ENVI二次开发模式
      widget_control,textIn2,get_value = fileIn;获取文本对话框
      ENVI_OPEN_FILE,fileIn,R_FID=fid;打开ENVI支持文件格式
      ENVI_FILE_QUERY,fid,dims=dims,nb=nb,ns=ns,nl=nl,wl=wl;查找数据文件信息
      data=fltarr(ns,nl,nb)
      print,nb;输出波段数
      for i=0,nb-1 do begin
        temp=ENVI_GET_DATA(FID=fid,DIMS=dims,POS=i)
        data[*,*,i]=temp
      endfor   
        image=data[*, *, [2, 1, 0]]
        image= congrid(image,280,340,3)
        widget_control,ev.top,get_uvalue=win
        wset,win
        tvscl,image,true=3,/order
end

  'buttonOut':begin
    fileOut = dialog_pickfile(/write)  ;保存文件对话框
    widget_control, textout, set_value = fileOut  ;修改文本框内容，路径
    end

   'buttonOK' : begin  ;如果点击OK按钮，则执行以下操作
     widget_control,textin1,get_value=file
     widget_control,textIn2,get_value=file1
     widget_control,textout,get_value=fileout
     forward_function envi_get_data
     ENVI,  /restore_base_save_file 
     ENVI_Batch_Init
     
     ENVI_OPEN_FILE,file,R_FID=fid  ;打开影像1
     ENVI_FILE_QUERY,fid,dims=dims,nb=nb,ns=ns,nl=nl,wl=wl
     data1=FLTARR(ns,nl,nb)
     FOR i=0,nb-1 DO BEGIN
       temp1=ENVI_GET_DATA(FID=fid,DIMS=dims,POS=i)
       data1[*,*,i]=temp1
     ENDFOR
     ENVI_OPEN_FILE,file1,R_FID=fid ;打开影像2
     ENVI_FILE_QUERY,fid,dims=dims,nb=nb,ns=ns,nl=nl,wl=wl
     data2=flTARR(ns,nl,nb)
     FOR i=0,nb-1 DO BEGIN
       temp2=ENVI_GET_DATA(FID=fid,DIMS=dims,POS=i)
       data2[*,*,i]=temp2
     ENDFOR
     
     sized=SIZE(data1,/N_DIMENSIONS )
     IF  sized EQ 2 then begin
       temp=data1
     ENDIF ELSE BEGIN
       temp=reform(data1[*,*,0],ns,nl)
     ENDELSE
     
     mask=~(~temp)
     para_n=140
     para_win=17
     para_winmax=31
     tol=0.01
     gain=1
     bias=0
     x1=SIZE(mask,/dimensions)
     x2=SIZE(data1,/dimensions)
     x3=SIZE(data2,/dimensions)
     ;剔除高饱和度的数据 排除条带区域
     imask=REFORM(mask, x1[0]*x1[1])
     ind1=WHERE(imask NE 0)
     mup=MEAN(data1[ind1])
     muf=MEAN(data2[ind1])
     thetap=VARIANCE(data1[ind1])
     thetaf=VARIANCE(data2[ind1])
     gain=thetap/thetaf
     if gain>3||gain<1/3 then gain=1
     bias=mup-muf*gain
     ;y=gain*x+b
     filled_img=(1-mask)*(gain*data2+bias)+data1
     
     ENVI,/restore_base_save_file
     
     ENVI_Batch_Init
     widget_control,textIn1,get_value=file1
     ENVI_OPEN_FILE,file1,R_FID=fid
     ENVI_FILE_QUERY,fid,dims=dims,nb=nb,ns=ns,nl=nl,wl=wl
     pos=indgen(nb)
     pri_image=uintarr(ns,nl,nb)
     FOR i=0,nb-1 DO BEGIN
       temp1=ENVI_GET_DATA(FID=fid,DIMS=dims,POS=i)
       pri_image[*,*,i]=temp1
     ENDFOR
     widget_control,textIn2,get_value=file2
     ENVI_OPEN_FILE,file2,R_FID=fid
     ENVI_FILE_QUERY,fid,dims=dims,nb=nb,ns=ns,nl=nl,wl=wl
     pos=INDGEN(nb)
     fill_image=UINTARR(ns,nl,nb)
     FOR i=0,nb-1 DO BEGIN
       temp2=ENVI_GET_DATA(FID=fid,DIMS=dims,POS=i)
       fill_image[*,*,i]=temp2
     ENDFOR
     
     sized=SIZE(pri_image,/N_DIMENSIONS )
     IF  sized EQ 2 then begin
       temp=pri_image
     ENDIF ELSE BEGIN
       temp=reform(pri_image[*,*,0],ns,nl)
     ENDELSE
     
     mask=~(~temp)
     para_n=140
     para_win=17
     para_winmax=31
     minw=floor(para_win/2)
     maxw=floor(para_winmax/2)
     padpri_img =  REPLICATE(0,ns+maxw*2,nl+maxw*2)
     padpri_img[15,15]=pri_image
     padfill_imag =  REPLICATE(0,ns+maxw*2,nl+maxw*2)
     padfill_imag[15,15]=fill_image
     padmask_imag =    REPLICATE(0,ns+maxw*2,nl+maxw*2)
     padmask_imag[15,15]=mask
     result=size(padpri_img, /dimensions)
     w=minw
     ;迭代
     for i=maxw,(result[0]-maxw-1) do begin
       for j=maxw,(result[1]-maxw-1) do begin
         w=minw
         if padmask_imag[i,j] ge 0 then begin
           ;取出局部窗口区域数据
           imask=padmask_imag[i-w:i+w,j-w:j+w]
           nzeros=where(imask ne 0);判断掩模板文件
           while ~(size(nzeros,/n_elements) gt para_n)&&w lt maxw do begin;判断窗口内的非0像元数满足要求否？
             w=w+1
             imask=padmask_imag[i-w:i+w,j-w:j+w]
             nzeros=where(imask ne 0)
           endwhile
           ;也暂不考虑适合的适合的像元总数最后仍然不满足要求的情况
           ;若不满足则用全局增益与偏置？
           limg=padpri_img[i-w:i+w,j-w:j+w]
           lfill=padfill_imag[i-w:i+w,j-w:j+w]
           ;暂不考虑高饱和度像元去除，可以通过提取出来后的图像中剔除
           gain=VARIANCE(limg[nzeros])/ VARIANCE(lfill[nzeros])
           if gain gt 3 or gain lt 1/3 then gain=1
           bias=mean(limg[nzeros])-gain*mean(lfill[nzeros])
           pri_image[i-maxw,j-maxw]=fill_image[i-maxw,j-maxw]*gain+bias
         endif
       endfor
     endfor

     
     envi_write_envi_file,pri_image,out_name=fileout,wl=wl  ;保存
     tmp=dialog_message('successful!',/info)
     widget_control,ev.top,get_uvalue=d
     wset,d
     TVSCL, pri_image
   end
   endcase
end
