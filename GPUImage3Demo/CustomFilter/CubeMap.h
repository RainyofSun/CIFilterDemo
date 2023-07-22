//
//  CubeMap.h
//  GPUImage3Demo
//
//  Created by 苍蓝猛兽 on 2023/7/17.
//

#ifndef CubeMap_h
#define CubeMap_h

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

struct CubeMap {
    int length;
    float dimension;
    float *data;
};

struct CubeMap createCubeMap(float minHueAngle, float maxHueAngle);

#endif /* CubeMap_h */
