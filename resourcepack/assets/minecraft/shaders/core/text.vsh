#version 330

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:sample_lightmap.glsl>
#endif

#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:projection.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
in ivec2 UV2;
#endif

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
uniform sampler2D Sampler2;
out float sphericalVertexDistance;
out float cylindricalVertexDistance;
#endif

out vec4 vertexColor;
out vec2 texCoord0;

void main() {
    int r = int(Color.r * 255.5);
    int g = int(Color.g * 255.5);
    int b = int(Color.b * 255.5);

    bool isCoordsLine = (r == 255 && g == 0 && b == 34); // color
    bool isCoordsShadow = (r >= 62 && r <= 64 && g == 0 && b >= 7 && b <= 9); // shadow

    bool isDayLine = (r == 255 && g == 0 && b == 17);
    bool isDayShadow = (r >= 62 && r <= 64 && g == 0 && b >= 3 && b <= 5);

    bool isHUD = isCoordsLine || isCoordsShadow || isDayLine || isDayShadow;

    vec4 pos = ModelViewMat * vec4(Position, 1.0);

#if defined(IS_GUI)
    if (isHUD) {
        float guiW = abs(2.0 / ProjMat[0][0]);
        float guiH = abs(2.0 / ProjMat[1][1]);
        
        if (isCoordsLine || isCoordsShadow) {
            // Line 1: Coords. Target X = 4.0, target Y = 5.0.
            float shiftX = 91.0 - (guiW / 2.0);
            float shiftY = 74.0 - guiH;
            pos.x += shiftX;
            pos.y += shiftY;
        } else if (isDayLine || isDayShadow) {
            // Line 2: Day. Target X = 4.0, target Y = 17.0 (12px gap).
            float shiftX = 92.0 - (guiW / 2.0);
            float shiftY = 86.0 - guiH;
            pos.x += shiftX;
            pos.y += shiftY;
        }
    }
#endif

    gl_Position = ProjMat * pos;

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);
    vertexColor = Color * sample_lightmap(Sampler2, UV2);
#else
    vertexColor = Color;
    if (isCoordsLine || isDayLine) {
        vertexColor = vec4(1.0, 1.0, 1.0, Color.a);
    } else if (isCoordsShadow || isDayShadow) {
        vertexColor = vec4(0.25, 0.25, 0.25, Color.a);
    }
#endif

    texCoord0 = UV0;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
//
//   This shader has been created by FuzjaJadrowa.
//              https://fuzjajadrowa.pl
//
//              COPYING IS PROHIBITED!
//
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#