/*
 *  MapManager.h
 *  iLiveTraffic
 *
 *  Created by sheva2003 on 10-9-2.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef _ZSM_H_MAPMANAGER
#define _ZSM_H_MAPMANAGER



#include  <vector>

#include "shapefil.h"

using namespace std;

class MapManager{

public:
	
	enum displayLevel {
		level1 = 0,level2,level3,level4,level5,level6,level7,level8
	};
	
	//constructor
	MapManager();

	//destructor
	~MapManager();
	
	//add map file from local disk
	bool addMap(const char* path,bool updateBounds = true);
	bool addXBase(const char* path, bool pushNullXBase);
	
	SHPHandle getLayer(int i);
	SHPTree* getTree(int i);
	DBFHandle getXBase(int i);

	void calcDefaultCenter();
	
	void calcZoomFactor(int screenWidth, int screenHeight);
	
	double getCenterX(){ return m_centerX;};
	double getCenterY(){ return m_centerY;};
	
	double convertScreenDist2GeoDist(int screenDist);
	int convertGeoDist2ScreenDist(double geoDist);
	
	int convertGeo2ScreenX(double geoX, int displayLeft, int displayWidth);
	int convertGeo2ScreenY(double geoY, int displayTop, int displayHeight);
	
	double convertScreen2GeoX(int screenX, int screenWidth);
	double convertScreen2GeoY(int screenY, int screenHeight);
	
	void calcGeoBoundsViaScreenRect(double* padfBoundsMin, double* padfBoundsMax,int screenWidth, int screenHeight);	
	void calcGeoBoundsViaScreenRectAndGeoCenter(double* padfBoundsMin, double* padfBoundsMax,double geoX,double geoY,int screenRadius = 3);	
	
	void updateZoomFactor(double time);
	void setZoomFactor(double factor);
	void zoomToCity();
	void zoomToLevel5();
	bool isZoomFactorLowerThanToCity() ;
	
	bool zoomIn();
	bool zoomOut();
	
	double getZoomFactor(){return m_zoomFactor;};
	int getDisplayStage(){return m_currentLevel;};

	void updateCenter(int screenOffsetX, int screenOffsetY);
	void setCenter(double geoX, double geoY);
	
	bool isPosInCity(double longitude, double latitude);
	
	int getDisplayStageCount() {return m_numStage;};
	
	bool isObjAtPos(double geoX, double geoY, double posX, double posY);
	
private:
	
	//data members
	vector<SHPHandle> m_vMaps;
	vector<SHPTree*> m_vTrees;
	vector<DBFHandle> m_vXBase;
	
	//Geo coordinates of the screen's center
	double m_centerX, m_centerY;
	
	//Boundary of all of the maps, left,right,top,bottom
	double m_pdfMapBounds[4];
	
	//zoom index list
	const static int m_numStage = 8;
	double m_zoomStage[m_numStage];
	double m_zoomFactor;
	
	int m_currentLevel;
	
	void updateCurrentStage();
	
};

#endif 

