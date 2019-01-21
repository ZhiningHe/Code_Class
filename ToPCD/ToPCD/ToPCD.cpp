#include "pre.h"
typedef pcl::PointXYZRGBA PointT;
typedef pcl::PointCloud<PointT> PointCloud;

int ToPCLdata(char* dep, char* color)
//int main(int argc, char** argv)
{
	// 相机内参
	const double camera_factor = 700;
	const double camera_cx = 256;
	const double camera_cy = 212;
	const double camera_fx = 363.0;
	const double camera_fy = 363;

	cv::Mat rgb, depth;
	//读取图像
	//rgb = cv::imread(color);	// rgb 图像是8UC3的彩色图像
	//depth = cv::imread(dep, -1);	// depth 是16UC1的单通道图像
	rgb = cv::imread(color);	// rgb 图像是8UC3的彩色图像
	depth = cv::imread(dep, -1);	// depth 是16UC1的单通道图像

	// 使用智能指针，创建一个空点云。这种指针用完会自动释放。
	PointCloud::Ptr cloud(new PointCloud);
	// 遍历深度图
	for (int m = 0; m < depth.rows; m++)
		for (int n = 0; n < depth.cols; n++)
		{
			// 获取深度图中(m,n)处的值
			ushort d = depth.ptr<ushort>(m)[n];
			// d 可能没有值，若如此，跳过此点
			if (d == 0) continue;

			// d 存在值，则向点云增加一个点
			PointT p;
			// 计算这个点的空间坐标
			p.z = double(d) / camera_factor;
			p.x = (n - camera_cx) * p.z / camera_fx;
			p.y = (m - camera_cy) * p.z / camera_fy;

			// 从rgb图像中获取它的颜色
			// rgb是三通道的BGR格式图，所以按下面的顺序获取颜色
			p.b = rgb.ptr<uchar>(m)[n * 3];
			p.g = rgb.ptr<uchar>(m)[n * 3 + 1];
			p.r = rgb.ptr<uchar>(m)[n * 3 + 2];

			// 把p加入到点云中
			cloud->points.push_back(p);
		}
	// 设置点云
	cloud->height = 1;
	cloud->width = cloud->points.size();
	cout << "point cloud size = " << cloud->points.size() << endl;
	cloud->is_dense = false;
	//保存点云
	pcl::io::savePCDFile("result_pcd.pcd", *cloud);
	// 清除数据并退出
	cloud->points.clear();
	cout << "Point cloud saved." << endl;
	//显示点云数据
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