pro Atmospheric
  tlb = widget_base( xsize = 800,ysize = 400, tlb_frame_attr = 1,title = 'Quick Atmospheric Correction ' )
  btnRun = widget_button( tlb, value = 'Run', xsize = 80, ysize = 25, xoffset = 650,yoffset = 350,uname='btrun'  )
  base1 = widget_base( tlb, xsize = 300,ysize = 350,xoffset = 25,yoffset = 25,frame = 1  )
  base2 = widget_base( tlb, xsize = 425,  ysize = 300,xoffset = 350,yoffset = 25,  frame = 1  )
  draw = widget_draw(  base1,  xsize = 280,   ysize = 340,  xoffset = 10, yoffset = 5 )
  labelIn1 = widget_label( base2,  value = 'Open Radiometric Correcton',  xoffset = 10, yoffset = 10 )
  textIn1 = widget_text(  base2, xsize = 30,  ysize = 1,  xoffset = 10,yoffset = 30,   uname='textIn1')
  btnOpen = widget_button( base2,  value = 'Open', xsize = 70,  ysize = 25, xoffset = 350,  yoffset = 25 , uname='btopen')
  labelIn2 = widget_label(  base2, value = 'Choose Output File', xoffset = 10,yoffset = 90)
  textIn2 = widget_text( base2,  xsize = 30, ysize = 1,xoffset = 10,  yoffset = 110, uname='textIn2'  )
  btnChoose = widget_button( base2,  value = 'Choose', xsize = 70, ysize = 25,   xoffset = 350,   yoffset = 105 , uname='btchoose')
  widget_control, tlb, /realize  ;显示容器
  widget_control, draw, get_value = win  ;获取图像控件的窗口ID  获取值保存在win
  widget_control, tlb, set_uvalue = win  ;保存图像控件的窗口ID 传递参数
  xmanager, 'testWidget', tlb, /no_block
end
pro testWidget_event,ev
  textIn = widget_info(ev.top, find_by_uname = 'textIn1')
  textSave = widget_info(ev.top, find_by_uname = 'textIn2')
  uname = widget_info(ev.id, /uname)  ;获取触发事件的控件的uname
  case uname of
    'btopen' : begin
      forward_function envi_get_data
      fileIn = dialog_pickfile(/read);打开文本对话框
      widget_control,textIn,set_value = fileIn;修改文本框内容
      ENVI,/restore_base_save_files
      ENVI_Batch_Init;初始化ENVI二次开发模式
      widget_control,textIn,get_value = fileIn;获取文本对话框
      ENVI_OPEN_FILE,fileIn,R_FID=fid;打开ENVI支持文件格式
      ENVI_FILE_QUERY,fid,dims=dims,nb=nb,ns=ns,nl=nl,wl=wl;查找数据文件信息
      data=fltarr(ns,nl,nb)
      for i=0,nb-1 do begin
        temp=ENVI_GET_DATA(FID=fid,DIMS=dims,POS=i)
        data[*,*,i]=temp
      endfor
      image=data[*, *, [4, 3, 2]]
      image= congrid(image,280,340,3)
      widget_control,ev.top,get_uvalue=win
      wset,win
      tvscl,  image,true=3, /order
    end
    'btchoose' : begin
      fileOut = dialog_pickfile(/write)  ;保存文件对话框
      widget_control, textSave, set_value = fileOut  ;修改文本框内容
    end
    'btrun' : begin  ;如果点击Run按钮，则执行以下操作
      forward_function envi_get_data
      widget_control,textIn,get_value = fileIn;获取文本对话框
      widget_control,textSave,get_value = fileChoose;获取文本对话框
      ENVI,/restore_base_save_files
      ENVI_Batch_Init;初始化ENVI二次开发模式
      ENVI_OPEN_FILE,fileIn,R_FID=fid;打开ENVI支持文件格式
      ENVI_FILE_QUERY,fid,dims=dims,ns=ns,nl=nl,nb=nb,wl=wl;查找数据文件信息
      pos=indgen(nb)
      out_name=fileChoose;获取输出名称
      envi_doit,'ENVI_QUAC_DOIT',fid=fid,pos=pos,dims=dims,OUT_NAME=out_name,R_FID=r_fid ;大气校正
      ;调用ENVI大气校正函数0
      ENVI_WRITE_ENVI_FILE,OUT_NAME=fileChoose,wl=wl ;以获取的输出名称，来输出大气校正结果
      tmp = dialog_message('successful!',/info) ;显示成功提示框
    end
  endcase
end
