#pragma once
#pragma once
#pragma comment(lib,"opencv_world345d.lib")
//#define _CRT_SECURE_NO_WARNINGS
//#define _SILENCE_FPOS_SEEKPOS_DEPRECATION_WARNING


#include<fstream>
#include<string>
#include<iostream>

#include <vector>
#include <ctime>
#include<cv.h>
#include<highgui.h>
#include<opencv2/opencv.hpp>


#include<pcl/io/pcd_io.h>
#include<pcl/point_types.h>
#include <pcl/point_cloud.h>
#include <pcl/kdtree/kdtree_flann.h>
#include<pcl/visualization/cloud_viewer.h>
using namespace cv;
using namespace std;

typedef pcl::PointXYZRGBA PointT;
typedef pcl::PointCloud<PointT> PointCloud;

#ifndef _DENOISE
#define _DENOISE
#define WINDOWS_NAME "¡¾SrcImage¡¿"
#define WINDOWS_NAME_DENOISING "¡¾BilateralFilter¡¿"

int Denoising(char* img, char* tosave);
int ToPCLdata(char *depth, char *rgb);


#endif
