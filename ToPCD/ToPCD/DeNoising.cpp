#include "pre.h"

int Denoising(char* img, char* tosave)
{
	Mat srcImage = imread(img);//读入原图
	if (!srcImage.data)
	{
		cout << "读取srcImage错误~！" << endl;
		return -1;
	}
	//创建Mat矩阵用来存放滤波数据，利用clone函数使其大小和原图大小相同
	Mat bilateral_Image = srcImage.clone();
	namedWindow(WINDOWS_NAME_DENOISING, 1);
	//双边滤波函数
	bilateralFilter(srcImage, bilateral_Image, 25, 25 * 2, 25 / 2, BORDER_DEFAULT);
	imshow(WINDOWS_NAME_DENOISING, bilateral_Image);
	imshow(WINDOWS_NAME, srcImage);
	//saveImage
	imwrite(tosave, bilateral_Image);
	cvWaitKey(6000);
	system("pause");
	return 0;
}