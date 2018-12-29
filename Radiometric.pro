pro Radiometric
  tlb = widget_base(xsize = 800,ysize = 400, tlb_frame_attr = 1, title = 'Radiometric Correcyion') ;创建基础容器
  
  base1 = widget_base(tlb,xsize = 300,ysize = 350, xoffset = 25,yoffset = 25,frame = 1)  ;创建base1
  draw = widget_draw(base1,xsize = 280,ysize = 340,xoffset = 10,yoffset = 5)
 
  base2 = widget_base(tlb,xsize = 425,ysize = 250,xoffset = 350,yoffset = 25,frame = 1)  ;创建base2
  
  labeIn1 = widget_label(base2,value = 'Open Input File',xoffset =10,yoffset = 10)  ;添加文字
  textIn1 = widget_text(base2,xsize = 35,ysize = 1,xoffset = 10, yoffset = 50,uname = 'textIn1')  ;添加文本框
  btnOpen1 = widget_button(base2, value = 'Open', xsize = 70, ysize = 25, xoffset = 350, yoffset = 50,uname = 'buttonIn1') ;创建Open按钮  
  
  labeIn2 = widget_label(base2,value = 'Choose Output File',xoffset =10,yoffset = 110) 
  textIn2 = widget_text(base2,xsize = 35,ysize = 1,xoffset = 10, yoffset = 150,uname = 'textout')  ;添加文本框
  btnOutput = widget_button(base2, value = 'Choose', xsize = 70, ysize = 25, xoffset = 350, yoffset = 150,uname = 'buttonOut') ;创建Next按钮
  

  ok = widget_button(tlb,value = 'OK',xsize = 100,ysize = 30,xoffset = 450,yoffset = 310,uname = 'buttonOK') ;创建ok按钮
  canel = widget_button(tlb, value = 'Cancel',xsize = 100,ysize = 30, xoffset = 650, yoffset = 310,uname = 'buttonCanel') ;创建canel按钮
  
  widget_control, tlb, /realize  ;显示容器
  widget_control, draw, get_value = win  ;获取图像控件的窗口ID
  widget_control, tlb, set_uvalue = win  ;保存图像控件的窗口ID
  xmanager, 'Radiometric', tlb, /no_block ;在定义tlb的函数中添加事件获取语句
end

pro Radiometric_event,ev ;ev是点击鼠标的操作
  textIn1 = widget_info(ev.top,find_by_uname = 'textIn1');获取文本框ID，通过uname查找
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
      print,nb
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
      widget_control,textIn1,get_value=filein
      widget_control,textout,get_value=fileout
      ENVI,/restore_base_save_files
      ENVI_Batch_Init
      ENVI_OPEN_FILE,filein,R_FID=fid
      ENVI_FILE_QUERY,fid,DIMS=dims,nb=nb,ns=ns,nl=nl,wl=wl
      ;lansat5
      M_5 = [0.765827,1.448189,1.043976,0.876024,0.120354,0.055376,0.065551];7
      A_5 = [-2.29,-4.29,-2.21,-2.39,-0.49,1.18,-0.22]
      M_7=[0.778740,0.798819,0.621654,0.969291,0.126220,0.067087,0.037205,0.043898];8
      A_7=[-6.98,-7.20,-5.62,-6.07,-1.13,-0.07,3.16,-0.39]
      
      data=fltarr(ns,nl,nb)
      for  i=0,nb-1 do begin
        img=envi_get_data(FID=fid,DIMS=dims,POS=i)
        data[*,*,i]=img
      endfor
      
      if nb eq 6 then begin
         for i=0,nb-1 do begin
          data[*,*,i]=data[*,*,i]*0.1*M_5[i]+A_5[i]*0.1 ;lansat5
        endfor 
         
     endif else begin        
        for i=0,nb-1 do begin
        data[*,*,i]=data[*,*,i]*0.1*M_7[i]+A_7[i]*0.1 ;lansat7
        endfor         
     endelse
     
      
      result=congrid(data[*,*,[3,2,1]],280,340,3) ;压缩
      widget_control,ev.top,get_uvalue=d
      wset,d
      tvscl,result,true=3,/order
      envi_write_envi_file,data,out_name=fileout,wl=wl  ;保存
      tmp=dialog_message('successful!',/info)
    end
    
    'buttonCancel':begin
      widget_control,ev.top,/destroy
      
    end
  endcase
  
end

