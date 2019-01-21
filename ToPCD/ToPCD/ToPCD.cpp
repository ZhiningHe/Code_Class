#include "pre.h"
typedef pcl::PointXYZRGBA PointT;
typedef pcl::PointCloud<PointT> PointCloud;

int ToPCLdata(char* dep, char* color)
//int main(int argc, char** argv)
{
	// ����ڲ�
	const double camera_factor = 700;
	const double camera_cx = 256;
	const double camera_cy = 212;
	const double camera_fx = 363.0;
	const double camera_fy = 363;

	cv::Mat rgb, depth;
	//��ȡͼ��
	//rgb = cv::imread(color);	// rgb ͼ����8UC3�Ĳ�ɫͼ��
	//depth = cv::imread(dep, -1);	// depth ��16UC1�ĵ�ͨ��ͼ��
	rgb = cv::imread(color);	// rgb ͼ����8UC3�Ĳ�ɫͼ��
	depth = cv::imread(dep, -1);	// depth ��16UC1�ĵ�ͨ��ͼ��

	// ʹ������ָ�룬����һ���յ��ơ�����ָ��������Զ��ͷš�
	PointCloud::Ptr cloud(new PointCloud);
	// �������ͼ
	for (int m = 0; m < depth.rows; m++)
		for (int n = 0; n < depth.cols; n++)
		{
			// ��ȡ���ͼ��(m,n)����ֵ
			ushort d = depth.ptr<ushort>(m)[n];
			// d ����û��ֵ������ˣ������˵�
			if (d == 0) continue;

			// d ����ֵ�������������һ����
			PointT p;
			// ���������Ŀռ�����
			p.z = double(d) / camera_factor;
			p.x = (n - camera_cx) * p.z / camera_fx;
			p.y = (m - camera_cy) * p.z / camera_fy;

			// ��rgbͼ���л�ȡ������ɫ
			// rgb����ͨ����BGR��ʽͼ�����԰������˳���ȡ��ɫ
			p.b = rgb.ptr<uchar>(m)[n * 3];
			p.g = rgb.ptr<uchar>(m)[n * 3 + 1];
			p.r = rgb.ptr<uchar>(m)[n * 3 + 2];

			// ��p���뵽������
			cloud->points.push_back(p);
		}
	// ���õ���
	cloud->height = 1;
	cloud->width = cloud->points.size();
	cout << "point cloud size = " << cloud->points.size() << endl;
	cloud->is_dense = false;
	//�������
	pcl::io::savePCDFile("result_pcd.pcd", *cloud);
	// ������ݲ��˳�
	cloud->points.clear();
	cout << "Point cloud saved." << endl;
	//��ʾ��������
	pcl::visualization::CloudViewer viewer("Cloud Viewer");
	viewer.showCloud(cloud);
	while (!viewer.wasStopped())
	{
	}
	return 0;
}

int main() {
	char dep[] = "a.jpg";
	char color[] = "after_denoising.jpg";
	ToPCLdata(dep, color);
	system("pause");
	return 0;
}