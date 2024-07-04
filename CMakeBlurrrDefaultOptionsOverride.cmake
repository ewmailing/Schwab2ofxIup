# Some Blurrr components are optional.
# If you don't need them and want to override their inclusion in the build process,
# use this file to override which ones you want.
# Any values you set here will override the default ones,
# and any values you omit, will continue to be set to the defaults.

# You must set these values before the initial CMake generation, otherwise you must clear the CMake cache.
# (Simply deleting your build folder and regenerating will suffice if you don't know how to clear the CMake cache.)

# Note: The default templates may be using this code as a starting point, so make sure to remove any code in use.


# Core libraries
BLURRR_FORCE_OPTION(BLURRR_USE_SDL "Use SDL library" OFF)
BLURRR_FORCE_OPTION(BLURRR_USE_BLURRRCORE "Use BlurrrCore library" ON)
BLURRR_FORCE_OPTION(BLURRR_USE_OPENAL "Use OpenAL audio library" OFF)
BLURRR_FORCE_OPTION(BLURRR_USE_ALMIXER "Use ALmixer audio library (requires OpenAL)" OFF)
BLURRR_FORCE_OPTION(BLURRR_USE_CHIPMUNK "Use Chipmunk physics library" OFF)
BLURRR_FORCE_OPTION(BLURRR_USE_SDLTTF "Use SDL_ttf library" OFF)
BLURRR_FORCE_OPTION(BLURRR_USE_SDLIMAGE "Use SDL_image library" OFF)
# BLURRR_FORCE_OPTION(BLURRR_USE_SDLGPU "Use SDL_gpu library" OFF)
# BLURRR_FORCE_OPTION(BLURRR_USE_SDLNET "Use SDL_net library" OFF)
# BLURRR_FORCE_OPTION(BLURRR_USE_CURL "Use curl library" OFF)
# BLURRR_FORCE_OPTION(BLURRR_USE_CJSON "Use cJSON library" OFF)
# BLURRR_FORCE_OPTION(BLURRR_USE_ZLIB "Use zlib library" OFF)
# BLURRR_FORCE_OPTION(BLURRR_USE_NATIVEFILEDIALOG "Use nfd library" OFF)
# BLURRR_FORCE_OPTION(BLURRR_USE_BLRPARTICLE "Use BLRParticle library" OFF)
# BLURRR_FORCE_OPTION(BLURRR_USE_BLRKEYFRAME "Use BLRKeyFrame library" OFF)
# BLURRR_FORCE_OPTION(BLURRR_USE_BLRINAPPPURCHASE "Use BLRInAppPurchase library" OFF)
# BLURRR_FORCE_OPTION(BLURRR_USE_BLURRRNETWORKSERVICEDISCOVERY "Use BlurrrNetworkServiceDiscovery library" OFF)
BLURRR_FORCE_OPTION(BLURRR_USE_IUP "Use iup library" ON)
BLURRR_FORCE_OPTION(BLURRR_USE_IUPWEB "Use iupweb library" OFF)

SET(BLURRR_IUP_BASED_APP 1)
SET(BLURRR_USE_STDMAIN 1)
SET(BLURRR_WINDOWS_USE_VISUAL_STYLES 1)
SET(BLURRR_USE_HIGH_DPI 1)


# Lua Modules/PlugIns
IF(BLURRR_USE_LUA)
	BLURRR_FORCE_OPTION(BLURRR_USE_LUAAL "Use LuaAL module" OFF)
	BLURRR_FORCE_OPTION(BLURRR_USE_LPEG "Use LPeg module" ON)
	BLURRR_FORCE_OPTION(BLURRR_USE_LUASOCKET "Use LuaSocket module" OFF)
	# BLURRR_FORCE_OPTION(BLURRR_USE_LUAFILESYSTEM "Use LuaFileSystem module" OFF)
	BLURRR_FORCE_OPTION(BLURRR_USE_IUPLUA "Use iuplua module" OFF)
	BLURRR_FORCE_OPTION(BLURRR_USE_IUPLUAWEB "Use iupluaweb module" OFF)

	BLURRR_FORCE_OPTION(BLURRR_USE_SDL_LUA_BINDING "Use sdl lua module" OFF)
	BLURRR_FORCE_OPTION(BLURRR_USE_BLURRRCORE_LUA_BINDING "Use blurrrcore lua module" ON)

	IF(BLURRR_PLATFORM_RASPBERRY_PI)
		# BLURRR_FORCE_OPTION(BLURRR_USE_GPIOLUA "Use Raspberry Pi GPIOLua" OFF)
	ENDIF()

ELSEIF(BLURRR_USE_JAVASCRIPT)

ELSEIF(BLURRR_USE_SWIFT)
	# BLURRR_FORCE_OPTION(BLURRR_USE_SWIFT_FOUNDATION_LIBRARY "Use Swift Foundation" OFF)
	# BLURRR_FORCE_OPTION(BLURRR_USE_SWIFT_C_LIBRARY "Use Swift C Library" ON)
	# BLURRR_FORCE_OPTION(BLURRR_USE_SWIFT_CORE_LIBRARY "Use Swift Core" ON)
	IF(BLURRR_PLATFORM_RASPBERRY_PI)
		# BLURRR_FORCE_OPTION(BLURRR_USE_PIGPIO "Use Raspberry Pi pigpio" OFF)
	ENDIF()

ELSE()
	IF(BLURRR_PLATFORM_RASPBERRY_PI)
		# BLURRR_FORCE_OPTION(BLURRR_USE_PIGPIO "Use Raspberry Pi pigpio" OFF)
	ENDIF()

ENDIF()


