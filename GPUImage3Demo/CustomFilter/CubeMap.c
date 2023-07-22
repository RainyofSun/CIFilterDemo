//
//  CubeMap.c
//  GPUImage3Demo
//
//  Created by 苍蓝猛兽 on 2023/7/17.
//

#include "CubeMap.h"

void rgbToHSV(float *rgb, float *hsv) {
    float min, max, delta;
    float r = rgb[0], g = rgb[1], b = rgb[2];
    float *h = hsv, *s = hsv + 1, *v = hsv + 2;
    
    min = fminf(fminf(r, g), b);
    max = fmax(fmaxf(r, g), b);
    *v = max;
    delta = max - min;
    if (max != 0) {
        *s = delta / max;
    } else {
        *s = 0;
        *h = -1;
        return;
    }
    if (r == max) {
        *h = (g - b) / delta;
    } else if (g == max) {
        *h = 2  + (b - r) / delta;
    } else {
        *h = 4 + (r - g) / delta;
    }
    
    *h *= 60;
    if (*h < 0) {
        *h += 360;
    }
}

struct CubeMap createCubeMap(float minHueAngle, float maxHueAngle) {
    const unsigned int size = 64;
    struct CubeMap map;
    map.length = size * size * size * sizeof(float) * 4;
    map.dimension = size;
    float *cubeData = (float *)malloc(map.length);
    float rgb[3], hsv[3], *c = cubeData;
    
    for (int z = 0; z < size; z++) {
        // Blue Value
        rgb[2] = ((double) z)/(size - 1);
        for (int y = 0; y < size; y ++) {
            // Green Vlaue
            rgb[1] = ((double) y) / (size - 1);
            for (int x = 0; x < size; x++) {
                // Red Value
                rgb[0] = ((double) x) / (size - 1);
                rgbToHSV(rgb, hsv);
                // Use the hue value to determine which to make transparent
                // The minimum and maximum hue angle depends on
                // the color you want to remove
                float alpha = (hsv[0] > minHueAngle && hsv[0] < maxHueAngle) ? 0.0f : 1.0f;
                // Calculate premultiplied alpha values for the cube
                c[0] = rgb[0] * alpha;
                c[1] = rgb[1] * alpha;
                c[2] = rgb[2] * alpha;
                c[3] = alpha;
                // advance our pointer into memory for the next color value
                c += 4;
            }
        }
    }
    
    map.data = cubeData;
    return map;
}
