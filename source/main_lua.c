/*
The purpose of this file is to start up the program and get into Lua.
Most of the time, you will not need to touch this file.
*/


#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

#include "iup.h"
#include "iupcbs.h"
#include "iup_varg.h"
//#include "iupweb.h"

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

#include "iuplua.h"

void DoStartupOnlyOnce(void);
void IupEntryPoint(void);

// Tricky: Do not #include "SDL.h" before declaring int main. SDL.h does some macro magic to hijack the definition on iOS to make SDL's booting go normally. But this will break normal use cases, like with IUP.
// Do not modify main(). Not all platforms use main as the entry point so your changes may have no effect.
int main(int argc, char* argv[])
{
	// Remember: Not all platforms run main.
	IupOpen(&argc, &argv); // removed because IupLua is presumably doing this.
	IupSetFunction("ENTRY_POINT", (Icallback)IupEntryPoint);
	IupMainLoop();
	return 0;
}


#include "BlurrrCore.h"
#include "BlurrrLua.h"


#define MAX_FILE_STRING_LENGTH 2048
#define MAX_PHRASE_STRING_LENGTH 10000


/* These functions are provided by the various libraries, but don't provide header files.
	So we just declare their interfaces here as any header file would do.
*/
extern int luaopen_BlurrrCore(lua_State* L); /* default Lua action */

struct GlobalResources
{
	struct lua_State* luaState;
	
	Ihandle* buttonParse;

//	Ihandle* textOptionsInfo;
	
//	char* currentFileBuffer;


//	int luaStartStack;
	

};

struct GlobalResources* g_globalResources = NULL;
static _Bool s_isInit = 0;

int actionParse(const char* source_file_name);

const char* GenProj_GetLocalizedString(const char* key, const char* comment)
{
	return IupGetLanguageString(key);
}
/*
const char* ApplicationState_GetLastOpenFileDialogPath()
{
	BlurrrShim_assert(g_applicationState);
	return g_applicationState->lastFileOpenDialogPath;
}
*/

static int report(lua_State* L, int status)
{
	const char* msg;
	if(status)
	{
		msg = lua_tostring(L, -1);
		if (msg == NULL) msg = "(error with no message)";
		BlurrrLog_SysLog("status=%d, %s\n", status, msg);
		lua_pop(L, 1);
	}
	return status;
}


#if 1
int actionParse(const char* source_file_name)
{

	lua_State* lua_state = g_globalResources->luaState;


	int start_stack = lua_gettop(lua_state);
	IupLog("DEBUG", "lua_gettop:%d", lua_gettop(lua_state));
	/* push functions and arguments */
	lua_getglobal(lua_state, "run_conversion");  /* function to be called */
	lua_pushstring(lua_state, source_file_name);   /* push 1st argument */
	IupLog("DEBUG", "lua_gettop:%d", lua_gettop(lua_state));
	IupLog("DEBUG", "lua_typename -1:%s", lua_typename(lua_state, lua_type(lua_state,-1)));
	IupLog("DEBUG", "lua_typename -2:%s", lua_typename(lua_state, lua_type(lua_state,-2)));

	/* do the call (2 arguments, 1 result) */
//	if(lua_pcall(lua_state, 2, 1, 0) != 0)
	/* do the call (1 arguments, 0 results) */
	if(lua_pcall(lua_state, 1, 0, 0) != 0)
	{
		BlurrrLog_SysLog("Error running function run_conversion': %s", lua_tostring(lua_state, -1));
		lua_settop(lua_state, start_stack);
		return IUP_DEFAULT;
	}


	lua_settop(lua_state, start_stack);
//	g_globalResources->luaStartStack = start_stack;
	
	
	
	return IUP_DEFAULT;
}
#endif


static int OnOpenFileSelect(Ihandle* button_object)
{
	int ret_status;
	const char* selected_path = NULL;
	Ihandle* file_dialog = IupFileDlg();
	struct WizardControllerState* wizard_state = (struct WizardControllerState*)IupGetAttribute(button_object, "wizardControllerState");
	int which_select_button = IupGetInt(button_object, "whichSelectButton");
	Ihandle* associated_label = (Ihandle*)IupGetAttribute(button_object, "associatedLabel");


	IupSetAttribute(file_dialog, "DIALOGTYPE", "OPEN");
	IupSetStrAttribute(file_dialog, "TITLE",
		GenProj_GetLocalizedString("Select .json file", "Select .json file")
	);
	IupSetAttribute(file_dialog, "FILTER", "*.json");

/*
	IupSetStrAttribute(file_dialog, "DIRECTORY",
		ApplicationState_GetLastOpenFileDialogPath()
	);
*/
	
	

//		printf("OnOpenFileSele
	
	IupPopup(file_dialog, IUP_CURRENT, IUP_CURRENT);

	ret_status = IupGetInt(file_dialog, "STATUS");

	if(-1 != ret_status)
	{
#define MY_MAX_PATH_LEN 2048
		const char* selected_file = NULL;

		selected_file = IupGetAttribute(file_dialog, "VALUE");

		BlurrrLog_SysLog("Selected file: %s", selected_file);

		actionParse(selected_file);

	}
	else
	{
		/* user cancelled */
	}

//  printf("OnNewProjectCallback(button=%d, press=%d)\n", button, press);



	return IUP_DEFAULT;
}

static void OnOpenFilesCallback(int file_index, int total_files_to_open, char* file_path)
{
//SDL_Log("OnOpenFilesCallback");

	// If the user is trying to open multiple files, we don't support that right now.
	// Only open one of the files and ignore the rest.
	if((total_files_to_open > 1) && (file_index > 0))
	{
		return;
	}

	// TODO: This is one of the few actual global/singleton variables I have.
	// I need this for the OPENFILES_CB on Mac because it is an application wide-event.
	// If I ever change to a multiple-document model, this is one of the things that must be fixed.

	actionParse(file_path);
	return;
}

void LoadLED()
{
  char *error=NULL;
  Ihandle *dlg=NULL;


#define MAX_FILE_STRING_LENGTH 2048
	char resource_file_path[MAX_FILE_STRING_LENGTH];
	char base_path[MAX_FILE_STRING_LENGTH];
	size_t len = BlurrrPath_GetResourceDirectoryString(base_path, MAX_FILE_STRING_LENGTH);
	BlurrrStdlib_strlcpy(resource_file_path, base_path, MAX_FILE_STRING_LENGTH);
	BlurrrStdlib_strlcat(resource_file_path, "main_dialog.led", MAX_FILE_STRING_LENGTH);
	

  if((error = IupLoad(resource_file_path)) != NULL)
  {
    IupMessage("%s\n", error);
    return;
  }

  dlg = IupGetHandle("dlg");



	Ihandle* button_parse = IupGetHandle("buttonParse");

//	Ihandle* text_options = IupGetHandle("textOptionsInfo");

	g_globalResources->buttonParse = button_parse;

//	g_globalResources->textOptionsInfo = text_options;

	//IupSetCallback(g_globalResources->buttonParse, "POSTMESSAGE_CB", (Icallback)PostMessageMainThreadCallback);

	IupSetFunction("actionParse", OnOpenFileSelect);

  /* sets mouse-movement callback */
#if 0
  IupSetFunction("mousemove", (Icallback) mousemove);
  IupSetFunction("button_press", (Icallback) button_press);
  IupSetFunction("button_release", (Icallback) button_release);

  IupSetAttribute(dial_v, "BUTTON_PRESS_CB", "button_press");
  IupSetAttribute(dial_c, "BUTTON_PRESS_CB", "button_press");
/*IupSetAttribute(dial_h, "BUTTON_PRESS_CB", "button_press"); This is done in LED */

  IupSetAttribute(dial_v, "BUTTON_RELEASE_CB", "button_release");
  IupSetAttribute(dial_h, "BUTTON_RELEASE_CB", "button_release");
/*IupSetAttribute(dial_c, "BUTTON_RELEASE_CB", "button_release"); This is done in LED */

  IupSetAttribute(dial_c, "MOUSEMOVE_CB", "mousemove");
  IupSetAttribute(dial_h, "MOUSEMOVE_CB", "mousemove");
/*IupSetAttribute(dial_v, "MOUSEMOVE_CB", "mousemove"); This is done in LED */
#endif

  IupShowXY(dlg,IUP_CENTER,IUP_CENTER);

//  IupMainLoop();

//  IupDestroy(dlg);

//  IupClose();
}

void CallLuaVoidFunction(struct lua_State* lua_state, const char* function_name)
{
	lua_getglobal(lua_state, function_name);
	int ret_flag = lua_pcall(lua_state, 0, 0, 0);
	if(0 != ret_flag)
	{
		report(lua_state, ret_flag);
	}
	else
	{
		// nothing to lua_pop with void function
	}
}

lua_State* LoadLuaFile(lua_State* lua_state, const char* lua_file_path)
{
	struct BlurrrFileHandle* rw_ops;
	int ret_flag;
	// We use SDL to open/read the file because on Android, it is inside the .apk (zip), so standard file functions won't work.
	rw_ops = BlurrrFile_Open(lua_file_path, "r");
	if(NULL != rw_ops)
	{
		int64_t file_size;
		file_size = BlurrrFile_Size(rw_ops);
		if(file_size > 0)
		{
			char* file_data_buffer;
			size_t bytes_read;
			file_data_buffer = (char*)calloc(file_size, sizeof(char));
			bytes_read = BlurrrFile_Read(rw_ops, file_data_buffer, 1, file_size);

			ret_flag = luaL_loadbuffer(lua_state, file_data_buffer, file_size, lua_file_path);
			if(0 != ret_flag)
			{
				report(lua_state, ret_flag);
				
			}
			else
			{
				ret_flag = lua_pcall(lua_state, 0, 0, 0);
				if(0 != ret_flag)
				{
					report(lua_state, ret_flag);
				}
			}
			free(file_data_buffer);
		}
		else
		{
			BlurrrLog_SysLog("Error: %s had a file size <= 0: %zu", lua_file_path, file_size);
		}
	}
	else
	{
		BlurrrLog_SysLog("Error: Could not open/find %s", lua_file_path);
		
	}
	BlurrrFile_Close(rw_ops);
	return lua_state;
}


void LoadLuaScript()
{
	struct lua_State* lua_state;
	int ret_flag;
	char lua_base_path[MAX_FILE_STRING_LENGTH];
	char lua_file_path[MAX_FILE_STRING_LENGTH];

	struct BlurrrFileHandle* rw_ops;
	
    // Override point for customization after application launch.
	lua_state = luaL_newstate();
	luaL_openlibs(lua_state);
	BlurrrLua_Init(lua_state);
	luaopen_BlurrrCore(lua_state);
//	iuplua_open(lua_state);
//	iupweblua_open(lua_state);
	/*
	luaopen_ALmixer(lua_state);
*/
//	luaopen_lpeg(lua_state);


	lua_file_path[0] = '\0';
	BlurrrPath_GetResourceDirectoryString(lua_base_path, MAX_FILE_STRING_LENGTH);
	BlurrrPath_GetResourceDirectoryString(lua_file_path, MAX_FILE_STRING_LENGTH);
	BlurrrStdlib_strlcpy(lua_file_path, lua_base_path, MAX_FILE_STRING_LENGTH);
	BlurrrStdlib_strlcat(lua_file_path, "runconversion.lua", MAX_FILE_STRING_LENGTH);
	lua_state = LoadLuaFile(lua_state, lua_file_path);

//	BlurrrStdlib_strlcpy(lua_file_path, lua_base_path, MAX_FILE_STRING_LENGTH);
//	BlurrrStdlib_strlcat(lua_file_path, "helpers.lua", MAX_FILE_STRING_LENGTH);

//	lua_state = LoadLuaFile(lua_state, lua_file_path);
	
	g_globalResources->luaState = lua_state;

	
}

static void DestroyGlobals()
{
	lua_close(g_globalResources->luaState);

//	free(g_globalResources->currentFileBuffer);
//	g_globalResources->currentFileBuffer = NULL;
	
    free(g_globalResources);
    g_globalResources = NULL;
}

// This function is called when the program exits.
static void IupExitPoint()
{
/*
	CallLuaVoidFunction(g_globalResources->luaState, "IupExitPoint");

//	iuplua_close(g_globalResources->luaState);
	lua_close(g_globalResources->luaState);
	g_globalResources->luaState = NULL;
//	IupClose(); // called in Lua
*/
	IupClose();
	s_isInit = 0;
	
	DestroyGlobals();
	BlurrrCore_Quit();
}

// IupLua has a strange startup sequence that is causing problems with the next-gen Iup backends because all of them require deferring to the OS's native event loop.
// IupLua seems to check to see if IupOpen is called outside of Lua first or in Lua and will do different things.
// When called outside of Lua, it skips certain registration operations which is breaking us.
// iuplua_opencall_internal in particular returns false in this case, which skips calling IupWebBrowserOpen in iupweb and breaks things.
// Unfortunately, because we must defer to the OS native loop for the new platforms,
// we are relying on the new IupEntryPoint behavior which means we must start in C and use Iup.
// The workaroud seems to be to immediately start Lua and call require() to get things going.
// Because the next-gen startup is not guaranteed to use main as the sole entry point, we must take care to not do our initialization twice.
// See _IUPOPEN_CALL and EXTERNAL and INTERNAL and iuplua_opencall_internal and iupweblua_open
void DoStartupOnlyOnce()
{
	if(s_isInit == 1)
	{
		return;
	}
	
	BlurrrCore_Init();
	g_globalResources = calloc(1, sizeof(struct GlobalResources));
/*
	int error_val = IupWebBrowserOpen();
	if(IUP_ERROR == error_val)
	{
		BlurrrLog_SysLog("Warning: IupWeb failed to initialize.");
		const char* missing_library_name = IupGetGlobal("_IUP_WEBBROWSER_MISSING_DLL");
		if(NULL != missing_library_name)
		{
			BlurrrLog_SysLog("Unable to load dependency %s. Please install this via your system's package manager and try again.", missing_library_name);
		}
	}
*/
	

	LoadLuaScript();
	IupSetFunction("OPENFILES_CB", (Icallback)OnOpenFilesCallback);
	
	LoadLED();
	s_isInit = 1;
}

void IupEntryPoint()
{
	DoStartupOnlyOnce();

	// This tells IUP to call IupExitPoint on exit.
	IupSetFunction("EXIT_CB", (Icallback)IupExitPoint);
 //   CallLuaVoidFunction(g_globalResources->luaState, "IupEntryPoint");
	IupSetInt(NULL, "UTF8MODE", 1);

}

