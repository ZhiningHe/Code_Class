pro SLCoffon
  tlb = widget_base(xsize = 800,ysize = 400, tlb_frame_attr = 1, title = 'SLC-offon') ;创建基础容器

  base1 = widget_base(tlb,xsize = 300,ysize = 350, xoffset = 25,yoffset = 25,frame = 1)  ;创建base1
  draw = widget_draw(base1,xsize = 280,ysize = 340,xoffset = 10,yoffset = 5)

  base2 = widget_base(tlb,xsize = 425,ysize = 300,xoffset = 350,yoffset = 25,frame = 1)  ;创建base2

  labeIn1 = widget_label(base2,value = 'Input Complete Image File',xoffset =10,yoffset = 10)  ;添加文字
  textIn1 = widget_text(base2,xsize = 35,ysize = 1,xoffset = 10, yoffset = 35,uname = 'textIn1')  ;添加文本框
  btnOpen1 = widget_button(base2, value = 'Open', xsize = 70, ysize = 25, xoffset = 350, yoffset = 35,uname = 'buttonIn1') ;创建Open按钮

  labeIn2 = widget_label(base2,value = 'Input Bad Image  File',xoffset =10,yoffset = 90)  ;添加文字
  textIn2 = widget_text(base2,xsize = 35,ysize = 1,xoffset = 10, yoffset = 110,uname = 'textIn2')  ;添加文本框
  btnOpen2 = widget_button(base2, value = 'Open', xsize = 70, ysize = 25, xoffset = 350, yoffset = 110,uname = 'buttonIn2') ;创建Open按钮

  labeIn3 = widget_label(base2,value = 'Input Mask Image  File',xoffset =10,yoffset = 155)  ;添加文字
  textIn3 = widget_text(base2,xsize = 35,ysize = 1,xoffset = 10, yoffset = 180,uname = 'textIn3')  ;添加文本框
  btnOpen3 = widget_button(base2, value = 'Open', xsize = 70, ysize = 25, xoffset = 350, yoffset = 180,uname = 'buttonIn3') ;创建Open按钮

  labeIn4 = widget_label(base2,value = 'Open Output File',xoffset =10,yoffset = 225)  ;添加文字
  textIn4 = widget_text(base2,xsize = 35,ysize = 1,xoffset = 10, yoffset = 250,uname = 'textout')  ;添加文本框
  btnOutput = widget_button(base2, value = 'Choose', xsize = 70, ysize = 25, xoffset = 350, yoffset = 250,uname = 'buttonOut') ;创建Next按钮

  ok = widget_button(tlb,value = 'OK',xsize = 100,ysize = 30,xoffset = 450,yoffset = 350,uname = 'buttonOK') ;创建ok按钮
  cancel = widget_button(tlb, value = 'Cancel',xsize = 100,ysize = 30, xoffset = 650, yoffset = 350) ;创建取消按钮

  widget_control, tlb, /realize  ;显示容器
  widget_control, draw, get_value = win  ;获取图像控件的窗口ID
  widget_control, tlb, set_uvalue = win  ;保存图像控件的窗口ID
  xmanager, 'SLCoffon', tlb, /no_block ;在定义tlb的函数中添加事件获取语句
end

pro SLCoffon_event,ev ;ev是点击鼠标的操作
  textIn1 = widget_info(ev.top,find_by_uname = 'textIn1');获取文本框ID，通过uname查找
  textIn2 = widget_info(ev.top,find_by_uname = 'textIn2')
  textIn3 = widget_info(ev.top,find_by_uname = 'textIn3') ;Mask
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
         data[*,*,i]=ENVI_GET_DaTa(FID=fid,DIMS=dims,POS=i)
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
        data[*,*,i]=ENVI_GET_DaTa(FID=fid,DIMS=dims,POS=i)
      endfor
      image=data[*, *, [2, 1, 0]]
      image= congrid(image,280,340,3)
      widget_control,ev.top,get_uvalue=win
      wset,win
      tvscl,image,true=3,/order
    end
    'buttonIn3':begin
      forward_function envi_get_data
      fileIn = dialog_pickfile(/read);打开文本对话框
      widget_control,textIn3,set_value = fileIn;修改文本框内容
      ENVI,/restore_base_save_files
      ENVI_Batch_Init;初始化ENVI二次开发模式
      widget_control,textIn3,get_value = fileIn;获取文本对话框
      ENVI_OPEN_FILE,fileIn,R_FID=fid;打开ENVI支持文件格式
      ENVI_FILE_QUERY,fid,dims=dims,nb=nb,ns=ns,nl=nl,wl=wl;查找数据文件信息
      data=fltarr(ns,nl,nb)
      print,nb;输出波段数
      for i=0,nb-1 do begin
        data[*,*,i]=ENVI_GET_DaTa(FID=fid,DIMS=dims,POS=i)       
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
      widget_control,textin1,get_value=file1
      widget_control,textIn2,get_value=file2
      widget_control,textIn3,get_value=file3
      widget_control,textout,get_value=fileout
      forward_function envi_get_data
      ENVI, /restore_base_save_file
      ENVI_Batch_Init
      ENVI_OPEN_FILE,file1,R_FID=fid1  ;打开影像完好的影像
      ENVI_FILE_QUERY,fid1,dims=dims1,nb=nb1,ns=ns1,nl=nl1,wl=wl1
      data1=FLTaRR(ns1,nl1,nb1)
      FOR i=0,nb1-1 DO BEGIN
        data1[*,*,i]=ENVI_GET_DaTa(FID=fid1,DIMS=dims1,POS=i)
      ENDFOR
      
      ENVI_OPEN_FILE,file2,R_FID=fid2 ;打开缺失影像
      ENVI_FILE_QUERY,fid2,dims=dims2,nb=nb2,ns=ns2,nl=nl2,wl=wl2
      data2=flTaRR(ns2,nl2,nb2)
      FOR i=0,nb2-1 DO BEGIN
        data2[*,*,i]=ENVI_GET_DaTa(FID=fid2,DIMS=dims2,POS=i)
      ENDFOR
      
      ENVI_OPEN_FILE,file3,R_FID=fid3 ;打开影像Mask
      ENVI_FILE_QUERY,fid3,dims=dims3,nb=nb3,ns=ns3,nl=nl3,wl=wl3
      data3=flTaRR(ns3,nl3,nb3)
      FOR i=0,nb3-1 DO BEGIN
       data3[*,*,i]=ENVI_GET_DaTa(FID=fid3,DIMS=dims3,POS=i)
      ENDFOR
      
      mask=~(~data3)
      if nb2 le 2 then begin
        var=size(data2,/Dimensions)
        if size(var,/n_Dimensions) le 2 then begin
          variance1=make_array(3,value=1) & variance1[0:1]=var & var=variance1
        endif
        data1=congrid(data1,var[0],var[1],var[2])
      endif else begin
        var=size(data2,/Dimensions)
        data1=congrid(data1,ns1,nl1,nb1)
      endelse
      res=intarr(ns1,nl1,nb1) ;用于存放新数组
      
      ;开始遍历
      for i=0,nb1-1 do begin    ;维数
        for j=20,ns1-21 do begin
          for k=20,nl1-21 do begin
            if mask[j,k] eq 1 then begin
              res[j,k,i]=data2[j,k,i]
            endif else begin
              ;先计算出窗口内有多少个好像元--------------------------
              index=0
              for m=j-20,j+20 do begin
                for n=k-20,k+20 do begin
                  if mask[m,n] then index=index+1
                endfor
              endfor
              ;再将好像元的值载入新数组并计算均值，方差之类的杂七杂八的东西----------------
              var2=intarr(index)
              var1=intarr(index)
              index2=0
              for m=j-20,j+20 do begin
                for n=k-20,k+20 do begin
                  if mask[m,n] eq 1 then begin
                    var2[index2]=data2[m,n,i]
                    var1[index2]=data1[m,n,i]
                    index2=index2+1
                  endif
                endfor
              endfor              
              mean1=mean(var1)
              variance1=Variance(var1)
              mean2=mean(var2)
              variance2=Variance(var2)
              ;计算新像元值分界线------------------
              res[j,k,i]=(variance2/variance1)*(data1[j,k,i]-mean1)+mean2 ;矩匹配法
            endelse
          endfor
        endfor
      endfor
      
        envi_write_envi_file,res,dime=dims1,wl=wl1,out_name=fileout  ;保存影像
        widget_control,ev.top,get_uvalue=win
        temp=dialog_message('successful!',/info)
    end
  endcase
end

