pro test
file = 'D:\file.txt'
if file_test(file) then begin         ;存在就读取
  read_file,file    ;以字符串方式输出
endif else begin                       ;不存在就创建
  openw,lun,file,/get_lun ;以读写方式打开文件
  printf, lun, indgen(5, 4) ;写入内容 
  free_lun, lun ;关闭文件 
endelse
end

pro read_file,file 
str ='' 
openr, lun, file, /get_lun ;打开文件 ;未到文件末尾则读取文件内容 
while(~eof(lun)) do begin ;以字符串方式读取一行
readf, lun, str 
print, str 
endwhile 
free_lun,lun ;关闭文件 
end
