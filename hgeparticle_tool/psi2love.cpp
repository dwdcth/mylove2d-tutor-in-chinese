#include <stdio.h>
#include <stdint.h>
#include <errno.h>
#include <string.h>
#include <math.h>

struct hgeColor
{
    float       r,g,b,a;
};

struct hgeParticleSystemInfo
{
    uint32_t sprite; // hgeSprite*  sprite;    // texture + blend mode
    int32_t nEmission; // int           nEmission; // particles per sec
    float       fLifetime;

    float       fParticleLifeMin;
    float       fParticleLifeMax;

    float       fDirection;
    float       fSpread;
    int32_t bRelative; // bool      bRelative;

    float       fSpeedMin;
    float       fSpeedMax;

    float       fGravityMin;
    float       fGravityMax;

    float       fRadialAccelMin;
    float       fRadialAccelMax;

    float       fTangentialAccelMin;
    float       fTangentialAccelMax;

    float       fSizeStart;
    float       fSizeEnd;
    float       fSizeVar;

    float       fSpinStart;
    float       fSpinEnd;
    float       fSpinVar;

    hgeColor    colColorStart; // + alpha
    hgeColor    colColorEnd;
    float       fColorVar;
    float       fAlphaVar;
};

int main( int argc, const char* argv[] )
{
    if ( argc != 5 )
    {
        fprintf( stderr, "USAGE: psi2love filename.psi func_name image_name max_particles\n" );
        return 1;
    }

    FILE* psi = fopen( argv[ 1 ], "rb" );
    if ( psi == NULL )
    {
        fprintf( stderr, "Error: %s\n", strerror( errno ) );
        return 1;
    }

    hgeParticleSystemInfo info;

    if ( fread( &info, 1, sizeof( info ), psi ) != sizeof( info ) )
    {
        fprintf( stderr, "Error: %s\n", strerror( errno ) );
        fclose( psi );
        return 1;
    }

    fclose( psi );

    printf( "local function %s()\n", argv[ 2 ] );
    printf( "  -- created from %s\n", argv[ 1 ] );
    printf( "\n" );
	printf("  local img=love.graphics.newImage(\"%s\")\n",argv[3]);
    printf( "  local ps = love.graphics.newParticleSystem( img, %s )\n", argv[ 4 ] );
    printf( "\n" );

    // nEmission
    printf( "  ps:setEmissionRate( %d )\n", info.nEmission );

    // fLifetime
    printf( "  ps:setLifetime( %g )%s\n", info.fLifetime, info.fLifetime == -1.0 ? " -- forever" : "" );

    // fParticleLifeMin, fParticleLifeMax
    printf( "  ps:setParticleLife( %g, %g )\n", info.fParticleLifeMin, info.fParticleLifeMax );

    // fDirection
    printf( "  ps:setDirection( %g )\n", info.fDirection - M_PI / 2 );

    // fSpread
    printf( "  ps:setSpread( %g )\n", info.fSpread );

    // bRelative
    printf( "  -- ps:setRelative( %s )\n", info.bRelative ? "true" : "false" );

    // fSpeedMin, fSpeedMax
    printf( "  ps:setSpeed( %g, %g )\n", info.fSpeedMin, info.fSpeedMax );

    // fGravityMin, fGravityMax
    printf( "  ps:setGravity( %g, %g )\n", info.fGravityMin, info.fGravityMax );

    // fRadialAccelMin, fRadialAccelMax
    printf( "  ps:setRadialAcceleration( %g, %g )\n", info.fRadialAccelMin, info.fRadialAccelMax );

    // fTangentialAccelMin, fTangentialAccelMax
    printf( "  ps:setTangentialAcceleration( %g, %g )\n", info.fTangentialAccelMin, info.fTangentialAccelMax );

    // fSizeStart, fSizeEnd, fSizeVar
    printf( "  ps:setSizes( %g, %g ) -- there's a bug in 0.7.1 that forces us to set the size variation using its own function\n", info.fSizeStart, info.fSizeEnd );
    printf( "  ps:setSizeVariation( %g )\n", info.fSizeVar );

    // fSpinStart, fSpinEnd, fSpinVar
    printf( "  ps:setSpin( %g, %g, %g )\n", info.fSpinStart, info.fSpinEnd, info.fSpinVar );

    // colColorStart, colColorEnd
    printf(
        "  ps:setColor( %d, %d, %d, %d, %d, %d, %d, %d )\n",
        (int)(info.colColorStart.r * 255), (int)(info.colColorStart.g * 255), (int)(info.colColorStart.b * 255), (int)(info.colColorStart.a * 255),
        (int)(info.colColorEnd.r * 255), (int)(info.colColorEnd.g * 255), (int)(info.colColorEnd.b * 255), (int)(info.colColorEnd.a * 255)
    );

    // fColorVar
    printf( "  -- ps:setColorVariation( %g )\n", info.fColorVar );

    // fAlphaVar
    printf( "  -- ps:setAlphaVariation( %g )\n", info.fAlphaVar );

    printf( "\n" );
    printf( "  return ps\n" );
    printf( "end\n" );

    return 0;
}

