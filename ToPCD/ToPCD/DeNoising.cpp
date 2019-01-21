#include "pre.h"

int Denoising(char* img, char* tosave)
{
	Mat srcImage = imread(img);//����ԭͼ
	if (!srcImage.data)
	{
		cout << "��ȡsrcImage����~��" << endl;
		return -1;
	}
	//����Mat������������˲����ݣ�����clone����ʹ���С��ԭͼ��С��ͬ
	Mat bilateral_Image = srcImage.clone();
	namedWindow(WINDOWS_NAME_DENOISING, 1);
	//˫���˲�����
	bilateralFilter(srcImage, bilateral_Image, 25, 25 * 2, 25 / 2, BORDER_DEFAULT);
	imshow(WINDOWS_NAME_DENOISING, bilateral_Image);
	imshow(WINDOWS_NAME, srcImage);
	//saveImage
	imwrite(tosave, bilateral_Image);
	cvWaitKey(6000);
	system("pause");
	return 0;
}