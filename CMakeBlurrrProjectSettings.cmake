# This file is designed to help isolate your specific project settings.
# The variable names are predetermined. DO NOT CHANGE the variable names.
# You may change the values of the variables.
# Please do not remove any comment automation markers or put anything in between. They are reserved for future use.

# Set the name of your project here. Avoid spaces and funny characters. (Change the part in quotes, not the variable name BLURRR_USER_PROJECT_NAME)
set(BLURRR_USER_PROJECT_NAME "Schwab2ofxIup")

# Set the name of your executable here. Avoid spaces and funny characters. (Change the part in quotes, not the variable name BLURRR_USER_PROJECT_NAME)
set(BLURRR_USER_EXECUTABLE_NAME "Schwab2ofxIup")

# Set the human readable name of program your  here. (Change the part in quotes, not the variable name BLURRR_USER_HUMAN_NAME)
set(BLURRR_USER_HUMAN_NAME "Schwab2ofxIup")

# Your company identifier
set(BLURRR_USER_COMPANY_IDENTIFIER "net.playcontrol")
# Mac App Store and iOS App Store may not use the same bundle identifier, so make one different.
if(BLURRR_PLATFORM_IOS)
	set(BLURRR_USER_BUNDLE_IDENTIFIER "${BLURRR_USER_COMPANY_IDENTIFIER}.${BLURRR_USER_EXECUTABLE_NAME}iOS")
else()
	# The name of your unique bundle identifer.
	set(BLURRR_USER_BUNDLE_IDENTIFIER "${BLURRR_USER_COMPANY_IDENTIFIER}.${BLURRR_USER_EXECUTABLE_NAME}")
endif()

# You must create a unique GUID for your application for WinRT. Other platforms can ignore this.
set(BLURRR_USER_PACKAGE_GUID "01234512-89ab-cdef-0123-456789abcdef")

set(BLURRR_VERSION_MAJOR "1")
set(BLURRR_VERSION_MINOR "0")
set(BLURRR_VERSION_PATCH "0")
# This is used for the Android versionCode. Must be an integer and should increase for each release.
set(BLURRR_VERSION_CODE 1)

set(BLURRR_USER_APP_DESCRIPTION "Convert Schwab to OFX")

# Must declare LSApplicationCategoryType in Info.plist to pass Mac App Store validation
# See https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/LaunchServicesKeys.html#//apple_ref/doc/uid/TP40009250-SW8
# The default for an IUP based app in Blurrr is public.app-category.productivity, but you should set it in case the default changes.
set(MACOSX_BUNDLE_APPLICATION_CATEGORY_TYPE "public.app-category.productivity")

# Uncomment this and set to your license file. This tells CPack installers which license file to display
# OSX Rez->SLA for DMG flips out on this.
if(BLURRR_PLATFORM_WINDOWS)
#	set(CPACK_RESOURCE_FILE_LICENSE "${PROJECT_SOURCE_DIR}/resources/LICENSE.TXT")
endif()




# Code Signing: Maybe changing in the IDE directly is sufficent. If not, change it here.
macro(BLURRR_CONFIGURE_CODESIGNING _EXE_NAME)

	if(BLURRR_PLATFORM_IOS)
		# iPhone Developer is the key you use to test on your own devices.
		# iPhone Distribution is the key you use to ship on the iOS App Store.
	
		# This if statement will allow you to specify the variable through the command line without being overridden.
		if(NOT BLURRR_IOS_CODESIGN_IDENTITY)

			set(BLURRR_IOS_CODESIGN_IDENTITY "iPhone Developer")
			# set(BLURRR_IOS_CODESIGN_IDENTITY "iPhone Distribution")
			
		endif()

		set_xcode_property(${_EXE_NAME} CODE_SIGN_IDENTITY "${BLURRR_IOS_CODESIGN_IDENTITY}")


	elseif(BLURRR_PLATFORM_OSX)
		# For Mac: There are multiple options.
		# GateKeeper (Developer ID Application) for signed non-Mac App Store apps
		# Mac Developer for developing Mac App Store apps
		# Mac Distribution (3rd Party Mac Developer Application) for actual Mac App Store deployment
		# And None ("") for no codesigning.
		# For shipping real apps, you should always sign with Developer ID or Mac Distribution.
		# Also, you should generally enable sandboxing out of courtesy for your users (and is required for MAS).
		# And for JavaScript debugging with Safari, you need to codesign to use the com.apple.security.get-task-allow entitlement.
		# But for faster development iteration, you may want to disable codesigning because the build takes longer.

		# This if statement will allow you to specify the variable through the command line without being overridden.
		if(NOT BLURRR_OSX_CODESIGN_IDENTITY)

			set(BLURRR_OSX_CODESIGN_IDENTITY "")
			# set(BLURRR_OSX_CODESIGN_IDENTITY "Developer ID Application")
			# set(BLURRR_OSX_CODESIGN_IDENTITY "Mac Developer")
			# set(BLURRR_OSX_CODESIGN_IDENTITY "3rd Party Mac Developer Application")

		else()
			set(OSX_ENTITLEMENT_APP_SANDBOX true)
		endif()

		set_xcode_property(${_EXE_NAME} CODE_SIGN_IDENTITY "${BLURRR_OSX_CODESIGN_IDENTITY}")

		# This will let you override some of the entitlement defaults in Blurrr-OSX-Template.entitlements.in
		set(OSX_ENTITLEMENT_APP_SANDBOX false)
		# Might become true for CMake-Server?
		set(OSX_ENTITLEMENT_NETWORK_CLIENT false)
		# Might become true for CMake-Server?
		set(OSX_ENTITLEMENT_NETWORK_SERVER false)
		set(OSX_ENTITLEMENT_DEVICE_BLUETOOTH false)
		set(OSX_ENTITLEMENT_DEVICE_USB false)
		set(OSX_ENTITLEMENT_FILES_BOOKMARKS_APP_SCOPE true)
#		set(OSX_ENTITLEMENT_FILES_BOOKMARKS_DOCUMENT_SCOPE true)
		set(OSX_ENTITLEMENT_FILES_USER_SELECTED_READ_WRITE true)
		set(OSX_ENTITLEMENT_FILES_USER_SELECTED_EXECUTABLE true)
#		set(OSX_ENTITLEMENT_APPLICATION_GROUPS true)
		set(OSX_ENTITLEMENT_SECURITY_INHERIT true)

		set(OSX_ENTITLEMENT_FREEFORM_INJECTION_VARAIBLE "<key>com.apple.security.temporary-exception.files.absolute-path.read-write</key><true/>")

		if(BLURRR_USE_JAVASCRIPTCORE)
			# Enable this for JavaScript debugging with Safari. Remember to disable when you ship your app.
			# set(OSX_ENTITLEMENT_GET_TASK_ALLOW true)
		endif()


	elseif(BLURRR_PLATFORM_WINDOWS)
		# Set your keyfile either here directly, 
		# though enviromental variables (BLURRR_WINDOWS_CODESIGN_KEYFILE or CODESIGN_FILE)
		# or through CMake flags via -DBLURRR_WINDOWS_CODESIGN_KEYFILE="C:\\path\\to\\foo.p12"
#		set(BLURRR_WINDOWS_CODESIGN_KEYFILE "C:\\MyKeys\\export.p12")
		if(NOT DEFINED BLURRR_WINDOWS_CODESIGN_KEYFILE)
			if(DEFINED ENV{BLURRR_WINDOWS_CODESIGN_KEYFILE})
				set(BLURRR_WINDOWS_CODESIGN_KEYFILE $ENV{BLURRR_WINDOWS_CODESIGN_KEYFILE})
			elseif(DEFINED ENV{CODESIGN_FILE})
				set(BLURRR_WINDOWS_CODESIGN_KEYFILE $ENV{CODESIGN_FILE})
			endif()
		endif()

		# You may set your password here, but I strong advice you don't (or never check in this file).
		# Instead, you can use an environmental variable (BLURRR_WINDOWS_CODESIGN_PASSWORD or CODESIGN_PASSWORD)
		# or CMake -D flag, -DBLURRR_WINDOWS_CODESIGN_KEYFILE="12345"
#		set(BLURRR_WINDOWS_CODESIGN_PASSWORD "12345")
		if(NOT DEFINED BLURRR_WINDOWS_CODESIGN_PASSWORD)
			if(DEFINED ENV{BLURRR_WINDOWS_CODESIGN_PASSWORD})
				set(BLURRR_WINDOWS_CODESIGN_PASSWORD $ENV{BLURRR_WINDOWS_CODESIGN_PASSWORD})
			elseif(DEFINED ENV{CODESIGN_PASSWORD})
				set(BLURRR_WINDOWS_CODESIGN_PASSWORD $ENV{CODESIGN_PASSWORD})
			endif()
		endif()


		
		if(BLURRR_WINDOWS_CODESIGN_KEYFILE)
		
			find_program(SIGNTOOL_EXECUTABLE
				NAMES "signtool.exe"
				PATHS
				"C:\\Program Files (x86)\\Windows Kits\\8.1\\bin\\x86"
				"D:\\Program Files (x86)\\Windows Kits\\8.1\\bin\\x86"
				"\\Program Files (x86)\\Windows Kits\\8.1\\bin\\x86"
			)
			if(NOT SIGNTOOL_EXECUTABLE)
				MESSAGE("Could not find signtool.exe. You can modify CMakeBlurrrProjectSettings.cmake, or try setting your system PATH, or running this process through VS Developer Command Prompt")
			endif()
		MESSAGE("SIGNTOOL_EXECUTABLE ${SIGNTOOL_EXECUTABLE}")

			# Maybe you don't have a password?
			if(BLURRR_WINDOWS_CODESIGN_PASSWORD)
					MESSAGE("BLURRR_WINDOWS_CODESIGN_PASSWORD ${BLURRR_WINDOWS_CODESIGN_PASSWORD}")

				# We dual sign. SHA256 for the modern, SHA1 for legacy. We probably can drop SHA1 at this point, but it is easy enough to do.

				# SHA1
				add_custom_command(TARGET ${_EXE_NAME} POST_BUILD
					COMMAND ${SIGNTOOL_EXECUTABLE} sign /f ${BLURRR_WINDOWS_CODESIGN_KEYFILE} /t http://timestamp.comodoca.com /v /p ${BLURRR_WINDOWS_CODESIGN_PASSWORD} $<TARGET_FILE:${_EXE_NAME}>
				)
				# SHA256
				add_custom_command(TARGET ${_EXE_NAME} POST_BUILD
					COMMAND ${SIGNTOOL_EXECUTABLE} sign /f ${BLURRR_WINDOWS_CODESIGN_KEYFILE} /tr http://timestamp.comodoca.com?td=sha256 /fd sha256 /as /v /p ${BLURRR_WINDOWS_CODESIGN_PASSWORD} $<TARGET_FILE:${_EXE_NAME}>
				)

				# NOTE: Haven't figured out how to sign CPack/WIX .msi. Sign manually for now.

			else()
				# We dual sign. SHA256 for the modern, SHA1 for legacy. We probably can drop SHA1 at this point, but it is easy enough to do.

				# SHA1
				add_custom_command(TARGET ${_EXE_NAME} POST_BUILD
					COMMAND ${SIGNTOOL_EXECUTABLE} sign /f ${BLURRR_WINDOWS_CODESIGN_KEYFILE} /t http://timestamp.comodoca.com /v $<TARGET_FILE:${_EXE_NAME}>
				)
				# SHA256
				add_custom_command(TARGET ${_EXE_NAME} POST_BUILD
					COMMAND ${SIGNTOOL_EXECUTABLE} sign /f ${BLURRR_WINDOWS_CODESIGN_KEYFILE} /tr http://timestamp.comodoca.com?td=sha256 /fd sha256 /as /v $<TARGET_FILE:${_EXE_NAME}>
				)
			endif(BLURRR_WINDOWS_CODESIGN_PASSWORD)
		endif(BLURRR_WINDOWS_CODESIGN_KEYFILE)
				

	endif()
endmacro(BLURRR_CONFIGURE_CODESIGNING)


macro(BLURRR_CONFIGURE_APPLICATION_MANIFEST _EXE_NAME)

	if(BLURRR_PLATFORM_APPLE)

		set(MACOSX_BUNDLE_GUI_IDENTIFIER "${BLURRR_USER_BUNDLE_IDENTIFIER}")
		set(MACOSX_BUNDLE_DISPLAY_NAME "${BLURRR_USER_HUMAN_NAME}")
		set(MACOSX_BUNDLE_BUNDLE_NAME "${_EXE_NAME}")
		set(MACOSX_BUNDLE_EXECUTABLE_NAME "${_EXE_NAME}")
		set(MACOSX_BUNDLE_SHORT_VERSION_STRING "${BLURRR_VERSION_MAJOR}.${BLURRR_VERSION_MINOR}")
		set(MACOSX_BUNDLE_BUNDLE_VERSION "${BLURRR_VERSION_MAJOR}.${BLURRR_VERSION_MINOR}")
		
	endif()
	
endmacro(BLURRR_CONFIGURE_APPLICATION_MANIFEST)


